<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
        
        .date-picker-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .date-picker-container input[type="date"] {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 8px 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .date-picker-container input[type="date"]:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
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
        
        /* Today's Appointments */
        .today-appointments {
            margin-bottom: 30px;
        }
        
        .appointment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
        }
        
        .appointment-header {
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .appointment-time {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .appointment-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
        }
        
        .status-scheduled { background: #e3f2fd; color: #1976d2; }
        .status-completed { background: #e8f5e8; color: #2e7d32; }
        .status-cancelled { background: #ffebee; color: #c62828; }
        .status-urgent { background: #fff3e0; color: #ef6c00; }
        
        .appointment-body {
            padding: 20px;
        }
        
        .patient-info {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .patient-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db, #2980b9);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.2rem;
            margin-right: 15px;
        }
        
        .patient-details h4 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .patient-details p {
            margin: 0;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .appointment-notes {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        .appointment-notes h5 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 0.9rem;
            font-weight: 600;
        }
        
        .appointment-notes p {
            margin: 0;
            color: #5a6c7d;
            font-size: 0.9rem;
            line-height: 1.5;
        }
        
        .appointment-actions {
            padding: 15px 20px;
            background: #f8f9fa;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .btn-action {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-1px);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            transform: translateY(-1px);
        }
        
        /* Upcoming Appointments */
        .upcoming-appointments {
            margin-top: 30px;
        }
        
        .upcoming-list {
            display: grid;
            gap: 15px;
        }
        
        .upcoming-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }
        
        .upcoming-item:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }
        
        .upcoming-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .upcoming-date {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .upcoming-time {
            color: #3498db;
            font-weight: 500;
        }
        
        .upcoming-patient {
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .upcoming-reason {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #bdc3c7;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .empty-state p {
            font-size: 1rem;
            line-height: 1.6;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            
            .welcome-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .appointment-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .appointment-actions {
                flex-direction: column;
            }
            
            .btn-action {
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
                <h1 class="welcome-message">My Appointments</h1>
                <div class="date-picker-container">
                    <label for="datePicker" style="margin-right: 10px; font-weight: 500; color: #2c3e50;">
                        <i class="fas fa-calendar"></i> Select Date:
                    </label>
                    <input type="date" id="datePicker" class="form-control" style="display: inline-block; width: auto; margin-right: 10px;" 
                           value="<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" />" />
                    <button class="btn-secondary" onclick="loadAppointmentsForDate()">
                        <i class="fas fa-search"></i> View Appointments
                    </button>
                </div>
            </div>
            
            <!-- Today's Appointments -->
            <div class="today-appointments">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title" id="appointmentsTitle">
                            <i class="fas fa-clock"></i> Today's Appointments (${todaysAppointments.size()})
                        </h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty todaysAppointments}">
                                <c:forEach var="appointment" items="${todaysAppointments}">
                                    <div class="appointment-card">
                                        <div class="appointment-header">
                                            <div class="appointment-time">
                                                <i class="fas fa-clock"></i>
                                                <fmt:formatDate value="${appointment.appointmentDateTime}" pattern="HH:mm" />
                                            </div>
                                            <span class="appointment-status status-${appointment.status.toLowerCase()}">
                                                ${appointment.status}
                                            </span>
                                        </div>
                                        <div class="appointment-body">
                                            <div class="patient-info">
                                                <div class="patient-avatar">
                                                    ${appointment.patient.firstName.charAt(0)}${appointment.patient.lastName.charAt(0)}
                                                </div>
                                                <div class="patient-details">
                                                    <h4>${appointment.patient.firstName} ${appointment.patient.lastName}</h4>
                                                    <p>Patient ID: ${appointment.patient.id}</p>
                                                </div>
                                            </div>
                                            <c:if test="${not empty appointment.notes}">
                                                <div class="appointment-notes">
                                                    <h5><i class="fas fa-sticky-note"></i> Notes</h5>
                                                    <p>${appointment.notes}</p>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="appointment-actions">
                                            <button class="btn-action btn-primary" onclick="viewPatient('${appointment.patient.id}')">
                                                <i class="fas fa-user"></i> View Patient
                                            </button>
                                            <button class="btn-action btn-success" onclick="startAppointment('${appointment.id}')">
                                                <i class="fas fa-play"></i> Start
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-check"></i>
                                    <h3>No Appointments Today</h3>
                                    <p>You have no appointments scheduled for today. Enjoy your day!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Upcoming Appointments -->
            <c:if test="${not empty upcomingAppointments}">
                <div class="upcoming-appointments">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-calendar-alt"></i> Upcoming Appointments (Next 7 Days)
                            </h3>
                        </div>
                        <div class="card-body">
                            <div class="upcoming-list">
                                <c:forEach var="appointment" items="${upcomingAppointments}">
                                    <div class="upcoming-item">
                                        <div class="upcoming-header">
                                            <div class="upcoming-date">
                                                <fmt:formatDate value="${appointment.appointmentDateTime}" pattern="EEEE, MMMM d" />
                                            </div>
                                            <div class="upcoming-time">
                                                <fmt:formatDate value="${appointment.appointmentDateTime}" pattern="HH:mm" />
                                            </div>
                                        </div>
                                        <div class="upcoming-patient">
                                            ${appointment.patient.firstName} ${appointment.patient.lastName}
                                        </div>
                                        <c:if test="${not empty appointment.notes}">
                                            <div class="upcoming-reason">
                                                ${appointment.notes}
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        function viewPatient(patientId) {
            window.open('${pageContext.request.contextPath}/patients/' + patientId, '_blank');
        }
        
        function startAppointment(appointmentId) {
            // In a real implementation, this would start the appointment process
            alert('Starting appointment: ' + appointmentId);
        }
        
        function loadAppointmentsForDate() {
            const selectedDate = document.getElementById('datePicker').value;
            if (!selectedDate) {
                alert('Please select a date');
                return;
            }
            
            const formattedDate = new Date(selectedDate).toLocaleDateString('en-US', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            
            // Show loading state
            const cardBody = document.querySelector('.card-body');
            const appointmentsTitle = document.getElementById('appointmentsTitle');
            
            cardBody.innerHTML = `
                <div style="text-align: center; padding: 40px;">
                    <i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: #3498db; margin-bottom: 20px;"></i>
                    <h4>Loading appointments for ${formattedDate}...</h4>
                </div>
            `;
            
            // Make AJAX call to fetch appointments
            fetch('${pageContext.request.contextPath}/my-appointments/api?date=' + selectedDate, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Appointments data:', data);
                
                if (data.appointments && data.appointments.length > 0) {
                    // Update title
                    appointmentsTitle.innerHTML = '<i class="fas fa-clock"></i> Appointments for ' + formattedDate + ' (' + data.count + ')';
                    
                    // Render appointments
                    let appointmentsHtml = '';
                    data.appointments.forEach(appointment => {
                        const appointmentTime = new Date(appointment.appointmentDateTime);
                        const timeString = appointmentTime.toLocaleTimeString('en-US', { 
                            hour: '2-digit', 
                            minute: '2-digit' 
                        });
                        
                        appointmentsHtml += '<div class="appointment-card">' +
                            '<div class="appointment-header">' +
                                '<div class="appointment-time">' +
                                    '<i class="fas fa-clock"></i>' +
                                    timeString +
                                '</div>' +
                                '<span class="appointment-status status-' + appointment.status.toLowerCase() + '">' +
                                    appointment.status +
                                '</span>' +
                            '</div>' +
                            '<div class="appointment-body">' +
                                '<div class="patient-info">' +
                                    '<div class="patient-avatar">' +
                                        appointment.patient.firstName.charAt(0) + appointment.patient.lastName.charAt(0) +
                                    '</div>' +
                                    '<div class="patient-details">' +
                                        '<h4>' + appointment.patient.firstName + ' ' + appointment.patient.lastName + '</h4>' +
                                        '<p>Patient ID: ' + appointment.patient.id + '</p>' +
                                    '</div>' +
                                '</div>';
                        
                        if (appointment.notes) {
                            appointmentsHtml += '<div class="appointment-notes">' +
                                '<h5><i class="fas fa-sticky-note"></i> Notes</h5>' +
                                '<p>' + appointment.notes + '</p>' +
                                '</div>';
                        }
                        
                        appointmentsHtml += '</div>' +
                            '<div class="appointment-actions">' +
                                '<button class="btn-action btn-primary" onclick="viewPatient(\'' + appointment.patient.id + '\')">' +
                                    '<i class="fas fa-user"></i> View Patient' +
                                '</button>' +
                                '<button class="btn-action btn-success" onclick="startAppointment(\'' + appointment.id + '\')">' +
                                    '<i class="fas fa-play"></i> Start' +
                                '</button>' +
                            '</div>' +
                        '</div>';
                    });
                    
                    cardBody.innerHTML = appointmentsHtml;
                } else {
                    // No appointments found
                    appointmentsTitle.innerHTML = '<i class="fas fa-clock"></i> Appointments for ' + formattedDate + ' (0)';
                    cardBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #7f8c8d;">' +
                        '<i class="fas fa-calendar-times" style="font-size: 3rem; margin-bottom: 20px;"></i>' +
                        '<h4>No Appointments Found</h4>' +
                        '<p>No appointments found for ' + formattedDate + '.</p>' +
                        '<button class="btn-secondary" onclick="location.reload()" style="margin-top: 15px;">' +
                            '<i class="fas fa-arrow-left"></i> Back to Today' +
                        '</button>' +
                        '</div>';
                }
            })
            .catch(error => {
                console.error('Error fetching appointments:', error);
                appointmentsTitle.innerHTML = '<i class="fas fa-clock"></i> Appointments for ' + formattedDate;
                cardBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;">' +
                    '<i class="fas fa-exclamation-triangle" style="font-size: 3rem; margin-bottom: 20px;"></i>' +
                    '<h4>Error Loading Appointments</h4>' +
                    '<p>Failed to load appointments. Please try again.</p>' +
                    '<button class="btn-secondary" onclick="location.reload()" style="margin-top: 15px;">' +
                        '<i class="fas fa-arrow-left"></i> Back to Today' +
                    '</button>' +
                    '</div>';
            });
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            console.log('My Appointments page loaded');
            
            // Add enter key support for date picker
            document.getElementById('datePicker').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    loadAppointmentsForDate();
                }
            });
        });
    </script>
</body>
</html> 