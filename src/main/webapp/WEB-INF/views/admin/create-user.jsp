<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create User - PeriDesk Admin</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card h2 {
            margin-top: 0;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
            margin-bottom: 10px;
            border: none;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #2c3e50;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        .actions {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .error-message {
            color: #e74c3c;
            margin-top: 5px;
            font-size: 0.9em;
        }
        .password-container {
            position: relative;
        }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            user-select: none;
            color: #3498db;
            font-size: 14px;
        }
        .section-title {
            font-size: 1.2em;
            color: #2c3e50;
            margin: 25px 0 15px 0;
            padding-bottom: 8px;
            border-bottom: 1px solid #eee;
        }
        .section-title i {
            margin-right: 8px;
            color: #3498db;
        }
        .form-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        .form-row .form-group {
            flex: 1;
            min-width: 200px;
        }
        .required::after {
            content: " *";
            color: #e74c3c;
        }
    </style>
    <script>
        function togglePassword(inputId) {
            const passwordInput = document.getElementById(inputId);
            const toggleText = document.querySelector(`.password-toggle[onclick*="${inputId}"]`);
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleText.innerText = "Hide";
            } else {
                passwordInput.type = "password";
                toggleText.innerText = "Show";
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Role-based field display
            const roleSelect = document.getElementById('role');
            
            function updateFormVisibility() {
                const role = roleSelect.value;
                const doctorFields = document.getElementById('doctorFields');
                const professionalDetails = document.getElementById('professionalDetails');
                
                // Reset all sections to hidden
                if (doctorFields) doctorFields.style.display = 'none';
                if (professionalDetails) professionalDetails.style.display = 'none';
                
                // Show sections based on role
                if (role === 'DOCTOR') {
                    if (doctorFields) doctorFields.style.display = 'block';
                    if (professionalDetails) professionalDetails.style.display = 'block';
                    
                    // Make doctor-specific fields required
                    const specializationField = document.getElementById('specialization');
                    if (specializationField) specializationField.required = true;
                } else if (role === 'STAFF' || role === 'RECEPTIONIST') {
                    if (professionalDetails) professionalDetails.style.display = 'block';
                    
                    // Make doctor-specific fields not required
                    const specializationField = document.getElementById('specialization');
                    if (specializationField) specializationField.required = false;
                }
            }
            
            if (roleSelect) {
                roleSelect.addEventListener('change', updateFormVisibility);
                // Initialize form visibility
                updateFormVisibility();
            }
        });
    </script>
</head>
<body>
    <div class="header">
        <h1>Create New User</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>User Information</h2>
            
            <c:if test="${error != null}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form:form action="${pageContext.request.contextPath}/admin/users/create" method="post" modelAttribute="user">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="form-group">
                    <label for="username" class="required">Username</label>
                    <form:input path="username" id="username" class="form-control" required="true" />
                    <div class="error-message">${usernameError}</div>
                </div>
                
                <div class="form-group">
                    <label for="password" class="required">Password</label>
                    <div class="password-container">
                        <form:password path="password" id="password" class="form-control" required="true" />
                        <span class="password-toggle" onclick="togglePassword('password')">Show</span>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName" class="required">First Name</label>
                        <form:input path="firstName" id="firstName" class="form-control" required="true" />
                    </div>
                    <div class="form-group">
                        <label for="lastName" class="required">Last Name</label>
                        <form:input path="lastName" id="lastName" class="form-control" required="true" />
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <form:input path="email" id="email" type="email" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label for="phoneNumber">Phone Number</label>
                        <form:input path="phoneNumber" id="phoneNumber" class="form-control" />
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="role" class="required">User Role</label>
                        <form:select path="role" id="role" class="form-control" required="true">
                            <form:option value="">-- Select Role --</form:option>
                            <form:option value="ADMIN">Administrator</form:option>
                            <form:option value="CLINIC_OWNER">Clinic Owner</form:option>
                            <form:option value="DOCTOR">Doctor</form:option>
                            <form:option value="STAFF">Staff</form:option>
                            <form:option value="RECEPTIONIST">Receptionist</form:option>
                        </form:select>
                    </div>
                    <div class="form-group" id="clinicGroup">
                        <label for="clinic.id">Assign to Clinic</label>
                        <form:select path="clinic.id" id="clinicId" class="form-control">
                            <form:option value="">-- Select Clinic --</form:option>
                            <c:forEach items="${clinics}" var="clinic">
                                <form:option value="${clinic.id}">${clinic.clinicName}</form:option>
                            </c:forEach>
                        </form:select>
                    </div>
                </div>
                
                <!-- Doctor specific fields -->
                <div id="doctorFields" style="display: none;">
                    <h3 class="section-title"><i class="fas fa-user-md"></i> Doctor Information</h3>
                    <div class="form-group">
                        <label for="specialization" class="required">Specialization</label>
                        <form:select path="specialization" id="specialization" class="form-control">
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
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="licenseNumber">License Number</label>
                            <form:input path="licenseNumber" id="licenseNumber" class="form-control" placeholder="Enter license number" />
                        </div>
                        <div class="form-group">
                            <label for="licenseExpiryDate">License Expiry Date</label>
                            <form:input path="licenseExpiryDate" id="licenseExpiryDate" type="date" class="form-control" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="bio">Professional Biography</label>
                        <form:textarea path="bio" id="bio" class="form-control" rows="4" placeholder="Enter professional background and expertise" />
                    </div>
                </div>
                
                <!-- Professional Details for all healthcare staff -->
                <div id="professionalDetails" style="display: none;">
                    <h3 class="section-title"><i class="fas fa-id-badge"></i> Professional Details</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="qualification">Qualification</label>
                            <form:input path="qualification" id="qualification" class="form-control" placeholder="e.g., BDS, MDS, PhD" />
                        </div>
                        <div class="form-group">
                            <label for="designation">Designation/Position</label>
                            <form:input path="designation" id="designation" class="form-control" placeholder="e.g., Senior Dentist" />
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="joiningDate">Joining Date</label>
                            <form:input path="joiningDate" id="joiningDate" type="date" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="emergencyContact">Emergency Contact</label>
                            <form:input path="emergencyContact" id="emergencyContact" class="form-control" placeholder="Emergency contact number" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <form:input path="address" id="address" class="form-control" placeholder="Enter address" />
                    </div>
                    
                    <div class="form-group">
                        <label for="isActive">Status</label>
                        <div class="form-control" style="display: flex; align-items: center;">
                            <form:checkbox path="isActive" id="isActive" style="margin-right: 10px;" checked="checked" />
                            <label for="isActive" style="margin: 0;">Active</label>
                        </div>
                    </div>
                </div>
                
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn" style="background-color: #95a5a6;">Cancel</a>
                    <button type="submit" class="btn">Create User</button>
                </div>
            </form:form>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
</body>
</html> 