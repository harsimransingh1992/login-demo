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
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
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
            padding: 20px;
            margin-left: 280px;
            position: relative;
            overflow-x: auto;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }
        
        .welcome-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 20px;
            flex-shrink: 0;
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
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
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

        /* FullCalendar Customization */
        .fc {
            height: 100% !important;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }

        .fc .fc-view-harness {
            height: 100% !important;
            overflow: visible;
        }

        .fc .fc-timegrid {
            height: 100% !important;
        }

        .fc .fc-timegrid-body {
            height: 100% !important;
            overflow: visible;
            margin-left: 80px;
        }

        .fc .fc-timegrid-slot {
            height: 60px;
            font-size: 0.9rem;
            color: #2c3e50;
            padding-left: 12px;
        }

        .fc .fc-timegrid-slot.fc-timegrid-slot-lane {
            background-color: #ffffff;
            height: 60px;
            padding-left: 12px;
        }

        .fc .fc-timegrid-slot.fc-timegrid-slot-lane.fc-timegrid-slot-label {
            background-color: #f8f9fa;
        }

        .fc .fc-timegrid-axis {
            width: 80px !important;
            font-size: 0.9rem;
            color: #2c3e50;
            padding-right: 10px;
        }

        .fc .fc-timegrid-axis-cushion {
            padding: 8px 12px;
            text-align: right;
        }

        .fc .fc-timegrid-col-frame {
            min-height: 100%;
            margin-left: 80px;
        }

        .fc .fc-timegrid-cols {
            margin-left: 80px;
        }

        .fc .fc-timegrid-header {
            margin-left: 80px;
        }

        .fc .fc-timegrid-event {
            margin: 2px 4px;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 0.875rem;
            background: #e8f4fc;
            border: none;
            border-left: 4px solid #3498db;
            min-height: 60px;
        }

        .fc .fc-event-title {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.875rem;
            margin-bottom: 4px;
        }

        .fc .fc-event-time {
            color: #3498db;
            font-weight: 500;
            font-size: 0.875rem;
            margin-bottom: 4px;
        }

        .fc .fc-event-doctor {
            color: #7f8c8d;
            font-size: 0.75rem;
            font-weight: 400;
        }

        .fc .fc-timegrid-event .fc-event-main {
            padding: 8px 12px;
        }

        .fc .fc-timegrid-event .fc-event-time {
            padding: 8px 12px 0;
        }

        .fc .fc-timegrid-event .fc-event-title {
            padding: 0 12px 4px;
        }

        .fc .fc-toolbar {
            padding: 16px;
            margin-bottom: 0;
            background: white;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .fc .fc-toolbar-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .fc .fc-button {
            background: white;
            border: 1px solid #e0e0e0;
            color: #7f8c8d;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .fc .fc-button:hover {
            background: #f8f9fa;
            border-color: #3498db;
            color: #3498db;
        }

        .fc .fc-button-primary:not(:disabled):active,
        .fc .fc-button-primary:not(:disabled).fc-button-active {
            background: #3498db;
            border-color: #3498db;
            color: white;
        }

        .fc .fc-timegrid-now-indicator-line {
            border-color: #3498db !important;
            border-width: 2px !important;
            z-index: 5 !important;
            position: relative;
        }

        .fc .fc-timegrid-now-indicator-arrow {
            display: none !important;
        }

        .fc .fc-timegrid-now-indicator-line::after {
            display: none !important;
        }

        .empty-state {
            text-align: center;
            padding: 48px;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            margin-top: 24px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .empty-state i {
            font-size: 3rem;
            color: #e0e0e0;
            margin-bottom: 16px;
        }
        
        .empty-state h3 {
            font-size: 1.25rem;
            color: #2c3e50;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .empty-state p {
            font-size: 0.875rem;
            color: #7f8c8d;
        }
        
        @media (max-width: 768px) {
            .welcome-container {
                flex-direction: column;
            }
            
            .sidebar-menu {
                width: 100%;
                padding: 15px;
            }
            
            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .fc .fc-toolbar {
                flex-direction: column;
                gap: 10px;
            }

            .fc .fc-toolbar-title {
                font-size: 1.1rem;
            }
        }

        .current-time-indicator {
            position: absolute;
            left: 0;
            right: 0;
            height: 2px;
            background-color: #3498db;
            z-index: 5;
            opacity: 0.7;
        }

        .current-time-indicator::before {
            content: '';
            position: absolute;
            left: 0;
            width: 8px;
            height: 8px;
            background-color: #3498db;
            border-radius: 50%;
            transform: translateY(-3px);
        }

        .current-time-indicator::after {
            content: '';
            position: absolute;
            right: 0;
            width: 8px;
            height: 8px;
            background-color: #3498db;
            border-radius: 50%;
            transform: translateY(-3px);
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
                <h1 class="welcome-message">Today's Appointments</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Patients
                    </a>
                </div>
            </div>
            
            <div id="calendar"></div>
        </div>
    </div>

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            
            // Debug appointments data
            <c:forEach items="${appointments}" var="appointment">
                console.log('Raw Data:', {
                    patientFirstName: '${appointment.patient.firstName}',
                    patientLastName: '${appointment.patient.lastName}',
                    doctorName: '${appointment.assignedDoctor.doctorName}',
                    date: '${appointment.treatmentStartingDate}'
                });
            </c:forEach>

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridDay',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'timeGridDay,timeGridWeek'
                },
                slotMinTime: '00:00:00',
                slotMaxTime: '24:00:00',
                slotDuration: '01:00:00',
                allDaySlot: false,
                height: '100%',
                expandRows: true,
                stickyHeaderDates: true,
                nowIndicator: true,
                timeZone: 'Asia/Kolkata',
                now: new Date(),
                scrollTime: new Date().getHours() + ':00:00',
                slotEventOverlap: false,
                forceEventDuration: true,
                defaultTimedEventDuration: '01:00:00',
                businessHours: false,
                eventBackgroundColor: '#e8f4fc',
                eventBorderColor: '#3498db',
                eventTextColor: '#2c3e50',
                nowIndicatorClassNames: ['fc-now-indicator-line'],
                nowIndicatorStyle: {
                    borderColor: '#3498db',
                    borderWidth: '2px',
                    zIndex: '5'
                },
                events: [
                    <c:forEach items="${appointments}" var="appointment" varStatus="status">
                    {
                        id: '${appointment.id}',
                        title: '${appointment.patient.firstName} ${appointment.patient.lastName} (${appointment.patient.phoneNumber}) - Dr. ${appointment.assignedDoctor.doctorName}',
                        start: '${appointment.treatmentStartingDate}',
                        url: '${pageContext.request.contextPath}/patients/examination/${appointment.id}',
                        backgroundColor: '#e8f4fc',
                        borderColor: '#3498db',
                        textColor: '#2c3e50'
                    }<c:if test="${not status.last}">,</c:if>
                    </c:forEach>
                ],
                eventClick: function(info) {
                    info.jsEvent.preventDefault();
                    window.location.href = info.event.url;
                },
                eventTimeFormat: {
                    hour: '2-digit',
                    minute: '2-digit',
                    hour12: false
                },
                eventContent: function(arg) {
                    console.log('Event Title:', arg.event.title);
                    return {
                        html: '<div style="padding: 4px; font-size: 12px;">' + 
                              arg.event.title + 
                              '</div>'
                    };
                },
                eventDidMount: function(info) {
                    console.log('Event Title:', info.event.title);
                },
                loading: function(isLoading) {
                    if (isLoading) {
                        console.log('Calendar is loading...');
                    } else {
                        console.log('Calendar loaded');
                    }
                },
                datesSet: function(dateInfo) {
                    // Get current time in IST
                    var now = new Date();
                    var istOffset = 5.5 * 60 * 60 * 1000; // IST is UTC+5:30
                    var istTime = new Date(now.getTime() + istOffset);
                    
                    // Update the calendar's current time
                    calendar.setOption('now', istTime);
                    
                    var currentHour = istTime.getHours();
                    var currentMinute = istTime.getMinutes();
                    var scrollContainer = document.querySelector('.fc-timegrid-body');
                    
                    if (scrollContainer) {
                        var hourHeight = 60; // Height of each hour slot
                        var minuteHeight = hourHeight / 60;
                        var scrollPosition = (currentHour * hourHeight) + (currentMinute * minuteHeight);
                        
                        // Center the current time in the view
                        var containerHeight = scrollContainer.clientHeight;
                        scrollPosition = scrollPosition - (containerHeight / 2);
                        
                        // Ensure we don't scroll past the top or bottom
                        scrollPosition = Math.max(0, Math.min(scrollPosition, scrollContainer.scrollHeight - containerHeight));
                        scrollContainer.scrollTop = scrollPosition;
                    }
                }
            });
            
            // Force calendar to render events
            calendar.render();
            setTimeout(function() {
                calendar.refetchEvents();
            }, 100);

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
                const response = await fetch(`${pageContext.request.contextPath}/patients/checkin/${patientId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    credentials: 'same-origin'
                });

                if (response.ok) {
                    const data = await response.json();
                    if (data.success) {
                        // Update button state for check-out
                        button.innerHTML = '<i class="fas fa-user-times"></i> Check Out';
                        button.className = 'check-btn btn-danger';
                        button.dataset.checkedIn = 'true';
                        button.setAttribute('onclick', `uncheckPatient('${patientId}', this)`);
                    } else {
                        alert(data.message || 'Failed to check in patient');
                    }
                } else {
                    const errorData = await response.json();
                    alert(`Error: ${errorData.message || 'Failed to check in patient'}`);
                }
            } catch (error) {
                console.error('Check-in failed:', error);
                alert('Failed to check in patient. Please try again.');
            }
        }

        async function uncheckPatient(patientId, button) {
            try {
                const csrfToken = document.querySelector('meta[name="_csrf"]').content;
                const response = await fetch(`${pageContext.request.contextPath}/patients/uncheck/${patientId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    credentials: 'same-origin'
                });

                if (response.ok) {
                    const data = await response.json();
                    if (data.success) {
                        // Update button state for check-in
                        button.innerHTML = '<i class="fas fa-user-check"></i> Check In';
                        button.className = 'check-btn btn-primary';
                        button.dataset.checkedIn = 'false';
                        button.setAttribute('onclick', `checkInPatient('${patientId}', this)`);
                    } else {
                        alert(data.message || 'Failed to check out patient');
                    }
                } else {
                    const errorData = await response.json();
                    alert(`Error: ${errorData.message || 'Failed to check out patient'}`);
                }
            } catch (error) {
                console.error('Check-out failed:', error);
                alert('Failed to check out patient. Please try again.');
            }
        }
    </script>
</body>
</html> 