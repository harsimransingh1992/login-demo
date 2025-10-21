<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Appointment Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0"><i class="fas fa-calendar-check"></i> Appointment Details</h2>
        <div>
            <c:if test="${not empty appointment && not empty appointment.patient}">
                <a href="${pageContext.request.contextPath}/patients/details/${appointment.patient.id}" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-arrow-left"></i> Back to Patient
                </a>
            </c:if>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-6">
                    <div class="mb-2"><strong>Date:</strong> <span>${appointmentDate}</span></div>
                    <div class="mb-2"><strong>Time:</strong> <span>${appointmentTime}</span></div>
                    <div class="mb-2"><strong>Status:</strong> <span class="badge bg-secondary">${statusDisplay}</span></div>
                </div>
                <div class="col-md-6">
                    <div class="mb-2"><strong>Patient:</strong>
                        <c:choose>
                            <c:when test="${not empty appointment && not empty appointment.patient}">
                                ${fn:escapeXml(appointment.patient.firstName)} ${fn:escapeXml(appointment.patient.lastName)}
                            </c:when>
                            <c:otherwise>${fn:escapeXml(appointment.patientName)}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="mb-2"><strong>Mobile:</strong>
                        <c:choose>
                            <c:when test="${not empty appointment.patientMobile}">${fn:escapeXml(appointment.patientMobile)}</c:when>
                            <c:when test="${not empty appointment && not empty appointment.patient && not empty appointment.patient.phoneNumber}">
                                ${fn:escapeXml(appointment.patient.phoneNumber)}
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <hr />
            <div class="mb-3">
                <strong>Purpose / Notes:</strong>
                <div class="mt-2">${fn:escapeXml(appointment.notes)}</div>
            </div>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/appointments/${appointment.id}/history" class="btn btn-outline-primary btn-sm">
                    <i class="fas fa-list"></i> View Reschedule History
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>