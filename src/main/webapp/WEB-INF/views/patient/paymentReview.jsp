<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Review - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
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
            flex-direction: row;
        }
        
        .sidebar-menu {
            width: 280px;
            background: linear-gradient(180deg, #ffffff, #f8f9fa);
            padding: 30px;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            position: relative;
            z-index: 10;
            transition: all 0.3s ease;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 35px;
        }
        
        .logo img {
            width: 40px;
            height: 40px;
            filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
        }
        
        .logo h1 {
            font-size: 1.5rem;
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .action-card {
            background: white;
            padding: 16px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
            transition: all 0.3s;
            text-decoration: none;
            border: 1px solid #f0f0f0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .action-card i {
            font-size: 1.2rem;
            color: #3498db;
            width: 30px;
        }
        
        .action-card:hover {
            transform: translateX(5px);
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border-color: transparent;
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.2);
        }
        
        .action-card:hover h3,
        .action-card:hover p,
        .action-card:hover i {
            color: white;
        }
        
        .action-card h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .action-card p {
            margin: 4px 0 0 0;
            color: #7f8c8d;
            font-size: 0.8rem;
        }
        
        .card-text {
            flex: 1;
        }
        
        .main-content {
            flex: 1;
            padding: 40px;
            position: relative;
            overflow-x: auto;
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
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 0.9rem;
            text-decoration: none;
            text-align: center;
            border: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(127, 140, 141, 0.2);
        }
        
        .footer {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            font-size: 12px;
            color: #999;
        }
        
        .copyright {
            margin: 5px 0;
        }
        
        .powered-by {
            color: #3498db;
            font-weight: 500;
        }
        
        .navtech {
            color: #2c3e50;
            font-weight: 600;
        }
        
        /* Payment Review Specific Styles */
        .payment-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .payment-header {
            margin-bottom: 15px;
            padding-bottom: 12px;
            border-bottom: 1px solid #eee;
        }
        
        .payment-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.4rem;
            margin-bottom: 8px;
        }

        .payment-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .meta-label {
            color: #7f8c8d;
            font-size: 0.85rem;
            margin-bottom: 4px;
        }
        
        .meta-value {
            color: #2c3e50;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .procedures-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }
        
        .procedures-table th {
            background-color: #f8f9fa;
            color: #2c3e50;
            text-align: left;
            padding: 12px;
            font-weight: 600;
            border-bottom: 2px solid #eee;
        }
        
        .procedures-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        
        .procedures-table tr:last-child td {
            border-bottom: none;
        }
        
        .procedures-table .price-col {
            text-align: right;
            font-weight: 600;
            color: #3498db;
        }
        
        .department-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            padding: 2px 8px;
            font-size: 0.75rem;
            font-weight: bold;
            color: white;
            box-shadow: 0 1px 2px rgba(0,0,0,0.2);
        }
        
        .badge-orthodontics {
            background-color: #3498db; /* Blue */
        }
        
        .badge-periodontics {
            background-color: #27ae60; /* Green */
        }
        
        .badge-prosthodontics {
            background-color: #f39c12; /* Orange */
        }
        
        .badge-pedodontics {
            background-color: #e74c3c; /* Red */
        }
        
        .badge-endodontics {
            background-color: #9b59b6; /* Purple */
        }
        
        .badge-implantology {
            background-color: #16a085; /* Teal */
        }
        
        .badge-diagnosis {
            background-color: #34495e; /* Dark blue */
        }
        
        .badge-other {
            background-color: #7f8c8d; /* Gray */
        }
        
        .total-row td {
            border-top: 2px solid #eee;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .total-label {
            text-align: right;
        }
        
        .total-amount {
            text-align: right;
            color: #27ae60;
        }
        
        .payment-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        /* Extra notes section */
        .notes-section {
            margin-top: 20px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #7f8c8d;
            border-left: 4px solid #3498db;
        }
        
        .notes-section h3 {
            color: #2c3e50;
            margin-top: 0;
            margin-bottom: 10px;
            font-size: 1rem;
        }
        
        .notification {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #e3f2fd;
            color: #0d47a1;
            border-left: 4px solid #1976d2;
            display: none;
        }
        
        .notification.error {
            background-color: #ffebee;
            color: #b71c1c;
            border-left-color: #f44336;
        }
        
        .notification.success {
            background-color: #e8f5e9;
            color: #1b5e20;
            border-left-color: #4caf50;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <div class="sidebar-menu">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
                <h1>PeriDesk</h1>
            </div>
            <a href="${pageContext.request.contextPath}/welcome" class="action-card">
                <i class="fas fa-clipboard-list"></i>
                <div class="card-text">
                    <h3>Waiting Lobby</h3>
                    <p>View waiting patients</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/register" class="action-card">
                <i class="fas fa-user-plus"></i>
                <div class="card-text">
                    <h3>Register Patient</h3>
                    <p>Add new patient</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/list" class="action-card">
                <i class="fas fa-users"></i>
                <div class="card-text">
                    <h3>View Patients</h3>
                    <p>Manage records</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/appointments" class="action-card">
                <i class="fas fa-calendar-alt"></i>
                <div class="card-text">
                    <h3>Appointments</h3>
                    <p>Today's schedule</p>
                </div>
            </a>
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Payment Review</h1>
                <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Examination
                </a>
            </div>
            
            <div id="notification" class="notification"></div>
            
            <div class="payment-container">
                <div class="payment-meta">
                    <div class="meta-item">
                        <span class="meta-label">Patient Name</span>
                        <span class="meta-value">${patient.firstName} ${patient.lastName}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Age</span>
                        <span class="meta-value">
                            <c:if test="${not empty patient.age}">
                                ${patient.age} years
                            </c:if>
                            <c:if test="${empty patient.age}">
                                Not specified
                            </c:if>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Phone</span>
                        <span class="meta-value">${patient.phoneNumber}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Examination ID</span>
                        <span class="meta-value">${examination.id}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Tooth Number</span>
                        <span class="meta-value">${examination.toothNumber}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Doctor</span>
                        <span class="meta-value">${examination.assignedDoctor.doctorName}</span>
                    </div>
                </div>
                
                <div class="payment-header">
                    <h2>Selected Procedures</h2>
                </div>
                
                <table class="procedures-table">
                    <thead>
                        <tr>
                            <th style="width: 5%">#</th>
                            <th style="width: 55%">Procedure</th>
                            <th style="width: 25%">Department</th>
                            <th style="width: 15%" class="price-col">Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty procedures}">
                            <tr>
                                <td colspan="4" style="text-align: center;">No procedures selected</td>
                            </tr>
                        </c:if>
                        
                        <c:forEach var="procedure" items="${procedures}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td>${procedure.procedureName}</td>
                                <td>
                                    <c:set var="deptName" value="Other" />
                                    <c:set var="badgeClass" value="badge-other" />
                                    
                                    <c:if test="${procedure.dentalDepartment != null && procedure.dentalDepartment.displayName != null}">
                                        <c:set var="deptName" value="${procedure.dentalDepartment.displayName}" />
                                        
                                        <c:choose>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'orthodontic')}">
                                                <c:set var="badgeClass" value="badge-orthodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'periodontic')}">
                                                <c:set var="badgeClass" value="badge-periodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'pedodontic')}">
                                                <c:set var="badgeClass" value="badge-pedodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'prosthodontic')}">
                                                <c:set var="badgeClass" value="badge-prosthodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'implantology')}">
                                                <c:set var="badgeClass" value="badge-implantology" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'endodontic')}">
                                                <c:set var="badgeClass" value="badge-endodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'diagnos')}">
                                                <c:set var="badgeClass" value="badge-diagnosis" />
                                            </c:when>
                                        </c:choose>
                                    </c:if>
                                    
                                    <span class="department-badge ${badgeClass}">${deptName}</span>
                                </td>
                                <td class="price-col">₹${procedure.price}</td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${not empty procedures}">
                            <tr class="total-row">
                                <td colspan="3" class="total-label">Total Amount</td>
                                <td class="total-amount">₹${totalAmount}</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                
                <div class="notes-section">
                    <h3><i class="fas fa-info-circle"></i> Payment Information</h3>
                    <p>Please review the selected procedures and total amount before proceeding to payment. Once confirmed, these procedures will be scheduled for the patient's treatment plan.</p>
                </div>
                
                <div class="payment-actions">
                    <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}/procedures" class="btn btn-secondary">
                        <i class="fas fa-edit"></i> Edit Procedures
                    </a>
                    <div>
                        <button id="collect-payment-btn" class="btn btn-primary">
                            <i class="fas fa-credit-card"></i> Collect Payment
                        </button>
                        <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}" class="btn btn-primary">
                            <i class="fas fa-check-circle"></i> Confirm
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
            const notification = document.getElementById('notification');
            const collectPaymentBtn = document.getElementById('collect-payment-btn');
            
            // Function to show notification
            function showNotification(message, isError = false) {
                notification.textContent = message;
                notification.className = 'notification ' + (isError ? 'error' : 'success');
                notification.style.display = 'block';
                
                // Hide after 5 seconds
                setTimeout(() => {
                    notification.style.display = 'none';
                }, 5000);
            }
            
            // Handle collect payment button
            if (collectPaymentBtn) {
                collectPaymentBtn.addEventListener('click', function() {
                    // In a real implementation, this would open a payment modal or redirect to a payment page
                    // For now, we'll just show a success notification
                    showNotification('Payment collection feature will be implemented in a future update', false);
                });
            }
        });
    </script>
</body>
</html> 