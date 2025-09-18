<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>PeriDesk - Set New Password</title>
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
            color: #27ae60;
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
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            user-select: none;
            color: #3498db;
            font-size: 14px;
            opacity: 0.7;
            transition: opacity 0.2s;
        }
        
        .password-toggle:hover {
            opacity: 1;
        }
        
        button {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(39, 174, 96, 0.3);
        }
        
        button:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.4);
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
        
        .user-info {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #6c757d;
            text-align: center;
        }
        
        .password-requirements {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 13px;
        }
        
        .password-requirements h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 14px;
        }
        
        .password-requirements ul {
            margin: 0;
            padding-left: 20px;
            color: #6c757d;
        }
        
        .password-requirements li {
            margin-bottom: 5px;
        }
        
        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }
        
        .strength-bar {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin: 5px 0;
            overflow: hidden;
        }
        
        .strength-fill {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }
        
        .strength-weak { background: #e74c3c; width: 25%; }
        .strength-fair { background: #f39c12; width: 50%; }
        .strength-good { background: #f1c40f; width: 75%; }
        .strength-strong { background: #27ae60; width: 100%; }
        
        .password-requirements-check {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #e9ecef;
        }
        
        .requirement-item {
            display: flex;
            align-items: center;
            margin: 5px 0;
            font-size: 12px;
        }
        
        .requirement-item i {
            margin-right: 8px;
            width: 12px;
        }
        
        .requirement-met i {
            color: #27ae60 !important;
        }
        
        .loading {
            display: none;
            text-align: center;
            color: #27ae60;
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
                <i class="fas fa-lock"></i>
                <h1>Set New Password</h1>
                <p>Create a secure password for your account</p>
            </div>
            
            <div id="message-container">
                <div id="error-message" class="error"></div>
                <div id="success-message" class="success"></div>
            </div>
            
            <div class="user-info">
                <i class="fas fa-user" style="color: #3498db; margin-right: 8px;"></i>
                Setting new password for: <strong>${username}</strong>
            </div>
            
            <div class="password-requirements">
                <h4><i class="fas fa-shield-alt" style="color: #3498db; margin-right: 8px;"></i>Password Requirements</h4>
                <ul>
                    <li>At least 8 characters long</li>
                    <li>One uppercase letter (A-Z)</li>
                    <li>One lowercase letter (a-z)</li>
                    <li>One number (0-9)</li>
                    <li>One special character (!@#$%^&*)</li>
                </ul>
            </div>
            
            <form id="resetPasswordForm">
                <input type="hidden" name="token" value="${token}">
                
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-key"></i>
                        New Password
                    </div>
                    
                    <div class="form-group">
                        <label for="newPassword">New Password <span class="required">*</span></label>
                        <div class="password-container">
                            <input type="password" id="newPassword" name="newPassword" required 
                                   placeholder="Enter your new password" autocomplete="new-password">
                            <span class="password-toggle" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye" id="newPassword-toggle"></i>
                            </span>
                        </div>
                        <div class="password-strength" id="password-strength" style="display: none;">
                            <div class="strength-bar">
                                <div class="strength-fill" id="strength-fill"></div>
                            </div>
                            <span id="strength-text">Password strength</span>
                        </div>
                        <div class="password-requirements-check" id="password-requirements-check" style="display: none;">
                            <div class="requirement-item" id="length-req">
                                <i class="fas fa-times" style="color: #e74c3c;"></i>
                                <span>At least 8 characters</span>
                            </div>
                            <div class="requirement-item" id="uppercase-req">
                                <i class="fas fa-times" style="color: #e74c3c;"></i>
                                <span>One uppercase letter</span>
                            </div>
                            <div class="requirement-item" id="lowercase-req">
                                <i class="fas fa-times" style="color: #e74c3c;"></i>
                                <span>One lowercase letter</span>
                            </div>
                            <div class="requirement-item" id="number-req">
                                <i class="fas fa-times" style="color: #e74c3c;"></i>
                                <span>One number</span>
                            </div>
                            <div class="requirement-item" id="special-req">
                                <i class="fas fa-times" style="color: #e74c3c;"></i>
                                <span>One special character</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password <span class="required">*</span></label>
                        <div class="password-container">
                            <input type="password" id="confirmPassword" name="confirmPassword" required 
                                   placeholder="Confirm your new password" autocomplete="new-password">
                            <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye" id="confirmPassword-toggle"></i>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="loading" id="loading">
                    <i class="fas fa-spinner"></i> Updating password...
                </div>
                
                <button type="submit" id="submitBtn">
                    <i class="fas fa-check"></i> Update Password
                </button>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // Password strength checker
            $('#newPassword').on('input', function() {
                const password = $(this).val();
                if (password.length > 0) {
                    $('#password-strength').show();
                    $('#password-requirements-check').show();
                    updatePasswordStrength(password);
                    updateRequirementIndicators(password);
                } else {
                    $('#password-strength').hide();
                    $('#password-requirements-check').hide();
                }
            });
            
            // Form submission
            $('#resetPasswordForm').on('submit', function(e) {
                e.preventDefault();
                
                const newPassword = $('#newPassword').val();
                const confirmPassword = $('#confirmPassword').val();
                const token = $('input[name="token"]').val();
                
                // Validation
                if (!newPassword || !confirmPassword) {
                    showError('Please fill in all required fields.');
                    return;
                }
                
                if (newPassword !== confirmPassword) {
                    showError('Passwords do not match.');
                    return;
                }
                
                // Enhanced password validation
                const passwordValidationError = validatePasswordStrength(newPassword);
                if (passwordValidationError) {
                    showError(passwordValidationError);
                    return;
                }
                
                // Show loading state
                $('#loading').show();
                $('#submitBtn').prop('disabled', true);
                hideMessages();
                
                // Submit request
                $.ajax({
                    url: '${pageContext.request.contextPath}/password-reset/reset',
                    type: 'POST',
                    data: {
                        token: token,
                        newPassword: newPassword,
                        confirmPassword: confirmPassword
                    },
                    success: function(response) {
                        if (response.success) {
                            showSuccess(response.message);
                            setTimeout(function() {
                                window.location.href = response.redirectUrl || '${pageContext.request.contextPath}/login';
                            }, 2000);
                        } else {
                            showError(response.message);
                        }
                    },
                    error: function(xhr) {
                        let errorMessage = 'An error occurred while updating your password.';
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
            
            function updatePasswordStrength(password) {
                let strength = 0;
                let text = '';
                let className = '';
                
                if (password.length >= 8) strength++;
                if (password.match(/[a-z]/)) strength++;
                if (password.match(/[A-Z]/)) strength++;
                if (password.match(/[0-9]/)) strength++;
                if (password.match(/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/)) strength++;
                
                switch (strength) {
                    case 0:
                    case 1:
                        text = 'Very Weak';
                        className = 'strength-weak';
                        break;
                    case 2:
                        text = 'Weak';
                        className = 'strength-weak';
                        break;
                    case 3:
                        text = 'Fair';
                        className = 'strength-fair';
                        break;
                    case 4:
                        text = 'Good';
                        className = 'strength-good';
                        break;
                    case 5:
                        text = 'Strong';
                        className = 'strength-strong';
                        break;
                }
                
                $('#strength-fill').removeClass().addClass('strength-fill ' + className);
                $('#strength-text').text(text);
            }
            
            function validatePasswordStrength(password) {
                if (!password || password.length < 8) {
                    return 'Password must be at least 8 characters long.';
                }
                
                if (!password.match(/[a-z]/)) {
                    return 'Password must contain at least one lowercase letter.';
                }
                
                if (!password.match(/[A-Z]/)) {
                    return 'Password must contain at least one uppercase letter.';
                }
                
                if (!password.match(/[0-9]/)) {
                    return 'Password must contain at least one number.';
                }
                
                if (!password.match(/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/)) {
                    return 'Password must contain at least one special character.';
                }
                
                return null; // Password is valid
            }
            
            function updateRequirementIndicators(password) {
                // Length requirement
                const lengthMet = password.length >= 8;
                updateRequirement('length-req', lengthMet);
                
                // Uppercase requirement
                const uppercaseMet = password.match(/[A-Z]/);
                updateRequirement('uppercase-req', uppercaseMet);
                
                // Lowercase requirement
                const lowercaseMet = password.match(/[a-z]/);
                updateRequirement('lowercase-req', lowercaseMet);
                
                // Number requirement
                const numberMet = password.match(/[0-9]/);
                updateRequirement('number-req', numberMet);
                
                // Special character requirement
                const specialMet = password.match(/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/);
                updateRequirement('special-req', specialMet);
            }
            
            function updateRequirement(elementId, isMet) {
                const element = $('#' + elementId);
                const icon = element.find('i');
                
                if (isMet) {
                    element.addClass('requirement-met');
                    icon.removeClass('fa-times').addClass('fa-check');
                } else {
                    element.removeClass('requirement-met');
                    icon.removeClass('fa-check').addClass('fa-times');
                }
            }
            
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
        
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const toggle = document.getElementById(fieldId + '-toggle');
            
            if (field.type === 'password') {
                field.type = 'text';
                toggle.className = 'fas fa-eye-slash';
            } else {
                field.type = 'password';
                toggle.className = 'fas fa-eye';
            }
        }
    </script>
</body>
</html>