<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cross-Clinic Schedules - PeriDesk</title>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <meta name="_csrf" content="${_csrf.token}" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <!-- FullCalendar v3 (consistent with receptionist management page) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@3.10.5/dist/fullcalendar.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.4/min/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@3.10.5/dist/fullcalendar.min.js"></script>
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/select-clinic.css" />
</head>
<body data-context-path="${pageContext.request.contextPath}">
<div class="welcome-container">
    <jsp:include page="/WEB-INF/views/common/menu.jsp" />

    <div class="main-content">
        <div id="notificationContainer" class="notification-container"></div>
        <div class="welcome-header">
            <h1 class="welcome-message">Cross-Clinic Schedules</h1>
            <div class="actions">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/welcome"><i class="fas fa-arrow-left"></i> Back</a>
            </div>
        </div>

        <c:if test="${!currentUserHasCrossClinicApptAccess}">
            <div class="alert"><i class="fas fa-shield-alt"></i> You do not have access to cross-clinic schedules.</div>
        </c:if>

        <c:if test="${currentUserHasCrossClinicApptAccess}">
            <div class="page-grid">
                <div class="card">
                    <h3><i class="fas fa-clinic-medical"></i> Clinics</h3>
                    <div class="form-group">
                        <label for="clinicDropdown" class="muted">Select a clinic</label>
                        <select id="clinicDropdown">
                            <option value="">-- Select Clinic --</option>
                            <c:forEach var="clinic" items="${clinics}">
                                <option value="${clinic.clinicId}">${clinic.clinicName} (${clinic.clinicId})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="muted" id="clinicHint">Only clinics you are authorized to view are listed.</div>
                </div>
                <div class="card">
                    <h3><i class="fas fa-user-md"></i> Doctors</h3>
                    <div class="form-group">
                        <label for="doctorDropdown" class="muted">Select a doctor</label>
                        <select id="doctorDropdown">
                            <option value="">-- Select Doctor --</option>
                        </select>
                    </div>
                    <div class="muted" id="doctorHint">Select a clinic to load doctors</div>
                </div>
                <div class="card">
                    <h3><i class="far fa-calendar-alt"></i> Date</h3>
                    <div class="form-group">
                        <label class="muted">Select a date</label>
                        <input type="date" class="datePicker" />
                    </div>
                </div>
            </div>

            <div class="card" id="appointmentsCard" style="margin-top:20px;">
                <div style="display:flex; justify-content:space-between; align-items:center; gap:12px;">
                    <h3 style="margin:0"><i class="fas fa-calendar-check"></i> Appointments</h3>
                    <div style="display:flex; align-items:center; gap:10px;">
                        <button class="btn btn-primary" id="openCreateAppointmentModal"><i class="fas fa-calendar-plus"></i> Create Cross Clinic Appointment</button>
                        <div class="calendar-toolbar">
                            <span class="muted">View</span>
                            <button class="btn btn-outline" id="tableViewBtn">Table</button>
                            <button class="btn btn-outline" id="calendarViewBtn">Calendar</button>
                        </div>
                    </div>
                </div>
                <div class="muted" id="appointmentsHint">Select a doctor and date to view appointments.</div>
                <div id="appointmentsTableContainer">
                    <div class="empty">No appointments to show</div>
                </div>
                <div id="appointmentsCalendarContainer" style="display:none;">
                    <div id="selectClinicCalendar"></div>
                </div>
            </div>

            <div class="footer-actions">
                <!-- Controls moved into page-grid; management/tracking links removed -->
            </div>
        </c:if>
    </div>
</div>

<!-- Create Appointment Modal -->
<div id="createAppointmentModal" class="modal-overlay" style="display:none;">
  <div class="modal">
    <div class="modal-header">
      <h3 style="margin:0"><i class="fas fa-calendar-plus"></i> Create Cross Clinic Appointment</h3>
      <button id="closeCreateAppointmentModal" class="modal-close" title="Close">&times;</button>
    </div>
    <div class="modal-body">
      <div class="form-group">
        <label class="muted" for="modalClinicSelect">Clinic</label>
        <select id="modalClinicSelect">
          <option value="">-- Select Clinic --</option>
        </select>
      </div>
      <div class="form-group">
        <label class="muted" for="modalDoctorSelect">Doctor</label>
        <select id="modalDoctorSelect">
          <option value="">-- Select Doctor --</option>
        </select>
      </div>
      <div class="form-group">
        <label class="muted" for="modalDateTimeInput">Date & Time</label>
        <input type="datetime-local" id="modalDateTimeInput" />
      </div>
      <div class="form-group">
        <label class="muted" for="modalPatientSearch">Patient Search (Reg. Code)</label>
        <div class="inline-input">
          <input type="text" id="modalPatientSearch" placeholder="Enter registration code" />
          <button class="btn btn-outline" id="modalSearchPatientBtn">Search</button>
        </div>
        <div class="muted" id="modalPatientResult"></div>
      </div>

      <div class="form-group">
        <label class="muted" for="modalNotes">Notes (optional)</label>
        <textarea id="modalNotes" rows="2"></textarea>
      </div>
      <div class="form-actions" style="display:flex; justify-content:flex-end; gap:10px;">
        <button class="btn btn-secondary" id="cancelCreateAppointmentBtn">Cancel</button>
        <button class="btn btn-primary" id="submitCreateAppointmentBtn">Create</button>
      </div>
      <div class="muted" id="modalError" style="color:#c00; display:none;"></div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/select-clinic.js"></script>
</body>
</html>