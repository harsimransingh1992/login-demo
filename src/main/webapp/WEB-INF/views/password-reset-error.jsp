<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>PeriDesk - Password Reset Error</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%233498db'><path d='M12 2C10.5 2 9 3.5 9 5C9 6.5 10.5 8 12 8C13.5 8 15 6.5 15 5C15 3.5 13.5 2 12 2ZM12 10C10.5 10 9 11.5 9 13C9 14.5 10.5 16 12 16C13.5 16 15 14.5 15 13C15 11.5 13.5 10 12 10ZM12 18C10.5 18 9 19.5 9 21C9 22.5 10.5 24 12 24C13.5 24 15 22.5 15 21C15 19.5 13.5 18 12 18Z'/></svg>">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f0f5fa;
            color: #2c3e50;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .main-content {
            width: 100%;
            max-width: 550px;
            padding: 20px;
        }
        
        .error-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
            width: 100%;
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
        
        .error-icon {
            font-size: 4rem;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 0 0 15px 0;
            font-weight: 600;
        }
        
        .error-message {
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 1rem;
            line-height: 1.6;
        }
        
        .error-details {
            background: #fee;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 30px;
            color: #721c24;
            font-size: 14px;
        }
        
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .btn {
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.4);
        }
        
        .btn-secondary {
            background: #f8f9fa;
            color: #6c757d;
            border: 1px solid #dee2e6;
        }
        
        .btn-secondary:hover {
            background: #e9ecef;
            color: #495057;
            transform: translateY(-1px);
        }
        
        .help-text {
            margin-top: 20px;
            font-size: 14px;
            color: #6c757d;
            line-height: 1.5;
        }
        
        .help-text a {
            color: #3498db;
            text-decoration: none;
        }
        
        .help-text a:hover {
            text-decoration: underline;
        }
        
        @media (min-width: 480px) {
            .action-buttons {
                flex-direction: row;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            
            <h1 class="error-title">Password Reset Error</h1>
            
            <p class="error-message">
                We're sorry, but there was a problem with your password reset request.
            </p>
            
            <div class="error-details">
                <i class="fas fa-info-circle" style="margin-right: 8px;"></i>
                <c:choose>
                    <c:when test="${not empty error}">
                        ${error}
                    </c:when>
                    <c:otherwise>
                        The password reset link is invalid or has expired. Please request a new password reset.
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/password-reset/request" class="btn btn-primary">
                    <i class="fas fa-redo"></i>
                    Request New Reset
                </a>
                
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Back to Login
                </a>
            </div>
            
            <div class="help-text">
                <p>
                    <strong>Common reasons for this error:</strong><br>
                    • The reset link has expired (links are valid for 30 minutes)<br>
                    • The link has already been used<br>
                    • The link was copied incorrectly
                </p>
                
                <p>
                    Need help? Contact our support team at 
                    <a href="mailto:support@peridesk.com">support@peridesk.com</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>