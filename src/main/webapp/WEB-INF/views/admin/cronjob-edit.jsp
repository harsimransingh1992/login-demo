<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Edit Cron Job</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Edit Cron Job</h2>
        <div>
            <a class="btn btn-secondary" href="/admin">Admin Dashboard</a>
            <a class="btn btn-outline-secondary" href="/admin/cronjobs">Back to Jobs</a>
            <a class="btn btn-outline-info" href="/admin/cronjobs/${job.id}/config-history">Config History</a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <h5 class="card-title mb-3">${job.name}</h5>
            <form method="post" action="/admin/cronjobs/${job.id}/edit">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <input type="text" name="description" class="form-control" value="${empty tempDescription ? job.description : tempDescription}"/>
                    <c:if test="${errors['description'] != null}">
                        <div class="text-danger small">${errors['description']}</div>
                    </c:if>
                </div>
                <div class="mb-3">
                    <label class="form-label">Cron Expression</label>
                    <input type="text" name="cronExpression" class="form-control" value="${empty tempCronExpression ? job.cronExpression : tempCronExpression}" placeholder="e.g. 0 0 * * * *"/>
                    <c:if test="${errors['cronExpression'] != null}">
                        <div class="text-danger small">${errors['cronExpression']}</div>
                    </c:if>
                    <div class="form-text">Supports Spring cron format (seconds optional depending on config).</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Recipients (CSV emails)</label>
                    <textarea name="recipientsCsv" class="form-control" rows="2" placeholder="alice@example.com, bob@example.com">${empty tempRecipientsCsv ? job.recipientsCsv : tempRecipientsCsv}</textarea>
                    <c:if test="${errors['recipientsCsv'] != null}">
                        <div class="text-danger small">${errors['recipientsCsv']}</div>
                    </c:if>
                    <div class="form-text">Comma-separated list of email addresses. Example: user1@example.com, user2@example.com</div>
                </div>

                <div class="row g-3">
                    <div class="col-6 form-check">
                        <input class="form-check-input" type="checkbox" name="active" id="active" <c:if test="${empty tempActive ? job.active : tempActive}">checked</c:if> />
                        <label class="form-check-label" for="active">Active</label>
                    </div>
                    <div class="col-6 form-check">
                        <input class="form-check-input" type="checkbox" name="paused" id="paused" <c:if test="${empty tempPaused ? job.paused : tempPaused}">checked</c:if> />
                        <label class="form-check-label" for="paused">Paused</label>
                    </div>
                    <div class="col-6 form-check">
                        <input class="form-check-input" type="checkbox" name="oneTime" id="oneTime" <c:if test="${empty tempOneTime ? job.oneTime : tempOneTime}">checked</c:if> />
                        <label class="form-check-label" for="oneTime">One-time</label>
                    </div>
                    <div class="col-6 form-check">
                        <input class="form-check-input" type="checkbox" name="concurrentAllowed" id="concurrentAllowed" <c:if test="${empty tempConcurrentAllowed ? job.concurrentAllowed : tempConcurrentAllowed}">checked</c:if> />
                        <label class="form-check-label" for="concurrentAllowed">Allow concurrent run</label>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        <label class="form-label">Max Retries</label>
                        <input type="number" name="maxRetries" class="form-control" value="${empty tempMaxRetries ? job.maxRetries : tempMaxRetries}" min="0"/>
                        <c:if test="${errors['maxRetries'] != null}">
                            <div class="text-danger small">${errors['maxRetries']}</div>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Retry Delay (seconds)</label>
                        <input type="number" name="retryDelaySeconds" class="form-control" value="${empty tempRetryDelaySeconds ? job.retryDelaySeconds : tempRetryDelaySeconds}" min="0"/>
                        <c:if test="${errors['retryDelaySeconds'] != null}">
                            <div class="text-danger small">${errors['retryDelaySeconds']}</div>
                        </c:if>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="submit" name="action" value="preview" class="btn btn-outline-primary">Validate & Preview Next Runs</button>
                    <button type="submit" name="action" value="save" class="btn btn-success">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty previewTimes}">
        <div class="card mt-4">
            <div class="card-header">Next 5 execution times (preview)</div>
            <div class="card-body">
                <ul class="mb-0">
                    <c:forEach var="t" items="${previewTimes}">
                        <li>${t}</li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </c:if>

</div>
</body>
</html>