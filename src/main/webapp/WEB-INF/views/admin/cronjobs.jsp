<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<html>
<head>
    <title>Cron Jobs</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
</head>
<body class="p-4">
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Cron Jobs</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/cronjobs/refresh">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-outline-primary">Refresh Registrations</button>
        </form>
    </div>

    <table class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Cron</th>
            <th>Active</th>
            <th>Paused</th>
            <th>Last Run</th>
            <th>Next Run</th>
            <th>Last Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="j" items="${jobs}">
            <tr>
                <td>${j.id}</td>
                <td>${j.name}</td>
                <td>${j.description}</td>
                <td>${j.cronExpression}</td>
                <td>
                    <c:choose>
                        <c:when test="${j.active}"><span class="badge bg-success">Active</span></c:when>
                        <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${j.paused}"><span class="badge bg-warning text-dark">Paused</span></c:when>
                        <c:otherwise><span class="badge bg-info">Running</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${j.lastRunEnd != null}">${j.lastRunEnd}</c:when>
                        <c:when test="${j.lastRunStart != null}">${j.lastRunStart}</c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${nextRunTimes != null && nextRunTimes[j.id] != null}">${nextRunTimes[j.id]}</c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </td>
                <td>${j.lastStatus}</td>
                <td>
                    <div class="btn-group" role="group">
                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/edit">Edit</a>
                        <form method="post" action="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/trigger">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button class="btn btn-sm btn-primary" type="submit">Trigger</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/pause" class="ms-1">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button class="btn btn-sm btn-warning" type="submit" <c:if test='${j.paused}'>disabled</c:if>>Pause</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/resume" class="ms-1">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button class="btn btn-sm btn-success" type="submit" <c:if test='${!j.paused}'>disabled</c:if>>Resume</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/stop" class="ms-1">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button class="btn btn-sm btn-danger" type="submit">Stop</button>
                        </form>
                        <a class="btn btn-sm btn-outline-info ms-1" href="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/config-history">Config History</a>
                        <a class="btn btn-sm btn-outline-secondary ms-1" href="${pageContext.request.contextPath}/admin/cronjobs/${j.id}/history">History</a>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <a href="${pageContext.request.contextPath}/admin" class="btn btn-link">Back to Admin</a>
</div>
</body>
</html>