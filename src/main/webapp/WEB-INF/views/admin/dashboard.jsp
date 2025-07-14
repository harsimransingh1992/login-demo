<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Console - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            position: relative;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card h2 {
            margin-top: 0;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
            margin-bottom: 10px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .btn-danger {
            background-color: #e74c3c;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .admin-menu {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }
        .admin-card {
            flex: 1;
            min-width: 250px;
            max-width: 400px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .admin-card h3 {
            color: #2c3e50;
            margin-top: 0;
        }
        .admin-card p {
            color: #7f8c8d;
            margin-bottom: 20px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .warning {
            color: #e74c3c;
            font-size: 0.9em;
            margin-top: 20px;
        }
        .logout-btn {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        .user-info {
            position: absolute;
            top: 60px;
            right: 20px;
            font-size: 0.9em;
            color: #ecf0f1;
        }
        .stats-card {
            border-radius: 10px;
            transition: transform 0.3s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stats-icon {
            font-size: 3rem;
            opacity: 0.8;
        }
        .card-link {
            text-decoration: none;
            color: inherit;
        }
        .card-link:hover {
            text-decoration: none;
            color: inherit;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>PeriDesk Admin Console</h1>
        <p>System Administration Panel</p>
        
        <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-btn">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-danger">Logout</button>
        </form>
        <div class="user-info">Logged in as: ${pageContext.request.userPrincipal.name}</div>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>System Management</h2>
            <p>Welcome to the admin console. From here, you can manage users, doctors, and system settings.</p>
            
            <div class="admin-menu">
                <div class="admin-card">
                    <h3>User Management</h3>
                    <p>Create, edit, and manage clinic user accounts</p>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn">Manage Users</a>
                </div>
                
                <div class="admin-card">
                    <h3>Doctor Management</h3>
                    <p>Manage doctor details and assignments to clinics</p>
                    <a href="${pageContext.request.contextPath}/admin/doctors" class="btn">Manage Doctors</a>
                </div>
                
                <div class="admin-card">
                    <h3>Procedure Prices</h3>
                    <p>Manage procedure prices based on city tiers</p>
                    <a href="${pageContext.request.contextPath}/admin/prices" class="btn">Manage Prices</a>
                </div>
                
                <div class="admin-card">
                    <h3>Doctor Targets</h3>
                    <p>Configure monthly targets for doctors based on city tiers</p>
                    <a href="${pageContext.request.contextPath}/admin/targets" class="btn">Manage Targets</a>
                </div>
                
                <div class="admin-card">
                    <h3>Database Maintenance</h3>
                    <p>Fix database integrity issues and perform maintenance</p>
                    <a href="${pageContext.request.contextPath}/admin/database-status" class="btn">Database Tools</a>
                </div>
            </div>
            
            <p class="warning">Note: This is a restricted area. All actions are logged for security purposes.</p>
        </div>
        
        <div class="card">
            <h2>Quick Actions</h2>
            <a href="${pageContext.request.contextPath}/admin/users/create" class="btn">Create New User</a>
            <a href="${pageContext.request.contextPath}/admin/doctors/create" class="btn">Add New Doctor</a>
            <a href="${pageContext.request.contextPath}/admin/prices/create" class="btn">Add New Procedure Price</a>
            <a href="${pageContext.request.contextPath}/admin/targets/new" class="btn">Create New Target</a>
            <a href="${pageContext.request.contextPath}/admin/database-status" class="btn">Database Maintenance</a>
            <a href="${pageContext.request.contextPath}/welcome" class="btn">Back to Main App</a>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
</body>
</html> 