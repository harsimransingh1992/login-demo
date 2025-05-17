<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Page Not Found - PeriDesk</title>
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
        .code-404 {
            font-size: 72px;
            font-weight: bold;
            color: #e74c3c;
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="fas fa-tooth tooth-icon"></i>
        <p class="code-404">404</p>
        <h1 class="error-title">Tooth Not Found!</h1>
        
        <img src="https://cdn-icons-png.flaticon.com/512/4476/4476761.png" alt="Missing tooth" class="error-image">
        
        <p class="error-message">
            Oops! The page you're looking for seems to be missing, just like this tooth.<br>
            Let's get you back to a place we know.
        </p>
        
        <a href="/" class="btn-home">
            <i class="fas fa-home"></i> Return to Home
        </a>
    </div>
</body>
</html> 