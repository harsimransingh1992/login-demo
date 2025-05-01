<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <title>Examination Details - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
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
        
        /* Examination Details Specific Styles */
        .examination-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            margin-bottom: 20px;
        }
        
        .examination-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .examination-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
        }
        
        .examination-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .meta-label {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .meta-value {
            color: #2c3e50;
            font-weight: 500;
            font-size: 1rem;
        }
        
        .form-sections-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .form-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .form-section h3 {
            color: #3498db;
            font-size: 1.1rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: #2c3e50;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            padding-right: 30px;
        }
        
        .notes-section {
            grid-column: 1 / -1;
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        /* Flatpickr Customization */
        .flatpickr-calendar {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 3px 13px rgba(0, 0, 0, 0.08);
            font-family: 'Poppins', sans-serif;
            padding-bottom: 50px !important;
        }
        
        .flatpickr-day {
            border-radius: 6px;
            margin: 2px;
        }
        
        .flatpickr-day.selected {
            background: #3498db;
            border-color: #3498db;
        }
        
        .flatpickr-time {
            border-top: 1px solid #eee;
            margin: 5px 0;
        }
        
        .flatpickr-time input {
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
        }
        
        .treatment-date-picker {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            cursor: pointer;
            background: #fff;
        }
        
        .treatment-date-picker:hover {
            border-color: #3498db;
        }
        
        .treatment-date-picker:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        /* Notification Styles */
        .notification {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .notification.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .notification.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Doctor Assignment Styles */
        .doctor-dropdown {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .doctor-dropdown.doctor-assigned {
            border-color: #3498db;
            background-color: #f0f7ff;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .welcome-container {
                flex-direction: column;
            }
            
            .sidebar-menu {
                width: 100%;
                padding: 15px;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .form-sections-container {
                grid-template-columns: 1fr;
            }
            
            .examination-meta {
                grid-template-columns: 1fr;
            }
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            overflow-y: auto;
        }
        
        .modal-content {
            background-color: white;
            margin: 2% auto;
            padding: 30px;
            border-radius: 12px;
            width: 95%;
            max-width: 1200px;
            position: relative;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .modal-content h2 {
            color: #2c3e50;
            font-size: 1.5rem;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .close {
            position: absolute;
            right: 30px;
            top: 30px;
            font-size: 28px;
            cursor: pointer;
            color: #666;
            transition: color 0.3s ease;
            background: none;
            border: none;
            padding: 0;
            line-height: 1;
        }
        
        .close:hover {
            color: #000;
        }
        
        /* Form Sections in Modal */
        .modal .form-sections-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }
        
        .modal .form-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            border: 1px solid #eee;
        }
        
        .modal .form-section h3 {
            color: #3498db;
            font-size: 1.1rem;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .modal .form-group {
            margin-bottom: 25px;
        }
        
        .modal .form-group label {
            display: block;
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .modal .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background-color: white;
        }
        
        .modal .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .modal select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }
        
        .modal textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .modal .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }
        
        .modal .btn {
            padding: 12px 25px;
            font-size: 0.95rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .modal .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
        }
        
        .modal .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .modal .btn-secondary {
            background: #95a5a6;
            color: white;
            border: none;
        }
        
        .modal .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(127, 140, 141, 0.2);
        }
        
        /* Responsive Modal */
        @media (max-width: 768px) {
            .modal-content {
                margin: 5% auto;
                width: 90%;
                padding: 20px;
            }
            
            .modal .form-sections-container {
                grid-template-columns: 1fr;
            }
            
            .modal .form-section {
                padding: 20px;
            }
            
            .modal .btn {
                padding: 10px 20px;
            }
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
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Examination Details</h1>
                <a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Patient Details
                </a>
            </div>
            
            <div id="notification" class="notification"></div>
            
            <div class="examination-container">
                <div class="examination-meta">
                    <div class="meta-item">
                        <span class="meta-label">Patient Name</span>
                        <span class="meta-value">${patient.firstName} ${patient.lastName}</span>
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
                        <span class="meta-label">Created</span>
                        <span class="meta-value">
                            <c:if test="${not empty examination.examinationDate}">
                                <c:set var="dateStr" value="${examination.examinationDate.toString()}" />
                                <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                <c:set var="timePart" value="${fn:substringBefore(fn:substringAfter(dateStr, 'T'), '.')}" />
                                
                                <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                
                                ${day}/${month}/${year} ${timePart} IST
                            </c:if>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Treatment Start Date</span>
                        <input type="text" 
                               class="treatment-date-picker" 
                               id="treatmentStartingDate"
                               data-exam-id="${examination.id}"
                               data-raw-date="${examination.treatmentStartingDate}"
                               value="<c:if test="${not empty examination.treatmentStartingDate}"><fmt:parseDate value="${examination.treatmentStartingDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"/><fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/></c:if>"
                               placeholder="Select date">
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Assigned Doctor</span>
                        <select id="doctorSelect" class="doctor-dropdown ${examination.assignedDoctor != null ? 'doctor-assigned' : ''}">
                            <option value="">--Select--</option>
                            <option value="remove" ${examination.assignedDoctor != null ? '' : 'disabled'}>-- Remove Doctor --</option>
                            <c:forEach var="doctor" items="${doctorDetails}">
                                <option value="${doctor.id}" ${examination.assignedDoctor != null && examination.assignedDoctor.id == doctor.id ? 'selected' : ''}>${doctor.doctorName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <form id="examinationForm">
                    <input type="hidden" id="examinationId" value="${examination.id}">
                    <input type="hidden" id="patientId" value="${examination.patientId}">
                    <input type="hidden" id="toothNumber" value="${examination.toothNumber}">
                    
                    <div class="form-sections-container">
                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h3>Basic Information</h3>
                            <div class="form-group">
                                <label for="toothSurface">Surface</label>
                                <select name="toothSurface" id="toothSurface" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothSurfaces}" var="surface">
                                        <option value="${surface}" ${examination.toothSurface == surface ? 'selected' : ''}>${surface}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothCondition">Condition</label>
                                <select name="toothCondition" id="toothCondition" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothConditions}" var="condition">
                                        <option value="${condition}" ${examination.toothCondition == condition ? 'selected' : ''}>${condition}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="existingRestoration">Restoration</label>
                                <select name="existingRestoration" id="existingRestoration" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${existingRestorations}" var="restoration">
                                        <option value="${restoration}" ${examination.existingRestoration == restoration ? 'selected' : ''}>${restoration}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Periodontal Assessment Section -->
                        <div class="form-section">
                            <h3>Periodontal Assessment</h3>
                            <div class="form-group">
                                <label for="pocketDepth">Pocket Depth</label>
                                <select name="pocketDepth" id="pocketDepth" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${pocketDepths}" var="depth">
                                        <option value="${depth}" ${examination.pocketDepth == depth ? 'selected' : ''}>${depth}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="bleedingOnProbing">Bleeding on Probing</label>
                                <select name="bleedingOnProbing" id="bleedingOnProbing" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${bleedingOnProbings}" var="bleeding">
                                        <option value="${bleeding}" ${examination.bleedingOnProbing == bleeding ? 'selected' : ''}>${bleeding}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="plaqueScore">Plaque Score</label>
                                <select name="plaqueScore" id="plaqueScore" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${plaqueScores}" var="score">
                                        <option value="${score}" ${examination.plaqueScore == score ? 'selected' : ''}>${score}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="gingivalRecession">Gingival Recession</label>
                                <select name="gingivalRecession" id="gingivalRecession" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${gingivalRecessions}" var="recession">
                                        <option value="${recession}" ${examination.gingivalRecession == recession ? 'selected' : ''}>${recession}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Clinical Assessment Section -->
                        <div class="form-section">
                            <h3>Clinical Assessment</h3>
                            <div class="form-group">
                                <label for="toothMobility">Mobility</label>
                                <select name="toothMobility" id="toothMobility" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothMobilities}" var="mobility">
                                        <option value="${mobility}" ${examination.toothMobility == mobility ? 'selected' : ''}>${mobility}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothVitality">Vitality</label>
                                <select name="toothVitality" id="toothVitality" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothVitalities}" var="vitality">
                                        <option value="${vitality}" ${examination.toothVitality == vitality ? 'selected' : ''}>${vitality}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothSensitivity">Sensitivity</label>
                                <select name="toothSensitivity" id="toothSensitivity" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothSensitivities}" var="sensitivity">
                                        <option value="${sensitivity}" ${examination.toothSensitivity == sensitivity ? 'selected' : ''}>${sensitivity}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="furcationInvolvement">Furcation</label>
                                <select name="furcationInvolvement" id="furcationInvolvement" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${furcationInvolvements}" var="furcation">
                                        <option value="${furcation}" ${examination.furcationInvolvement == furcation ? 'selected' : ''}>${furcation}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Notes Section -->
                        <div class="form-section notes-section">
                            <h3>Clinical Notes</h3>
                            <div class="form-group">
                                <label for="examinationNotes">Notes</label>
                                <textarea name="examinationNotes" id="examinationNotes" class="form-control" rows="4">${examination.examinationNotes}</textarea>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/patients/details/${patient.id}'" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Examination</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div id="examinationDetailsModal" class="modal">
        <div class="modal-content">
            <h2>Examination Details</h2>
            <span class="close">&times;</span>
            <div class="form-sections-container">
                <!-- Basic Information Section -->
                <div class="form-section">
                    <h3>Basic Information</h3>
                    <div class="form-group">
                        <label for="toothSurface">Surface</label>
                        <select name="toothSurface" id="toothSurface" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothSurfaces}" var="surface">
                                <option value="${surface}" ${examination.toothSurface == surface ? 'selected' : ''}>${surface}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toothCondition">Condition</label>
                        <select name="toothCondition" id="toothCondition" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothConditions}" var="condition">
                                <option value="${condition}" ${examination.toothCondition == condition ? 'selected' : ''}>${condition}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="existingRestoration">Restoration</label>
                        <select name="existingRestoration" id="existingRestoration" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${existingRestorations}" var="restoration">
                                <option value="${restoration}" ${examination.existingRestoration == restoration ? 'selected' : ''}>${restoration}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Periodontal Assessment Section -->
                <div class="form-section">
                    <h3>Periodontal Assessment</h3>
                    <div class="form-group">
                        <label for="pocketDepth">Pocket Depth</label>
                        <select name="pocketDepth" id="pocketDepth" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${pocketDepths}" var="depth">
                                <option value="${depth}" ${examination.pocketDepth == depth ? 'selected' : ''}>${depth}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="bleedingOnProbing">Bleeding on Probing</label>
                        <select name="bleedingOnProbing" id="bleedingOnProbing" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${bleedingOnProbings}" var="bleeding">
                                <option value="${bleeding}" ${examination.bleedingOnProbing == bleeding ? 'selected' : ''}>${bleeding}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="plaqueScore">Plaque Score</label>
                        <select name="plaqueScore" id="plaqueScore" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${plaqueScores}" var="score">
                                <option value="${score}" ${examination.plaqueScore == score ? 'selected' : ''}>${score}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="gingivalRecession">Gingival Recession</label>
                        <select name="gingivalRecession" id="gingivalRecession" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${gingivalRecessions}" var="recession">
                                <option value="${recession}" ${examination.gingivalRecession == recession ? 'selected' : ''}>${recession}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Clinical Assessment Section -->
                <div class="form-section">
                    <h3>Clinical Assessment</h3>
                    <div class="form-group">
                        <label for="toothMobility">Mobility</label>
                        <select name="toothMobility" id="toothMobility" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothMobilities}" var="mobility">
                                <option value="${mobility}" ${examination.toothMobility == mobility ? 'selected' : ''}>${mobility}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toothVitality">Vitality</label>
                        <select name="toothVitality" id="toothVitality" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothVitalities}" var="vitality">
                                <option value="${vitality}" ${examination.toothVitality == vitality ? 'selected' : ''}>${vitality}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toothSensitivity">Sensitivity</label>
                        <select name="toothSensitivity" id="toothSensitivity" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothSensitivities}" var="sensitivity">
                                <option value="${sensitivity}" ${examination.toothSensitivity == sensitivity ? 'selected' : ''}>${sensitivity}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="furcationInvolvement">Furcation</label>
                        <select name="furcationInvolvement" id="furcationInvolvement" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${furcationInvolvements}" var="furcation">
                                <option value="${furcation}" ${examination.furcationInvolvement == furcation ? 'selected' : ''}>${furcation}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Notes Section -->
                <div class="form-section notes-section">
                    <h3>Clinical Notes</h3>
                    <div class="form-group">
                        <label for="examinationNotes">Notes</label>
                        <textarea name="examinationNotes" id="examinationNotes" class="form-control" rows="4">${examination.examinationNotes}</textarea>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/patients/details/${patient.id}'" class="btn btn-secondary">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Examination</button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('examinationForm');
            const doctorSelect = document.getElementById('doctorSelect');
            const notification = document.getElementById('notification');
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
            
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
            
            // Handle form submission
            form.addEventListener('submit', async function(e) {
                e.preventDefault();
                
                // Collect form data
                const data = {
                    id: document.getElementById('examinationId').value,
                    patientId: document.getElementById('patientId').value,
                    toothNumber: document.getElementById('toothNumber').value,
                    toothSurface: document.getElementById('toothSurface').value,
                    toothCondition: document.getElementById('toothCondition').value,
                    existingRestoration: document.getElementById('existingRestoration').value,
                    pocketDepth: document.getElementById('pocketDepth').value,
                    bleedingOnProbing: document.getElementById('bleedingOnProbing').value,
                    plaqueScore: document.getElementById('plaqueScore').value,
                    gingivalRecession: document.getElementById('gingivalRecession').value,
                    toothMobility: document.getElementById('toothMobility').value,
                    toothVitality: document.getElementById('toothVitality').value,
                    toothSensitivity: document.getElementById('toothSensitivity').value,
                    furcationInvolvement: document.getElementById('furcationInvolvement').value,
                    examinationNotes: document.getElementById('examinationNotes').value
                };
                
                // Only include non-empty values
                Object.keys(data).forEach(key => {
                    if (data[key] === '') {
                        delete data[key];
                    }
                });
                
                try {
                    const response = await fetch('${pageContext.request.contextPath}/patients/examination/update', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: JSON.stringify(data)
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        // Store success message in sessionStorage
                        sessionStorage.setItem('flashMessage', 'Examination updated successfully');
                        sessionStorage.setItem('flashMessageType', 'success');
                        
                        // Redirect to the same page
                        window.location.href = window.location.href;
                    } else {
                        showNotification('Error: ' + (result.message || 'Failed to update examination'), true);
                    }
                } catch (error) {
                    console.error('Error updating examination:', error);
                    showNotification('Error: ' + error.message, true);
                }
            });
            
            // Check for flash message on page load
            const flashMessage = sessionStorage.getItem('flashMessage');
            const flashMessageType = sessionStorage.getItem('flashMessageType');
            
            if (flashMessage) {
                showNotification(flashMessage, flashMessageType === 'error');
                // Clear the flash message
                sessionStorage.removeItem('flashMessage');
                sessionStorage.removeItem('flashMessageType');
            }
            
            // Handle doctor assignment
            doctorSelect.addEventListener('change', async function() {
                const doctorId = this.value;
                const examinationId = document.getElementById('examinationId').value;
                
                if (!doctorId) return;
                
                const isRemove = doctorId === 'remove';
                
                try {
                    const response = await fetch('${pageContext.request.contextPath}/patients/tooth-examination/assign-doctor', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: JSON.stringify({
                            examinationId: examinationId,
                            doctorId: isRemove ? null : doctorId
                        })
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        showNotification(isRemove ? 'Doctor removed successfully' : 'Doctor assigned successfully');
                    } else {
                        showNotification('Error: ' + (result.message || 'Failed to update doctor assignment'), true);
                        
                        // Reset the select if there was an error
                        const currentDoctorId = '${examination.assignedDoctor != null ? examination.assignedDoctor.id : ""}';
                        this.value = currentDoctorId || '';
                    }
                } catch (error) {
                    console.error('Error assigning doctor:', error);
                    showNotification('Error: ' + error.message, true);
                    
                    // Reset the select if there was an error
                    const currentDoctorId = '${examination.assignedDoctor != null ? examination.assignedDoctor.id : ""}';
                    this.value = currentDoctorId || '';
                }
            });

            // Initialize flatpickr for treatment date picker
            const treatmentDatePicker = document.getElementById('treatmentStartingDate');
            if (treatmentDatePicker) {
                const fp = flatpickr(treatmentDatePicker, {
                    enableTime: true,
                    dateFormat: "Y-m-d H:i",
                    time_24hr: true,
                    defaultDate: treatmentDatePicker.dataset.rawDate || new Date(),
                    minuteIncrement: 5,
                    allowInput: false,
                    clickOpens: true,
                    closeOnSelect: false
                });

                // Create and style the button container
                const buttonContainer = document.createElement('div');
                buttonContainer.style.cssText = `
                    position: absolute;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    display: flex;
                    justify-content: flex-end;
                    gap: 10px;
                    padding: 10px;
                    background: #fff;
                    border-top: 1px solid #eee;
                    z-index: 1000;
                `;

                // Create and style the "Now" button
                const nowButton = document.createElement('button');
                nowButton.style.cssText = `
                    padding: 6px 12px;
                    background: #3498db;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    font-size: 12px;
                    cursor: pointer;
                    min-width: 100px;
                `;
                nowButton.textContent = 'Set Current Time';
                nowButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    const now = new Date();
                    fp.setDate(now);
                });

                // Create and style the "Save" button
                const saveButton = document.createElement('button');
                saveButton.style.cssText = `
                    padding: 6px 12px;
                    background: #2ecc71;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    font-size: 12px;
                    cursor: pointer;
                    min-width: 100px;
                `;
                saveButton.textContent = 'Save Time';
                saveButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    const selectedDate = fp.selectedDates[0];
                    if (selectedDate) {
                        updateTreatmentDate(selectedDate, treatmentDatePicker.dataset.examId);
                        fp.close();
                    }
                });

                // Add the buttons to the container
                buttonContainer.appendChild(nowButton);
                buttonContainer.appendChild(saveButton);

                // Add the container to the calendar
                const calendarContainer = fp.calendarContainer;
                calendarContainer.style.paddingBottom = '50px';
                calendarContainer.appendChild(buttonContainer);

                // Ensure the calendar has enough space for the buttons
                const calendar = calendarContainer.querySelector('.flatpickr-calendar');
                if (calendar) {
                    calendar.style.paddingBottom = '50px';
                }
            }

            // Function to update treatment date
            function updateTreatmentDate(date, examinationId) {
                if (!date) return;
                
                const csrfToken = document.querySelector("meta[name='_csrf']").content;
                
                // Format the date in 24-hour format
                const formattedDate = flatpickr.formatDate(date, "Y-m-d H:i");
                console.log('Sending date to backend:', formattedDate);
                
                fetch('${pageContext.request.contextPath}/patients/tooth-examination/update-treatment-date', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify({
                        examinationId: examinationId,
                        treatmentStartDate: formattedDate
                    })
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to update treatment date');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        showNotification('Treatment start date updated successfully');
                        // Update the input field with the formatted date
                        const input = document.getElementById('treatmentStartingDate');
                        if (input) {
                            // Format the date for display
                            const displayDate = flatpickr.formatDate(date, "Y-m-d H:i");
                            input.value = displayDate;
                        }
                    } else {
                        throw new Error(data.message || 'Failed to update treatment date');
                    }
                })
                .catch(error => {
                    console.error('Error updating treatment date:', error);
                    showNotification(`Error: ${error.message}`, true);
                });
            }
        });
    </script>
</body>
</html> 