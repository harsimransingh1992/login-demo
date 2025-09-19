<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="_csrf" content="${_csrf.token}" />
                        <meta name="_csrf_header" content="${_csrf.headerName}" />
                        <title>Patient List - PeriDesk</title>
                        <jsp:include page="/WEB-INF/views/common/head.jsp" />
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="${pageContext.request.contextPath}/js/common.js"></script>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

                            .search-container {
                                margin: 20px 0;
                                padding: 15px;
                                background: #fff;
                                border-radius: 8px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                            }

                            .search-form {
                                display: flex;
                                gap: 10px;
                                align-items: stretch;
                            }

                            .search-select {
                                padding: 10px 15px;
                                border: 1px solid #ddd;
                                border-radius: 6px;
                                background-color: #fff;
                                font-size: 14px;
                                color: #333;
                                min-width: 220px;
                                cursor: pointer;
                                transition: border-color 0.3s ease;
                                height: 42px;
                                box-sizing: border-box;
                            }

                            .search-select:hover {
                                border-color: #007bff;
                            }

                            .search-select:focus {
                                outline: none;
                                border-color: #007bff;
                                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
                            }

                            .search-input {
                                flex: 1;
                                padding: 10px 15px;
                                border: 1px solid #ddd;
                                border-radius: 6px;
                                font-size: 14px;
                                transition: border-color 0.3s ease;
                                min-width: 400px;
                                height: 42px;
                                box-sizing: border-box;
                            }

                            .search-input:focus {
                                outline: none;
                                border-color: #007bff;
                                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
                            }

                            .search-button {
                                padding: 6px 10px;
                                background-color: #007bff;
                                color: white;
                                border: none;
                                border-radius: 6px;
                                cursor: pointer;
                                font-size: 11px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                gap: 3px;
                                transition: background-color 0.3s ease;
                                white-space: nowrap;
                                min-width: 70px;
                                height: 42px;
                                box-sizing: border-box;
                            }

                            .search-button:hover {
                                background-color: #0056b3;
                            }

                            .search-button i {
                                font-size: 11px;
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
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

                            .audit-info {
                                font-size: 0.85rem;
                                color: #495057;
                                font-weight: 500;
                            }

                            .text-muted {
                                color: #6c757d;
                                font-style: italic;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="welcome-container">
                            <jsp:include page="/WEB-INF/views/common/menu.jsp" />
                            <div class="main-content">
                                <div class="welcome-header">
                                    <h1 class="welcome-message">Patient Records</h1>
                                    <form action="${pageContext.request.contextPath}/logout" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn-secondary"><i class="fas fa-power-off"></i>
                                            Logout</button>
                                    </form>
                                </div>

                                <div class="search-container">
                                    <form action="${pageContext.request.contextPath}/patients/search" method="get"
                                        class="search-form">
                                        <select name="searchType" class="search-select" required>
                                            <option value="name">Search by Name</option>
                                            <option value="phone">Search by Phone</option>
                                            <option value="registration">Search by Registration Code</option>
                                            <option value="examination">Search by Examination ID</option>
                                        </select>
                                        <input type="text" name="query" class="search-input"
                                            placeholder="Enter search term..." required>
                                        <button type="submit" class="search-button">
                                            <i class="fas fa-search"></i>
                                            Search
                                        </button>
                                    </form>
                                </div>

                                <h1>Patient List</h1>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Registration Code</th>
                                                <th>Name</th>
                                                <th>Date of Birth</th>
                                                <th>Gender</th>
                                                <th>Phone</th>
                                                <th>Email</th>
                                                <th>Registration Date</th>
                                                <th>Created By</th>
                                                <th>Registered At</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty patients}">
                                                <tr>
                                                    <td colspan="9" class="no-results">No patients found</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${patients}" var="patient">
                                                <tr>
                                                    <td>${patient.registrationCode}</td>
                                                    <td><a href="${pageContext.request.contextPath}/patients/details/${patient.id}"
                                                            class="patient-link">${patient.firstName}
                                                            ${patient.lastName}</a></td>
                                                    <td>
                                                        <fmt:formatDate value="${patient.dateOfBirth}"
                                                            pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>${patient.gender}</td>
                                                    <td>${patient.phoneNumber}</td>
                                                    <td>${patient.email}</td>
                                                    <td>
                                                        <fmt:formatDate value="${patient.registrationDate}"
                                                            pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty patient.createdBy}">
                                                                <span class="audit-info">${patient.createdBy}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty patient.registeredClinic}">
                                                                <span
                                                                    class="audit-info">${patient.registeredClinic}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                            <div class="action-buttons">
                                                                <button
                                                                    onclick="scheduleAppointment('${patient.id}', '${patient.firstName} ${patient.lastName}')"
                                                                    class="btn-appointment"><i
                                                                        class="fas fa-calendar-plus"></i> Schedule
                                                                    Appointment</button>
                                                                <c:choose>
                                                                    <c:when test="${!patient.checkedIn}">
                                                                        <button onclick="checkIn('${patient.id}')"
                                                                            class="btn-checkin"><i
                                                                                class="fas fa-user-check"></i> Check
                                                                            In</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button onclick="uncheck('${patient.id}')"
                                                                            class="btn-checkout"><i
                                                                                class="fas fa-user-times"></i> Check
                                                                            Out</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </sec:authorize>
                                                        <sec:authorize
                                                            access="hasRole('DOCTOR') or hasRole('OPD_DOCTOR')">
                                                            <span
                                                                style="color: #6c757d; font-style: italic; font-size: 0.9em;">Disabled
                                                                for Doctor Role</span>
                                                        </sec:authorize>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination Controls -->
                                <c:if test="${totalPages > 1 or not empty patients}">
                                    <div class="pagination-container">
                                        <div class="pagination-info">
                                            Showing ${(currentPage * pageSize) + 1} to ${(currentPage * pageSize) +
                                            fn:length(patients)} of ${totalItems} patients
                                        </div>

                                        <div class="pagination-controls">
                                            <!-- Page Size Selector -->
                                            <div class="page-size-selector">
                                                <label for="pageSize">Show:</label>
                                                <select id="pageSize" onchange="changePageSize(this.value)">
                                                    <option value="10" ${pageSize==10 ? 'selected' : '' }>10</option>
                                                    <option value="20" ${pageSize==20 ? 'selected' : '' }>20</option>
                                                    <option value="50" ${pageSize==50 ? 'selected' : '' }>50</option>
                                                    <option value="100" ${pageSize==100 ? 'selected' : '' }>100</option>
                                                </select>
                                            </div>

                                            <!-- Sort Controls -->
                                            <div class="sort-controls">
                                                <label for="sort">Sort by:</label>
                                                <select id="sort" onchange="changeSort(this.value)">
                                                    <option value="id" ${sort=='id' ? 'selected' : '' }>ID</option>
                                                    <option value="firstName" ${sort=='firstName' ? 'selected' : '' }>
                                                        Name</option>
                                                    <option value="registrationDate" ${sort=='registrationDate'
                                                        ? 'selected' : '' }>Registration Date</option>
                                                    <option value="dateOfBirth" ${sort=='dateOfBirth' ? 'selected' : ''
                                                        }>Date of Birth</option>
                                                </select>
                                                <select id="direction" onchange="changeDirection(this.value)">
                                                    <option value="desc" ${direction=='desc' ? 'selected' : '' }>Desc
                                                    </option>
                                                    <option value="asc" ${direction=='asc' ? 'selected' : '' }>Asc
                                                    </option>
                                                </select>
                                            </div>

                                            <!-- Navigation Buttons -->
                                            <c:if test="${currentPage > 0}">
                                                <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})"
                                                    class="pagination-button">
                                                    <i class="fas fa-chevron-left"></i> Previous
                                                </a>
                                            </c:if>

                                            <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                                <c:choose>
                                                    <c:when test="${pageNum == currentPage}">
                                                        <span class="pagination-button active">${pageNum + 1}</span>
                                                    </c:when>
                                                    <c:when test="${pageNum == 0}">
                                                        <a href="javascript:void(0)" onclick="goToPage(${pageNum})"
                                                            class="pagination-button">${pageNum + 1}</a>
                                                    </c:when>
                                                    <c:when test="${pageNum == totalPages - 1}">
                                                        <a href="javascript:void(0)" onclick="goToPage(${pageNum})"
                                                            class="pagination-button">${pageNum + 1}</a>
                                                    </c:when>
                                                    <c:when
                                                        test="${pageNum >= currentPage - 2 and pageNum <= currentPage + 2}">
                                                        <a href="javascript:void(0)" onclick="goToPage(${pageNum})"
                                                            class="pagination-button">${pageNum + 1}</a>
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
                                                <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})"
                                                    class="pagination-button">
                                                    Next <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Appointment Scheduling Modal -->
                        <div id="appointmentModal" class="modal"
                            style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
                            <div class="modal-content"
                                style="background-color: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 500px; box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
                                <div class="modal-header"
                                    style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; padding: 20px; border-radius: 12px 12px 0 0;">
                                    <h3
                                        style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                                        <i class="fas fa-calendar-plus"></i> Schedule Appointment
                                    </h3>
                                    <span class="close-modal" onclick="closeAppointmentModal()"
                                        style="position: absolute; right: 20px; top: 20px; font-size: 28px; font-weight: bold; cursor: pointer; color: white;">&times;</span>
                                </div>
                                <div class="modal-body" style="padding: 25px;">
                                    <form id="appointmentForm">
                                        <input type="hidden" id="patientId" name="patientId">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Patient
                                                Name</label>
                                            <input type="text" id="patientName" readonly
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; background-color: #f8f9fa; color: #6c757d;">
                                        </div>

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="appointmentDate"
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Appointment
                                                Date</label>
                                            <input type="date" id="appointmentDate" name="appointmentDate" required
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
                                        </div>

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="appointmentTime"
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Appointment
                                                Time</label>
                                            <input type="time" id="appointmentTime" name="appointmentTime" required
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
                                        </div>

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="doctorId"
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Assign
                                                Doctor (Optional)</label>
                                            <select id="doctorId" name="doctorId"
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
                                                <option value="">Select a doctor (optional)</option>
                                                <c:forEach items="${clinicDoctors}" var="doctor">
                                                    <option value="${doctor.id}">
                                                        Dr. ${doctor.firstName} ${doctor.lastName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="appointmentNotes"
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Notes
                                                (Optional)</label>
                                            <textarea id="appointmentNotes" name="appointmentNotes" rows="3"
                                                placeholder="Enter any additional notes for this appointment..."
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; resize: vertical;"></textarea>
                                        </div>

                                        <div class="modal-footer"
                                            style="display: flex; justify-content: flex-end; gap: 12px; padding: 20px 0 0 0; border-top: 1px solid #eee; margin-top: 20px;">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeAppointmentModal()"
                                                style="background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancel</button>
                                            <button type="button" id="saveAppointment" class="btn btn-primary"
                                                style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                                                <i class="fas fa-save"></i> Schedule Appointment
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Check-In Modal -->
                        <div id="checkInModal" class="modal"
                            style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
                            <div class="modal-content"
                                style="background-color: white; margin: 10% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 500px; box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
                                <div class="modal-header"
                                    style="background: linear-gradient(135deg, #27ae60, #2ecc71); color: white; padding: 20px; border-radius: 12px 12px 0 0;">
                                    <h3
                                        style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                                        <i class="fas fa-user-check"></i> Check In Patient
                                    </h3>
                                    <span class="close-modal" onclick="closeCheckInModal()"
                                        style="position: absolute; right: 20px; top: 20px; font-size: 28px; font-weight: bold; cursor: pointer; color: white;">&times;</span>
                                </div>
                                <div class="modal-body" style="padding: 25px;">
                                    <form id="checkInForm">
                                        <input type="hidden" id="checkInPatientId" name="patientId">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Patient
                                                Name</label>
                                            <input type="text" id="checkInPatientName" readonly
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; background-color: #f8f9fa; color: #6c757d;">
                                        </div>

                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="checkInDoctorId"
                                                style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Assign
                                                Doctor (Optional)</label>
                                            <select id="checkInDoctorId" name="doctorId"
                                                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
                                                <option value="">Select a doctor (optional)</option>
                                                <c:forEach items="${clinicDoctors}" var="doctor">
                                                    <option value="${doctor.id}">
                                                        Dr. ${doctor.firstName} ${doctor.lastName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="modal-footer"
                                            style="display: flex; justify-content: flex-end; gap: 12px; padding: 20px 0 0 0; border-top: 1px solid #eee; margin-top: 20px;">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeCheckInModal()"
                                                style="background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancel</button>
                                            <button type="button" id="confirmCheckIn" class="btn btn-success"
                                                style="background: linear-gradient(135deg, #27ae60, #2ecc71); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                                                <i class="fas fa-user-check"></i> Check In Patient
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script>
                            // Appointment scheduling functions
                            function scheduleAppointment(patientId, patientName) {
                                document.getElementById('patientId').value = patientId;
                                document.getElementById('patientName').value = patientName;

                                // Set default date to today
                                const today = new Date().toISOString().split('T')[0];
                                document.getElementById('appointmentDate').value = today;

                                // Set default time to next hour
                                const nextHour = new Date();
                                nextHour.setHours(nextHour.getHours() + 1);
                                const timeString = nextHour.toTimeString().slice(0, 5);
                                document.getElementById('appointmentTime').value = timeString;

                                document.getElementById('appointmentModal').style.display = 'block';
                            }

                            function closeAppointmentModal() {
                                document.getElementById('appointmentModal').style.display = 'none';
                                // Clear form
                                document.getElementById('appointmentForm').reset();
                            }

                            // Save appointment
                            document.getElementById('saveAppointment').addEventListener('click', async function () {
                                const patientId = document.getElementById('patientId').value;
                                const appointmentDate = document.getElementById('appointmentDate').value;
                                const appointmentTime = document.getElementById('appointmentTime').value;
                                const appointmentNotes = document.getElementById('appointmentNotes').value;
                                const doctorId = document.getElementById('doctorId').value;

                                if (!appointmentDate || !appointmentTime) {
                                    alert('Please select both date and time for the appointment.');
                                    return;
                                }

                                try {
                                    const response = await fetch('${pageContext.request.contextPath}/patients/schedule-appointment', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                                        },
                                        body: JSON.stringify({
                                            patientId: patientId,
                                            appointmentDate: appointmentDate,
                                            appointmentTime: appointmentTime,
                                            notes: appointmentNotes,
                                            doctorId: doctorId
                                        })
                                    });

                                    if (response.ok) {
                                        const result = await response.json();
                                        if (result.success) {
                                            alert('Appointment scheduled successfully!');
                                            closeAppointmentModal();
                                        } else {
                                            alert('Error: ' + (result.message || 'Failed to schedule appointment'));
                                        }
                                    } else {
                                        alert('Error: Failed to schedule appointment');
                                    }
                                } catch (error) {
                                    console.error('Error scheduling appointment:', error);
                                    alert('Error: Failed to schedule appointment');
                                }
                            });

                            // Close modal when clicking outside
                            window.onclick = function (event) {
                                const appointmentModal = document.getElementById('appointmentModal');
                                const checkInModal = document.getElementById('checkInModal');

                                if (event.target === appointmentModal) {
                                    closeAppointmentModal();
                                }
                                if (event.target === checkInModal) {
                                    closeCheckInModal();
                                }
                            }

                            // Check-in modal functions
                            function checkIn(patientId) {
                                // Get patient name from the row
                                const patientRow = event.target.closest('tr');
                                const patientNameCell = patientRow.querySelector('td:first-child');
                                const patientName = patientNameCell.textContent.trim();

                                document.getElementById('checkInPatientId').value = patientId;
                                document.getElementById('checkInPatientName').value = patientName;
                                document.getElementById('checkInModal').style.display = 'block';
                            }

                            function closeCheckInModal() {
                                document.getElementById('checkInModal').style.display = 'none';
                                // Clear form
                                document.getElementById('checkInForm').reset();
                            }

                            // Confirm check-in with doctor assignment
                            document.getElementById('confirmCheckIn').addEventListener('click', async function () {
                                const patientId = document.getElementById('checkInPatientId').value;
                                const doctorId = document.getElementById('checkInDoctorId').value;

                                // Show loading state
                                const button = this;
                                const originalContent = button.innerHTML;
                                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Checking In...';
                                button.disabled = true;

                                try {
                                    const url = "${pageContext.request.contextPath}/patients/checkin/" + patientId;
                                    const response = await fetch(url, {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                                        },
                                        body: JSON.stringify({
                                            doctorId: doctorId
                                        }),
                                        credentials: 'same-origin'
                                    });

                                    if (response.ok) {
                                        const result = await response.json();
                                        if (result.success) {
                                            closeCheckInModal();
                                            window.location.reload(); // Reload page on successful check-in
                                        } else {
                                            alert('Error: ' + (result.message || 'Failed to check in patient'));
                                            button.innerHTML = originalContent;
                                            button.disabled = false;
                                        }
                                    } else {
                                        console.error('Error response:', response.status, response.statusText);
                                        alert('Failed to check in patient. Please try again.');
                                        button.innerHTML = originalContent;
                                        button.disabled = false;
                                    }
                                } catch (error) {
                                    console.error('Request failed:', error);
                                    alert('Network error. Please try again.');
                                    button.innerHTML = originalContent;
                                    button.disabled = false;
                                }
                            });

                            async function uncheck(patientId) {
                                // Find the button that was clicked
                                const button = event.target.closest('button');
                                if (!button) return;

                                // Prevent multiple clicks
                                if (button.disabled) {
                                    console.log('Check-out already in progress, ignoring click');
                                    return;
                                }

                                // Store original button content
                                const originalContent = button.innerHTML;
                                const originalDisabled = button.disabled;

                                // Show loading state
                                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Checking Out...';
                                button.disabled = true;
                                button.classList.add('btn-loading');

                                try {
                                    const url = "${pageContext.request.contextPath}/patients/uncheck/" + patientId;
                                    const response = await fetch(url, {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                                        },
                                        credentials: 'same-origin'
                                    });

                                    if (response.ok) {
                                        window.location.reload(); // Reload page on successful check-out
                                    } else {
                                        console.error('Error response:', response.status, response.statusText);
                                        // Restore button state on error
                                        button.innerHTML = originalContent;
                                        button.disabled = originalDisabled;
                                        button.classList.remove('btn-loading');
                                        alert('Failed to check out patient. Please try again.');
                                    }
                                } catch (error) {
                                    console.error('Request failed:', error);
                                    // Restore button state on error
                                    button.innerHTML = originalContent;
                                    button.disabled = originalDisabled;
                                    button.classList.remove('btn-loading');
                                    alert('Network error. Please try again.');
                                }
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