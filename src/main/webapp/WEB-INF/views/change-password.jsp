<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .password-container {
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 5px;
        }
        .required-field::after {
            content: " *";
            color: red;
        }
        .password-input-group {
            position: relative;
        }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
        }
        .password-toggle:hover {
            color: #495057;
        }
        .password-strength {
            height: 4px;
            background: #eee;
            margin-top: 8px;
            border-radius: 2px;
            position: relative;
        }
        .password-strength-fill {
            height: 100%;
            border-radius: 2px;
            transition: width 0.3s, background 0.3s;
        }
        .password-strength-text {
            font-size: 0.85rem;
            margin-top: 5px;
            text-align: right;
        }
        .password-requirements {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .requirement {
            margin: 5px 0;
            display: flex;
            align-items: center;
            transition: color 0.3s ease;
        }
        .requirement i {
            width: 20px;
            text-align: center;
            margin-right: 8px;
            transition: color 0.3s ease;
        }
        .requirement.valid {
            color: #28a745;
        }
        .requirement.valid i {
            color: #28a745;
        }
        .requirement.invalid {
            color: #dc3545;
        }
        .requirement.invalid i {
            color: #dc3545;
        }
        .requirement-text {
            flex-grow: 1;
        }
        .strength-weak {
            color: #dc3545;
        }
        .strength-medium {
            color: #ffc107;
        }
        .strength-strong {
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="password-container">
            <h2 class="text-center mb-4">
                <c:if test="${forceChange}">
                    Password Change Required
                </c:if>
                <c:if test="${!forceChange}">
                    Change Password
                </c:if>
            </h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success" role="alert">
                    ${success}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/change-password" method="post" id="passwordForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="form-group">
                    <label for="currentPassword" class="required-field">Current Password</label>
                    <div class="password-input-group">
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                        <span class="password-toggle" onclick="togglePassword('currentPassword')">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="newPassword" class="required-field">New Password</label>
                    <div class="password-input-group">
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        <span class="password-toggle" onclick="togglePassword('newPassword')">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <div class="password-strength">
                        <div id="passwordStrengthFill" class="password-strength-fill"></div>
                    </div>
                    <div id="passwordStrengthText" class="password-strength-text"></div>
                    <div class="password-requirements">
                        <div class="requirement" id="lengthReq">
                            <i class="fas fa-times"></i>
                            <span class="requirement-text">At least 8 characters</span>
                        </div>
                        <div class="requirement" id="uppercaseReq">
                            <i class="fas fa-times"></i>
                            <span class="requirement-text">At least one uppercase letter</span>
                        </div>
                        <div class="requirement" id="lowercaseReq">
                            <i class="fas fa-times"></i>
                            <span class="requirement-text">At least one lowercase letter</span>
                        </div>
                        <div class="requirement" id="numberReq">
                            <i class="fas fa-times"></i>
                            <span class="requirement-text">At least one number</span>
                        </div>
                        <div class="requirement" id="specialReq">
                            <i class="fas fa-times"></i>
                            <span class="requirement-text">At least one special character (!@#$%^&*(),.?":{}|<>)</span>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="required-field">Confirm New Password</label>
                    <div class="password-input-group">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <div id="passwordMatch" class="password-requirements"></div>
                </div>
                
                <div class="form-group text-center">
                    <button type="submit" class="btn btn-primary" id="submitBtn" disabled>Change Password</button>
                    <c:if test="${!forceChange}">
                        <a href="${pageContext.request.contextPath}/welcome" class="btn btn-secondary ml-2">Cancel</a>
                    </c:if>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        function checkPasswordStrength(password) {
            const requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
            };
            
            // Update requirement indicators
            const reqs = {
                length: document.getElementById('lengthReq'),
                uppercase: document.getElementById('uppercaseReq'),
                lowercase: document.getElementById('lowercaseReq'),
                number: document.getElementById('numberReq'),
                special: document.getElementById('specialReq')
            };
            
            // Update each requirement's status
            Object.entries(requirements).forEach(([key, met]) => {
                const req = reqs[key];
                const icon = req.querySelector('i');
                
                if (met) {
                    req.className = 'requirement valid';
                    icon.className = 'fas fa-check';
                } else {
                    req.className = 'requirement invalid';
                    icon.className = 'fas fa-times';
                }
            });
            
            // Calculate strength
            const strength = Object.values(requirements).filter(Boolean).length;
            const strengthFill = document.getElementById('passwordStrengthFill');
            const strengthText = document.getElementById('passwordStrengthText');
            
            // Update strength bar
            strengthFill.style.width = `${(strength / 5) * 100}%`;
            
            // Update strength text and colors
            if (strength <= 2) {
                strengthFill.style.backgroundColor = '#dc3545';
                strengthText.textContent = 'Weak Password';
                strengthText.className = 'password-strength-text strength-weak';
            } else if (strength <= 4) {
                strengthFill.style.backgroundColor = '#ffc107';
                strengthText.textContent = 'Medium Password';
                strengthText.className = 'password-strength-text strength-medium';
            } else {
                strengthFill.style.backgroundColor = '#28a745';
                strengthText.textContent = 'Strong Password';
                strengthText.className = 'password-strength-text strength-strong';
            }
            
            return Object.values(requirements).every(Boolean);
        }
        
        function checkPasswordMatch() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword) {
                if (newPassword === confirmPassword) {
                    matchDiv.innerHTML = '<i class="fas fa-check"></i> Passwords match';
                    matchDiv.style.color = '#28a745';
                } else {
                    matchDiv.innerHTML = '<i class="fas fa-times"></i> Passwords do not match';
                    matchDiv.style.color = '#dc3545';
                }
            } else {
                matchDiv.innerHTML = '';
            }
            
            return newPassword === confirmPassword;
        }
        
        function validateForm() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const submitBtn = document.getElementById('submitBtn');
            
            const isPasswordStrong = checkPasswordStrength(newPassword);
            const doPasswordsMatch = checkPasswordMatch();
            
            submitBtn.disabled = !(isPasswordStrong && doPasswordsMatch);
        }
        
        // Add event listeners
        document.getElementById('newPassword').addEventListener('input', validateForm);
        document.getElementById('confirmPassword').addEventListener('input', validateForm);
        
        // Initial validation
        validateForm();
    </script>
</body>
</html> 