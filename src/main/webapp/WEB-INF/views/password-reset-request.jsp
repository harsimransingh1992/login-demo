<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>PeriDesk - Password Reset</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%233498db'><path d='M12 2C10.5 2 9 3.5 9 5C9 6.5 10.5 8 12 8C13.5 8 15 6.5 15 5C15 3.5 13.5 2 12 2ZM12 10C10.5 10 9 11.5 9 13C9 14.5 10.5 16 12 16C13.5 16 15 14.5 15 13C15 11.5 13.5 10 12 10ZM12 18C10.5 18 9 19.5 9 21C9 22.5 10.5 24 12 24C13.5 24 15 22.5 15 21C15 19.5 13.5 18 12 18Z'/></svg>">
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
        
        .form-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
            width: 100%;
        }
        
        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(to right, #3498db, #2980b9);
        }
        
        .logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo i {
            font-size: 3rem;
            color: #3498db;
            margin-bottom: 15px;
        }
        
        .logo h1 {
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 0 0 10px 0;
            font-weight: 600;
        }
        
        .logo p {
            color: #7f8c8d;
            margin: 0;
            font-size: 1rem;
        }
        
        .form-section {
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 1.2rem;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            font-weight: 600;
        }
        
        .section-title i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .form-group label .required {
            color: #e74c3c;
            margin-left: 4px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
            outline: none;
            background-color: #fff;
        }
        
        button {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
        }
        
        button:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.4);
        }
        
        button:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .error, .success {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
            display: none;
        }
        
        .error {
            background-color: #fee;
            color: #e74c3c;
            border-left: 4px solid #e74c3c;
        }
        
        .success {
            background-color: #e3f8e3;
            color: #27ae60;
            border-left: 4px solid #27ae60;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            transition: color 0.3s;
        }
        
        .back-link a:hover {
            color: #2980b9;
        }
        
        .back-link a i {
            margin-right: 8px;
        }
        
        .info-box {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #6c757d;
        }
        
        .loading {
            display: none;
            text-align: center;
            color: #3498db;
        }
        
        .loading i {
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="form-container">
            <div class="logo">
                <i class="fas fa-key"></i>
                <h1>Reset Password</h1>
                <p>Enter your username to receive reset instructions</p>
            </div>
            
            <div id="message-container">
                <div id="error-message" class="error"></div>
                <div id="success-message" class="success"></div>
            </div>
            
            <div class="info-box">
                <i class="fas fa-info-circle" style="color: #3498db; margin-right: 8px;"></i>
                Enter your username and we'll send password reset instructions to your registered email address.
            </div>
            
            <form id="resetRequestForm">
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-user"></i>
                        Account Information
                    </div>
                    
                    <div class="form-group">
                        <label for="username">Username <span class="required">*</span></label>
                        <input type="text" id="username" name="username" required 
                               placeholder="Enter your username" autocomplete="username">
                    </div>
                </div>
                
                <div class="loading" id="loading">
                    <i class="fas fa-spinner"></i> Processing request...
                </div>
                
                <button type="submit" id="submitBtn">
                    <i class="fas fa-paper-plane"></i> Send Reset Instructions
                </button>
            </form>
            
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/login">
                    <i class="fas fa-arrow-left"></i>
                    Back to Login
                </a>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('#resetRequestForm').on('submit', function(e) {
                e.preventDefault();
                
                const username = $('#username').val().trim();
                
                if (!username) {
                    showError('Please enter your username.');
                    return;
                }
                
                // Show loading state
                $('#loading').show();
                $('#submitBtn').prop('disabled', true);
                hideMessages();
                
                // Submit request
                $.ajax({
                    url: '${pageContext.request.contextPath}/password-reset/request',
                    type: 'POST',
                    data: { username: username },
                    success: function(response) {
                        if (response.success) {
                            let message = response.message;
                            if (response.maskedEmail) {
                                message += ' Email sent to: ' + response.maskedEmail;
                            }
                            showSuccess(message);
                            $('#resetRequestForm')[0].reset();
                        } else {
                            showError(response.message);
                        }
                    },
                    error: function(xhr) {
                        let errorMessage = 'An error occurred while processing your request.';
                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMessage = xhr.responseJSON.message;
                        }
                        showError(errorMessage);
                    },
                    complete: function() {
                        $('#loading').hide();
                        $('#submitBtn').prop('disabled', false);
                    }
                });
            });
            
            // Real-time username validation
            $('#username').on('blur', function() {
                const username = $(this).val().trim();
                if (username) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/password-reset/check-username',
                        type: 'GET',
                        data: { username: username },
                        success: function(response) {
                            if (response.exists && response.maskedEmail) {
                                $('#username').css('border-color', '#27ae60');
                            }
                        }
                    });
                }
            });
            
            function showError(message) {
                $('#error-message').text(message).show();
                $('#success-message').hide();
            }
            
            function showSuccess(message) {
                $('#success-message').text(message).show();
                $('#error-message').hide();
            }
            
            function hideMessages() {
                $('#error-message, #success-message').hide();
            }
        });
    </script>
</body>
</html>