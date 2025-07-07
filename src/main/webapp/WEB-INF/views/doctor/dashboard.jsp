<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Dashboard - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    <style>
        .main-content {
            flex: 1;
            padding: 40px;
            position: relative;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            padding: 40px;
            position: relative;
            overflow: hidden;
        }
        
        .dashboard-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #74b9ff, #0984e3);
        }
        
        .dashboard-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .dashboard-title {
            font-size: 2.5rem;
            color: #2d3436;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .dashboard-subtitle {
            font-size: 1.1rem;
            color: #636e72;
            margin-bottom: 20px;
        }
        
        .dashboard-icon {
            color: #74b9ff;
            font-size: 3rem;
            margin-bottom: 20px;
            display: block;
        }
        
        .date-filter-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 40px;
            text-align: center;
            border: 1px solid #e9ecef;
        }
        
        .date-filter-title {
            font-size: 1.2rem;
            color: #2d3436;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .dashboard-form {
            display: flex;
            gap: 20px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-group label {
            font-weight: 600;
            color: #2d3436;
            font-size: 0.9rem;
        }
        
        .dashboard-form input[type="date"] {
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            min-width: 180px;
        }
        
        .dashboard-form input[type="date"]:focus {
            outline: none;
            border-color: #74b9ff;
            box-shadow: 0 0 0 3px rgba(116, 185, 255, 0.1);
        }
        
        .dashboard-form button {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            box-shadow: 0 4px 15px rgba(116, 185, 255, 0.2);
        }
        
        .dashboard-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(116, 185, 255, 0.3);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .summary-card {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            color: white;
            box-shadow: 0 10px 30px rgba(116, 185, 255, 0.2);
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
            pointer-events: none;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
        }
        
        .summary-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            opacity: 0.9;
        }
        
        .summary-title {
            font-size: 1.1rem;
            margin-bottom: 10px;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .summary-value {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .summary-subtitle {
            font-size: 0.9rem;
            opacity: 0.8;
        }
        
        /* Target Progress Styles */
        .target-progress-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 20px;
            padding: 35px;
            margin-bottom: 40px;
            border: 1px solid #e9ecef;
        }
        
        .section-title {
            color: #2d3436;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .motivational-message {
            text-align: center;
            font-size: 1.2rem;
            color: #00b894;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-radius: 15px;
            border: 2px solid #c3e6cb;
            font-weight: 600;
        }
        
        .target-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .target-card {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .target-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
        }
        
        .target-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .target-label {
            font-weight: 700;
            color: #2d3436;
            font-size: 1.2rem;
        }
        
        .target-progress-text {
            font-weight: 800;
            color: #74b9ff;
            font-size: 1.4rem;
        }
        
        .progress-bar {
            width: 100%;
            height: 15px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 20px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #74b9ff, #0984e3);
            border-radius: 10px;
            transition: width 0.8s ease;
            position: relative;
        }
        
        .progress-fill::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0) 50%, rgba(255,255,255,0.3) 100%);
            animation: shimmer 2s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        .target-details {
            font-size: 1rem;
            color: #636e72;
        }
        
        .target-current {
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 8px;
            font-size: 1.1rem;
        }
        
        .target-remaining {
            color: #e17055;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .target-daily {
            color: #fdcb6e;
            font-weight: 600;
        }
        
        .target-footer {
            text-align: center;
            margin-top: 25px;
            padding: 20px;
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            border-radius: 15px;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .dashboard-table-section {
            background: #fff;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        
        .table-title {
            margin-bottom: 20px;
            color: #2d3436;
            font-size: 1.4rem;
            font-weight: 700;
            text-align: center;
        }
        
        .dashboard-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .dashboard-table th, .dashboard-table td {
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            text-align: left;
        }
        
        .dashboard-table th {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            color: white;
            font-weight: 600;
            font-size: 1rem;
        }
        
        .dashboard-table tr:last-child td {
            border-bottom: none;
        }
        
        .dashboard-table tr:hover {
            background: #f8f9fa;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #636e72;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #b2bec3;
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2d3436;
        }
        
        .empty-state p {
            font-size: 1.1rem;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 20px;
                margin: 20px;
            }
            
            .dashboard-form {
                flex-direction: column;
                align-items: stretch;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .target-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="dashboard-container">
                <div class="dashboard-header">
                    <i class="fas fa-chart-line dashboard-icon"></i>
                    <h1 class="dashboard-title">My Performance Dashboard</h1>
                    <p class="dashboard-subtitle">Track your progress and achieve your monthly targets</p>
                </div>
                
                <div class="date-filter-section">
                    <h3 class="date-filter-title">Select Date Range</h3>
                <form class="dashboard-form" method="get" action="">
                        <div class="form-group">
                            <label for="from">From Date</label>
                            <input type="date" id="from" name="from" value="${from}" required />
                        </div>
                        <div class="form-group">
                            <label for="to">To Date</label>
                            <input type="date" id="to" name="to" value="${to}" required />
                        </div>
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="submit">
                                <i class="fas fa-search"></i> Update Dashboard
                            </button>
                        </div>
                </form>
                </div>
                
                <div class="stats-grid">
                    <div class="summary-card">
                        <i class="fas fa-users summary-icon"></i>
                        <div class="summary-title">Patients Treated</div>
                        <div class="summary-value">${patientCount}</div>
                        <div class="summary-subtitle">This period</div>
                    </div>
                    <div class="summary-card">
                        <i class="fas fa-rupee-sign summary-icon"></i>
                        <div class="summary-title">Revenue Generated</div>
                        <div class="summary-value">₹<fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/></div>
                        <div class="summary-subtitle">Total earnings</div>
                        </div>
                    <div class="summary-card">
                        <i class="fas fa-stethoscope summary-icon"></i>
                        <div class="summary-title">Procedures Completed</div>
                        <div class="summary-value">${completedExams.size()}</div>
                        <div class="summary-subtitle">Medical procedures</div>
                    </div>
                </div>
                
                <!-- Target Progress Section -->
                <c:if test="${not empty targetProgress}">
                    <div class="target-progress-section">
                        <h3 class="section-title">
                            <i class="fas fa-bullseye"></i> Monthly Targets Progress
                        </h3>
                        <div class="motivational-message">
                            <i class="fas fa-star"></i> ${targetProgress.motivationalMessage}
                        </div>
                        
                        <div class="target-cards">
                            <!-- Revenue Target -->
                            <div class="target-card">
                                <div class="target-header">
                                    <span class="target-label">
                                        <i class="fas fa-rupee-sign"></i> Revenue Target
                                    </span>
                                    <span class="target-progress-text">${targetProgress.revenueProgress.intValue()}%</span>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: ${targetProgress.revenueProgress}%"></div>
                                </div>
                                <div class="target-details">
                                    <div class="target-current">₹<fmt:formatNumber value="${targetProgress.currentRevenue}" type="number" maxFractionDigits="2"/> / ₹<fmt:formatNumber value="${targetProgress.monthlyRevenueTarget}" type="number" maxFractionDigits="2"/></div>
                                    <c:if test="${targetProgress.remainingRevenue > 0}">
                                        <div class="target-remaining">
                                            <i class="fas fa-exclamation-triangle"></i> ₹<fmt:formatNumber value="${targetProgress.remainingRevenue}" type="number" maxFractionDigits="2"/> remaining
                                        </div>
                                        <div class="target-daily">
                                            <i class="fas fa-calendar-day"></i> Need ₹<fmt:formatNumber value="${targetProgress.dailyAverageNeeded}" type="number" maxFractionDigits="2"/> per day
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Patient Target -->
                            <div class="target-card">
                                <div class="target-header">
                                    <span class="target-label">
                                        <i class="fas fa-users"></i> Patient Target
                                    </span>
                                    <span class="target-progress-text">${targetProgress.patientProgress.intValue()}%</span>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: ${targetProgress.patientProgress}%"></div>
                                </div>
                                <div class="target-details">
                                    <div class="target-current">${targetProgress.currentPatients} / ${targetProgress.monthlyPatientTarget} patients</div>
                                    <c:if test="${targetProgress.remainingPatients > 0}">
                                        <div class="target-remaining">
                                            <i class="fas fa-exclamation-triangle"></i> ${targetProgress.remainingPatients} more patients needed
                                        </div>
                                        <div class="target-daily">
                                            <i class="fas fa-calendar-day"></i> Need ${targetProgress.dailyPatientsNeeded} patients per day
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Procedure Target -->
                            <div class="target-card">
                                <div class="target-header">
                                    <span class="target-label">
                                        <i class="fas fa-stethoscope"></i> Procedure Target
                                    </span>
                                    <span class="target-progress-text">${targetProgress.procedureProgress.intValue()}%</span>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: ${targetProgress.procedureProgress}%"></div>
                                </div>
                                <div class="target-details">
                                    <div class="target-current">${targetProgress.currentProcedures} / ${targetProgress.monthlyProcedureTarget} procedures</div>
                                    <c:if test="${targetProgress.remainingProcedures > 0}">
                                        <div class="target-remaining">
                                            <i class="fas fa-exclamation-triangle"></i> ${targetProgress.remainingProcedures} more procedures needed
                                        </div>
                                        <div class="target-daily">
                                            <i class="fas fa-calendar-day"></i> Need ${targetProgress.dailyProceduresNeeded} procedures per day
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <div class="target-footer">
                            <i class="fas fa-calendar-alt"></i> ${targetProgress.daysRemainingInMonth} days remaining this month to reach your targets!
                        </div>
                    </div>
                </c:if>
                
                <c:choose>
                    <c:when test="${not empty completedExams}">
                    <div class="dashboard-table-section">
                            <h3 class="table-title">
                                <i class="fas fa-list-alt"></i> Recent Procedures Completed
                            </h3>
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                        <th><i class="fas fa-user"></i> Patient</th>
                                        <th><i class="fas fa-stethoscope"></i> Procedure</th>
                                        <th><i class="fas fa-calendar"></i> Date</th>
                                        <th><i class="fas fa-rupee-sign"></i> Amount Paid</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${examTableRows}">
                                    <tr>
                                            <td><strong>${row.patientName}</strong></td>
                                        <td>${row.procedureName}</td>
                                        <td>${row.date}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${row.amount >= 0}">
                                                        <span style="color: #27ae60; font-weight: 600;">₹<fmt:formatNumber value="${row.amount}" type="number" maxFractionDigits="2"/></span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span style="color: #7f8c8d;">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-clipboard-list"></i>
                            <h3>No Procedures Found</h3>
                            <p>No procedures have been completed in the selected date range.</p>
                            <p>Try selecting a different date range or check back later for updates.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html> 