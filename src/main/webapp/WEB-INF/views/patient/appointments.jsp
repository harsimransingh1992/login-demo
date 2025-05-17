<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>PeriDesk - Today's Appointments</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />
    <link href="${pageContext.request.contextPath}/css/patient/appointments.css" rel="stylesheet" />
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
            <a href="${pageContext.request.contextPath}/doctors" class="action-card">
                <i class="fas fa-user-md"></i>
                <div class="card-text">
                    <h3>Doctors</h3>
                    <p>Manage doctors</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/settings" class="action-card">
                <i class="fas fa-cog"></i>
                <div class="card-text">
                    <h3>Settings</h3>
                    <p>System configuration</p>
                </div>
            </a>
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Today's Appointments</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Patients
                    </a>
                </div>
            </div>
            
            <div class="calendar-container">
                <div id="calendar"></div>
            </div>
            
            <!-- Debug section -->
            <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">
                <h3>Today's Appointments</h3>
                <p>Total appointments: ${appointments.size()}</p>
                <c:choose>
                    <c:when test="${empty appointments}">
                        <p>No appointments scheduled for today.</p>
                    </c:when>
                    <c:otherwise>
                        <ul style="list-style-type: none; padding: 0;">
                            <c:forEach items="${appointments}" var="appointment">
                                <li style="margin-bottom: 15px; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                                    <strong>Patient:</strong> ${appointment.patient.firstName} ${appointment.patient.lastName}<br>
                                    <strong>Doctor:</strong> ${appointment.assignedDoctor.doctorName}<br>
                                    <strong>Time:</strong> ${appointment.treatmentStartingDate}<br>
                                    <a href="${pageContext.request.contextPath}/patients/examination/${appointment.id}" 
                                       class="btn btn-primary" style="margin-top: 5px; display: inline-block;">
                                        View Details
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Hidden container with appointment data -->
    <div id="appointment-data" style="display: none;">
        <c:forEach items="${appointments}" var="appointment" varStatus="status">
            <div class="appointment-item"
                 data-id="${appointment.id}"
                 data-first-name="${appointment.patient.firstName}"
                 data-last-name="${appointment.patient.lastName}"
                 data-start-date="${appointment.treatmentStartingDate}"
                 data-doctor-name="${appointment.assignedDoctor.doctorName}"
                 data-phone="${appointment.patient.phoneNumber}">
            </div>
        </c:forEach>
    </div>

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
    <script src="${pageContext.request.contextPath}/js/appointment-calendar.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Extract appointment data from hidden container
            var appointmentEvents = [];
            
            // Get appointment data from the hidden container
            var appointmentItems = document.querySelectorAll('.appointment-item');
            appointmentItems.forEach(function(item) {
                // Only add appointments with valid dates
                if (item.dataset.startDate) {
                    appointmentEvents.push({
                        id: item.dataset.id,
                        title: item.dataset.firstName + ' ' + item.dataset.lastName,
                        start: item.dataset.startDate,
                        url: '${pageContext.request.contextPath}/patients/examination/' + item.dataset.id,
                        extendedProps: {
                            doctor: item.dataset.doctorName,
                            phone: item.dataset.phone
                        }
                    });
                }
            });
            
            // Initialize calendar with the events
            initializeCalendar(appointmentEvents);
        });
    </script>
</body>
</html> 