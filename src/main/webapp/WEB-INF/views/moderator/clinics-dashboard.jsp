<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clinics Summary Dashboard - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-papmQ+K6FQn6QwQn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Qn1Q==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
      .clinics-dashboard-container {
        max-width: calc(100% - 280px);
        margin-left: 280px;
        margin-right: 0;
        padding-left: 32px;
        padding-right: 32px;
      }
      .clinics-dashboard-header { color: #1565c0; font-size: 2em; font-weight: 700; margin-bottom: 18px; }
      .clinics-dashboard-desc { color: #555; margin-bottom: 28px; font-size: 1.13em; }
      .clinics-filter-bar { display: flex; gap: 24px; align-items: flex-end; margin-bottom: 32px; flex-wrap: wrap; }
      .clinics-filter-bar label { font-weight: 600; color: #374151; margin-bottom: 8px; font-size: 0.95em; text-transform: uppercase; letter-spacing: 0.5px; }
      .clinics-filter-bar input[type="date"] { padding: 12px 16px; border: 2px solid #d1d5db; border-radius: 10px; font-size: 1em; background: #fff; color: #374151; min-width: 220px; }
      .clinics-filter-bar button { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: #fff; padding: 14px 28px; border: none; border-radius: 12px; font-size: 1.05em; font-weight: 600; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); text-transform: uppercase; letter-spacing: 0.5px; min-width: 140px; }
      .clinics-filter-bar button:hover { background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%); }
      .dashboard-cards { display: flex; gap: 32px; margin: 32px 0 24px 0; flex-wrap: wrap; align-items: stretch; }
      .dashboard-card { background: #f4f6fa; border-radius: 10px; box-shadow: 0 1px 8px #e1e4ea; padding: 18px 28px; min-width: 180px; max-width: 260px; flex: 1 1 180px; text-align: center; display: flex; flex-direction: column; justify-content: center; }
      .dashboard-card-title { color: #374151; font-size: 1.01em; font-weight: 600; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
      .dashboard-card-value { color: #1565c0; font-size: 1.25em; font-weight: 700; min-height: 1.5em; }
      .doctor-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-bottom: 32px; }
      .doctor-table th, .doctor-table td { padding: 16px 18px; background: #fff; border-radius: 8px; text-align: left; font-size: 1.08em; }
      .doctor-table th { color: #1565c0; font-weight: 700; background: #f4f6fa; border-bottom: 2px solid #e1e4ea; }
      .doctor-table tr { box-shadow: 0 2px 8px #e1e4ea; transition: box-shadow 0.18s, transform 0.18s; }
      .doctor-table tr:hover td { box-shadow: 0 6px 24px #b3c6e4; background: #f7fafc; color: #2563eb; }
      .empty-state { text-align: center; color: #888; padding: 60px 0 40px 0; }
      .clinic-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 24px; margin-top: 32px; }
      .clinic-card { background: #f4f6fa; border-radius: 10px; box-shadow: 0 1px 8px #e1e4ea; padding: 18px 20px; text-align: left; }
      .clinic-title { font-size: 1.1em; font-weight: 600; color: #374151; margin-bottom: 8px; }
      .clinic-row { display: flex; align-items: center; margin-bottom: 4px; font-size: 0.95em; color: #555; }
      .clinic-icon { margin-right: 8px; color: #1565c0; }
      .clinic-revenue { font-size: 1.2em; font-weight: 700; color: #1565c0; margin-top: 12px; }
      .clinic-doctors { font-size: 0.9em; color: #555; margin-top: 4px; }
      @media (max-width: 700px) { .doctor-table th, .doctor-table td { padding: 10px 6px; font-size: 0.98em; } .clinics-filter-bar { gap: 12px; } .dashboard-cards { gap: 12px; } }
      .sortable-header {
        cursor: pointer;
        user-select: none;
        transition: background-color 0.2s ease;
        position: relative;
      }
      .sortable-header:hover {
        background-color: #e2e8f0 !important;
      }
      .sortable-header i {
        margin-left: 8px;
        font-size: 0.9em;
        color: #6b7280;
        transition: color 0.2s ease;
      }
      .sortable-header.sort-asc i,
      .sortable-header.sort-desc i {
        color: #2563eb;
      }
      .sortable-header.sort-asc,
      .sortable-header.sort-desc {
        background-color: #dbeafe !important;
      }
      .moderator-container {
        width: 100%;
        box-sizing: border-box;
      }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container clinics-dashboard-container">
    <div class="clinics-dashboard-header">Clinics Summary Dashboard <i class="fas fa-check-circle" style="color:#2563eb;"></i></div>
    <div class="clinics-dashboard-desc">Select a date range to view revenue and patient metrics across all clinics.</div>
    <form method="get" class="clinics-filter-bar">
        <div>
            <label for="startDate">Start Date</label><br>
            <input type="date" id="startDate" name="startDate" value="${param.startDate}">
        </div>
        <div>
            <label for="endDate">End Date</label><br>
            <input type="date" id="endDate" name="endDate" value="${param.endDate}">
        </div>
        <div style="align-self: flex-end; display: flex; gap: 12px;">
            <button type="submit">Show Dashboard</button>
            <button type="button" onclick="clearClinicsDashboardForm()" style="background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);">Clear</button>
        </div>
    </form>
    <script>
        function clearClinicsDashboardForm() {
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.forms[0].submit();
        }
    </script>
    <div style="margin: 40px 0 0 0;">
        <canvas id="revenueBarChart" height="120"></canvas>
    </div>
    <div class="dashboard-cards">
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Revenue</div>
            <div class="dashboard-card-value">
                <c:choose>
                    <c:when test="${not empty totalRevenue && totalRevenue > 0}">
                        <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" minFractionDigits="2" />
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Check-ins</div>
            <div class="dashboard-card-value">
                <c:choose>
                    <c:when test="${not empty totalCheckins && totalCheckins > 0}">
                        ${totalCheckins}
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Average Turnaround Time (min)</div>
            <div class="dashboard-card-value">
                <c:choose>
                    <c:when test="${not empty averageTurnaroundMinutes && averageTurnaroundMinutes > 0}">
                        <c:set var="avgMinutes" value="${fn:substringBefore(averageTurnaroundMinutes, '.')}" />
                        <c:set var="hours" value="${avgMinutes div 60}" />
                        <c:set var="minutes" value="${avgMinutes mod 60}" />
                        <c:out value="${hours} h ${minutes} m" />
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Patients</div>
            <div class="dashboard-card-value">
                <c:choose>
                    <c:when test="${not empty totalPatients && totalPatients > 0}">
                        ${totalPatients}
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Patients Registered</div>
            <div class="dashboard-card-value">
                <c:set var="totalRegistered" value="0" />
                <c:forEach var="row" items="${clinicsSummary}">
                    <c:set var="totalRegistered" value="${totalRegistered + row.patientRegisteredCount}" />
                </c:forEach>
                ${totalRegistered}
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Total Appointments Booked</div>
            <div class="dashboard-card-value">
                <c:set var="totalAppointments" value="0" />
                <c:forEach var="row" items="${clinicsSummary}">
                    <c:set var="totalAppointments" value="${totalAppointments + row.checkinCount}" />
                </c:forEach>
                ${totalAppointments}
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">No-Show Appointments</div>
            <div class="dashboard-card-value">
                <c:set var="totalNoShow" value="0" />
                <c:forEach var="row" items="${clinicsSummary}">
                    <c:set var="totalNoShow" value="${totalNoShow + row.noShowCount}" />
                </c:forEach>
                ${totalNoShow}
            </div>
        </div>
        <div class="dashboard-card">
            <div class="dashboard-card-title">Cancelled Appointments</div>
            <div class="dashboard-card-value">
                <c:set var="totalCancelled" value="0" />
                <c:forEach var="row" items="${clinicsSummary}">
                    <c:set var="totalCancelled" value="${totalCancelled + row.cancelledCount}" />
                </c:forEach>
                ${totalCancelled}
            </div>
        </div>
    </div>
    <c:choose>
        <c:when test="${not empty clinicsSummary}">
            <table class="doctor-table" id="clinicsTable">
                <thead>
                    <tr>
                        <th onclick="sortTable(0)" class="sortable-header">Clinic Name <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(1)" class="sortable-header">Clinic Code <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(2)" class="sortable-header">City Tier <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(3)" class="sortable-header">Revenue <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(4)" class="sortable-header">Patients <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(5)" class="sortable-header">Patients Registered <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(6)" class="sortable-header">Total Appointments Booked <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(7)" class="sortable-header">No-Show Appointments <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(8)" class="sortable-header">Cancelled Appointments <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(9)" class="sortable-header">Avg Turnaround Time (min) <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(10)" class="sortable-header">Total Check-ins <i class="fas fa-sort"></i></th>
                    </tr>
                </thead>
                <tbody id="clinicsTableBody">
                    <c:forEach var="row" items="${clinicsSummary}">
                        <tr>
                            <td>${row.clinicName}</td>
                            <td>${row.clinicId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty row.cityTier}">${row.cityTier.displayName}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${row.revenue}" type="number" groupingUsed="true" maxFractionDigits="0" /></td>
                            <td>${row.patientCount}</td>
                            <td>${row.patientRegisteredCount}</td>
                            <td>${row.checkinCount}</td>
                            <td>${row.noShowCount}</td>
                            <td>${row.cancelledCount}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty row.averageTurnaroundMinutes && row.averageTurnaroundMinutes > 0}">
                                        <c:set var="avgMinutes" value="${fn:substringBefore(row.averageTurnaroundMinutes, '.')}" />
                                        <c:set var="hours" value="${avgMinutes div 60}" />
                                        <c:set var="minutes" value="${avgMinutes mod 60}" />
                                        <c:out value="${hours} h ${minutes} m" />
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${row.totalCheckins}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty clinicsSummary}">
                <div class="empty-state">No clinics found for this date range.</div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">Please select a date range to view clinics summary.</div>
        </c:otherwise>
    </c:choose>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://kit.fontawesome.com/2b8e1e2e8b.js" crossorigin="anonymous"></script>
    <script>
      function renderBarChart() {
        const ctx = document.getElementById('revenueBarChart').getContext('2d');
        if (window.revenueBarChart) window.revenueBarChart.destroy();
        const labels = [
          <c:forEach var="row" items="${clinicsSummary}" varStatus="loop">
            "${row.clinicName}"<c:if test="${!loop.last}">,</c:if>
          </c:forEach>
        ];
        const data = [
          <c:forEach var="row" items="${clinicsSummary}" varStatus="loop">
            ${row.revenue}<c:if test="${!loop.last}">,</c:if>
          </c:forEach>
        ];
        window.revenueBarChart = new Chart(ctx, {
          type: 'bar',
          data: {
            labels: labels,
            datasets: [{
              label: 'Revenue',
              data: data,
              backgroundColor: 'rgba(37, 99, 235, 0.7)',
              borderRadius: 8,
            }]
          },
          options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
              x: { grid: { display: false } },
              y: { grid: { color: '#e1e4ea' }, beginAtZero: true }
            }
          }
        });
      }
      window.onload = function() { renderBarChart(); };

      // Sorting functionality
      let currentSortColumn = -1;
      let currentSortDirection = 'asc';
      function sortTable(columnIndex) {
        const table = document.getElementById('clinicsTableBody');
        const rows = Array.from(table.getElementsByTagName('tr'));
        const headers = document.querySelectorAll('.sortable-header');
        // Clear previous sort indicators and reset icons
        headers.forEach((header, idx) => {
          header.classList.remove('sort-asc', 'sort-desc');
          const icon = header.querySelector('i');
          if (icon) icon.className = 'fas fa-sort';
        });
        // Determine sort direction
        if (currentSortColumn === columnIndex) {
          currentSortDirection = currentSortDirection === 'asc' ? 'desc' : 'asc';
        } else {
          currentSortColumn = columnIndex;
          currentSortDirection = 'asc';
        }
        // Add sort indicator to current column and set icon
        headers[columnIndex].classList.add(currentSortDirection === 'asc' ? 'sort-asc' : 'sort-desc');
        const icon = headers[columnIndex].querySelector('i');
        if (icon) {
          if (currentSortDirection === 'asc') {
            icon.className = 'fas fa-sort-up';
          } else {
            icon.className = 'fas fa-sort-down';
          }
        }
        // Sort the rows
        rows.sort((a, b) => {
          const aValue = getCellValue(a, columnIndex);
          const bValue = getCellValue(b, columnIndex);
          let comparison = 0;
          // Numeric columns: Revenue, Patients, Patients Registered, Total Appointments, No-Show, Cancelled
          if ([3, 4, 5, 6, 7, 8, 9, 10].includes(columnIndex)) {
            const aNum = parseFloat(aValue.replace(/[\u20B9,]/g, '')) || 0;
            const bNum = parseFloat(bValue.replace(/[\u20B9,]/g, '')) || 0;
            comparison = aNum - bNum;
          } else {
            // String comparison for other columns
            comparison = aValue.localeCompare(bValue, undefined, {numeric: true, sensitivity: 'base'});
          }
          return currentSortDirection === 'asc' ? comparison : -comparison;
        });
        // Reorder the table
        rows.forEach(row => table.appendChild(row));
      }
      function getCellValue(row, columnIndex) {
        const cell = row.getElementsByTagName('td')[columnIndex];
        return cell.textContent.trim();
      }
    </script>
</div>
</body>
</html> 