<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Patient Appointments - PeriDesk</title>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    <!-- Bootstrap and Flatpickr for modals and date-time picker -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f0f5fa;
            color: #2c3e50;
            line-height: 1.6;
        }

        .welcome-container { display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 40px; position: relative; }
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
        .page-title { margin: 0; font-size: 24px; font-weight: 600; }
        .subtext { color: #7f8c8d; font-size: 14px; margin-top: 6px; }
        .header-actions { display: flex; gap: 10px; }
        .button { padding: 10px 14px; border-radius: 6px; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 6px; }
        .button.primary { background: #3498db; color: #fff; }
        .button.secondary { background: #ecf0f1; color: #2c3e50; }
        .button:hover { filter: brightness(0.95); }

        .info-banner {
            padding: 15px 18px;
            background: #e8f4fd;
            border: 1px solid #d6eaf8;
            color: #2c3e50;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .status-chip { background: #3498db; color: #fff; border-radius: 999px; padding: 4px 10px; font-size: 12px; text-transform: capitalize; }
        .card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .filter-controls { display: flex; gap: 10px; align-items: center; }
        .filter-select, .sort-button { padding: 8px 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; background: #fff; cursor: pointer; }
        .sort-button { color: #2c3e50; }
        .table { width: 100%; border-collapse: collapse; }
        .table th, .table td { padding: 12px; border-bottom: 1px solid #e0e0e0; }
        .table th { background: rgba(52, 152, 219, 0.08); font-weight: 600; }
        .table tr:hover { background: rgba(52, 152, 219, 0.05); }
        .text-right { text-align: right; }
        .appointment-actions { display: inline-flex; gap: 8px; align-items: center; }
        .button.disabled { pointer-events: none; opacity: 0.6; }
    </style>
</head>
<body>
<div class="welcome-container">
    <jsp:include page="/WEB-INF/views/common/menu.jsp" />
    <div class="main-content">
        <div class="welcome-header">
            <div>
                <h1 class="page-title">
                    <i class="fas fa-calendar-check" style="color:#3498db;"></i>
                    Appointments — <c:out value="${patient.firstName}"/> <c:out value="${patient.lastName}"/>
                </h1>
                <div class="subtext">Patient ID: <c:out value="${patient.id}"/> · Phone: <c:out value="${patient.phoneNumber}"/></div>
            </div>
            <div class="header-actions">
                <a class="button secondary" href="${pageContext.request.contextPath}/patients/details/${patient.id}"><i class="fas fa-user"></i> Patient Details</a>

            </div>
        </div>

        <c:if test="${not empty upcomingAppointment}">
            <div class="info-banner">
                <i class="fas fa-bell" style="color:#f39c12;"></i>
                <div>
                    <strong>Upcoming:</strong>
                    <span class="ms-1"><c:out value="${upcomingAppointment.dateStr}"/> at <c:out value="${upcomingAppointment.timeStr}"/> — Dr. <c:out value="${upcomingAppointment.doctorName}"/></span>
                    <span class="status-chip"><c:out value="${fn:toLowerCase(upcomingAppointment.statusDisplay)}"/></span>
                    <c:if test="${not empty upcomingAppointment.notes}">
                        <div class="subtext">Notes: <c:out value="${upcomingAppointment.notes}"/></div>
                    </c:if>
                </div>
                <a class="button secondary" style="margin-left:auto" href="#" onclick="showAppointmentStatusModal('${upcomingAppointment.id}'); return false;"><i class="fas fa-sync-alt"></i> Update Status</a>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h3 style="margin:0;">All Appointments</h3>
                <div class="filter-controls">
                    <select id="statusFilter" class="filter-select">
                        <option value="">All Statuses</option>
                        <option value="SCHEDULED">Scheduled</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="CANCELLED">Cancelled</option>
                        <option value="NO_SHOW">No Show</option>
                    </select>
                    <button id="sortAsc" class="sort-button"><i class="fas fa-sort-amount-up"></i> Date Asc</button>
                    <button id="sortDesc" class="sort-button"><i class="fas fa-sort-amount-down"></i> Date Desc</button>
                </div>
            </div>
            <table class="table" id="appointmentsTable">
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Doctor</th>
                    <th>Mobile</th>
                    <th>Clinic</th>
                    <th>Purpose / Notes</th>
                    <th>Status</th>
                    <th class="text-right">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ap" items="${appointmentsData}">
                    <tr data-status="${ap.status}" data-date="${ap.dateIso}">
                        <td><c:out value="${ap.dateStr}"/></td>
                        <td><c:out value="${ap.timeStr}"/></td>
                        <td><c:out value="${ap.doctorName}"/></td>
                        <td><c:out value="${ap.mobile}"/></td>
                        <td><c:out value="${ap.clinicName}"/></td>
                        <td><c:out value="${fn:escapeXml(ap.notes)}"/></td>
                        <td><span class="status-chip"><c:out value="${fn:toLowerCase(ap.statusDisplay)}"/></span></td>
                        <td class="text-right">
                            <div class="appointment-actions">
                                <a class="button secondary" href="#" onclick="showAppointmentStatusModal('${ap.id}'); return false;"><i class="fas fa-sync-alt"></i> Update Status</a>
                                <a href="#" class="button secondary ${ap.status ne 'SCHEDULED' ? 'disabled' : ''}"
                                   onclick="showRescheduleModal('${ap.id}', '${fn:escapeXml(ap.dateStr)} ${fn:escapeXml(ap.timeStr)}', '${fn:escapeXml(ap.dateIso)}'); return false;">
                                    <i class="fas fa-calendar-alt"></i> Reschedule
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 15px; text-align: right;">
            <a class="button secondary" href="${pageContext.request.contextPath}/patients/details/${patient.id}"><i class="fas fa-arrow-left"></i> Back to Patient</a>
        </div>
    </div>
</div>

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
                    <input type="text" id="patientRegistrationNumber" class="form-control" placeholder="Enter patient registration number" value="${patient.registrationCode}">
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
<!-- Reschedule Modal -->
<div id="rescheduleModal" class="modal" style="display: none;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Reschedule Appointment</h5>
                <button type="button" class="btn-close" onclick="closeRescheduleModal()"></button>
            </div>
            <div class="modal-body">
                <form id="rescheduleForm">
                    <input type="hidden" id="rescheduleAppointmentId">

                    <div class="form-group" style="margin-bottom:12px;">
                        <label>Current Date & Time:</label>
                        <div id="currentDateTime" style="font-weight:600;">-</div>
                    </div>

                    <div class="form-group" style="margin-bottom:12px;">
                        <label for="newAppointmentDateTime">New Date & Time</label>
                        <input type="text" id="newAppointmentDateTime" class="form-control" placeholder="Select new date & time">
                    </div>

                    <div class="form-group" style="margin-bottom:12px;">
                        <label for="rescheduleReasonSelect">Reason</label>
                        <select id="rescheduleReasonSelect" class="form-control" onchange="toggleOtherReason()">
                            <option value="Patient Request">Patient Request</option>
                            <option value="Doctor Request">Doctor Request</option>
                            <option value="Doctor Unavailable">Doctor Unavailable</option>
                            <option value="Scheduling Conflict">Scheduling Conflict</option>
                            <option value="Emergency">Emergency</option>
                            <option value="Clinic Closed">Clinic Closed</option>
                            <option value="Equipment Maintenance">Equipment Maintenance</option>
                            <option value="Weather/Transport Issue">Weather/Transport Issue</option>
                            <option value="Follow-up Adjustment">Follow-up Adjustment</option>
                            <option value="Other">Other</option>
                        </select>
                        <div id="otherReasonGroup" class="form-group" style="margin-top:8px; display:none;">
                            <label for="rescheduleReasonOther">Other Reason</label>
                            <input type="text" id="rescheduleReasonOther" class="form-control" placeholder="Enter reason">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom:12px;">
                        <label for="additionalNotes">Additional Notes</label>
                        <textarea id="additionalNotes" class="form-control" rows="2" placeholder="Optional"></textarea>
                    </div>

                    <div id="rescheduleError" class="alert alert-danger" style="display:none;"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeRescheduleModal()">Cancel</button>
                <button type="button" class="btn btn-warning" onclick="submitReschedule()">Reschedule</button>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const filter = document.getElementById('statusFilter');
        const table = document.getElementById('appointmentsTable');
        const sortAscBtn = document.getElementById('sortAsc');
        const sortDescBtn = document.getElementById('sortDesc');

        function applyFilter() {
            const val = filter.value;
            table.querySelectorAll('tbody tr').forEach(row => {
                const status = row.getAttribute('data-status');
                row.style.display = !val || status === val ? '' : 'none';
            });
        }

        function sortRows(desc = false) {
            const rows = Array.from(table.querySelectorAll('tbody tr'));
            rows.sort((a, b) => {
                const da = a.getAttribute('data-date') || '';
                const db = b.getAttribute('data-date') || '';
                return desc ? db.localeCompare(da) : da.localeCompare(db);
            });
            const tbody = table.querySelector('tbody');
            rows.forEach(r => tbody.appendChild(r));
        }

        filter.addEventListener('change', applyFilter);
        sortAscBtn.addEventListener('click', () => sortRows(false));
        sortDescBtn.addEventListener('click', () => sortRows(true));
    })();

    // Status update modal logic
    var currentAppointmentId = null;

    function showAppointmentStatusModal(appointmentId) {
        if (!appointmentId) {
            console.error('No appointment ID provided');
            return;
        }
        currentAppointmentId = appointmentId;
        // Hide previous error
        var err = document.getElementById('statusUpdateError');
        if (err) err.style.display = 'none';
        // Pre-fill registration if available
        var regInput = document.getElementById('patientRegistrationNumber');
        if (regInput && !regInput.value) {
            regInput.value = '${patient.registrationCode}';
        }
        // Reset status change visibility
        handleStatusChange();
        var modal = new bootstrap.Modal(document.getElementById('statusUpdateModal'));
        modal.show();
    }

    function handleStatusChange() {
        var statusEl = document.getElementById('statusSelect');
        var groupEl = document.getElementById('patientRegistrationGroup');
        if (!statusEl || !groupEl) return;
        var status = statusEl.value;
        groupEl.style.display = (status === 'COMPLETED') ? 'block' : 'none';
    }

    function updateStatus() {
        if (!currentAppointmentId) {
            console.error('No appointment ID available');
            return;
        }
        var newStatus = document.getElementById('statusSelect').value;
        var patientRegistrationNumber = document.getElementById('patientRegistrationNumber').value;

        if (newStatus === 'COMPLETED' && !patientRegistrationNumber) {
            var errorDiv = document.getElementById('statusUpdateError');
            errorDiv.textContent = 'Please enter patient registration number';
            errorDiv.style.display = 'block';
            return;
        }

        var url = '${pageContext.request.contextPath}/appointments/management/update-status';

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                '${_csrf.headerName}': '${_csrf.token}'
            },
            body: JSON.stringify({
                id: currentAppointmentId,
                status: newStatus,
                patientRegistrationNumber: patientRegistrationNumber
            })
        })
        .then(function(response) {
            if (response.ok) {
                var modal = bootstrap.Modal.getInstance(document.getElementById('statusUpdateModal'));
                if (modal) modal.hide();
                window.location.reload();
            } else {
                return response.text().then(function(text) {
                    var errorDiv = document.getElementById('statusUpdateError');
                    var errorMessage = 'Failed to update status';
                    try {
                        var data = JSON.parse(text);
                        errorMessage = data.message || errorMessage;
                    } catch (e) {
                        errorMessage = 'Server error: ' + (text.length > 100 ? text.substring(0, 100) + '...' : text);
                    }
                    errorDiv.textContent = errorMessage;
                    errorDiv.style.display = 'block';
                    throw new Error(errorMessage);
                });
            }
        })
        .catch(function(error) {
            console.error('Error updating status:', error);
            var errorDiv = document.getElementById('statusUpdateError');
            errorDiv.textContent = error.message;
            errorDiv.style.display = 'block';
        });
    }

    // Reschedule functions
    function showRescheduleModal(appointmentId, formattedDateTime, rawDateTime) {
        document.getElementById('rescheduleAppointmentId').value = appointmentId;
        document.getElementById('currentDateTime').textContent = formattedDateTime;
        document.getElementById('rescheduleModal').style.display = 'block';

        // Initialize flatpickr for new date/time
        flatpickr('#newAppointmentDateTime', {
            enableTime: true,
            dateFormat: 'Y-m-d H:i:S',
            time_24hr: false,
            minDate: 'today',
            minTime: '00:00',
            maxTime: '23:59',
            defaultHour: new Date().getHours(),
            defaultMinute: new Date().getMinutes(),
            defaultSeconds: 0
        });
    }

    function closeRescheduleModal() {
        document.getElementById('rescheduleModal').style.display = 'none';
        document.getElementById('rescheduleForm').reset();
        document.getElementById('rescheduleError').style.display = 'none';
        var otherGroup = document.getElementById('otherReasonGroup');
        if (otherGroup) { otherGroup.style.display = 'none'; }
    }

    function toggleOtherReason() {
        var select = document.getElementById('rescheduleReasonSelect');
        var otherGroup = document.getElementById('otherReasonGroup');
        if (!select || !otherGroup) return;
        otherGroup.style.display = (select.value === 'Other') ? 'block' : 'none';
    }

    function submitReschedule() {
        var appointmentId = document.getElementById('rescheduleAppointmentId').value;
        var newDateTime = document.getElementById('newAppointmentDateTime').value;
        var reasonSelect = document.getElementById('rescheduleReasonSelect');
        var reason = reasonSelect ? reasonSelect.value : '';
        if (reason === 'Other') {
            var otherReason = document.getElementById('rescheduleReasonOther').value;
            if (!otherReason) {
                document.getElementById('rescheduleError').textContent = 'Please provide the reason for Other';
                document.getElementById('rescheduleError').style.display = 'block';
                return;
            }
            reason = otherReason;
        }
        var additionalNotes = document.getElementById('additionalNotes').value;

        if (!newDateTime || !reason) {
            document.getElementById('rescheduleError').textContent = 'Please fill in all required fields';
            document.getElementById('rescheduleError').style.display = 'block';
            return;
        }

        // Convert "YYYY-MM-DD HH:mm:SS" to "YYYY-MM-DDTHH:mm:SS"
        var formattedDateTime = newDateTime.replace(' ', 'T');

        var data = {
            appointmentId: parseInt(appointmentId),
            newAppointmentDateTime: formattedDateTime,
            reason: reason,
            additionalNotes: additionalNotes
        };

        fetch('${pageContext.request.contextPath}/appointments/reschedule', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                '${_csrf.headerName}': '${_csrf.token}'
            },
            body: JSON.stringify(data)
        })
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success) {
                closeRescheduleModal();
                window.location.reload();
            } else {
                document.getElementById('rescheduleError').textContent = data.message;
                document.getElementById('rescheduleError').style.display = 'block';
            }
        })
        .catch(function(error) {
            console.error('Error rescheduling appointment:', error);
            document.getElementById('rescheduleError').textContent = 'An error occurred while rescheduling the appointment';
            document.getElementById('rescheduleError').style.display = 'block';
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
</body>
</html>