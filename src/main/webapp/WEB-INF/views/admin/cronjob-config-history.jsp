<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Cron Job Config History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Config History: ${job.name}</h2>
        <div>
            <a class="btn btn-secondary" href="/admin">Admin Dashboard</a>
            <a class="btn btn-outline-secondary" href="/admin/cronjobs">Back to Jobs</a>
            <a class="btn btn-outline-primary" href="/admin/cronjobs/${job.id}/edit">Edit</a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-striped mb-0">
                <thead>
                    <tr>
                        <th>Changed At</th>
                        <th>Field</th>
                        <th>Old Value</th>
                        <th>New Value</th>
                        <th>Changed By</th>
                        <th>Rollback</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${changes}">
                    <tr>
                        <td>${c.changedAt}</td>
                        <td>${c.fieldName}</td>
                        <td><pre class="mb-0">${c.oldValue}</pre></td>
                        <td><pre class="mb-0">${c.newValue}</pre></td>
                        <td>${c.changedBy}</td>
                        <td>
                            <form method="post" action="/admin/cronjobs/config-history/${c.id}/rollback" onsubmit="return confirm('Rollback this change?');">
                                <button type="submit" class="btn btn-sm btn-outline-danger">Rollback</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
</body>
</html>