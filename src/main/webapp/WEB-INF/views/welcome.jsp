<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
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
        
        .welcome-message span {
            color: #3498db;
            font-weight: 600;
        }
        
        .btn-secondary {
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
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .btn-secondary i {
            font-size: 0.9rem;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .table thead {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .table th {
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover {
            background-color: #f9f9f9;
        }
        
        .patient-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        
        .patient-link:hover {
            color: #2980b9;
            text-decoration: underline;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #a82315);
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.2);
        }
        
        .no-results {
            text-align: center;
            color: #7f8c8d;
            padding: 25px !important;
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
        
        h1 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 20px;
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
                <h1 class="welcome-message">Welcome, <span>${username}</span></h1>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-secondary"><i class="fas fa-sign-out-alt"></i> Logout</button>
                </form>
            </div>
            <h1>Waiting Patients</h1>
            <table class="table">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Mobile Number</th>
                    <th>Check-In Date/Time</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty waitingPatients}">
                    <tr>
                        <td colspan="4" class="no-results">No waiting patients found.</td>
                    </tr>
                </c:if>
                <c:forEach items="${waitingPatients}" var="patient">
                    <tr>    
                        <td><a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="patient-link">${patient.firstName} ${patient.lastName}</a></td>
                        <td>${patient.phoneNumber}</td>
                        <td>
                            <c:if test="${not empty patient.currentCheckInRecord.checkInTime}">
                                <c:set var="dateStr" value="${patient.currentCheckInRecord.checkInTime.toString()}" />
                                <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                <c:set var="timePart" value="${fn:substringBefore(fn:substringAfter(dateStr, 'T'), '.')}" />
                                
                                <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                
                                ${day}/${month}/${year} ${timePart} IST
                            </c:if>
                        </td>
                        <td>
                            <button class="check-btn ${patient.checkedIn ? 'btn-danger' : 'btn-primary'}" 
                                    data-patient-id="${patient.id}"
                                    data-checked-in="${patient.checkedIn}">
                                <i class="fas ${patient.checkedIn ? 'fa-user-times' : 'fa-user-check'}"></i>
                                ${patient.checkedIn ? 'Check Out' : 'Check In'}
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add event listener for all check buttons
            document.addEventListener('click', function(event) {
                const button = event.target.closest('.check-btn');
                if (!button) return;

                event.preventDefault();
                const patientId = button.dataset.patientId;
                const isCheckedIn = button.dataset.checkedIn === 'true';

                if (isCheckedIn) {
                    uncheckPatient(patientId, button);
                } else {
                    checkInPatient(patientId, button);
                }
            });
        });

        async function checkInPatient(patientId, button) {
            try {
                const csrfToken = document.querySelector('meta[name="_csrf"]').content;
                const url = '${pageContext.request.contextPath}/patients/checkin/' + patientId;
                console.log('Check-in URL:', url);
                
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    credentials: 'same-origin'
                });

                console.log('Check-in Response Status:', response.status);
                const responseText = await response.text();
                console.log('Check-in Response Text:', responseText);

                if (response.ok) {
                    // Update button state for check-out
                    button.innerHTML = '<i class="fas fa-user-times"></i> Check Out';
                    button.className = 'check-btn btn-danger';
                    button.dataset.checkedIn = 'true';
                } else {
                    throw new Error(`Server returned status ${response.status}: ${responseText}`);
                }
            } catch (error) {
                console.error('Check-in failed:', error);
                alert('Failed to check in patient. Please try again. Error: ' + error.message);
            }
        }

        async function uncheckPatient(patientId, button) {
            try {
                const csrfToken = document.querySelector('meta[name="_csrf"]').content;
                const url = '${pageContext.request.contextPath}/patients/uncheck/' + patientId;
                console.log('Check-out URL:', url);
                
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    credentials: 'same-origin'
                });

                console.log('Check-out Response Status:', response.status);
                const responseText = await response.text();
                console.log('Check-out Response Text:', responseText);

                if (response.ok) {
                    // Update button state for check-in
                    button.innerHTML = '<i class="fas fa-user-check"></i> Check In';
                    button.className = 'check-btn btn-primary';
                    button.dataset.checkedIn = 'false';
                } else {
                    throw new Error(`Server returned status ${response.status}: ${responseText}`);
                }
            } catch (error) {
                console.error('Check-out failed:', error);
                alert('Failed to check out patient. Please try again. Error: ' + error.message);
            }
        }
    </script>
</body>
</html> 