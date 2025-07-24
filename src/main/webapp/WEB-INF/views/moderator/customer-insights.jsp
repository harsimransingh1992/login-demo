<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="percentEmergency" value="${percentWithEmergencyContact2 != null ? percentWithEmergencyContact2 : 0}" />
<c:set var="percentEmail" value="${percentWithEmail != null ? percentWithEmail : 0}" />
<c:set var="percentProfile" value="${percentWithProfilePicture != null ? percentWithProfilePicture : 0}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Insights</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
      body { background: #f8fafc; }
      .insights-container { width: calc(100% - 280px); max-width: none; margin: 0; padding: 32px; box-sizing: border-box; margin-left: 280px; background: #f8fafc; }
      .insights-header { font-size: 2em; font-weight: 700; color: #174ea6; margin-bottom: 18px; }
      .insights-section { margin-bottom: 40px; }
      .insights-section h3 {
        font-size: 1.7em;
        font-weight: 800;
        color: #2563eb;
        margin-bottom: 22px;
        letter-spacing: 0.5px;
        border-left: 6px solid #2563eb;
        background: #f4f6fa;
        padding: 8px 18px;
        border-radius: 6px;
        box-shadow: 0 1px 4px #e1e4ea;
      }
      .insights-section h4 { font-size: 1.15em; font-weight: 600; color: #374151; margin-bottom: 10px; letter-spacing: 0.2px; }
      .dashboard-card {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 1px 8px #e1e4ea;
        padding: 18px 28px;
        min-width: 180px;
        max-width: 260px;
        flex: 1 1 180px;
        text-align: center;
        display: flex;
        flex-direction: column;
        justify-content: center;
        margin-bottom: 18px;
      }
      .dashboard-card-title { color: #374151; font-size: 1.01em; font-weight: 600; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
      .dashboard-card-value { color: #2563eb; font-size: 1.25em; font-weight: 700; min-height: 1.5em; }
      .advanced-toggle-btn {
        background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 10px 24px;
        font-size: 1em;
        font-weight: 600;
        cursor: pointer;
        margin-bottom: 18px;
        box-shadow: 0 2px 8px #e1e4ea;
        transition: background 0.2s;
      }
      .advanced-toggle-btn:hover {
        background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 100%);
      }
      .advanced-insights-collapsed { display: none; }
      .advanced-insights-expanded { display: block; }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container insights-container">
    <div class="insights-header">Customer Insights</div>
    <div class="insights-section">
        <h3>Overview</h3>
        <div id="overview-cards" style="display: flex; gap: 24px; flex-wrap: wrap; margin-bottom: 32px;">
            <div class="dashboard-card">
                <div class="dashboard-card-title">Total Patients</div>
                <div class="dashboard-card-value">${totalPatients}</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">New Patients This Month</div>
                <div class="dashboard-card-value">${newPatientsThisMonth}</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Returning Patients This Month</div>
                <div class="dashboard-card-value">${returningPatientsThisMonth}</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Avg Age (Last 12 Months)</div>
                <div class="dashboard-card-value">
                    <fmt:formatNumber value="${averageAgeLast12Months}" type="number" minFractionDigits="1" maxFractionDigits="1" /> yrs
                </div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Most Common Occupation</div>
                <div class="dashboard-card-value">${mostCommonOccupation}</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">% with Emergency Contact</div>
                <div class="dashboard-card-value">
                    <fmt:formatNumber value="${percentWithEmergencyContact}" type="number" minFractionDigits="1" maxFractionDigits="1" />%
                </div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">% with Complete Contact Info</div>
                <div class="dashboard-card-value">
                    <fmt:formatNumber value="${percentWithCompleteContactInfo}" type="number" minFractionDigits="1" maxFractionDigits="1" />%
                </div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Avg Time to First Check-in</div>
                <div class="dashboard-card-value">
                    <fmt:formatNumber value="${avgTimeToFirstCheckin}" type="number" minFractionDigits="1" maxFractionDigits="1" /> days
                </div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Patient Growth Rate (vs Last Year)</div>
                <div class="dashboard-card-value">
                    <fmt:formatNumber value="${patientGrowthRate}" type="number" minFractionDigits="1" maxFractionDigits="1" />%
                </div>
            </div>
        </div>
    </div>
    <div class="insights-section">
        <h3>Demographics</h3>
        <div style="display: flex; gap: 32px; flex-wrap: wrap;">
            <div style="flex:1; min-width: 320px;">
                <h4>Age Distribution</h4>
                <canvas id="ageChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Gender Distribution (Male vs Female)</h4>
                <canvas id="genderChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Top 5 Cities</h4>
                <canvas id="cityChart" height="180"></canvas>
            </div>
        </div>
        <div style="margin-top: 32px; display: flex; gap: 32px; flex-wrap: wrap;">
            <div style="flex:1; min-width: 320px;">
                <h4>Top 5 States</h4>
                <canvas id="stateChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Occupation</h4>
                <canvas id="occupationChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Referral Source</h4>
                <canvas id="referralChart" height="180"></canvas>
            </div>
        </div>
    </div>
    <div class="insights-section">
        <h3>
            <i class="fas fa-chart-line" style="color:#2563eb; margin-right:10px;"></i>
            Registration Trends
        </h3>
        <div style="margin-bottom: 10px; color: #555; font-size: 1.05em;">
            Monthly new patient registrations over the past year.<br/>
            <b>Peak:</b> ${peakMonth} (${peakValue}) &nbsp;|&nbsp;
            <b>Lowest:</b> ${lowestMonth} (${lowestValue}) &nbsp;|&nbsp;
            <b>Current Month:</b> ${currentMonthValue} &nbsp;|&nbsp;
            <b>Change from last month:</b> <fmt:formatNumber value="${percentChange}" type="number" minFractionDigits="1" maxFractionDigits="1" />%
        </div>
        <canvas id="registrationTrendChart" height="120"></canvas>
    </div>
    <div class="insights-section">
        <h3><i class="fas fa-lightbulb" style="color:#f59e42; margin-right:10px;"></i> Advanced Insights</h3>
        <button class="advanced-toggle-btn" onclick="toggleAdvancedInsights()" id="advancedToggleBtn">Show More Insights</button>
        <div id="advancedInsights" class="advanced-insights-collapsed">
        <div style="display: flex; gap: 32px; flex-wrap: wrap;">
            <div style="flex:1; min-width: 320px;">
                <h4>Top Clinics by Patient Registration</h4>
                <table style="width:100%; background:#f8fafc; border-radius:8px;">
                    <tr><th style="text-align:left;">Clinic</th><th style="text-align:right;">Patients</th></tr>
                    <c:forEach var="entry" items="${topClinics}">
                        <tr><td>${entry.key}</td><td style="text-align:right;">${entry.value}</td></tr>
                    </c:forEach>
                </table>
                <canvas id="topClinicsChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Top Staff by Patient Registration</h4>
                <table style="width:100%; background:#f8fafc; border-radius:8px;">
                    <tr><th style="text-align:left;">Staff</th><th style="text-align:right;">Patients</th></tr>
                    <c:forEach var="entry" items="${topStaff}">
                        <tr><td>${entry.key}</td><td style="text-align:right;">${entry.value}</td></tr>
                    </c:forEach>
                </table>
                <canvas id="topStaffChart" height="180"></canvas>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Checked In > Once</div>
                <div class="dashboard-card-value">${patientsCheckedInMoreThanOnce}</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Avg Check-ins/Patient</div>
                <div class="dashboard-card-value">
                    <fmt:formatNumber value="${avgCheckinsPerPatient}" type="number" minFractionDigits="1" maxFractionDigits="1" />
                </div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">Currently Checked In</div>
                <div class="dashboard-card-value">${patientsCurrentlyCheckedIn}</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">With Emergency Contact</div>
                <div class="dashboard-card-value">${patientsWithEmergencyContact} (<fmt:formatNumber value="${percentWithEmergencyContact2}" type="number" minFractionDigits="1" maxFractionDigits="1" />%)</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">With Email</div>
                <div class="dashboard-card-value">${patientsWithEmail} (<fmt:formatNumber value="${percentWithEmail}" type="number" minFractionDigits="1" maxFractionDigits="1" />%)</div>
            </div>
            <div class="dashboard-card">
                <div class="dashboard-card-title">With Profile Picture</div>
                <div class="dashboard-card-value">${patientsWithProfilePicture} (<fmt:formatNumber value="${percentWithProfilePicture}" type="number" minFractionDigits="1" maxFractionDigits="1" />%)</div>
            </div>
        </div>
        <div style="margin-top: 32px; display: flex; gap: 32px; flex-wrap: wrap;">
            <div style="flex:1; min-width: 320px;">
                <h4>Check-in Frequency</h4>
                <canvas id="checkinFrequencyChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Currently Checked In</h4>
                <canvas id="currentlyCheckedInChart" height="180"></canvas>
            </div>
            <div style="flex:1; min-width: 320px;">
                <h4>Data Completeness</h4>
                <canvas id="dataCompletenessChart" height="180"></canvas>
            </div>
        </div>
        <div style="margin-top: 32px;">
            <h4>Top 10 Recently Checked-in Patients</h4>
            <table style="width:100%; background:#f8fafc; border-radius:8px;">
                <tr>
                    <th style="text-align:left;">Name</th>
                    <th style="text-align:left;">Phone</th>
                    <th style="text-align:left;">Check-in Time</th>
                    <th style="text-align:left;">Clinic</th>
                </tr>
                <c:forEach var="p" items="${top10RecentCheckins}">
                    <tr>
                        <td>${p.firstName} ${p.lastName}</td>
                        <td>${p.phoneNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.currentCheckInRecord.checkInTime}">
                                    <c:out value="${p.currentCheckInRecord.checkInTime}" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.currentCheckInRecord.clinic && not empty p.currentCheckInRecord.clinic.clinicName}">
                                    ${p.currentCheckInRecord.clinic.clinicName}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        </div>
    </div>
</div>
<script>
// Helper to convert JSP map/array to JS
function parseJspMap(obj) {
    if (!obj) return {};
    if (typeof obj === 'string') return JSON.parse(obj.replace(/'/g, '"'));
    return obj;
}
// Age Distribution
const ageLabels = [<c:forEach var="entry" items="${ageDistribution}">'${entry.key}',</c:forEach>];
const ageData = [<c:forEach var="entry" items="${ageDistribution}">${entry.value},</c:forEach>];
// Gender Distribution
const genderLabels = [<c:forEach var="entry" items="${genderDistribution}">'${entry.key}',</c:forEach>];
const genderData = [<c:forEach var="entry" items="${genderDistribution}">${entry.value},</c:forEach>];
// Top Cities
const cityLabels = [<c:forEach var="entry" items="${topCities}">'${entry.key}',</c:forEach>];
const cityData = [<c:forEach var="entry" items="${topCities}">${entry.value},</c:forEach>];
// Top States
const stateLabels = [<c:forEach var="entry" items="${topStates}">'${entry.key}',</c:forEach>];
const stateData = [<c:forEach var="entry" items="${topStates}">${entry.value},</c:forEach>];
// Occupation
const occupationLabels = [<c:forEach var="entry" items="${occupationDistribution}">'${entry.key}',</c:forEach>];
const occupationData = [<c:forEach var="entry" items="${occupationDistribution}">${entry.value},</c:forEach>];
// Referral Source
const referralLabels = [<c:forEach var="entry" items="${referralSourceDistribution}">'${entry.key}',</c:forEach>];
const referralData = [<c:forEach var="entry" items="${referralSourceDistribution}">${entry.value},</c:forEach>];
// Registration Trends
const regTrendLabels = [<c:forEach var="entry" items="${registrationsOverTime}">'${entry.key}',</c:forEach>];
const regTrendData = [<c:forEach var="entry" items="${registrationsOverTime}">${entry.value},</c:forEach>];

// Chart.js rendering
window.onload = function() {
    new Chart(document.getElementById('ageChart'), {
        type: 'bar',
        data: { labels: ageLabels, datasets: [{ label: 'Patients', data: ageData, backgroundColor: '#2563eb' }] },
        options: { plugins: { legend: { display: false } }, responsive: true }
    });
    new Chart(document.getElementById('genderChart'), {
        type: 'pie',
        data: { labels: genderLabels, datasets: [{ data: genderData, backgroundColor: ['#2563eb', '#f59e42', '#e11d48', '#10b981'] }] },
        options: { responsive: true }
    });
    new Chart(document.getElementById('cityChart'), {
        type: 'bar',
        data: { labels: cityLabels, datasets: [{ label: 'Patients', data: cityData, backgroundColor: '#f59e42' }] },
        options: { plugins: { legend: { display: false } }, responsive: true }
    });
    new Chart(document.getElementById('stateChart'), {
        type: 'bar',
        data: { labels: stateLabels, datasets: [{ label: 'Patients', data: stateData, backgroundColor: '#10b981' }] },
        options: { plugins: { legend: { display: false } }, responsive: true }
    });
    new Chart(document.getElementById('occupationChart'), {
        type: 'pie',
        data: { labels: occupationLabels, datasets: [{ data: occupationData, backgroundColor: ['#2563eb', '#f59e42', '#e11d48', '#10b981', '#6366f1', '#fbbf24'] }] },
        options: { responsive: true }
    });
    new Chart(document.getElementById('referralChart'), {
        type: 'pie',
        data: { labels: referralLabels, datasets: [{ data: referralData, backgroundColor: ['#2563eb', '#f59e42', '#e11d48', '#10b981', '#6366f1', '#fbbf24'] }] },
        options: { responsive: true }
    });
    new Chart(document.getElementById('registrationTrendChart'), {
        type: 'line',
        data: { labels: regTrendLabels, datasets: [{ label: 'Registrations', data: regTrendData, borderColor: '#2563eb', backgroundColor: 'rgba(37,99,235,0.1)', fill: true }] },
        options: { responsive: true, plugins: { legend: { display: false } } }
    });
    // Top Clinics Bar Chart
    const topClinicsLabels = [<c:forEach var="entry" items="${topClinics}">'${entry.key}',</c:forEach>];
    const topClinicsData = [<c:forEach var="entry" items="${topClinics}">${entry.value},</c:forEach>];
    new Chart(document.getElementById('topClinicsChart'), {
        type: 'bar',
        data: { labels: topClinicsLabels, datasets: [{ label: 'Patients', data: topClinicsData, backgroundColor: '#6366f1' }] },
        options: { plugins: { legend: { display: false } }, responsive: true }
    });
    // Top Staff Bar Chart
    const topStaffLabels = [<c:forEach var="entry" items="${topStaff}">'${entry.key}',</c:forEach>];
    const topStaffData = [<c:forEach var="entry" items="${topStaff}">${entry.value},</c:forEach>];
    new Chart(document.getElementById('topStaffChart'), {
        type: 'bar',
        data: { labels: topStaffLabels, datasets: [{ label: 'Patients', data: topStaffData, backgroundColor: '#f59e42' }] },
        options: { plugins: { legend: { display: false } }, responsive: true }
    });
    // Check-in Frequency Pie Chart
    new Chart(document.getElementById('checkinFrequencyChart'), {
        type: 'pie',
        data: {
            labels: ['Checked In > Once', 'Checked In Once or Never'],
            datasets: [{
                data: [parseFloat('${patientsCheckedInMoreThanOnce}'), parseFloat('${totalPatients - patientsCheckedInMoreThanOnce}')],
                backgroundColor: ['#2563eb', '#e5e7eb']
            }]
        },
        options: { responsive: true }
    });
    // Currently Checked In Pie Chart
    new Chart(document.getElementById('currentlyCheckedInChart'), {
        type: 'pie',
        data: {
            labels: ['Currently Checked In', 'Not Checked In'],
            datasets: [{
                data: [parseFloat('${patientsCurrentlyCheckedIn}'), parseFloat('${totalPatients - patientsCurrentlyCheckedIn}')],
                backgroundColor: ['#10b981', '#e5e7eb']
            }]
        },
        options: { responsive: true }
    });
    // Data Completeness Bar Chart
    new Chart(document.getElementById('dataCompletenessChart'), {
        type: 'bar',
        data: {
            labels: ['Emergency Contact', 'Email', 'Profile Picture'],
            datasets: [{
                label: '% of Patients',
                data: [parseFloat('${percentEmergency}'), parseFloat('${percentEmail}'), parseFloat('${percentProfile}')],
                backgroundColor: ['#6366f1', '#f59e42', '#e11d48']
            }]
        },
        options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, max: 100 } } }
    });
};

function toggleAdvancedInsights() {
    var adv = document.getElementById('advancedInsights');
    var btn = document.getElementById('advancedToggleBtn');
    if (adv.classList.contains('advanced-insights-collapsed')) {
        adv.classList.remove('advanced-insights-collapsed');
        adv.classList.add('advanced-insights-expanded');
        btn.textContent = 'Hide Advanced Insights';
    } else {
        adv.classList.remove('advanced-insights-expanded');
        adv.classList.add('advanced-insights-collapsed');
        btn.textContent = 'Show More Insights';
    }
}
</script>
</body>
</html> 