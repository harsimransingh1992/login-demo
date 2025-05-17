<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Oops! - PeriDesk</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            text-align: center;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .error-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 600px;
            width: 90%;
        }
        .error-title {
            font-size: 28px;
            color: #e74c3c;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .error-message {
            font-size: 18px;
            line-height: 1.5;
            margin-bottom: 30px;
        }
        .error-details {
            background-color: #f9f9f9;
            border-radius: 4px;
            padding: 15px;
            text-align: left;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .error-image {
            max-width: 250px;
            margin: 20px 0;
        }
        .btn-home {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .btn-home:hover {
            background-color: #2980b9;
        }
        .tooth-icon {
            font-size: 48px;
            color: #3498db;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="fas fa-tooth tooth-icon"></i>
        <h1 class="error-title">Oops! Our tooth got chipped!</h1>
        
        <img src="https://cdn-icons-png.flaticon.com/512/4053/4053768.png" alt="Broken tooth" class="error-image">
        
        <p class="error-message">
            Sorry, but something went wrong with our system. <br>
            Our dental team is working to fix it as soon as possible!
        </p>
        
        <c:if test="${not empty status}">
            <div class="error-details">
                <p><strong>Error Code:</strong> ${status} ${error}</p>
                <c:if test="${not empty message}">
                    <p><strong>Message:</strong> ${message}</p>
                </c:if>
                <c:if test="${not empty trace}">
                    <p><strong>Details:</strong> ${trace}</p>
                </c:if>
            </div>
        </c:if>
        
        <a href="/" class="btn-home">
            <i class="fas fa-home"></i> Return to Home
        </a>
    </div>
</body>
</html> 