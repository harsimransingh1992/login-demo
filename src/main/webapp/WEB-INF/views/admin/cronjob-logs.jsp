<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Cron Job Logs</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
</head>
<body class="p-4">
<div class="container">
    <h2>Logs for History #<c:out value="${historyId}"/></h2>
    <table class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>Timestamp</th>
            <th>Level</th>
            <th>Message</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="l" items="${logs}">
            <tr>
                <td>${l.timestamp}</td>
                <td>${l.level}</td>
                <td><pre class="mb-0"><c:out value='${l.message}'/></pre></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/admin/cronjobs" class="btn btn-link">Back to Cron Jobs</a>
    <a href="${pageContext.request.contextPath}/admin" class="btn btn-link">Back to Admin</a>
</div>
</body>
</html>