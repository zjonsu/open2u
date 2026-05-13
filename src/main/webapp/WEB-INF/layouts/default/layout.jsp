<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:set var="ctx" scope="request" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title><tiles:getAsString name="title" ignore="true"/></title>
        <link rel="stylesheet" href="${ctx}/resource/css/ui.common.css"/>
        <tiles:insertAttribute name="head" ignore="true"/>
        <script src="${ctx}/resource/js/ui.common.js"></script>
    </head>
    <body>
        <div class="wrap <tiles:getAsString name="wrapClass" ignore="true"/>">

            <header class="header_wrap">
                <tiles:insertAttribute name="header" ignore="true"/>
                <tiles:insertAttribute name="menu" ignore="true"/>
            </header>

            <div class="container">
                <tiles:insertAttribute name="body" ignore="true"/>
            </div>

            <footer class="footer_wrap">
                <tiles:insertAttribute name="footer" ignore="true"/>
            </footer>

        </div>
    </body>
</html>
