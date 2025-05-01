<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Patient - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        
        @media (max-width: 992px) {
            .welcome-container {
                flex-direction: column;
            }
            
            .sidebar-menu {
                width: 100%;
                min-height: auto;
                padding: 20px;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .form-group {
                width: 100% !important;
            }
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
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="welcome-header">
                <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button class="btn btn-secondary">
                        <i class="fas fa-sign-out-alt"></i>
                        Logout
                    </button>
                </form>
            </div>

            <div class="form-container">
                <h1>Edit Patient</h1>
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success-message">${success}</div>
                </c:if>
                
                <form:form action="${pageContext.request.contextPath}/patients/update" method="post" modelAttribute="patient">
                    <form:hidden path="id" />
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                        
                        <div class="form-row">
                            <div class="form-group w-50">
                                <label for="firstName">First Name <span class="required">*</span></label>
                                <form:input path="firstName" id="firstName" required="true" />
                            </div>
                            <div class="form-group w-50">
                                <label for="lastName">Last Name <span class="required">*</span></label>
                                <form:input path="lastName" id="lastName" required="true" />
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group w-33">
                                <label for="dateOfBirth">Date of Birth <span class="required">*</span></label>
                                <form:input path="dateOfBirth" type="date" id="dateOfBirth" required="true" />
                            </div>
                            <div class="form-group w-33">
                                <label for="gender">Gender <span class="required">*</span></label>
                                <form:select path="gender" id="gender" required="true">
                                    <form:option value="" label="-- Select Gender --" />
                                    <form:option value="Male" label="Male" />
                                    <form:option value="Female" label="Female" />
                                    <form:option value="Other" label="Other" />
                                </form:select>
                            </div>
                            <div class="form-group w-33">
                                <label for="occupation">Occupation</label>
                                <form:select path="occupation" id="occupation">
                                    <form:option value="" label="-- Select Occupation --" />
                                    <form:options items="${occupations}" itemValue="name" itemLabel="displayName" />
                                </form:select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-phone-alt"></i> Contact Information</h3>
                        
                        <div class="form-row">
                            <div class="form-group w-50">
                                <label for="phoneNumber">Phone Number <span class="required">*</span></label>
                                <form:input path="phoneNumber" id="phoneNumber" required="true" />
                            </div>
                            <div class="form-group w-50">
                                <label for="email">Email</label>
                                <form:input path="email" type="email" id="email" />
                        </div>
                    </div>
                    
                        <div class="form-row">
                            <div class="form-group w-100">
                            <label for="streetAddress">Street Address <span class="required">*</span></label>
                                <form:input path="streetAddress" id="streetAddress" required="true" />
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group w-33">
                                <label for="state">State <span class="required">*</span></label>
                                <form:select path="state" id="state" required="true" onchange="loadCities()">
                                    <form:option value="" label="-- Select State --" />
                                    <form:options items="${indianStates}" itemValue="name" itemLabel="name" />
                                </form:select>
                            </div>
                            <div class="form-group w-33">
                                <label for="city">City <span class="required">*</span></label>
                                <form:select path="city" id="city" required="true">
                                    <form:option value="" label="-- Select City --" />
                                    <!-- Cities will be loaded dynamically -->
                                </form:select>
                            </div>
                            <div class="form-group w-33">
                                <label for="pincode">Pincode <span class="required">*</span></label>
                                <form:input path="pincode" id="pincode" required="true" maxlength="6" />
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-notes-medical"></i> Medical Information</h3>
                        
                        <div class="form-row">
                            <div class="form-group w-100">
                            <label for="medicalHistory">Medical History</label>
                                <form:textarea path="medicalHistory" id="medicalHistory" rows="4" />
                        </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-phone-alt"></i> Emergency Contact</h3>
                        
                        <div class="form-row">
                            <div class="form-group w-50">
                                <label for="emergencyContactName">Emergency Contact Name</label>
                                <form:input path="emergencyContactName" id="emergencyContactName" />
                            </div>
                            <div class="form-group w-50">
                                <label for="emergencyContactPhoneNumber">Emergency Contact Phone</label>
                                <form:input path="emergencyContactPhoneNumber" id="emergencyContactPhoneNumber" />
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
    
<script>
        // Load cities function
        function loadCities() {
            const stateSelect = document.getElementById('state');
            const citySelect = document.getElementById('city');
            const selectedState = stateSelect.value;
            
            // Clear current cities
            citySelect.innerHTML = '<option value="">-- Select City --</option>';
            
            if (!selectedState) {
                return;
            }
            
            console.log("Loading cities for state:", selectedState);
            citySelect.innerHTML = '<option value="">Loading cities...</option>';
            
            // Fetch cities for the selected state
            fetch('${pageContext.request.contextPath}/api/cities?state=' + encodeURIComponent(selectedState))
                .then(response => response.json())
                .then(cities => {
                    console.log("API Response:", cities);
                    
                    // Clear the loading option
                    citySelect.innerHTML = '<option value="">-- Select City --</option>';
                    
                    cities.forEach(city => {
                        const option = document.createElement('option');
                        // The API returns objects with displayName property
                        option.value = city.displayName;
                        option.textContent = city.displayName;
                        citySelect.appendChild(option);
                    });
                    
                    // If editing and city is already set, select it
                    const currentCity = "${patient.city}";
                    console.log("Current city to select:", currentCity);
                    if (currentCity) {
                        let cityFound = false;
                        for (let i = 0; i < citySelect.options.length; i++) {
                            if (citySelect.options[i].value === currentCity) {
                                citySelect.selectedIndex = i;
                                cityFound = true;
                                console.log("City matched at index:", i);
                                break;
                            }
                        }
                        
                        if (!cityFound) {
                            console.log("Current city not found in options - adding it manually");
                            const option = document.createElement('option');
                            option.value = currentCity;
                            option.textContent = currentCity;
                            citySelect.appendChild(option);
                            citySelect.value = currentCity;
                        }
                    }
                })
                .catch(error => {
                    console.error('Error loading cities:', error);
                    citySelect.innerHTML = '<option value="">Error loading cities</option>';
                });
        }
        
        // When the page loads, if state is already selected, load the cities
        document.addEventListener('DOMContentLoaded', function() {
            const stateSelect = document.getElementById('state');
            console.log("DOM loaded - state value:", stateSelect.value);
            if (stateSelect.value) {
                loadCities();
            }
            
            // Log the patient data for debugging
            console.log("Patient city:", "${patient.city}");
            console.log("Patient state:", "${patient.state}");
            
            // Add state change event listener
            stateSelect.addEventListener('change', function() {
                loadCities();
            });
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(event) {
                const stateSelect = document.getElementById('state');
                const citySelect = document.getElementById('city');
                
                if (stateSelect.value && !citySelect.value) {
                    event.preventDefault();
                    alert('Please select a city');
                    citySelect.focus();
                }
        });
    });
</script>
</body>
</html> 