<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Access Denied - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
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
        
        .sidebar-menu {
            width: 280px;
            background: linear-gradient(180deg, #ffffff, #f8f9fa);
            padding: 30px;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            position: relative;
            z-index: 10;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 35px;
        }
        
        .logo img {
            width: 40px;
            height: 40px;
            filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
        }
        
        .logo h1 {
            font-size: 1.5rem;
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .logo p {
            color: #7f8c8d;
            margin: 5px 0 0 0;
            font-size: 1rem;
        }
        
        .action-card {
            background: white;
            padding: 16px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
            transition: all 0.3s;
            text-decoration: none;
            border: 1px solid #f0f0f0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .action-card i {
            font-size: 1.2rem;
            color: #3498db;
            width: 30px;
        }
        
        .action-card:hover {
            transform: translateX(5px);
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border-color: transparent;
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.2);
        }
        
        .action-card:hover h3,
        .action-card:hover p,
        .action-card:hover i {
            color: white;
        }
        
        .action-card h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .action-card p {
            margin: 4px 0 0 0;
            color: #7f8c8d;
            font-size: 0.8rem;
        }
        
        .card-text {
            flex: 1;
        }
        
        .main-content {
            flex: 1;
            padding: 40px;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .error-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            position: relative;
            overflow: hidden;
            width: 100%;
            max-width: 550px;
            text-align: center;
        }
        
        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(to right, #e74c3c, #c0392b);
        }
        
        .error-code {
            font-size: 72px;
            color: #e74c3c;
            margin: 0;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .error-message {
            font-size: 24px;
            color: #2c3e50;
            margin-top: 10px;
            font-weight: 600;
        }
        
        .error-description {
            color: #7f8c8d;
            margin: 20px 0 30px;
            font-size: 16px;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
        }
        
        .btn:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.4);
        }
        
        .btn i {
            font-size: 16px;
        }
        
        .footer {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            font-size: 12px;
            color: #999;
        }
        
        .copyright {
            margin: 5px 0;
        }
        
        .powered-by {
            color: #3498db;
            font-weight: 500;
        }
        
        .navtech {
            color: #2c3e50;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <div class="sidebar-menu">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
            <h1>PeriDesk</h1>
            </div>
            <a href="${pageContext.request.contextPath}/welcome" class="action-card">
                <i class="fas fa-home"></i>
                <div class="card-text">
                    <h3>Dashboard</h3>
                    <p>Return to main page</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/login" class="action-card">
                <i class="fas fa-sign-in-alt"></i>
                <div class="card-text">
                    <h3>Sign In</h3>
                    <p>Login with different account</p>
                </div>
            </a>
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="error-container">
        <h1 class="error-code">403</h1>
        <h2 class="error-message">Access Denied</h2>
        <p class="error-description">You don't have permission to access this page.</p>
        
                <a href="${pageContext.request.contextPath}/welcome" class="btn">
                    <i class="fas fa-arrow-left"></i> Return to Dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html> 