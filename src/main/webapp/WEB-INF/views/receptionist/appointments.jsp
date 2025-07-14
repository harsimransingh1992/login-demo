<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <title>Appointment Management - PeriDesk</title>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    
    <!-- Flatpickr CSS and JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/material_blue.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    
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
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
            overflow: hidden;
        }
        
        .card-header {
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .card-title {
            margin: 0;
            font-size: 1.2rem;
            color: #2c3e50;
            font-weight: 600;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .appointments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .appointments-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .appointments-table td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            vertical-align: middle;
        }
        
        .appointments-table tr:last-child td {
            border-bottom: none;
        }
        
        .appointments-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .appointment-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .patient-name {
            font-weight: 500;
            color: #2c3e50;
        }
        
        .appointment-time {
            color: #7f8c8d;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .doctor-info {
            color: #7f8c8d;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .patient-registration-id {
            font-family: 'Courier New', monospace;
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .appointment-notes {
            max-width: 200px;
        }
        
        .notes {
            color: #7f8c8d;
            font-size: 0.85rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-weight: 500;
            display: inline-block;
        }
        
        .status-scheduled { background-color: #e3f2fd; color: #1976d2; }
        .status-checked-in { background-color: #e8f5e9; color: #2e7d32; }
        .status-in-progress { background-color: #fff3e0; color: #f57c00; }
        .status-completed { background-color: #e3f2fd; color: #1976d2; }
        .status-cancelled { background-color: #ffebee; color: #c62828; }
        
        .create-appointment-btn {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .create-appointment-btn:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
        }
        
        .btn-outline-primary {
            background: transparent;
            color: #3498db;
            border: 1px solid #3498db;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-outline-primary:hover:not(:disabled) {
            background: #3498db;
            color: white;
        }
        
        .btn-outline-primary:disabled {
            background: #f5f5f5;
            color: #999;
            border-color: #ddd;
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        .btn-outline-primary.active {
            background: #3498db;
            color: white;
        }
        
        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-backdrop.show {
            opacity: 1;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1050;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow-x: hidden;
            overflow-y: auto;
            outline: 0;
        }
        
        .modal-dialog {
            position: relative;
            width: auto;
            margin: 1.75rem auto;
            max-width: 600px;
            pointer-events: none;
        }
        
        .modal-dialog-centered {
            display: flex;
            align-items: center;
            min-height: calc(100% - 3.5rem);
        }
        
        .modal-content {
            position: relative;
            display: flex;
            flex-direction: column;
            width: 100%;
            pointer-events: auto;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid rgba(0, 0, 0, 0.2);
            border-radius: 12px;
            outline: 0;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .modal-header {
            display: flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem;
            border-bottom: 1px solid #eee;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }
        
        .modal-title {
            margin: 0;
            line-height: 1.5;
            font-size: 1.25rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .modal-body {
            position: relative;
            flex: 1 1 auto;
            padding: 1.5rem;
        }
        
        .modal-footer {
            display: flex;
            flex-wrap: wrap;
            flex-shrink: 0;
            align-items: center;
            justify-content: flex-end;
            padding: 1.5rem;
            border-top: 1px solid #eee;
            border-bottom-right-radius: 12px;
            border-bottom-left-radius: 12px;
            gap: 0.5rem;
        }
        
        .btn-close {
            box-sizing: content-box;
            width: 1em;
            height: 1em;
            padding: 0.25em;
            color: #000;
            background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 011.414 0L8 6.586 14.293.293a1 1 0 111.414 1.414L9.414 8l6.293 6.293a1 1 0 01-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 01-1.414-1.414L6.586 8 .293 1.707a1 1 0 010-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
            border: 0;
            border-radius: 0.375rem;
            opacity: 0.5;
            cursor: pointer;
            transition: opacity 0.15s ease-in-out;
        }
        
        .btn-close:hover {
            opacity: 0.75;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group:last-child {
            margin-bottom: 0;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2c3e50;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .form-control {
            display: block;
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            font-weight: 400;
            line-height: 1.5;
            color: #2c3e50;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ddd;
            border-radius: 8px;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        .form-control:focus {
            color: #2c3e50;
            background-color: #fff;
            border-color: #3498db;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
        .text-danger {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .modal-dialog {
                margin: 1rem;
                max-width: calc(100% - 2rem);
            }
            
            .modal-content {
                border-radius: 8px;
            }
            
            .modal-header,
            .modal-body,
            .modal-footer {
                padding: 1rem;
            }
        }
        
        /* Custom tooltip styling */
        .tooltip {
            font-family: 'Poppins', sans-serif;
        }
        
        .tooltip .tooltip-inner {
            background-color: #2c3e50;
            color: white;
            font-size: 0.85rem;
            padding: 8px 12px;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .tooltip.bs-tooltip-top .tooltip-arrow::before {
            border-top-color: #2c3e50;
        }
        
        /* Flatpickr custom styles */
        .flatpickr-calendar {
            font-family: 'Poppins', sans-serif;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            border: none;
        }
        
        .flatpickr-day.selected {
            background: #3498db;
            border-color: #3498db;
        }
        
        .flatpickr-day:hover {
            background: #e3f2fd;
        }
        
        .flatpickr-day.today {
            border-color: #3498db;
        }
        
        .flatpickr-months .flatpickr-month {
            background: #3498db;
            color: white;
            border-radius: 12px 12px 0 0;
        }
        
        .flatpickr-current-month .flatpickr-monthDropdown-months {
            color: white;
        }
        
        .flatpickr-current-month .flatpickr-monthDropdown-months option {
            color: #2c3e50;
        }
        
        .flatpickr-weekdays {
            background: #f8f9fa;
        }
        
        .flatpickr-weekday {
            color: #2c3e50;
            font-weight: 500;
        }
        
        .date-picker-container {
            position: relative;
            min-width: 200px;
            width: 220px;
        }
        
        .date-picker-container .form-control {
            padding-left: 40px;
            cursor: pointer;
            width: 100%;
            min-width: 200px;
        }
        
        .date-picker-container i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #3498db;
            pointer-events: none;
        }
        
        .date-picker-container input:disabled {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        .date-picker-container input:disabled + i {
            color: #6c757d;
        }
        
        .date-picker-container.disabled {
            position: relative;
        }
        
        .date-picker-container.disabled::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(248, 249, 250, 0.8);
            border-radius: 8px;
            pointer-events: none;
            z-index: 1;
        }
        
        /* Disabled button styling */
        .btn-outline-primary.disabled {
            opacity: 0.6;
            cursor: not-allowed;
            background-color: #f8f9fa;
            border-color: #dee2e6;
            color: #6c757d;
        }
        
        .btn-outline-primary.disabled:hover {
            background-color: #f8f9fa;
            border-color: #dee2e6;
            color: #6c757d;
            transform: none;
            box-shadow: none;
        }
        
        /* Mobile number validation styles */
        .form-control.is-valid {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        .form-control.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        .form-control.is-valid:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        .form-control.is-invalid:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        #mobileError {
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        /* Mobile input specific styling */
        #patientMobile {
            font-family: 'Courier New', monospace;
            letter-spacing: 1px;
        }
        
        /* Pagination styles */
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .pagination-info {
            color: #666;
            font-size: 14px;
        }
        
        .pagination-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .pagination-button {
            padding: 8px 12px;
            border: 1px solid #ddd;
            background: white;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .pagination-button:hover {
            background: #f8f9fa;
            border-color: #007bff;
            color: #007bff;
        }
        
        .pagination-button:disabled {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #dee2e6;
        }
        
        .pagination-button.active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }
        
        .page-size-selector {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .page-size-selector select {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .sort-controls {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .sort-controls select {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .pagination-container {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            
            .pagination-controls {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Appointment Management</h1>
                <div style="display: flex; gap: 15px; align-items: center;">
                    <div class="form-group date-picker-container ${myAppointments ? 'disabled' : ''}" style="margin: 0;" 
                         data-bs-toggle="tooltip" 
                         data-bs-placement="top" 
                         title="${myAppointments ? 'Date picker is disabled when viewing My Appointments' : 'Select a date to view appointments'}">
                        <i class="fas fa-calendar"></i>
                        <input type="text" id="appointmentDate" class="form-control" 
                               value="${selectedDate}"
                               placeholder="Select Date"
                               ${myAppointments ? 'disabled' : ''}>
                    </div>
                    <input type="hidden" id="myAppointmentsState" value="${myAppointments}">
                    <sec:authorize access="hasRole('DOCTOR')">
                        <button class="btn-outline-primary ${myAppointments ? 'active' : ''}" id="myAppointmentsBtn" 
                                onclick="toggleMyAppointments()"
                                data-bs-toggle="tooltip"
                                data-bs-placement="top"
                                title="View your upcoming appointments">
                            <i class="fas fa-user"></i> My Appointments
                        </button>
                    </sec:authorize>
                    <sec:authorize access="hasRole('RECEPTIONIST')">
                        <button class="btn-outline-primary disabled" id="myAppointmentsBtn" 
                                disabled
                                data-bs-toggle="tooltip"
                                data-bs-placement="top"
                                title="My Appointments feature is not available for Receptionist role">
                            <i class="fas fa-user"></i> My Appointments
                        </button>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                        <button class="create-appointment-btn" onclick="openCreateAppointmentModal()">
                            <i class="fas fa-plus-circle"></i> Create New Appointment
                        </button>
                    </sec:authorize>
                </div>
            </div>
            <div class="alert alert-info" style="margin: 20px 0 0 0;">
                <strong>Status Legend:</strong>
                <ul style="margin-bottom: 0;">
                    <li><strong>Scheduled</strong>: Appointment is scheduled and upcoming.</li>
                    <li><strong>Completed</strong>: Appointment has been completed.</li>
                    <li><strong>Cancelled</strong>: Appointment was cancelled by the patient or staff.</li>
                    <li><strong>No Show</strong>: Patient did not show up for the appointment.</li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">
                        <i class="fas fa-calendar-check"></i> 
                        ${myAppointments ? 'My Upcoming Appointments' : 'Appointments'}
                    </h5>
                </div>
                <div class="card-body">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> ${successMessage}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${empty appointments}">
                            <div class="text-center py-5">
                                <i class="fas fa-calendar-times fa-4x text-muted mb-4"></i>
                                <h3 class="text-muted mb-3">No Appointments Found</h3>
                                <p class="text-muted mb-4">
                                    ${myAppointments ? 
                                        'You have no upcoming appointments.' : 
                                        'There are no appointments scheduled for the selected date.'}
                                </p>
                                <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                    <button class="create-appointment-btn" onclick="openCreateAppointmentModal()">
                                        <i class="fas fa-plus-circle"></i> Schedule New Appointment
                                    </button>
                                </sec:authorize>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="appointments-table">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Registration ID</th>
                                        <th>Appointment Date</th>
                                        <th>Time</th>
                                        <th>Doctor</th>
                                        <th>Status</th>
                                        <th>Notes</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${appointments}" var="appointment">
                                        <tr>
                                            <td>
                                                <div class="appointment-info">
                                                    <span class="patient-name">
                                                        ${appointment.patientName != null ? appointment.patientName : appointment.patientMobile}
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.patient != null}">
                                                        <span class="appointment-info"
                                                     data-bs-toggle="tooltip" 
                                                     data-bs-placement="top" 
                                                              title="Patient Registration ID: ${appointment.patient.registrationCode}">
                                                            <span class="patient-registration-id">${appointment.patient.registrationCode}</span>
                                                    </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="appointment-info"
                                                              data-bs-toggle="tooltip"
                                                              data-bs-placement="top"
                                                              title="No patient assigned">
                                                            <span class="patient-registration-id">N/A</span>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="appointment-date">
                                                    <fmt:parseDate value="${appointment.appointmentDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="appointment-time">
                                                    <i class="fas fa-clock"></i>
                                                    <fmt:parseDate value="${appointment.appointmentDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                                                    <fmt:formatDate value="${parsedDate}" pattern="hh:mm a"/>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.doctor != null}">
                                                <div class="doctor-info">
                                                    <i class="fas fa-user-md"></i>
                                                            ${appointment.doctor.firstName} ${appointment.doctor.lastName}
                                                </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="doctor-info">
                                                            <i class="fas fa-user-md"></i>
                                                            Unassigned
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="status-badge status-${appointment.status.toString().toLowerCase()}">
                                                    ${appointment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="appointment-notes" 
                                                     data-bs-toggle="tooltip" 
                                                     data-bs-placement="top" 
                                                     title="${appointment.notes != null && !appointment.notes.isEmpty() ? appointment.notes : 'No notes'}">
                                                    <span class="notes">
                                                        ${appointment.notes != null && !appointment.notes.isEmpty() ? appointment.notes : '-'}
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                    <button class="btn-outline-primary" 
                                                            onclick="showAppointmentDetails('${appointment.id}')"
                                                            ${appointment.status == 'CANCELLED' || appointment.status == 'NO_SHOW' || appointment.status == 'COMPLETED' ? 'disabled' : ''}
                                                            data-bs-toggle="tooltip"
                                                            data-bs-placement="top"
                                                            data-bs-custom-class="custom-tooltip"
                                                            title="${appointment.status == 'CANCELLED' || appointment.status == 'NO_SHOW' || appointment.status == 'COMPLETED' ? 'Cannot transition from terminal status' : 'Update appointment status'}">
                                                        <i class="fas fa-eye"></i> Details
                                                    </button>
                                                </sec:authorize>
                                                <sec:authorize access="hasRole('DOCTOR')">
                                                    <span style="color: #6c757d; font-style: italic; font-size: 0.9em;">Status updates disabled for Doctor Role</span>
                                                </sec:authorize>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Pagination Controls -->
                    <c:if test="${totalPages > 1 or not empty appointments}">
                        <div class="pagination-container">
                            <div class="pagination-info">
                                Showing ${(currentPage * pageSize) + 1} to ${(currentPage * pageSize) + fn:length(appointments)} of ${totalItems} appointments
                            </div>
                            
                            <div class="pagination-controls">
                                <!-- Page Size Selector -->
                                <div class="page-size-selector">
                                    <label for="pageSize">Show:</label>
                                    <select id="pageSize" onchange="changePageSize(this.value)">
                                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                        <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                    </select>
                                </div>
                                
                                <!-- Sort Controls -->
                                <div class="sort-controls">
                                    <label for="sort">Sort by:</label>
                                    <select id="sort" onchange="changeSort(this.value)">
                                        <option value="appointmentDateTime" ${sort == 'appointmentDateTime' ? 'selected' : ''}>Appointment Time</option>
                                        <option value="patientName" ${sort == 'patientName' ? 'selected' : ''}>Patient Name</option>
                                        <option value="status" ${sort == 'status' ? 'selected' : ''}>Status</option>
                                        <option value="doctor.firstName" ${sort == 'doctor.firstName' ? 'selected' : ''}>Doctor</option>
                                    </select>
                                    <select id="direction" onchange="changeDirection(this.value)">
                                        <option value="asc" ${direction == 'asc' ? 'selected' : ''}>Asc</option>
                                        <option value="desc" ${direction == 'desc' ? 'selected' : ''}>Desc</option>
                                    </select>
                                </div>
                                
                                <!-- Navigation Buttons -->
                                <c:if test="${currentPage > 0}">
                                    <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" class="pagination-button">
                                        <i class="fas fa-chevron-left"></i> Previous
                                    </a>
                                </c:if>
                                
                                <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                    <c:choose>
                                        <c:when test="${pageNum == currentPage}">
                                            <span class="pagination-button active">${pageNum + 1}</span>
                                        </c:when>
                                        <c:when test="${pageNum == 0}">
                                            <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                        </c:when>
                                        <c:when test="${pageNum == totalPages - 1}">
                                            <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                        </c:when>
                                        <c:when test="${pageNum >= currentPage - 2 and pageNum <= currentPage + 2}">
                                            <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                        </c:when>
                                        <c:when test="${pageNum == currentPage - 3}">
                                            <span class="pagination-button">...</span>
                                        </c:when>
                                        <c:when test="${pageNum == currentPage + 3}">
                                            <span class="pagination-button">...</span>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages - 1}">
                                    <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" class="pagination-button">
                                        Next <i class="fas fa-chevron-right"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Appointment Modal -->
    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
        <div class="modal fade" id="createAppointmentModal" tabindex="-1" aria-labelledby="createAppointmentModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="createAppointmentModalLabel">
                            <i class="fas fa-plus-circle"></i> Create New Appointment
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="createAppointmentForm" action="${pageContext.request.contextPath}/appointments/create" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="form-group">
                                <label for="patientName">Patient Name</label>
                                <input type="text" class="form-control" id="patientName" name="patientName" required>
                                <c:if test="${not empty patientNameError}">
                                    <div class="text-danger">${patientNameError}</div>
                                </c:if>
                            </div>
                            <div class="form-group">
                                <label for="patientMobile">Mobile Number</label>
                                <input type="tel" class="form-control" id="patientMobile" name="patientMobile" 
                                       pattern="[0-9]{10}" required>
                                <c:if test="${not empty patientMobileError}">
                                    <div class="text-danger">${patientMobileError}</div>
                                </c:if>
                            </div>
                            <div class="form-group">
                                <label for="appointmentDateTime">Appointment Date & Time</label>
                                <input type="datetime-local" class="form-control" id="appointmentDateTime" 
                                       name="appointmentDateTime" required>
                                <c:if test="${not empty appointmentDateTimeError}">
                                    <div class="text-danger">${appointmentDateTimeError}</div>
                                </c:if>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Create Appointment</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </sec:authorize>

    <!-- Appointment Status Update Modal -->
    <div class="modal fade" id="statusUpdateModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Appointment Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="statusUpdateError" class="alert alert-danger" style="display: none;"></div>
                    <div class="form-group">
                        <label for="statusSelect">Select New Status:</label>
                        <select id="statusSelect" class="form-control" onchange="handleStatusChange()">
                            <c:forEach items="${statuses}" var="status">
                                <option value="${status}">${status}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div id="patientRegistrationGroup" class="form-group" style="display: none; margin-top: 15px;">
                        <label for="patientRegistrationNumber">Patient Registration Number:</label>
                        <input type="text" id="patientRegistrationNumber" class="form-control" 
                               placeholder="Enter patient registration number">
                        <small class="text-muted">Required for completing the appointment</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="updateStatus()">Update Status</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Global variable for the modal
        let createAppointmentModal = null;
        
        // Function to open modal - defined globally
        function openCreateAppointmentModal() {
            if (createAppointmentModal) {
                createAppointmentModal.show();
            } else {
                console.error('Create appointment modal not initialized');
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM Content Loaded');
            
            // Initialize Bootstrap modal only if element exists
            const createAppointmentModalElement = document.getElementById('createAppointmentModal');
            if (createAppointmentModalElement) {
                createAppointmentModal = new bootstrap.Modal(createAppointmentModalElement);
            }
            
            // Initialize Flatpickr
            console.log('Initializing flatpickr with selectedDate:', "${selectedDate}");
            const datePicker = flatpickr("#appointmentDate", {
                dateFormat: "d-m-Y",
                defaultDate: "${selectedDate}",
                onChange: function(selectedDates, dateStr) {
                    // Convert DD-MM-YYYY to YYYY-MM-DD for the URL
                    const parts = dateStr.split('-');
                    const formattedDate = parts[2] + '-' + parts[1] + '-' + parts[0];
                    window.location.href = '${pageContext.request.contextPath}/appointments/management?date=' + formattedDate;
                },
                theme: "material_blue",
                disableMobile: false,
                animate: true,
                monthSelectorType: "static",
                yearSelectorType: "static",
                showMonths: 1,
                enableTime: false,
                time_24hr: false,
                locale: {
                    firstDayOfWeek: 1
                }
            });
            
            // Disable/enable date picker based on My Appointments filter
            const myAppointmentsState = document.getElementById('myAppointmentsState').value === 'true';
            const datePickerContainer = document.querySelector('.date-picker-container');
            const datePickerInput = document.getElementById('appointmentDate');
            
            if (myAppointmentsState) {
                // Disable the date picker
                if (datePicker && typeof datePicker.disable === 'function') {
                    try {
                        datePicker.disable();
                    } catch (error) {
                        console.warn('Flatpickr disable method not available, using fallback:', error);
                        if (datePickerInput) {
                            datePickerInput.disabled = true;
                            datePickerInput.style.opacity = '0.6';
                            datePickerInput.style.cursor = 'not-allowed';
                        }
                    }
                } else if (datePickerInput) {
                    datePickerInput.disabled = true;
                    datePickerInput.style.opacity = '0.6';
                    datePickerInput.style.cursor = 'not-allowed';
                }
                if (datePickerContainer) {
                    datePickerContainer.classList.add('disabled');
                }
            } else {
                // Enable the date picker
                if (datePicker && typeof datePicker.enable === 'function') {
                    try {
                        datePicker.enable();
                    } catch (error) {
                        console.warn('Flatpickr enable method not available, using fallback:', error);
                        if (datePickerInput) {
                            datePickerInput.disabled = false;
                            datePickerInput.style.opacity = '1';
                            datePickerInput.style.cursor = 'pointer';
                        }
                    }
                } else if (datePickerInput) {
                    datePickerInput.disabled = false;
                    datePickerInput.style.opacity = '1';
                    datePickerInput.style.cursor = 'pointer';
                }
                if (datePickerContainer) {
                    datePickerContainer.classList.remove('disabled');
                }
            }
            
            // Form validation
            const form = document.getElementById('createAppointmentForm');
            const mobileInput = document.getElementById('patientMobile');
            
            if (form) {
                // Real-time mobile number validation
                if (mobileInput) {
                    mobileInput.addEventListener('input', function(e) {
                        // Remove any non-digit characters
                        let value = e.target.value.replace(/\D/g, '');
                        
                        // Limit to 10 digits
                        if (value.length > 10) {
                            value = value.substring(0, 10);
                        }
                        
                        // Update the input value
                        e.target.value = value;
                        
                        // Validate and show feedback
                        validateMobileNumber(value);
                    });
                    
                    mobileInput.addEventListener('blur', function(e) {
                        validateMobileNumber(e.target.value);
                    });
                }
                
                form.addEventListener('submit', function(e) {
                    const mobile = mobileInput.value;
                    if (!/^\d{10}$/.test(mobile)) {
                        e.preventDefault();
                        showMobileError('Please enter a valid 10-digit mobile number');
                        mobileInput.focus();
                        return false;
                    }
                    
                    // Clear any error messages if validation passes
                    clearMobileError();
                });
            }
            
            // Mobile number validation function
            function validateMobileNumber(value) {
                const mobileInput = document.getElementById('patientMobile');
                const errorDiv = document.getElementById('mobileError');
                
                if (!errorDiv) {
                    // Create error div if it doesn't exist
                    const newErrorDiv = document.createElement('div');
                    newErrorDiv.id = 'mobileError';
                    newErrorDiv.className = 'text-danger mt-1';
                    mobileInput.parentNode.appendChild(newErrorDiv);
                }
                
                if (value.length === 0) {
                    clearMobileError();
                    mobileInput.classList.remove('is-valid', 'is-invalid');
                } else if (value.length < 10) {
                    showMobileError('Please enter ' + (10 - value.length) + ' more digit' + ((10 - value.length === 1) ? '' : 's'));
                    mobileInput.classList.remove('is-valid');
                    mobileInput.classList.add('is-invalid');
                } else if (value.length === 10) {
                    clearMobileError();
                    mobileInput.classList.remove('is-invalid');
                    mobileInput.classList.add('is-valid');
                } else {
                    showMobileError('Mobile number should be exactly 10 digits');
                    mobileInput.classList.remove('is-valid');
                    mobileInput.classList.add('is-invalid');
                }
            }
            
            function showMobileError(message) {
                const errorDiv = document.getElementById('mobileError');
                if (errorDiv) {
                    errorDiv.textContent = message;
                    errorDiv.style.display = 'block';
                }
            }
            
            function clearMobileError() {
                const errorDiv = document.getElementById('mobileError');
                if (errorDiv) {
                    errorDiv.textContent = '';
                    errorDiv.style.display = 'none';
                }
            }

            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
        
        let currentAppointmentId = null;
        
        function showAppointmentDetails(appointmentId) {
            if (!appointmentId) {
                console.error('No appointment ID provided');
                return;
            }
            currentAppointmentId = appointmentId;
            // Hide any previous error message
            document.getElementById('statusUpdateError').style.display = 'none';
            const modal = new bootstrap.Modal(document.getElementById('statusUpdateModal'));
            modal.show();
        }
        
        function handleStatusChange() {
            const status = document.getElementById('statusSelect').value;
            const patientGroup = document.getElementById('patientRegistrationGroup');
            
            if (status === 'COMPLETED') {
                patientGroup.style.display = 'block';
            } else {
                patientGroup.style.display = 'none';
            }
        }
        
        function updateStatus() {
            if (!currentAppointmentId) {
                console.error('No appointment ID available');
                return;
            }
            
            const newStatus = document.getElementById('statusSelect').value;
            const patientRegistrationNumber = document.getElementById('patientRegistrationNumber').value;
            
            // Validate patient registration number for COMPLETED status
            if (newStatus === 'COMPLETED' && !patientRegistrationNumber) {
                const errorDiv = document.getElementById('statusUpdateError');
                errorDiv.textContent = 'Please enter patient registration number';
                errorDiv.style.display = 'block';
                return;
            }
            
            const url = '${pageContext.request.contextPath}/appointments/' + currentAppointmentId + '/status';
            
            fetch(url, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    '${_csrf.headerName}': '${_csrf.token}'
                },
                body: JSON.stringify({ 
                    status: newStatus,
                    patientRegistrationNumber: patientRegistrationNumber
                })
            })
            .then(response => {
                if (response.ok) {
                    // Close modal and refresh page
                    const modal = bootstrap.Modal.getInstance(document.getElementById('statusUpdateModal'));
                    modal.hide();
                    window.location.reload();
                } else {
                    return response.json().then(data => {
                        throw new Error(data.message || 'Failed to update status');
                    });
                }
            })
            .catch(error => {
                console.error('Error updating status:', error);
                const errorDiv = document.getElementById('statusUpdateError');
                errorDiv.textContent = error.message;
                errorDiv.style.display = 'block';
            });
        }

        function filterAppointmentsByDate(date) {
            console.log('Filtering appointments for date:', date);
            
            if (!date) {
                // If no date is selected, use today's date
                const today = new Date();
                const year = today.getFullYear();
                const month = String(today.getMonth() + 1).padStart(2, '0');
                const day = String(today.getDate()).padStart(2, '0');
                date = `${year}-${month}-${day}`;
                console.log('No date provided, using today:', date);
                document.getElementById('appointmentDate').value = date;
            }
            
            // Update URL with selected date
            const url = new URL(window.location.href);
            url.searchParams.set('date', date);
            console.log('Updating URL to:', url.toString());
            window.history.pushState({}, '', url);
            
            // Fetch appointments for selected date
            const fetchUrl = new URL(window.location.pathname, window.location.origin);
            fetchUrl.searchParams.set('date', date);
            console.log('Fetching appointments from:', fetchUrl.toString());
            
            fetch(fetchUrl.toString(), {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                console.log('Received response:', response.status);
                return response.text();
            })
            .then(html => {
                console.log('Received HTML response');
                // Update the appointments table
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newTable = doc.querySelector('.appointments-table');
                const currentTable = document.querySelector('.appointments-table');
                const noAppointmentsDiv = document.querySelector('.text-center');
                
                if (newTable) {
                    if (currentTable) {
                        console.log('Updating appointments table');
                        currentTable.innerHTML = newTable.innerHTML;
                    }
                } else if (doc.querySelector('.text-center')) {
                    // Handle no appointments case
                    if (currentTable) {
                        currentTable.style.display = 'none';
                    }
                    if (!noAppointmentsDiv) {
                        const cardBody = document.querySelector('.card-body');
                        const noAppointmentsHtml = doc.querySelector('.text-center').outerHTML;
                        cardBody.insertAdjacentHTML('beforeend', noAppointmentsHtml);
                    }
                }
                
                // Reinitialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            })
            .catch(error => {
                console.error('Error fetching appointments:', error);
                alert('Failed to fetch appointments. Please try again.');
            });
        }
        
        function toggleMyAppointments() {
            const url = new URL(window.location.href);
            const currentMyAppointments = url.searchParams.get('myAppointments') === 'true';
            const newMyAppointments = !currentMyAppointments;
            
            if (newMyAppointments) {
                url.searchParams.set('myAppointments', 'true');
                // Remove date parameter when showing my appointments
                url.searchParams.delete('date');
            } else {
                url.searchParams.delete('myAppointments');
            }
            
            window.location.href = url.toString();
        }
        
        // Pagination functions
        function goToPage(page) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page);
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
        
        function changePageSize(size) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('pageSize', size);
            urlParams.set('page', '0'); // Reset to first page when changing size
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
        
        function changeSort(sort) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('sort', sort);
            urlParams.set('page', '0'); // Reset to first page when changing sort
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
        
        function changeDirection(direction) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('direction', direction);
            urlParams.set('page', '0'); // Reset to first page when changing direction
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
    </script>
</body>
</html> 