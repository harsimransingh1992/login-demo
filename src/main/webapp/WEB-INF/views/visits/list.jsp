<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Visits - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
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
        
        .table-responsive {
            overflow-x: auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
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
            white-space: nowrap;
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
        
        .status-badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-checked-in {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-checked-out {
            background-color: #f8d7da;
            color: #721c24;
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
        
        .text-muted {
            color: #6c757d;
            font-style: italic;
        }
        
        .menu-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 999;
            background: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #2c3e50;
        }
        
        @media (max-width: 992px) {
            .welcome-container {
                position: relative;
            }
            
            .menu-toggle {
                display: flex;
            }
            
            .sidebar-menu {
                position: fixed;
                left: -340px;
                top: 0;
                bottom: 0;
                transition: left 0.3s ease;
                height: 100%;
                overflow-y: auto;
            }
            
            .sidebar-menu.active {
                left: 0;
            }
            
            .main-content {
                padding: 30px 20px;
                width: 100%;
            }
            
            .welcome-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
        }
        
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9;
        }
        
        .overlay.active {
            display: block;
        }
    </style>
</head>
<body>
    <button class="menu-toggle" id="menuToggle">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="overlay" id="overlay"></div>
    
    <div class="welcome-container">
        <div class="sidebar-menu" id="sidebarMenu">
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
            <a href="${pageContext.request.contextPath}/visits" class="action-card">
                <i class="fas fa-calendar-check"></i>
                <div class="card-text">
                    <h3>Patient Visits</h3>
                    <p>Track patient history</p>
                </div>
            </a>
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Patient Visit History</h1>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-secondary"><i class="fas fa-sign-out-alt"></i> Logout</button>
                </form>
            </div>
            
            <h1>All Patient Visits</h1>
            
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Visit ID</th>
                            <th>Patient Name</th>
                            <th>Clinic</th>
                            <th>Check-in Time</th>
                            <th>Check-out Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty visits}">
                            <tr>
                                <td colspan="6" class="no-results">No visits found</td>
                            </tr>
                        </c:if>
                        
                        <c:forEach var="visit" items="${visits}">
                            <tr>
                                <td>${visit.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${visit.patient != null && visit.patient.firstName != null && visit.patient.lastName != null}">
                                            ${visit.patient.firstName} ${visit.patient.lastName}
                                        </c:when>
                                        <c:when test="${visit.patient != null && visit.patient.firstName != null}">
                                            ${visit.patient.firstName} (no last name)
                                        </c:when>
                                        <c:when test="${visit.patient != null && visit.patient.lastName != null}">
                                            (no first name) ${visit.patient.lastName}
                                        </c:when>
                                        <c:when test="${visit.patient != null}">
                                            <span class="text-muted">Patient with incomplete name</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Unknown Patient</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${visit.checkInClinic != null}">
                                            ${visit.checkInClinic.username}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Unknown Clinic</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${not empty visit.checkInTime}">
                                        ${visit.checkInTime.toLocalDate()} ${visit.checkInTime.toLocalTime().toString().substring(0, 5)}
                                    </c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${visit.checkOutTime != null}">
                                            ${visit.checkOutTime.toLocalDate()} ${visit.checkOutTime.toLocalTime().toString().substring(0, 5)}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Still checked in</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${visit.checkOutTime == null}">
                                            <span class="status-badge status-checked-in">Checked In</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-checked-out">Checked Out</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        // Mobile menu toggle functionality
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            const sidebarMenu = document.getElementById('sidebarMenu');
            const overlay = document.getElementById('overlay');
            
            menuToggle.addEventListener('click', function() {
                sidebarMenu.classList.toggle('active');
                overlay.classList.toggle('active');
            });
            
            overlay.addEventListener('click', function() {
                sidebarMenu.classList.remove('active');
                overlay.classList.remove('active');
            });
        });
    </script>
</body>
</html> 