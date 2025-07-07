<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 5px;
        }
        .error-details {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <h2 class="text-center text-danger mb-4">Error</h2>
            
            <div class="alert alert-danger" role="alert">
                ${errorMessage}
            </div>
            
            <div class="error-details">
                <p><strong>Status:</strong> ${status}</p>
                <p><strong>URL:</strong> ${url}</p>
                <p><strong>Time:</strong> ${timestamp}</p>
            </div>
            
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Home</a>
                <button onclick="history.back()" class="btn btn-secondary ml-2">Go Back</button>
            </div>
        </div>
    </div>
</body>
</html> 