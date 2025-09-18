<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctors Performance - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <style>
      .doctor-performance-container {
        max-width: calc(100% - 280px);
        margin-left: 280px;
        margin-right: 0;
        padding-left: 32px;
        padding-right: 32px;
      }
      .doctor-performance-header { color: #1565c0; font-size: 2em; font-weight: 700; margin-bottom: 18px; }
      .doctor-performance-desc { color: #555; margin-bottom: 28px; font-size: 1.13em; }
      .doctor-filter-bar { display: flex; gap: 24px; align-items: flex-end; margin-bottom: 32px; flex-wrap: wrap; }
      .doctor-filter-bar label { font-weight: 600; color: #374151; margin-bottom: 8px; font-size: 0.95em; text-transform: uppercase; letter-spacing: 0.5px; }
      .doctor-filter-bar select { padding: 12px 16px; border: 2px solid #d1d5db; border-radius: 10px; font-size: 1em; background: #fff; color: #374151; min-width: 220px; }
      .doctor-filter-bar button { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: #fff; padding: 14px 28px; border: none; border-radius: 12px; font-size: 1.05em; font-weight: 600; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); text-transform: uppercase; letter-spacing: 0.5px; min-width: 140px; }
      .doctor-filter-bar button:hover { background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%); }
      .doctor-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-bottom: 32px; }
      .doctor-table th, .doctor-table td { padding: 16px 18px; background: #fff; border-radius: 8px; text-align: left; font-size: 1.08em; }
      .doctor-table th { color: #1565c0; font-weight: 700; background: #f4f6fa; border-bottom: 2px solid #e1e4ea; }
      .doctor-table tr { box-shadow: 0 2px 8px #e1e4ea; transition: box-shadow 0.18s, transform 0.18s; }
      .doctor-table tr:hover td { box-shadow: 0 6px 24px #b3c6e4; background: #f7fafc; color: #2563eb; }
      .empty-state { text-align: center; color: #888; padding: 60px 0 40px 0; }
      @media (max-width: 700px) { .doctor-table th, .doctor-table td { padding: 10px 6px; font-size: 0.98em; } .doctor-filter-bar { gap: 12px; } }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container doctor-performance-container">
    <div class="doctor-performance-header">Doctors Performance</div>
    <div class="doctor-performance-desc">Select a clinic to view the performance of its doctors. Metrics include patients seen, revenue generated, and procedures performed.</div>
    <form method="get" class="doctor-filter-bar">
        <div>
            <label for="clinicId">Clinic</label><br>
            <select id="clinicId" name="clinicId">
                <option value="">Select Clinic</option>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}" <c:if test="${clinic.clinicId == selectedClinicId}">selected</c:if>>${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>
        <c:set var="monthNames" value="January,February,March,April,May,June,July,August,September,October,November,December" />
        <div>
            <label for="month">Month (optional)</label><br>
            <select id="month" name="month">
                <option value="">Whole Year</option>
                <c:forEach var="m" begin="1" end="12">
                    <c:set var="mStr" value="${m < 10 ? '0' : ''}${m}" />
                    <c:set var="monthName" value="${fn:split(monthNames, ',')[m-1]}" />
                    <option value="${mStr}" <c:if test="${mStr == selectedMonth}">selected</c:if>>
                        ${monthName}
                    </option>
                </c:forEach>
            </select>
        </div>
        <%
            int currentYear = java.time.Year.now().getValue();
        %>
        <div>
            <label for="year">Year <span style="color:#b91c1c;">*</span></label><br>
            <select id="year" name="year" required>
                <option value="">Select Year</option>
                <c:forEach var="y" begin="2022" end="<%= currentYear %>">
                    <option value="${y}" <c:if test="${y == selectedYear}">selected</c:if>>${y}</option>
                </c:forEach>
            </select>
        </div>
        <div style="align-self: flex-end; display: flex; gap: 12px;">
            <button type="submit">Show Performance</button>
            <button type="button" onclick="clearDoctorPerformanceForm()" style="background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);">Clear</button>
        </div>
    </form>
    <script>
        function clearDoctorPerformanceForm() {
            document.getElementById('clinicId').value = '';
            document.getElementById('month').value = '';
            document.getElementById('year').value = '';
            document.forms[0].submit();
        }
    </script>
    <c:if test="${not empty validationError}">
        <div style="color: #b91c1c; font-weight: 600; margin-bottom: 18px;">${validationError}</div>
    </c:if>
    <c:choose>
        <c:when test="${showStats}">
            <table class="doctor-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Joining Date</th>
                        <th>Department</th>
                        <th>Unique Patients</th>
                        <th>Patients</th>
                        <th>Revenue</th>
                        <th>Procedures</th>
                        <th>New Patients</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="stats" items="${doctorStats}">
                        <tr>
                            <td>${stats.doctor.firstName} ${stats.doctor.lastName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty stats.doctor.joiningDate}">
                                        ${stats.doctor.joiningDate}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${stats.doctor.specialization}</td>
                            <td>${stats.uniquePatients}</td>
                            <td>${stats.totalPatients}</td>
                            <td>${stats.revenue}</td>
                            <td>${stats.procedures}</td>
                            <td>${stats.newPatients}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty doctorStats}">
                <div class="empty-state">No doctors found for this clinic and year.</div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">Please select a clinic and year to view doctors' performance. (Month is optional)</div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>