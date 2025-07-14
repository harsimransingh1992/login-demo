<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Reports - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: #f5f6fa;
        }

        .welcome-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 250px; /* Adjust based on your menu width */
        }

        .report-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .report-title {
            font-size: 24px;
            color: #2c3e50;
            margin: 0;
        }
        
        .date-filter {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .date-input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Poppins', sans-serif;
        }
        
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .metric-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .metric-title {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .metric-value {
            color: #2c3e50;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .metric-trend {
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .trend-up {
            color: #2ecc71;
        }
        
        .trend-down {
            color: #e74c3c;
        }
        
        .chart-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            height: 400px;
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .chart-title {
            font-size: 18px;
            color: #2c3e50;
            margin: 0;
        }
        
        .chart-actions {
            display: flex;
            gap: 10px;
        }
        
        .chart-btn {
            padding: 6px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: white;
            cursor: pointer;
            font-size: 12px;
            color: #2c3e50;
        }
        
        .chart-btn:hover {
            background: #f8f9fa;
        }
        
        .chart-btn.active {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .data-table th {
            background: #f8f9fa;
            font-weight: 500;
            color: #2c3e50;
        }
        
        .data-table tr:hover {
            background: #f8f9fa;
        }
        
        .export-btn {
            padding: 8px 16px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .export-btn:hover {
            background: #2980b9;
        }
        
        .report-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 20px;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 10px;
            }

            .metrics-grid {
                grid-template-columns: 1fr;
            }
            
            .date-filter {
                flex-direction: column;
                align-items: stretch;
            }
            
            .chart-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .chart-actions {
                width: 100%;
                justify-content: space-between;
            }

            .report-header {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="report-container">
                <div class="report-header">
                    <h1 class="report-title">Admin Reports Dashboard</h1>
                    <div class="date-filter">
                        <input type="date" class="date-input" id="startDate">
                        <span>to</span>
                        <input type="date" class="date-input" id="endDate">
                        <button class="export-btn" onclick="exportReport()">
                            <i class="fas fa-download"></i> Export Report
                        </button>
                    </div>
                </div>
                
                <!-- Key Metrics Section -->
                <div class="report-section">
                    <h2 class="section-title">Key Performance Indicators</h2>
                    <div class="metrics-grid">
                        <div class="metric-card">
                            <div class="metric-title">Total Procedures</div>
                            <div class="metric-value">${totalProcedures}</div>
                            <div class="metric-trend trend-up">
                                <i class="fas fa-arrow-up"></i> 12% from last month
                            </div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-title">Revenue</div>
                            <div class="metric-value">₹${totalRevenue}</div>
                            <div class="metric-trend trend-up">
                                <i class="fas fa-arrow-up"></i> 8% from last month
                            </div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-title">Average Procedure Time</div>
                            <div class="metric-value">${avgProcedureTime} min</div>
                            <div class="metric-trend trend-down">
                                <i class="fas fa-arrow-down"></i> 5% from last month
                            </div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-title">Success Rate</div>
                            <div class="metric-value">${successRate}%</div>
                            <div class="metric-trend trend-up">
                                <i class="fas fa-arrow-up"></i> 3% from last month
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Clinical Performance Section -->
                <div class="report-section">
                    <h2 class="section-title">Clinical Performance</h2>
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Procedure Distribution by Type</h3>
                            <div class="chart-actions">
                                <button class="chart-btn active" data-period="week">Week</button>
                                <button class="chart-btn" data-period="month">Month</button>
                                <button class="chart-btn" data-period="year">Year</button>
                            </div>
                        </div>
                        <canvas id="procedureDistributionChart"></canvas>
                    </div>
                    
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Treatment Success Rate by Condition</h3>
                        </div>
                        <canvas id="successRateChart"></canvas>
                    </div>
                </div>
                
                <!-- Financial Performance Section -->
                <div class="report-section">
                    <h2 class="section-title">Financial Performance</h2>
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Revenue Trends</h3>
                            <div class="chart-actions">
                                <button class="chart-btn active" data-period="week">Week</button>
                                <button class="chart-btn" data-period="month">Month</button>
                                <button class="chart-btn" data-period="year">Year</button>
                            </div>
                        </div>
                        <canvas id="revenueChart"></canvas>
                    </div>
                    
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Payment Mode Distribution</h3>
                        </div>
                        <canvas id="paymentModeChart"></canvas>
                    </div>
                </div>
                
                <!-- Operational Metrics Section -->
                <div class="report-section">
                    <h2 class="section-title">Operational Metrics</h2>
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Doctor Performance</h3>
                        </div>
                        <canvas id="doctorPerformanceChart"></canvas>
                    </div>
                    
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Procedure Status Distribution</h3>
                        </div>
                        <canvas id="procedureStatusChart"></canvas>
                    </div>
                </div>
                
                <!-- Detailed Data Tables -->
                <div class="report-section">
                    <h2 class="section-title">Detailed Reports</h2>
                    <div class="chart-container">
                        <div class="chart-header">
                            <h3 class="chart-title">Recent Procedures</h3>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Patient</th>
                                    <th>Procedure</th>
                                    <th>Doctor</th>
                                    <th>Status</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentProcedures}" var="procedure">
                                    <tr>
                                        <td>${procedure.date}</td>
                                        <td>${procedure.patientName}</td>
                                        <td>${procedure.procedureName}</td>
                                        <td>${procedure.doctorName}</td>
                                        <td>${procedure.status}</td>
                                        <td>₹${procedure.amount}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Initialize charts when the page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Procedure Distribution Chart
            const procedureCtx = document.getElementById('procedureDistributionChart').getContext('2d');
            new Chart(procedureCtx, {
                type: 'bar',
                data: {
                    labels: ['Root Canal', 'Filling', 'Extraction', 'Cleaning', 'Other'],
                    datasets: [{
                        label: 'Number of Procedures',
                        data: [65, 59, 80, 81, 56],
                        backgroundColor: [
                            'rgba(52, 152, 219, 0.8)',
                            'rgba(46, 204, 113, 0.8)',
                            'rgba(155, 89, 182, 0.8)',
                            'rgba(241, 196, 15, 0.8)',
                            'rgba(231, 76, 60, 0.8)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            
            // Success Rate Chart
            const successCtx = document.getElementById('successRateChart').getContext('2d');
            new Chart(successCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Success Rate',
                        data: [85, 88, 87, 90, 89, 92],
                        borderColor: 'rgba(46, 204, 113, 1)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Revenue',
                        data: [120000, 150000, 140000, 160000, 170000, 180000],
                        borderColor: 'rgba(52, 152, 219, 1)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            
            // Payment Mode Chart
            const paymentCtx = document.getElementById('paymentModeChart').getContext('2d');
            new Chart(paymentCtx, {
                type: 'pie',
                data: {
                    labels: ['Cash', 'Card', 'UPI', 'Insurance'],
                    datasets: [{
                        data: [30, 40, 20, 10],
                        backgroundColor: [
                            'rgba(52, 152, 219, 0.8)',
                            'rgba(46, 204, 113, 0.8)',
                            'rgba(155, 89, 182, 0.8)',
                            'rgba(241, 196, 15, 0.8)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            
            // Doctor Performance Chart
            const doctorCtx = document.getElementById('doctorPerformanceChart').getContext('2d');
            new Chart(doctorCtx, {
                type: 'bar',
                data: {
                    labels: ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams', 'Dr. Brown'],
                    datasets: [{
                        label: 'Procedures Completed',
                        data: [45, 38, 42, 35],
                        backgroundColor: 'rgba(52, 152, 219, 0.8)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            
            // Procedure Status Chart
            const statusCtx = document.getElementById('procedureStatusChart').getContext('2d');
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'In Progress', 'Scheduled', 'Cancelled'],
                    datasets: [{
                        data: [60, 20, 15, 5],
                        backgroundColor: [
                            'rgba(46, 204, 113, 0.8)',
                            'rgba(52, 152, 219, 0.8)',
                            'rgba(241, 196, 15, 0.8)',
                            'rgba(231, 76, 60, 0.8)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        });
        
        // Handle period selection
        document.querySelectorAll('.chart-btn').forEach(button => {
            button.addEventListener('click', function() {
                // Remove active class from all buttons in the same group
                this.parentElement.querySelectorAll('.chart-btn').forEach(btn => {
                    btn.classList.remove('active');
                });
                // Add active class to clicked button
                this.classList.add('active');
                // Update chart data based on selected period
                updateChartData(this.dataset.period);
            });
        });
        
        function updateChartData(period) {
            // Implement chart data update logic based on selected period
            console.log('Updating charts for period:', period);
        }
        
        function exportReport() {
            // Implement report export logic
            console.log('Exporting report...');
        }
    </script>
</body>
</html> 