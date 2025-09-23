<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Patient Pending Payments - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f0f5fa;
            color: #2c3e50;
            line-height: 1.6;
        }

        .welcome-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 40px;
            position: relative;
        }

        .welcome-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
        }

        .welcome-message {
            font-size: 1.5rem;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .welcome-message i {
            color: #3498db;
        }

        .patient-info {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            border: none;
        }

        .patient-name {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .patient-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            color: #2c3e50;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-label {
            font-weight: 500;
            color: #2c3e50;
        }

        .total-pending {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            text-align: center;
            border-left: 4px solid #f57c00;
        }

        .total-amount {
            font-size: 2rem;
            font-weight: 700;
            color: #f57c00;
            margin-bottom: 5px;
        }

        .total-label {
            color: #666;
            font-size: 1.1rem;
        }

        .examinations-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            border: none;
        }

        .table-header {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 20px 30px;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
            color: #2c3e50;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        .amount-cell {
            font-weight: 600;
            text-align: right;
        }

        .pending-amount {
            color: #f57c00;
        }

        .total-amount-cell {
            color: #2e7d32;
        }

        .paid-amount-cell {
            color: #3498db;
        }

        .date-cell {
            color: #666;
            font-size: 0.9rem;
        }

        .tooth-number {
            background: #e3f2fd;
            color: #3498db;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            display: inline-block;
            min-width: 30px;
            text-align: center;
        }

        .procedure-name {
            font-weight: 500;
            color: #2c3e50;
        }

        .clinic-info {
            color: #666;
            font-size: 0.9rem;
        }

        .examination-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 4px 8px;
            border-radius: 4px;
        }

        .examination-link:hover {
            color: #2980b9;
            background-color: #f8f9fa;
            text-decoration: none;
            transform: translateY(-1px);
        }

        .examination-link:focus {
            outline: 2px solid #3498db;
            outline-offset: 2px;
        }

        .back-button {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
            text-decoration: none;
            color: white;
        }

        .no-payments {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .no-payments i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .no-payments h3 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 5px solid #f44336;
        }
    </style>
</head>

<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />

        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">
                    <i class="fas fa-credit-card"></i>
                    Patient Pending Payments
                </h1>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty patient}">
                <div class="patient-info">
                    <div class="patient-name">
                        <i class="fas fa-user"></i>
                        ${patient.firstName} ${patient.lastName}
                    </div>
                    <div class="patient-details">
                        <div class="detail-item">
                            <span class="detail-label">Registration Code:</span>
                            <span>${patient.registrationCode}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Phone:</span>
                            <span>${patient.phoneNumber}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Email:</span>
                            <span>${patient.email}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Age:</span>
                            <span>${patient.age} years</span>
                        </div>
                    </div>
                </div>

                <c:if test="${totalPendingAmount > 0}">
                    <div class="total-pending">
                        <div class="total-amount">
                            ₹<fmt:formatNumber value="${totalPendingAmount}" pattern="#,##0.00"/>
                        </div>
                        <div class="total-label">Total Pending Amount</div>
                    </div>
                </c:if>

                <div class="examinations-table">
                    <div class="table-header">
                        <i class="fas fa-list"></i>
                        Pending Examinations
                    </div>

                    <c:choose>
                        <c:when test="${not empty pendingExaminations}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Examination ID</th>
                                        <th>Tooth</th>
                                        <th>Procedure</th>
                                        <th>Date</th>
                                        <th>Clinic</th>
                                        <th>Total Amount</th>
                                        <th>Paid Amount</th>
                                        <th>Pending Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="examination" items="${pendingExaminations}">
                                        <c:set var="pendingAmount" value="${examination.totalProcedureAmount - examination.totalPaidAmount}" />
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}" 
                                                   class="examination-link" title="View examination details">
                                                    #${examination.id}
                                                </a>
                                            </td>
                                            <td>
                                                <c:if test="${not empty examination.toothNumber}">
                                                    <span class="tooth-number">${examination.toothNumber}</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty examination.procedure}">
                                                    <div class="procedure-name">${examination.procedure.procedureName}</div>
                                                </c:if>
                                            </td>
                                            <td class="date-cell">
                                <c:if test="${not empty examination.examinationDate}">
                                    <c:set var="dateStr" value="${examination.examinationDate.toString()}" />
                                    <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                    <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                    <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                    <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                    ${day}/${month}/${year}
                                </c:if>
                            </td>
                                            <td class="clinic-info">
                                                <c:if test="${not empty examination.examinationClinic}">
                                                    ${examination.examinationClinic.clinicName}
                                                </c:if>
                                            </td>
                                            <td class="amount-cell total-amount-cell">
                                                ₹<fmt:formatNumber value="${examination.totalProcedureAmount}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="amount-cell paid-amount-cell">
                                                ₹<fmt:formatNumber value="${examination.totalPaidAmount}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="amount-cell pending-amount">
                                                ₹<fmt:formatNumber value="${pendingAmount}" pattern="#,##0.00"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="no-payments">
                                <i class="fas fa-check-circle"></i>
                                <h3>No Pending Payments</h3>
                                <p>This patient has no pending payments at this time.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>
</body>

</html>