#!/usr/bin/env bash
# run.sh — Open2U local Jetty controller
#
# Usage:
#   ./run.sh start     # 백그라운드 기동
#   ./run.sh stop      # mvn jetty:stop 으로 graceful 종료
#   ./run.sh restart   # stop → start
#   ./run.sh status    # 현재 상태 출력
#
# 동작 요약:
#   - mvn -DskipTests jetty:run 을 nohup 으로 백그라운드 실행
#   - HTTP 8080, stopPort 18081, stopKey "open2u" (pom.xml 의 jetty-maven-plugin 설정)
#   - PID, 로그는 ./logs/ 아래에 보관
#       logs/jetty.pid
#       logs/jetty.log

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/jetty.log"
PID_FILE="$LOG_DIR/jetty.pid"
HTTP_PORT=8080
STOP_PORT=18081
READY_MARK="Started o.e.j.m.p.JettyWebAppContext"
READY_TIMEOUT=90    # 초
STOP_TIMEOUT=30     # 초

mkdir -p "$LOG_DIR"

if [ -t 1 ]; then
    C_RED=$'\033[31m'; C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_RESET=$'\033[0m'
else
    C_RED=''; C_GREEN=''; C_YELLOW=''; C_RESET=''
fi
info() { echo "${C_GREEN}[run.sh]${C_RESET} $*"; }
warn() { echo "${C_YELLOW}[run.sh]${C_RESET} $*"; }
err()  { echo "${C_RED}[run.sh]${C_RESET} $*" >&2; }

read_pid()       { [ -f "$PID_FILE" ] && cat "$PID_FILE" || echo ""; }
is_pid_alive()   { [ -n "${1:-}" ] && kill -0 "$1" 2>/dev/null; }
port_listening() { lsof -nP -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1; }

cmd_status() {
    local pid; pid="$(read_pid)"
    if is_pid_alive "$pid"; then
        info "RUNNING  pid=$pid  url=http://localhost:${HTTP_PORT}/home  log=$LOG_FILE"
        return 0
    fi
    if port_listening "$HTTP_PORT"; then
        warn "포트 ${HTTP_PORT} 가 다른 프로세스에 의해 점유 중 (PID 파일 없음)"
        lsof -nP -iTCP:"$HTTP_PORT" -sTCP:LISTEN | sed -n '1,5p'
        return 1
    fi
    info "STOPPED"
    return 3
}

cmd_start() {
    local pid; pid="$(read_pid)"
    if is_pid_alive "$pid"; then
        warn "이미 실행 중입니다 (pid=$pid). 재기동은 '$0 restart' 를 사용하세요."
        return 0
    fi
    if port_listening "$HTTP_PORT"; then
        err "포트 ${HTTP_PORT} 가 이미 사용 중입니다. '$0 stop' 또는 충돌 프로세스를 정리하세요."
        return 1
    fi

    info "Jetty 백그라운드 기동..."
    : > "$LOG_FILE"
    nohup mvn -DskipTests jetty:run >>"$LOG_FILE" 2>&1 &
    local new_pid=$!
    disown "$new_pid" 2>/dev/null || true
    echo "$new_pid" > "$PID_FILE"
    info "spawned pid=$new_pid (log: $LOG_FILE)"

    local i
    for i in $(seq 1 "$READY_TIMEOUT"); do
        if ! is_pid_alive "$new_pid"; then
            err "Jetty 프로세스가 비정상 종료되었습니다. 로그 확인: tail -n 60 $LOG_FILE"
            tail -n 30 "$LOG_FILE" 2>/dev/null | sed 's/^/    /'
            rm -f "$PID_FILE"
            return 1
        fi
        if grep -q "$READY_MARK" "$LOG_FILE" 2>/dev/null; then
            info "READY  pid=$new_pid  ->  http://localhost:${HTTP_PORT}/home  (대기 ${i}s)"
            return 0
        fi
        sleep 1
    done

    warn "${READY_TIMEOUT}s 안에 READY 마커를 찾지 못했습니다. 로그를 확인하세요:"
    warn "  tail -f $LOG_FILE"
    return 1
}

cmd_stop() {
    local pid; pid="$(read_pid)"

    if ! is_pid_alive "$pid" && ! port_listening "$HTTP_PORT"; then
        info "이미 STOPPED 상태입니다."
        rm -f "$PID_FILE"
        return 0
    fi

    info "graceful 종료 요청 (mvn jetty:stop, stopPort=${STOP_PORT})..."
    mvn jetty:stop >>"$LOG_FILE" 2>&1 || warn "mvn jetty:stop 가 0이 아닌 코드 반환 — PID 폴백으로 진행"

    if is_pid_alive "$pid"; then
        local i
        for i in $(seq 1 "$STOP_TIMEOUT"); do
            is_pid_alive "$pid" || break
            sleep 1
        done
        if is_pid_alive "$pid"; then
            warn "${STOP_TIMEOUT}s 후에도 종료되지 않음 — SIGTERM 전송 (pid=$pid)"
            kill "$pid" 2>/dev/null || true
            for i in $(seq 1 10); do
                is_pid_alive "$pid" || break
                sleep 1
            done
            if is_pid_alive "$pid"; then
                err "여전히 살아있음 — SIGKILL 전송 (pid=$pid)"
                kill -9 "$pid" 2>/dev/null || true
            fi
        fi
    fi

    rm -f "$PID_FILE"
    info "STOPPED"
}

cmd_restart() {
    cmd_stop || true
    sleep 1
    cmd_start
}

usage() {
    cat <<EOF
Usage: $0 {start|stop|restart|status}

설정:
  http   : http://localhost:${HTTP_PORT}/home
  log    : $LOG_FILE
  pid    : $PID_FILE
  stop   : mvn jetty:stop  (stopPort=${STOP_PORT}, stopKey=open2u)

팁:
  - 로그 따라가기 :  tail -f $LOG_FILE
  - 수동 종료    :  mvn jetty:stop
EOF
}

case "${1:-}" in
    start)              cmd_start ;;
    stop)               cmd_stop ;;
    restart)            cmd_restart ;;
    status)             cmd_status ;;
    ""|-h|--help|help)  usage ;;
    *)                  usage; exit 2 ;;
esac
