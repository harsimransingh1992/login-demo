<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - PeriDesk</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f1c40f;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-bg);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .page-title {
            margin: 0;
            color: var(--secondary-color);
            font-size: 24px;
            font-weight: 600;
        }

        .admin-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .admin-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            text-decoration: none;
            color: var(--secondary-color);
        }

        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-decoration: none;
            color: var(--secondary-color);
        }

        .card-icon {
            width: 50px;
            height: 50px;
            background: var(--light-bg);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .card-icon i {
            font-size: 24px;
            color: var(--primary-color);
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .card-description {
            font-size: 14px;
            color: #6c757d;
            margin: 0;
        }

        .stats-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-card {
            text-align: center;
            padding: 20px;
            background: var(--light-bg);
            border-radius: 10px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            color: #6c757d;
            margin: 0;
        }

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">Admin Panel</h1>
            </div>

            <div class="admin-grid">
                <a href="${pageContext.request.contextPath}/admin/clinics" class="admin-card">
                    <div class="card-icon">
                        <i class="fas fa-clinic-medical"></i>
                    </div>
                    <h3 class="card-title">Clinic Management</h3>
                    <p class="card-description">Manage clinics, add new clinics, and configure clinic settings</p>
                </a>

                <a href="${pageContext.request.contextPath}/admin/users" class="admin-card">
                    <div class="card-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="card-title">User Management</h3>
                    <p class="card-description">Manage users, roles, and permissions</p>
                </a>

                <a href="${pageContext.request.contextPath}/admin/doctors" class="admin-card">
                    <div class="card-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h3 class="card-title">Doctor Management</h3>
                    <p class="card-description">Manage doctors and their schedules</p>
                </a>

                <a href="${pageContext.request.contextPath}/admin/prices" class="admin-card">
                    <div class="card-icon">
                        <i class="fas fa-tags"></i>
                    </div>
                    <h3 class="card-title">Procedure Prices</h3>
                    <p class="card-description">Configure procedure prices and packages</p>
                </a>

                <a href="${pageContext.request.contextPath}/admin/report-dashboard" class="admin-card">
                    <div class="card-icon">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <h3 class="card-title">Report Dashboard</h3>
                    <p class="card-description">Manage automated reports and scheduling triggers</p>
                </a>

                <a href="${pageContext.request.contextPath}/admin/cronjobs" class="admin-card">
                    <div class="card-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3 class="card-title">Cron Jobs</h3>
                    <p class="card-description">Manage scheduled jobs, triggers, and history</p>
                </a>
            </div>

            <div class="stats-section">
                <h2 class="mb-4">System Overview</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">${totalClinics}</div>
                        <p class="stat-label">Total Clinics</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${totalUsers}</div>
                        <p class="stat-label">Total Users</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${totalDoctors}</div>
                        <p class="stat-label">Total Doctors</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${totalPatients}</div>
                        <p class="stat-label">Total Patients</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>