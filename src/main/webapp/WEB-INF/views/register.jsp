<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>PeriDesk - User Registration</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
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
        
        .form-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            position: relative;
            overflow: hidden;
            width: 100%;
            max-width: 550px;
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
        
        .form-group input, .form-group select {
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
        
        .form-group input:focus, .form-group select:focus {
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
        
        .form-tip {
            font-size: 0.8rem;
            color: #7f8c8d;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }
        
        .form-tip i {
            margin-right: 5px;
            color: #3498db;
            font-size: 0.8rem;
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
        
        .error, .success {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
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
        
        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 14px;
        }
        
        .login-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        
        .login-link a:hover {
            color: #2980b9;
            text-decoration: underline;
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
        
        /* Progress indicators */
        .strength-meter {
            height: 4px;
            background: #eee;
            margin-top: 8px;
            border-radius: 2px;
            position: relative;
        }
        
        .strength-meter-fill {
            height: 100%;
            border-radius: 2px;
            width: 0%;
            transition: width 0.3s, background 0.3s;
        }
        
        .password-strength-text {
            font-size: 12px;
            margin-top: 5px;
            color: #999;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
    </style>
    <script>
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const toggleText = document.querySelector(`.password-toggle[onclick*="${inputId}"]`);
            
            if (input.type === "password") {
                input.type = "text";
                toggleText.innerHTML = '<i class="fas fa-eye-slash"></i>';
            } else {
                input.type = "password";
                toggleText.innerHTML = '<i class="fas fa-eye"></i>';
            }
        }
        
        function checkPasswordStrength(password) {
            const meter = document.getElementById('strength-meter-fill');
            const text = document.getElementById('password-strength-text');
            
            if (!password) {
                meter.style.width = '0%';
                meter.style.background = '#eee';
                text.textContent = '';
                return;
            }
            
            // Simple password strength calculation
            let strength = 0;
            if (password.length >= 8) strength += 25;
            if (password.match(/[a-z]+/)) strength += 25;
            if (password.match(/[A-Z]+/)) strength += 25;
            if (password.match(/[0-9]+/) || password.match(/[^a-zA-Z0-9]+/)) strength += 25;
            
            meter.style.width = strength + '%';
            
            if (strength < 25) {
                meter.style.background = '#ff4d4d';
                text.textContent = 'Very Weak';
                text.style.color = '#ff4d4d';
            } else if (strength < 50) {
                meter.style.background = '#ffaa00';
                text.textContent = 'Weak';
                text.style.color = '#ffaa00';
            } else if (strength < 75) {
                meter.style.background = '#ffcc00';
                text.textContent = 'Good';
                text.style.color = '#ffcc00';
            } else {
                meter.style.background = '#2ecc71';
                text.textContent = 'Strong';
                text.style.color = '#2ecc71';
            }
        }
        
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchText = document.getElementById('password-match-text');
            
            if (!confirmPassword) {
                matchText.textContent = '';
                return;
            }
            
            if (password === confirmPassword) {
                matchText.textContent = 'Passwords match';
                matchText.style.color = '#2ecc71';
            } else {
                matchText.textContent = 'Passwords do not match';
                matchText.style.color = '#ff4d4d';
            }
        }
        
        window.onload = function() {
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const roleSelect = document.getElementById('role');
            
            if (passwordInput) {
                passwordInput.addEventListener('input', function() {
                    checkPasswordStrength(this.value);
                });
            }
            
            if (confirmPasswordInput) {
                confirmPasswordInput.addEventListener('input', function() {
                    checkPasswordMatch();
                });
            }
            
            // Role-based field display
            if (roleSelect) {
                function updateFieldDisplay() {
                    const role = roleSelect.value;
                    const doctorFields = document.getElementById('doctorFields');
                    const professionalDetails = document.getElementById('professionalDetails');
                    
                    // Reset field display
                    if (doctorFields) doctorFields.style.display = 'none';
                    if (professionalDetails) professionalDetails.style.display = 'none';
                    
                    // Set required attributes
                    const doctorRequiredFields = document.querySelectorAll('.doctorRequired');
                    doctorRequiredFields.forEach(field => {
                        const input = field.closest('.form-group').querySelector('input, select');
                        if (input) {
                            input.required = role === 'DOCTOR';
                        }
                    });
                    
                    // Show fields based on role
                    if (role === 'DOCTOR') {
                        if (doctorFields) doctorFields.style.display = 'block';
                        if (professionalDetails) professionalDetails.style.display = 'block';
                    } else if (role === 'STAFF' || role === 'RECEPTIONIST') {
                        if (professionalDetails) professionalDetails.style.display = 'block';
                    }
                }
                
                roleSelect.addEventListener('change', updateFieldDisplay);
                // Initialize field display
                updateFieldDisplay();
            }
        }
    </script>
</head>
<body>
    <div class="welcome-container">
        <div class="sidebar-menu">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
                <h1>PeriDesk</h1>
            </div>
            <a href="${pageContext.request.contextPath}/" class="action-card">
                <i class="fas fa-sign-in-alt"></i>
                <div class="card-text">
                    <h3>Sign In</h3>
                    <p>Login to your account</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/register" class="action-card">
                <i class="fas fa-user-plus"></i>
                <div class="card-text">
                    <h3>User Registration</h3>
                    <p>Create a new user account</p>
                </div>
            </a>
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="form-container">
                <div class="logo">
                    <h1>Create Account</h1>
                    <p>Register as a new user</p>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="error">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success">
                        <i class="fas fa-check-circle"></i> ${success}
                    </div>
                </c:if>
                
                <form:form action="${pageContext.request.contextPath}/register" method="post" modelAttribute="registrationDto">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName">First Name <span class="required">*</span></label>
                                <form:input path="firstName" id="firstName" required="true" placeholder="Enter your first name"/>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last Name <span class="required">*</span></label>
                                <form:input path="lastName" id="lastName" required="true" placeholder="Enter your last name"/>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <form:input path="email" id="email" type="email" placeholder="Enter your email address"/>
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber">Phone Number</label>
                                <form:input path="phoneNumber" id="phoneNumber" placeholder="Enter your phone number"/>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-clinic-medical"></i> Clinic Association</h3>
                        <div class="form-group">
                            <label for="clinicId">Select Clinic</label>
                            <form:select path="clinicId" id="clinicId">
                                <form:option value="">-- Select a clinic --</form:option>
                                <c:forEach items="${clinics}" var="clinic">
                                    <form:option value="${clinic.id}">${clinic.clinicName}</form:option>
                                </c:forEach>
                            </form:select>
                            <div class="form-tip">
                                <i class="fas fa-info-circle"></i> Select the clinic you are associated with
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="role">User Role <span class="required">*</span></label>
                            <form:select path="role" id="role" required="true">
                                <form:option value="STAFF">Staff</form:option>
                                <form:option value="DOCTOR">Doctor</form:option>
                                <form:option value="RECEPTIONIST">Receptionist</form:option>
                            </form:select>
                            <div class="form-tip">
                                <i class="fas fa-info-circle"></i> Select your role in the clinic
                            </div>
                        </div>
                    </div>
                    
                    <!-- Doctor specific fields -->
                    <div id="doctorFields" class="form-section" style="display: none;">
                        <h3 class="section-title"><i class="fas fa-user-md"></i> Professional Details</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="specialization">Specialization <span class="required doctorRequired">*</span></label>
                                <form:select path="specialization" id="specialization">
                                    <form:option value="">-- Select Specialization --</form:option>
                                    <form:option value="Orthodontist">Orthodontist</form:option>
                                    <form:option value="Periodontist">Periodontist</form:option>
                                    <form:option value="Endodontist">Endodontist</form:option>
                                    <form:option value="Oral Surgeon">Oral Surgeon</form:option>
                                    <form:option value="Pediatric Dentist">Pediatric Dentist</form:option>
                                    <form:option value="Prosthodontist">Prosthodontist</form:option>
                                    <form:option value="General Dentist">General Dentist</form:option>
                                </form:select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="licenseNumber">License Number <span class="required doctorRequired">*</span></label>
                                <form:input path="licenseNumber" id="licenseNumber" placeholder="Enter your license number"/>
                            </div>
                            <div class="form-group">
                                <label for="licenseExpiryDate">License Expiry Date</label>
                                <form:input path="licenseExpiryDate" id="licenseExpiryDate" type="date"/>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="bio">Professional Biography</label>
                            <form:textarea path="bio" id="bio" rows="4" placeholder="Brief description of your professional experience and expertise" style="width: 100%; padding: 12px 15px; border: 1px solid #e0e0e0; border-radius: 8px;"/>
                        </div>
                    </div>
                    
                    <!-- Professional Details for all healthcare staff -->
                    <div id="professionalDetails" class="form-section" style="display: none;">
                        <h3 class="section-title"><i class="fas fa-id-badge"></i> Employment Details</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="qualification">Qualification</label>
                                <form:input path="qualification" id="qualification" placeholder="Your educational qualifications (e.g., BDS, MDS)"/>
                            </div>
                            <div class="form-group">
                                <label for="designation">Designation/Position</label>
                                <form:input path="designation" id="designation" placeholder="Your job title or position"/>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="joiningDate">Joining Date</label>
                                <form:input path="joiningDate" id="joiningDate" type="date"/>
                            </div>
                            
                            <div class="form-group">
                                <label for="emergencyContact">Emergency Contact</label>
                                <form:input path="emergencyContact" id="emergencyContact" placeholder="Emergency contact number"/>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Address</label>
                            <form:input path="address" id="address" placeholder="Your residential address"/>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-id-card"></i> Account Information</h3>
                        <div class="form-group">
                            <label for="username">Username <span class="required">*</span></label>
                            <form:input path="username" id="username" required="true" placeholder="Choose a unique username"/>
                            <div class="form-tip">
                                <i class="fas fa-info-circle"></i> This will be used for login
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-lock"></i> Security</h3>
                        <div class="form-group">
                            <label for="password">Password <span class="required">*</span></label>
                            <div class="password-container">
                                <form:password path="password" id="password" required="true" placeholder="Create a strong password"/>
                                <span class="password-toggle" onclick="togglePassword('password')"><i class="fas fa-eye"></i></span>
                            </div>
                            <div class="strength-meter">
                                <div id="strength-meter-fill" class="strength-meter-fill"></div>
                            </div>
                            <div id="password-strength-text" class="password-strength-text"></div>
                            <div class="form-tip">
                                <i class="fas fa-shield-alt"></i> Use 8+ characters with a mix of letters, numbers & symbols
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                            <div class="password-container">
                                <form:password path="confirmPassword" id="confirmPassword" required="true" placeholder="Type your password again"/>
                                <span class="password-toggle" onclick="togglePassword('confirmPassword')"><i class="fas fa-eye"></i></span>
                            </div>
                            <div id="password-match-text" class="password-strength-text"></div>
                        </div>
                    </div>
                    
                    <button type="submit">Create Account</button>
                    
                    <div class="login-link">
                        <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</body>
</html> 