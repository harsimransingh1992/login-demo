<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assigned Cases - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    <style>
        .main-content { flex: 1; padding: 30px; background: #f5f7fa; min-height: 100vh; }
        .container { max-width: 1600px; margin: 0 auto; background: #fff; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.08); padding: 24px; }
        .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom: 20px; }
        .page-title { font-size: 1.8rem; font-weight: 700; color: #2d3436; }
        .filters { background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 12px; padding: 16px; margin-bottom: 20px; }
        .filters form { display:flex; flex-wrap:wrap; gap: 12px; align-items:end; }
        .filters label { font-weight:600; color:#2d3436; font-size:0.9rem; display:block; margin-bottom:6px; }
        .filters select, .filters input[type="date"] { padding:10px 12px; border:1px solid #e9ecef; border-radius:8px; min-width: 180px; font-family:'Poppins',sans-serif; }
        .filters button { background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%); color:#fff; border:none; border-radius:10px; padding:10px 20px; font-weight:600; cursor:pointer; }
        .table { width:100%; border-collapse:collapse; }
        .table th, .table td { padding:12px 10px; border-bottom:1px solid #eee; }
        .table th { background:#f8f9fa; text-align:left; font-weight:600; color:#2d3436; }
        .status-chip { display:inline-block; padding:6px 10px; border-radius:999px; font-size:0.85rem; font-weight:600; }
        .status-PENDING { background:#fff3cd; color:#856404; }
        .status-SCHEDULED { background:#cce5ff; color:#004085; }
        .status-IN_PROGRESS { background:#d4edda; color:#155724; }
        .status-CLOSED { background:#e2e3e5; color:#6c757d; }
        .pagination { display:flex; gap:8px; justify-content:flex-end; margin-top:16px; }
        .pagination a, .pagination span { padding:8px 12px; border:1px solid #e9ecef; border-radius:8px; text-decoration:none; color:#0984e3; }
        .pagination .active { background:#0984e3; color:#fff; }
        .row-actions a { color:#0984e3; text-decoration:none; font-weight:600; }
        .error { color:#d62828; margin-bottom:10px; }
    </style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/common/menu.jsp" />
    <main class="main-content">
        <div class="container">
            <div class="page-header">
                <div>
                    <h1 class="page-title"><i class="fa-solid fa-clipboard-list"></i> Assigned Cases</h1>
                    <p class="dashboard-subtitle">Cases assigned to you across clinics</p>
                </div>
            </div>

            <c:if test="${not empty dateParseError}">
                <div class="error">${dateParseError}</div>
            </c:if>

            <div class="filters">
                <form method="get" action="${pageContext.request.contextPath}/assigned-cases">
                    <div>
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="">All</option>
                            <c:forEach items="${procedureStatuses}" var="ps">
                                <option value="${ps}" <c:if test="${statusFilter == ps}">selected</c:if>>${ps}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label for="startDate">Start date</label>
                        <input type="date" id="startDate" name="startDate" value="${startDateFilter}">
                    </div>
                    <div>
                        <label for="endDate">End date</label>
                        <input type="date" id="endDate" name="endDate" value="${endDateFilter}">
                    </div>
                    <div>
                        <button type="submit">Apply Filters</button>
                    </div>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Procedure</th>
                            <th>Clinic</th>
                            <th>Exam Date</th>
                            <th>Scheduled</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cases}" var="c">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.patient}">
                                            <c:out value="${c.patient.firstName}"/> <c:out value="${c.patient.lastName}"/>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${c.procedure != null ? c.procedure.procedureName : '—'}"/></td>
                                <td><c:out value="${c.examinationClinic != null ? c.examinationClinic.clinicName : '—'}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.examinationDateFormatted}">
                                            <c:out value="${c.examinationDateFormatted}"/>
                                        </c:when>
                                        <c:when test="${not empty c.examinationDate}">
                                            <c:out value="${c.examinationDate}"/>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.treatmentStartDate}">
                                            <c:out value="${c.treatmentStartDate}"/>
                                        </c:when>
                                        <c:when test="${not empty c.treatmentStartingDate}">
                                            <c:out value="${c.treatmentStartingDate}"/>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status-chip status-${c.procedureStatus}">
                                        <c:out value="${c.procedureStatus}"/>
                                    </span>
                                </td>
                                <td class="row-actions">
                                    <c:choose>
                                        <c:when test="${c.id != null}">
                                            <a href="${pageContext.request.contextPath}/patients/examination/${c.id}">View</a>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty cases}">
                            <tr>
                                <td colspan="7" style="text-align:center; color:#6c757d;">No cases found for the selected filters.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 0}">
                <div class="pagination">
                    <c:forEach var="i" begin="0" end="${totalPages - 1}">
                        <c:choose>
                            <c:when test="${i == page}">
                                <span class="active">${i + 1}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/assigned-cases?status=${statusFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}&page=${i}&size=${size}">${i + 1}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>