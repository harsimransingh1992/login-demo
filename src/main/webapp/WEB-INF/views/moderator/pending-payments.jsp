<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Payments - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <style>
      .pending-payments-container { max-width: 1100px; margin: 0 auto; }
      .pending-payments-header { color: #1565c0; font-size: 2em; font-weight: 700; margin-bottom: 18px; }
      .pending-payments-desc { color: #555; margin-bottom: 28px; font-size: 1.13em; }
      .pending-filter-bar { display: flex; gap: 24px; align-items: flex-end; margin-bottom: 32px; flex-wrap: wrap; }
      .pending-filter-bar label { font-weight: 600; color: #374151; margin-bottom: 8px; font-size: 0.95em; text-transform: uppercase; letter-spacing: 0.5px; }
      .pending-filter-bar select, .pending-filter-bar input[type="date"] { padding: 12px 16px; border: 2px solid #d1d5db; border-radius: 10px; font-size: 1em; background: #fff; color: #374151; min-width: 220px; }
      .pending-filter-bar button { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: #fff; padding: 14px 28px; border: none; border-radius: 12px; font-size: 1.05em; font-weight: 600; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); text-transform: uppercase; letter-spacing: 0.5px; min-width: 140px; }
      .pending-filter-bar button:hover { background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%); }
      .doctor-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-bottom: 32px; }
      .doctor-table th, .doctor-table td { padding: 16px 18px; background: #fff; border-radius: 8px; text-align: left; font-size: 1.08em; }
      .doctor-table th { color: #1565c0; font-weight: 700; background: #f4f6fa; border-bottom: 2px solid #e1e4ea; }
      .doctor-table tr { box-shadow: 0 2px 8px #e1e4ea; transition: box-shadow 0.18s, transform 0.18s; }
      .doctor-table tr:hover td { box-shadow: 0 6px 24px #b3c6e4; background: #f7fafc; color: #2563eb; }
      .empty-state { text-align: center; color: #888; padding: 60px 0 40px 0; }
      @media (max-width: 700px) { .doctor-table th, .doctor-table td { padding: 10px 6px; font-size: 0.98em; } .pending-filter-bar { gap: 12px; } }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container pending-payments-container">
    <div class="pending-payments-header">Pending Payments Across Clinics</div>
    <div class="pending-payments-desc">Select a clinic and date range to view outstanding payments for each clinic.</div>
    <form method="get" class="pending-filter-bar">
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
            <label for="startDate">Start Date</label><br>
            <input type="date" id="startDate" name="startDate" value="${param.startDate}">
        </div>
        <div>
            <label for="endDate">End Date</label><br>
            <input type="date" id="endDate" name="endDate" value="${param.endDate}">
        </div>
        <div style="align-self: flex-end; display: flex; gap: 12px;">
            <button type="submit">Show Pending</button>
            <button type="button" onclick="clearPendingPaymentsForm()" style="background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);">Clear</button>
        </div>
    </form>
    <script>
        function clearPendingPaymentsForm() {
            document.getElementById('clinicId').value = '';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.forms[0].submit();
        }
    </script>
    <c:choose>
        <c:when test="${not empty pendingPayments}">
            <table class="doctor-table">
                <thead>
                    <tr>
                        <th>Clinic Name</th>
                        <th>Clinic Code</th>
                        <th>City Tier</th>
                        <th>Pending Amount</th>
                        <th>Pending Cases</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${pendingPayments}">
                        <tr>
                            <td>${row.clinicName}</td>
                            <td>${row.clinicId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty row.cityTier}">${row.cityTier.displayName}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>₹ <fmt:formatNumber value="${row.totalPendingAmount}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                            <td>${row.pendingCasesCount}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty pendingPayments}">
                <div class="empty-state">No pending payments found for this clinic and date range.</div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">Please select a clinic and date range to view pending payments.</div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html> 