<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Cron Job History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
</head>
<body class="p-4">
<div class="container">
    <h2>History - <c:out value="${job.name}"/></h2>
    <table class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Status</th>
            <th>Started</th>
            <th>Finished</th>
            <th>Trigger</th>
            <th>Error</th>
            <th>Logs</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="h" items="${histories}">
            <tr>
                <td>${h.id}</td>
                <td>${h.status}</td>
                <td>${h.startTime}</td>
                <td>${h.endTime}</td>
                <td>${h.triggerType}</td>
                <td><c:out value="${h.errorMessage}"/></td>
                <td>
                    <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/admin/cronjobs/history/${h.id}/logs">View Logs</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/admin/cronjobs" class="btn btn-link">Back to Cron Jobs</a>
    <a href="${pageContext.request.contextPath}/admin" class="btn btn-link">Back to Admin</a>
</div>
</body>
</html>