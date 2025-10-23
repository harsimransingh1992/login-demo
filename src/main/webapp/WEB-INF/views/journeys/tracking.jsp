<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Patient Journey</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="_csrf" content="${_csrf.token}" />
  <meta name="_csrf_header" content="${_csrf.headerName}" />
  <jsp:include page="/WEB-INF/views/common/head.jsp" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/journeys.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <!-- Include common menu styles for consistent navigation -->
  <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
</head>
<body>
<div class="welcome-container">
  <jsp:include page="/WEB-INF/views/common/menu.jsp" />
  <div class="main-content">
    <div class="page-header">
      <h1 class="page-title"><i class="fas fa-stethoscope"></i> Patient Journey</h1>
      <p class="page-subtitle">Review clinical events and actions across visits</p>
    </div>

    <div class="journeys-container">
      <div class="header">
        <div class="actions">
          <button id="applyFiltersBtn" class="btn btn-primary"><i class="fas fa-filter"></i> Apply Filters</button>
          <button id="printSummaryBtn" class="btn btn-outline"><i class="fas fa-print"></i> Print</button>
          <button id="exportCsvBtn" class="btn"><i class="fas fa-file-export"></i> Export CSV</button>
        </div>
      </div>

      <div class="card filters" role="region" aria-label="Filters">
        <div class="filter-group" role="group" aria-labelledby="labelPatient">
          <label id="labelPatient" for="filterPatientId">Patient ID</label>
          <input type="number" id="filterPatientId" value="${patientId}" placeholder="e.g. 12345" aria-describedby="patientHelp" />
          <small id="patientHelp">Search by internal patient record number</small>
        </div>
        <div class="filter-group wide" role="group" aria-labelledby="labelEvents">
          <label id="labelEvents" for="filterEventTypes">Event Types</label>
          <select id="filterEventTypes" multiple size="6" aria-multiselectable="true">
            <option value="registration">Registration</option>
            <option value="clinic_checkin">Clinic Check-in</option>
            <option value="clinic_checkout">Clinic Check-out</option>
            <option value="appointment_booked">Appointment Booked</option>
            <option value="examination_added">Examination Added</option>
            <option value="status_changed">Status Changed</option>
            <option value="payment_transaction">Payment Transaction</option>
            <option value="interaction">Other Interaction</option>
          </select>
          <small>Select one or more to narrow results</small>
        </div>
        <div class="filter-group" role="group" aria-labelledby="labelFrom">
          <label id="labelFrom" for="filterFrom">From</label>
          <input type="date" id="filterFrom" />
        </div>
        <div class="filter-group" role="group" aria-labelledby="labelTo">
          <label id="labelTo" for="filterTo">To</label>
          <input type="date" id="filterTo" />
        </div>
        <div class="filter-group wide" role="group" aria-labelledby="labelSearch">
          <label id="labelSearch" for="filterSearch">Search Notes</label>
          <input type="text" id="filterSearch" placeholder="Find by notes or details" />
        </div>
        <div class="filter-actions">
          <button id="presetToday" class="btn"><i class="fas fa-sun"></i> Today</button>
          <button id="preset7d" class="btn"><i class="fas fa-calendar-week"></i> Last 7 days</button>
          <button id="preset30d" class="btn"><i class="fas fa-calendar"></i> Last 30 days</button>
          <button id="clearFilters" class="btn"><i class="fas fa-eraser"></i> Clear</button>
        </div>
      </div>

      <div id="summaryContainer" class="summary card" role="region" aria-label="Summary"></div>
      <div id="timelineContainer" class="timeline" role="region" aria-label="Timeline">
        <div class="empty">Use filters to load patient interactions</div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/journeys.js"></script>
</body>
</html>