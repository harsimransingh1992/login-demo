<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Reconciliation Report - ${formattedDate}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @media print {
            body { 
                margin: 0.5in; 
                font-size: 10px;
            }
            .no-print { display: none !important; }
            .summary-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
            .breakdown-grid { grid-template-columns: repeat(3, 1fr); gap: 8px; }
            .transactions-table th, .transactions-table td { padding: 4px 6px; font-size: 9px; }
            .header { margin-bottom: 15px; padding-bottom: 10px; }
            .summary-section, .breakdown-section, .transactions-section { margin-bottom: 15px; }
            .summary-card, .breakdown-item { padding: 8px; }
            .footer { margin-top: 20px; padding-top: 10px; }
            .exam-link {
                color: #000 !important;
                text-decoration: none !important;
            }
        }
        
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            line-height: 1.4;
            color: #333;
            font-size: 12px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #333;
            padding-bottom: 15px;
        }
        
        .header h1 {
            margin: 0;
            color: #2c3e50;
            font-size: 20px;
        }
        
        .header .date {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        
        .summary-section {
            margin-bottom: 20px;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .summary-card {
            border: 1px solid #ddd;
            padding: 12px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        
        .summary-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 4px;
        }
        
        .summary-value {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .breakdown-section {
            margin-bottom: 20px;
        }
        
        .breakdown-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 12px;
            color: #2c3e50;
        }
        
        .breakdown-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
        }
        
        .breakdown-item {
            border: 1px solid #ddd;
            padding: 8px;
            border-radius: 5px;
        }
        
        .breakdown-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 4px;
        }
        
        .breakdown-amount {
            font-size: 14px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .transactions-section {
            margin-bottom: 20px;
        }
        
        .transactions-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 12px;
            color: #2c3e50;
        }
        
        .transactions-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
            font-size: 11px;
        }
        
        .transactions-table th,
        .transactions-table td {
            border: 1px solid #ddd;
            padding: 6px 8px;
            text-align: left;
        }
        
        .transactions-table th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
            font-size: 10px;
        }
        
        .transactions-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .footer {
            margin-top: 25px;
            text-align: center;
            font-size: 10px;
            color: #666;
            border-top: 1px solid #ddd;
            padding-top: 15px;
        }
        
        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .print-button:hover {
            background-color: #2980b9;
        }
        
        .exam-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <button class="print-button no-print" onclick="window.print()">Print Report</button>
    
    <div class="header">
        <h1>Payment Reconciliation Report</h1>
        <div class="date">Date: ${formattedDate}</div>
    </div>
    
    <div class="summary-section">
        <div class="summary-grid">
            <div class="summary-card">
                <div class="summary-label">Net Collections</div>
                <div class="summary-value">₹<fmt:formatNumber value="${reconciliationData.totalCollections}" pattern="#,##0.00"/></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Total Transactions</div>
                <div class="summary-value">${reconciliationData.totalTransactions}</div>
            </div>
        </div>
    </div>
    
    <c:if test="${not empty reconciliationData.paymentModeBreakdown}">
        <div class="breakdown-section">
            <div class="breakdown-title">Payment Mode Breakdown</div>
            <div class="breakdown-grid">
                <c:forEach items="${reconciliationData.paymentModeBreakdown}" var="entry">
                    <div class="breakdown-item">
                        <div class="breakdown-label">${entry.key}</div>
                        <div class="breakdown-amount">₹<fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty reconciliationData.transactions}">
        <div class="transactions-section">
            <div class="transactions-title">Daily Transactions</div>
            <table class="transactions-table">
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>Exam ID</th>
                        <th>Exam Date</th>
                        <th>Patient</th>
                        <th>Registration ID</th>
                        <th>Procedure</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Payment Mode</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${reconciliationData.transactions}" var="transaction">
                        <tr>
                            <td>
                                <c:set var="dateString" value="${transaction.collectionDate}"/>
                                <c:if test="${not empty dateString}">
                                    <fmt:parseDate value="${dateString}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate"/>
                                    <fmt:formatDate value="${parsedDate}" pattern="HH:mm a"/>
                                </c:if>
                            </td>
                            <td><a href="${pageContext.request.contextPath}/examination/${transaction.examinationId}" class="exam-link" target="_blank">${transaction.examinationId}</a></td>
                            <td>
                                <c:set var="examDateString" value="${transaction.examinationDate}"/>
                                <c:if test="${not empty examDateString}">
                                    <fmt:parseDate value="${examDateString}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedExamDate"/>
                                    <fmt:formatDate value="${parsedExamDate}" pattern="dd/MM/yyyy"/>
                                </c:if>
                                <c:if test="${empty examDateString}">N/A</c:if>
                            </td>
                            <td>${transaction.patientName}</td>
                            <td>${transaction.patientRegistrationCode}</td>
                            <td>${transaction.procedureName}</td>
                            <td>${transaction.transactionType}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${transaction.transactionType == 'REFUND'}">
                                        -₹<fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00"/>
                                    </c:when>
                                    <c:otherwise>
                                        ₹<fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${transaction.paymentMode}</td>
                            <td>${transaction.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    
    <c:if test="${empty reconciliationData.transactions}">
        <div class="transactions-section">
            <div class="transactions-title">Daily Transactions</div>
            <p>No transactions found for this date.</p>
        </div>
    </c:if>
    
    <div class="footer">
        <p>Report generated on <fmt:formatDate value="${java.time.LocalDateTime.now()}" pattern="dd MMMM yyyy 'at' HH:mm:ss"/></p>
        <p>PeriDesk Dental Management System</p>
    </div>
</body>
</html> 