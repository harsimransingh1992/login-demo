<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Registration - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Add jQuery for easier DOM manipulation -->
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
        }
        
        .welcome-header {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
        }
        
        .logout-form {
            margin: 0;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 0.9rem;
            text-decoration: none;
            text-align: center;
            border: none;
        }
        
        .btn i {
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #a82315);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.2);
        }
        
        .form-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            position: relative;
            overflow: hidden;
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
        
        .form-container .logo {
            display: block;
            text-align: center;
            margin-bottom: 35px;
        }
        
        .form-container .logo h1 {
            font-size: 1.8rem;
            margin-bottom: 10px;
            color: #3498db;
        }
        
        .form-container .logo p {
            color: #7f8c8d;
            margin: 0;
            font-size: 1.05rem;
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
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .form-group {
            flex: 1;
            min-width: 200px;
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
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            color: #000000 !important;
            box-sizing: border-box;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
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
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 35px;
            flex-wrap: wrap;
        }
        
        .footer {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        
        .copyright {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin: 0;
        }
        
        .powered-by {
            color: #3498db;
            font-weight: 500;
        }
        
        .navtech {
            color: #2c3e50;
            font-weight: 600;
        }
        
        .btn-small {
            padding: 8px 16px;
            font-size: 0.85rem;
        }
        
        /* Alert styles */
        .alert {
            padding: 16px 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .alert i {
            font-size: 1.1rem;
        }
        
        .alert-danger {
            background-color: #fdecec;
            color: #721c24;
            border-left: 4px solid #e74c3c;
        }
        
        .alert-success {
            background-color: #eafaf1;
            color: #155724;
            border-left: 4px solid #27ae60;
        }
        
        /* Select field styling */
        select.form-control {
            width: 100%;
            height: 45px;
            padding: 8px 12px;
            border: 1px solid #c0c0c0; 
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            color: #000000 !important;
            background-color: #f9f9f9;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%232c3e50' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        /* Add a specific style for city dropdown */
        #city {
            background-color: #f0f7ff;
            border: 1px solid #a6c8e6;
            color: #000000 !important;
            font-weight: 500;
        }
        
        #city:focus {
            background-color: #fff;
            border-color: #3498db;
        }
        
        /* Animation for loading effect */
        @keyframes highlightDropdown {
            0% { border-color: #3498db; box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1); }
            100% { border-color: #a6c8e6; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); }
        }
        
        .highlight-dropdown {
            animation: highlightDropdown 0.6s ease;
        }
        
        /* Error styling */
        .error-message {
            color: #e74c3c;
            font-size: 0.8rem;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }
        
        .error-message i {
            margin-right: 5px;
        }
        
        .invalid-field {
            border-color: #e74c3c !important;
            background-color: #ffeeee !important;
        }
        
        /* Profile picture upload styles */
        .profile-picture-container {
            width: 100%;
        }
        
        .profile-upload-area {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 10px;
        }
        
        .profile-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 2px dashed #c0c0c0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }
        
        .profile-preview i {
            font-size: 3rem;
            color: #c0c0c0;
            margin-bottom: 5px;
        }
        
        .profile-preview span {
            font-size: 0.8rem;
            color: #7f8c8d;
            text-align: center;
            padding: 0 5px;
        }
        
        .profile-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .upload-controls {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .btn-upload {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-upload:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
        }
        
        #removeImage {
            padding: 6px 12px;
            font-size: 0.85rem;
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
                <i class="fas fa-clipboard-list"></i>
                <div class="card-text">
                    <h3>Waiting Lobby</h3>
                    <p>View waiting patients</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/register" class="action-card">
                <i class="fas fa-user-plus"></i>
                <div class="card-text">
                    <h3>Register Patient</h3>
                    <p>Add new patient</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/list" class="action-card">
                <i class="fas fa-users"></i>
                <div class="card-text">
                    <h3>View Patients</h3>
                    <p>Manage records</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/appointments" class="action-card">
                <i class="fas fa-calendar-alt"></i>
                <div class="card-text">
                    <h3>Appointments</h3>
                    <p>Today's schedule</p>
                </div>
            </a>
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        <div class="main-content">
            <div class="welcome-header">
                <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-secondary btn-small">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>

            <div class="form-container">
                <div class="logo">
                    <h1>Patient Registration</h1>
                    <p>Please fill in the patient's details below</p>
                </div>
                
                <!-- Display error message if any -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <!-- Display success message if any -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                
                <form:form action="${pageContext.request.contextPath}/patients/register" method="post" modelAttribute="patient" enctype="multipart/form-data">
                    <!-- Personal Information Section -->
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName">First Name <span class="required">*</span></label>
                                <form:input type="text" id="firstName" path="firstName" required="true" placeholder="Enter first name"/>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last Name <span class="required">*</span></label>
                                <form:input type="text" id="lastName" path="lastName" required="true" placeholder="Enter last name"/>
                            </div>
                        </div>
                        
                        <!-- Profile Picture Upload -->
                        <div class="form-row">
                            <div class="form-group profile-picture-container">
                                <label for="profilePicture">Profile Picture</label>
                                <div class="profile-upload-area">
                                    <div class="profile-preview" id="profilePreview">
                                        <i class="fas fa-user-circle"></i>
                                        <span>No image selected</span>
                                    </div>
                                    <div class="upload-controls">
                                        <label for="profilePicture" class="btn btn-secondary btn-upload">
                                            <i class="fas fa-upload"></i> Choose Image
                                        </label>
                                        <input type="file" id="profilePicture" name="profilePicture" accept="image/*" style="display: none;" />
                                        <button type="button" id="removeImage" class="btn btn-danger btn-small" style="display: none;">
                                            <i class="fas fa-times"></i> Remove
                                        </button>
                                    </div>
                                </div>
                                <div class="form-tip">
                                    <i class="fas fa-info-circle"></i> Maximum size: 2MB. Recommended: square image (1:1 ratio)
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="dateOfBirth">Date of Birth <span class="required">*</span></label>
                                <form:input type="date" id="dateOfBirth" path="dateOfBirth" required="true"/>
                                <div class="form-tip">
                                    <i class="fas fa-info-circle"></i> Format: MM/DD/YYYY
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="gender">Gender <span class="required">*</span></label>
                                <form:select id="gender" path="gender" required="true">
                                    <form:option value="">Select Gender</form:option>
                                    <form:option value="MALE">Male</form:option>
                                    <form:option value="FEMALE">Female</form:option>
                                    <form:option value="OTHER">Other</form:option>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Contact Information Section -->
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-address-book"></i> Contact Information</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phoneNumber">Phone Number <span class="required">*</span></label>
                                <form:input type="tel" id="phoneNumber" path="phoneNumber" required="true" 
                                            pattern="[0-9]{10}" maxlength="10" placeholder="Enter 10-digit phone number"
                                            title="Please enter a valid 10-digit phone number (numbers only)"/>
                                <div class="form-tip">
                                    <i class="fas fa-info-circle"></i> 10-digit number only, no spaces or special characters
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <form:input type="email" id="email" path="email" placeholder="Enter email address"/>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Address Section -->
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-map-marker-alt"></i> Address Details</h3>
                        <div class="form-group">
                            <label for="streetAddress">Street Address <span class="required">*</span></label>
                            <form:textarea id="streetAddress" path="streetAddress" rows="2" required="true" 
                                         placeholder="Enter complete street address"/>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="state">State <span class="required">*</span></label>
                                <form:select id="state" path="state" class="form-control" required="true">
                                    <form:option value="">Select State</form:option>
                                    <form:options items="${indianStates}" itemLabel="displayName" itemValue="displayName"/>
                                </form:select>
                            </div>
                            <div class="form-group">
                                <label for="city">City <span class="required">*</span></label>
                                <form:select id="city" path="city" class="form-control" required="true">
                                    <form:option value="">Select City</form:option>
                                </form:select>
                                <div class="form-tip">
                                    <i class="fas fa-info-circle"></i> First select a state to load cities
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="pincode">Pincode <span class="required">*</span></label>
                                <form:input type="text" id="pincode" path="pincode" pattern="[0-9]*" maxlength="6" 
                                          placeholder="6-digit pincode" title="Please enter a valid 6-digit pincode" required="true"/>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Additional Information Section -->
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-file-medical"></i> Additional Information</h3>
                        <div class="form-group">
                            <label for="medicalHistory">Medical History</label>
                            <form:textarea id="medicalHistory" path="medicalHistory" rows="3" 
                                         placeholder="Enter any relevant medical history, allergies, or conditions"/>
                        </div>
                        <div class="form-group">
                            <label for="occupation">Occupation</label>
                            <form:select id="occupation" path="occupation" class="form-control">
                                <form:option value="">Select Occupation</form:option>
                                <form:options items="${occupations}" itemLabel="displayName" itemValue="name"/>
                            </form:select>
                        </div>
                        <div class="form-group">
                            <label for="referral">How did you hear about us? <span class="required">*</span></label>
                            <form:select id="referral" path="referral" class="form-control" required="true">
                                <form:option value="">Select an option</form:option>
                                <form:options items="${referralModels}" itemLabel="displayName" itemValue="name"/>
                            </form:select>
                            <div class="form-tip">
                                <i class="fas fa-info-circle"></i> This helps us understand how patients find us
                            </div>
                        </div>
                    </div>
                    
                    <!-- Emergency Contact Section -->
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-ambulance"></i> Emergency Contact</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="emergencyContactName">Emergency Contact Name</label>
                                <form:input type="text" id="emergencyContactName" path="emergencyContactName" 
                                          placeholder="Enter emergency contact person's name"/>
                            </div>
                            <div class="form-group">
                                <label for="emergencyContactPhoneNumber">Emergency Contact Phone</label>
                                <form:input type="tel" id="emergencyContactPhoneNumber" path="emergencyContactPhoneNumber" 
                                          pattern="[0-9]{10}" maxlength="10" placeholder="Enter 10-digit emergency contact number"
                                          title="Please enter a valid 10-digit phone number (numbers only)"/>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Register Patient
                        </button>
                        <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-danger">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</body>
<!-- Add script for state and city population -->
<script>
    $(document).ready(function() {
        console.log("Register form initialization");
        
        // Define a mapping of states to their cities
        const citiesByState = {};
        
        // Helper function to set text color on city options
        function applyTextStyles() {
            $('#city').find('option').css({
                'color': '#000000 !important',
                'background-color': '#ffffff',
                'font-weight': '500'
            });
        }
        
        // Validate the form before submission
        $('form').on('submit', function(e) {
            // Check if city is selected when state is selected
            const stateValue = $('#state').val();
            const cityValue = $('#city').val();
            
            if (stateValue && !cityValue) {
                // State is selected but city is not
                $('#city').addClass('invalid-field');
                // Highlight the city field
                $('#city').css({
                    'border-color': '#e74c3c',
                    'background-color': '#ffeeee'
                });
                // Show error message
                if ($('#city-error').length === 0) {
                    $('<div id="city-error" class="error-message">Please select a city</div>')
                        .insertAfter('#city')
                        .css({
                            'color': '#e74c3c',
                            'font-size': '0.8rem',
                            'margin-top': '5px'
                        });
                }
                
                // Prevent form submission
                e.preventDefault();
                return false;
            } else {
                // Remove error if city is selected
                $('#city').removeClass('invalid-field');
                $('#city').css({
                    'border-color': '#a6c8e6',
                    'background-color': '#f0f7ff'
                });
                $('#city-error').remove();
            }
            
            // Check if phone number is exactly 10 digits
            const phoneValue = $('#phoneNumber').val();
            if (phoneValue && !/^[0-9]{10}$/.test(phoneValue)) {
                // Phone number is invalid
                $('#phoneNumber').addClass('invalid-field');
                $('#phoneNumber').css({
                    'border-color': '#e74c3c',
                    'background-color': '#ffeeee'
                });
                
                // Show error message
                if ($('#phone-error').length === 0) {
                    $('<div id="phone-error" class="error-message">Please enter a valid 10-digit phone number</div>')
                        .insertAfter('#phoneNumber')
                        .css({
                            'color': '#e74c3c',
                            'font-size': '0.8rem',
                            'margin-top': '5px'
                        });
                }
                
                // Prevent form submission
                e.preventDefault();
                return false;
            } else {
                // Remove error if phone number is valid
                $('#phoneNumber').removeClass('invalid-field');
                $('#phoneNumber').css({
                    'border-color': '#c0c0c0',
                    'background-color': '#f9f9f9'
                });
                $('#phone-error').remove();
            }
            
            // Check if pincode is valid
            const pincodeValue = $('#pincode').val();
            if (pincodeValue && !/^\d{6}$/.test(pincodeValue)) {
                // Pincode is invalid
                $('#pincode').addClass('invalid-field');
                $('#pincode').css({
                    'border-color': '#e74c3c',
                    'background-color': '#ffeeee'
                });
                
                // Show error message
                if ($('#pincode-error').length === 0) {
                    $('<div id="pincode-error" class="error-message">Please enter a valid 6-digit pincode</div>')
                        .insertAfter('#pincode')
                        .css({
                            'color': '#e74c3c',
                            'font-size': '0.8rem',
                            'margin-top': '5px'
                        });
                }
                
                // Prevent form submission
                e.preventDefault();
                return false;
            } else {
                // Remove error if pincode is valid
                $('#pincode').removeClass('invalid-field');
                $('#pincode').css({
                    'border-color': '#c0c0c0',
                    'background-color': '#f9f9f9'
                });
                $('#pincode-error').remove();
            }
            
            return true;
        });
        
        // Validate city when state changes
        $('#state').on('change', function() {
            if ($(this).val()) {
                // Mark city as required when state is selected
                $('#city').attr('required', 'required');
            }
        });
        
        // Populate the city dropdown based on selected state
        function populateCityDropdown(selectedState) {
            const cityDropdown = $('#city');
            console.log("Populating city dropdown for state:", selectedState);
            
            // Visual feedback - add loading state
            cityDropdown.css({
                'background-color': '#f0f0f0',
                'color': '#000000',
                'font-weight': '500'
            });
            cityDropdown.empty().append('<option value="">Loading cities...</option>');
            
            if (selectedState && citiesByState[selectedState]) {
                cityDropdown.empty().append('<option value="">Select City</option>');
                console.log("Cities available:", citiesByState[selectedState].length);
                
                // Sort cities alphabetically
                citiesByState[selectedState].sort().forEach(city => {
                    // Make sure city value and text are set correctly with explicit DOM creation
                    const newOption = document.createElement('option');
                    newOption.value = city;
                    newOption.textContent = city;
                    newOption.style.color = '#000000';
                    newOption.style.fontWeight = '500';
                    cityDropdown[0].appendChild(newOption);
                });
                
                // If there's a pre-selected city, select it
                const selectedCity = "${patient.city}";
                if (selectedCity) {
                    console.log("Preselected city:", selectedCity);
                    cityDropdown.val(selectedCity);
                }
                
                // Reset background to normal 
                cityDropdown.css('background-color', '#f0f7ff');
                
                // Log the current state of the city dropdown
                console.log("City dropdown populated with options:", cityDropdown.find('option').length);
                console.log("Current selected value:", cityDropdown.val());
            } else if (!selectedState) {
                cityDropdown.empty().append('<option value="">Select City</option>');
                cityDropdown.css('background-color', '#f0f7ff');
            }
            
            // Apply direct styling for visibility
            applyTextStyles();
            
            // Force dropdown to refresh
            cityDropdown.hide().show(0);
            
            // Visually highlight the dropdown to draw attention
            cityDropdown.addClass('highlight-dropdown');
            setTimeout(() => {
                cityDropdown.removeClass('highlight-dropdown');
            }, 600);
        }
        
        // Handle state selection change
        $('#state').on('change', function() {
            const selectedState = $(this).val();
            console.log("State changed to:", selectedState);
            
            if (selectedState) {
                // If we don't have the cities for this state yet, fetch them
                if (!citiesByState[selectedState]) {
                    console.log("Fetching cities for state:", selectedState);
                    $.ajax({
                        url: "${pageContext.request.contextPath}/api/cities",
                        method: "GET",
                        data: { state: selectedState },
                        dataType: "json",
                        success: function(response) {
                            console.log("API response received:", response);
                            
                            // Extract city names from the response
                            const cityNames = response.map(city => city.displayName);
                            console.log("City names extracted:", cityNames);
                            
                            // Store the cities for this state
                            citiesByState[selectedState] = cityNames;
                            
                            // Update the dropdown
                            populateCityDropdown(selectedState);
                        },
                        error: function(xhr, status, error) {
                            console.error("Error loading cities for state:", selectedState, error);
                            console.error("Response:", xhr.responseText);
                            $('#city').empty().append('<option value="">Error loading cities</option>');
                            $('#city').css('background-color', '#ffeeee');
                        }
                    });
                } else {
                    console.log("Using cached cities for state:", selectedState);
                    // We already have the cities, just update the dropdown
                    populateCityDropdown(selectedState);
                }
            } else {
                // Clear the city dropdown if no state is selected
                $('#city').empty().append('<option value="">Select City</option>');
                $('#city').css('background-color', '#f0f7ff');
            }
        });
        
        // Add highlight animation class and other styles
        $("<style>")
            .text(`
                @keyframes highlightDropdown {
                    0% { border-color: #3498db; box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1); }
                    100% { border-color: #a6c8e6; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); }
                }
                .highlight-dropdown {
                    animation: highlightDropdown 0.6s ease;
                }
                
                /* Additional styles for dropdown visibility */
                #city option, #state option {
                    color: #000000 !important;
                    background-color: #ffffff !important;
                    padding: 8px 12px !important;
                    font-weight: 500 !important;
                }
                
                /* Force visible text in dropdowns */
                #city, #state, select.form-control {
                    color: #000000 !important;
                    font-weight: 500 !important;
                    text-shadow: none !important;
                }
            `)
            .appendTo("head");
        
        // If there's a pre-selected state on page load, trigger the city population
        const preSelectedState = "${patient.state}";
        if (preSelectedState) {
            console.log("Pre-selected state detected:", preSelectedState);
            $('#state').val(preSelectedState).trigger('change');
        } else {
            // Clear the city dropdown
            $('#city').empty().append('<option value="">Select City</option>');
            $('#city').css('background-color', '#f0f7ff');
        }
        
        // Check city visibility after page has fully loaded
        $(window).on('load', function() {
            console.log("Window loaded - checking city dropdown");
            const cityDropdown = $('#city');
            console.log("City dropdown value:", cityDropdown.val());
            console.log("City dropdown options:", cityDropdown.find('option').length);
            
            // Ensure the dropdown is visible
            applyTextStyles();
            
            // Set text style for all select elements
            $('select').css({
                'color': '#000000',
                'font-weight': '500'
            });
        });
    });
</script>

<!-- Add script for profile picture handling -->
<script>
    $(document).ready(function() {
        // Profile picture upload handling
        const profileInput = document.getElementById('profilePicture');
        const profilePreview = document.getElementById('profilePreview');
        const removeButton = document.getElementById('removeImage');
        
        // Handle file selection
        profileInput.addEventListener('change', function() {
            const file = this.files[0];
            
            if (file) {
                // Validate file size (max 2MB)
                if (file.size > 2 * 1024 * 1024) {
                    alert('Error: Image size exceeds 2MB. Please choose a smaller image.');
                    this.value = ''; // Clear the input
                    return;
                }
                
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Error: Please select an image file.');
                    this.value = ''; // Clear the input
                    return;
                }
                
                // Create preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    // Clear previous content
                    profilePreview.innerHTML = '';
                    
                    // Create and add image
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'Profile Preview';
                    profilePreview.appendChild(img);
                    
                    // Update styling
                    profilePreview.style.border = 'none';
                    removeButton.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
        
        // Handle remove button click
        removeButton.addEventListener('click', function() {
            // Clear the file input
            profileInput.value = '';
            
            // Reset the preview
            profilePreview.innerHTML = `
                <i class="fas fa-user-circle"></i>
                <span>No image selected</span>
            `;
            
            // Reset styling
            profilePreview.style.border = '2px dashed #c0c0c0';
            removeButton.style.display = 'none';
        });
    });
</script>
</html> 