<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Department-wise Revenue - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <style>
      .department-revenue-container { max-width: 1100px; margin: 0 auto; }
      .department-revenue-header { color: #1565c0; font-size: 2em; font-weight: 700; margin-bottom: 18px; }
      .department-revenue-desc { color: #555; margin-bottom: 28px; font-size: 1.13em; }
      .department-filter-bar { display: flex; gap: 24px; align-items: flex-end; margin-bottom: 32px; flex-wrap: wrap; }
      .department-filter-bar label { font-weight: 600; color: #374151; margin-bottom: 8px; font-size: 0.95em; text-transform: uppercase; letter-spacing: 0.5px; }
      .department-filter-bar select, .department-filter-bar input[type="date"] { padding: 12px 16px; border: 2px solid #d1d5db; border-radius: 10px; font-size: 1em; background: #fff; color: #374151; min-width: 220px; }
      .department-filter-bar button { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: #fff; padding: 14px 28px; border: none; border-radius: 12px; font-size: 1.05em; font-weight: 600; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); text-transform: uppercase; letter-spacing: 0.5px; min-width: 140px; }
      .department-filter-bar button:hover { background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%); }
      .dashboard-cards { display: flex; gap: 32px; margin: 32px 0 24px 0; flex-wrap: wrap; }
      .dashboard-card { background: #f4f6fa; border-radius: 10px; box-shadow: 0 1px 8px #e1e4ea; padding: 18px 28px; min-width: 180px; text-align: center; }
      .dashboard-card-title { color: #374151; font-size: 1.01em; font-weight: 600; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
      .dashboard-card-value { color: #1565c0; font-size: 1.25em; font-weight: 700; }
      .doctor-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-bottom: 32px; }
      .doctor-table th, .doctor-table td { padding: 16px 18px; background: #fff; border-radius: 8px; text-align: left; font-size: 1.08em; }
      .doctor-table th { color: #1565c0; font-weight: 700; background: #f4f6fa; border-bottom: 2px solid #e1e4ea; }
      .doctor-table tr { box-shadow: 0 2px 8px #e1e4ea; transition: box-shadow 0.18s, transform 0.18s; }
      .doctor-table tr:hover td { box-shadow: 0 6px 24px #b3c6e4; background: #f7fafc; color: #2563eb; }
      .empty-state { text-align: center; color: #888; padding: 60px 0 40px 0; }
      @media (max-width: 700px) { .doctor-table th, .doctor-table td { padding: 10px 6px; font-size: 0.98em; } .department-filter-bar { gap: 12px; } .dashboard-cards { gap: 12px; } }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container department-revenue-container">
    <div class="department-revenue-header">Department-wise Revenue Dashboard</div>
    <div class="department-revenue-desc">Select a clinic, department, and date range to view revenue and key metrics by department.</div>
    <form method="get" class="department-filter-bar">
        <div>
            <label for="clinicId">Clinic</label><br>
            <select id="clinicId" name="clinicId">
                <option value="">All Clinics</option>
                <c:forEach var="clinic" items="${allClinics}">
                    <option value="${clinic.clinicId}" <c:if test="${clinic.clinicId == selectedClinicId}">selected</c:if>>${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>
        <div>
            <label for="department">Department</label><br>
            <select id="department" name="department">
                <option value="">All Departments</option>
                <c:forEach var="row" items="${departmentRevenue}">
                    <c:if test="${not empty row.departmentName}">
                        <option value="${row.departmentName}" <c:if test="${row.departmentName == selectedDepartment}">selected</c:if>>${row.departmentName}</option>
                    </c:if>
                </c:forEach>
            </select>
        </div>
        <div>
            <label for="startDate">Start Date</label><br>
            <input type="date" id="startDate" name="startDate" value="${param.startDate}">
        </div>
        <div>
            <label for="endDate">End Date</label><br>
            <input type="date" id="endDate" name="endDate" value="${param.endDate}">
        </div>
        <div style="align-self: flex-end; display: flex; gap: 12px;">
            <button type="submit">Show Revenue</button>
            <button type="button" onclick="clearDepartmentRevenueForm()" style="background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);">Clear</button>
        </div>
    </form>
    <script>
        function clearDepartmentRevenueForm() {
            document.getElementById('clinicId').value = '';
            document.getElementById('department').value = '';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.forms[0].submit();
        }
    </script>
    <div class="dashboard-cards">
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Revenue</div>
            <div class="dashboard-card-value">₹ <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Patients</div>
            <div class="dashboard-card-value">${totalPatients}</div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Procedures</div>
            <div class="dashboard-card-value">${totalProcedures}</div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Doctors</div>
            <div class="dashboard-card-value">${totalDoctors}</div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Pending Revenue</div>
            <div class="dashboard-card-value">₹ <fmt:formatNumber value="${totalPending}" type="number" groupingUsed="true" minFractionDigits="2" /></div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Top Department</div>
            <div class="dashboard-card-value">${topDepartment}</div>
        </div>
    </div>
    <c:choose>
        <c:when test="${not empty departmentRevenue}">
            <table class="doctor-table">
                <thead>
                    <tr>
                        <th>Department</th>
                        <th>Revenue</th>
                        <th>Patients</th>
                        <th>Procedures</th>
                        <th>Doctors</th>
                        <th>Pending Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${departmentRevenue}">
                        <tr>
                            <td>${row.departmentName}</td>
                            <td>₹ <fmt:formatNumber value="${row.revenue}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                            <td>${row.patientCount}</td>
                            <td>${row.procedureCount}</td>
                            <td>${row.doctorCount}</td>
                            <td>₹ <fmt:formatNumber value="${row.pendingRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty departmentRevenue}">
                <div class="empty-state">No department revenue found for this clinic and date range.</div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">Please select a clinic, department, and date range to view department revenue.</div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html> 