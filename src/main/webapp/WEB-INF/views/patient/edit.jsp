<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Patient - PeriDesk</title>
    <!-- Bootstrap 5 CSS for modal and layout -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Add jQuery for easier DOM manipulation -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f8fafc;
            color: #1e293b;
            line-height: 1.6;
        }
        
        .welcome-container {
            display: flex;
            min-height: 100vh;
            flex-direction: row;
            background: #f8fafc;
        }
        
        .main-content {
            flex: 1;
            padding: 40px;
            position: relative;
            overflow-x: auto;
        }
        
        .welcome-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
        }
        
        .welcome-message {
            font-size: 1.5rem;
            color: #2c3e50;
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
        
        .form-group.w-33 {
            flex: 0 0 calc(33.333% - 14px);
        }
        
        .form-group.w-50 {
            flex: 0 0 calc(50% - 10px);
        }
        
        .form-group.w-100 {
            flex: 0 0 100%;
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
            box-sizing: border-box;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-tip {
            font-size: 0.8rem;
            color: #7f8c8d;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }
        
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
        
        /* Read-only field styling */
        .read-only-field {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            color: #495057;
            min-height: 45px;
            display: flex;
            align-items: center;
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .welcome-container {
                flex-direction: column;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .form-group.w-33,
            .form-group.w-50 {
                flex: 0 0 100%;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .welcome-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Edit Patient</h1>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-secondary"><i class="fas fa-power-off"></i> Logout</button>
                </form>
            </div>

            <div class="form-container">
                <div class="logo">
                    <h1>Patient Information</h1>
                    <p>Update patient details and information</p>
                </div>
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success-message">${success}</div>
                </c:if>
                
                <form:form action="${pageContext.request.contextPath}/patients/update" method="post" modelAttribute="patient" enctype="multipart/form-data">
                    <form:hidden path="id" />
                    
                    <div class="form-section">
                        <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                        
                        <!-- Profile picture section -->
                        <div class="form-row">
                            <div class="form-group w-100">
                                <label for="profilePicture">Profile Picture</label>
                                <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 10px;">
                                    <!-- Profile picture container -->
                                    <div style="width: 120px; height: 120px; border-radius: 50%; overflow: hidden; border: 2px solid #e0e0e0; display: flex; align-items: center; justify-content: center; background-color: #f9f9f9;">
                                        <c:choose>
                                            <c:when test="${not empty patient.profilePicturePath}">
                                                <!-- Make the image itself clickable -->
                                                <img id="profileImg" 
                                                     src="${pageContext.request.contextPath}/uploads/${patient.profilePicturePath}" 
                                                     alt="Profile Picture" 
                                                     style="width: 100%; height: 100%; object-fit: cover; cursor: pointer; position: relative; z-index: 10;"
                                                     onclick="document.getElementById('profileModal').style.display='block'; document.getElementById('modalProfileImg').src=this.src;"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-profile.png';">
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-user-circle" style="font-size: 3rem; color: #c0c0c0;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <input type="file" name="profilePicture" id="profilePicture" accept="image/*" style="display: none;">
                                        <label for="profilePicture" class="btn btn-secondary" style="cursor: pointer;">
                                            <i class="fas fa-upload"></i> ${not empty patient.profilePicturePath ? 'Change Picture' : 'Upload Picture'}
                                        </label>
                                        <button type="button" id="webcamBtn" class="btn btn-info btn-webcam" style="margin-left: 10px;"
                                            onclick="openWebcamModal({ fileInputId: 'profilePicture', previewSelector: '.profile-preview' })">
                                            <i class="fas fa-camera"></i> Use Camera
                                        </button>
                                        <c:if test="${not empty patient.profilePicturePath}">
                                            <button type="button" id="removeProfilePicture" class="btn btn-danger" style="margin-left: 10px;">
                                                <i class="fas fa-trash"></i> Remove
                                            </button>
                                            <input type="hidden" name="removeProfilePicture" id="removeProfilePictureFlag" value="false">
                                        </c:if>
                                        <div class="form-tip" style="margin-top: 5px;">
                                            <i class="fas fa-info-circle"></i> Maximum size: 2MB. Recommended: square image (1:1 ratio)
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
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
                                <div class="read-only-field">
                                    <c:choose>
                                        <c:when test="${not empty patient.gender}">
                                            ${patient.gender}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999; font-style: italic;">Not specified</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <!-- Hidden field to ensure gender is submitted with form -->
                                <form:hidden path="gender" />
                            </div>
                            <div class="form-group w-33">
                                <label for="occupation">Occupation</label>
                                <form:select path="occupation" id="occupation" class="form-control">
                                    <form:option value="">Select Occupation</form:option>
                                    <form:options items="${occupations}" itemLabel="displayName" itemValue="name"/>
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
                                    <c:forEach items="${indianStates}" var="state">
                                        <form:option value="${state.displayName}" label="${state.displayName}" />
                                    </c:forEach>
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
                        
                        <div class="form-row">
                            <div class="form-group w-50">
                                <label for="referralModel">Referral Source</label>
                                <form:select path="referralModel" id="referralModel" class="form-control">
                                    <form:option value="">Select Referral Source</form:option>
                                    <form:options items="${referralModels}" itemLabel="displayName" itemValue="name"/>
                                </form:select>
                            </div>
                            <div class="form-group w-50">
                                <label for="colorCode">Patient Code</label>
                                <form:select path="colorCode" id="colorCode" class="form-control">
                                    <form:option value="">Select a code</form:option>
                                    <form:options items="${patientColorCodes}" itemLabel="displayName" itemValue="name"/>
                                </form:select>
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
    
    <!-- Webcam modal should be outside main content for best compatibility -->
    <jsp:include page="/WEB-INF/views/common/webcamModal.jsp" />
    
<script>
        // Load cities function
        function loadCities(restoreCity = false) {
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
                    
                    // Only restore city if explicitly requested (on page load)
                    if (restoreCity) {
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
            
            // Log the patient data for debugging
            console.log("Patient city:", "${patient.city}");
            console.log("Patient state:", "${patient.state}");
            
            // Set the state value if patient has a state
            const patientState = "${patient.state}";
            if (patientState && patientState !== "") {
                stateSelect.value = patientState;
                console.log("Set state to:", patientState);
                // Load cities after setting state and restore the current city
                loadCities(true);
            }
            
            // Add state change event listener
            stateSelect.addEventListener('change', function() {
                // Don't restore city when state changes - reset to empty
                loadCities(false);
            });
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(event) {
                const stateSelect = document.getElementById('state');
                const citySelect = document.getElementById('city');
                
                console.log('=== FORM SUBMISSION DEBUG ===');
                console.log('State value:', stateSelect.value);
                console.log('City value:', citySelect.value);
                console.log('City options length:', citySelect.options.length);
                console.log('City options:', Array.from(citySelect.options).map(opt => opt.value));
                
                // Only validate city if state is selected and city dropdown has options
                if (stateSelect.value && citySelect.options.length > 1 && !citySelect.value) {
                    console.log('BLOCKING: City validation failed');
                    event.preventDefault();
                    alert('Please select a city');
                    citySelect.focus();
                    return;
                }
                
                // Validate profile picture if one is selected
                const profilePicture = document.getElementById('profilePicture');
                if (profilePicture.files.length > 0) {
                    const file = profilePicture.files[0];
                    
                    console.log('Profile picture file size:', file.size);
                    console.log('Profile picture file type:', file.type);
                    
                    // Check file size (max 2MB)
                    if (file.size > 2 * 1024 * 1024) {
                        console.log('BLOCKING: File size too large');
                        event.preventDefault();
                        alert('Error: Profile picture size exceeds 2MB limit');
                        return;
                    }
                    
                    // Check file type
                    if (!file.type.startsWith('image/')) {
                        console.log('BLOCKING: Invalid file type');
                        event.preventDefault();
                        alert('Error: Only image files are allowed for profile picture');
                        return;
                    }
                }
                
                console.log('FORM SUBMISSION ALLOWED - No validation errors');
            });
            
            // Profile picture preview functionality
            const profilePictureInput = document.getElementById('profilePicture');
            if (profilePictureInput) {
                profilePictureInput.addEventListener('change', function() {
                    if (this.files && this.files[0]) {
                        const reader = new FileReader();
                        
                        reader.onload = function(e) {
                            // Find the image or create one if it doesn't exist
                            let imgPreview = document.querySelector('.form-group div div img');
                            if (!imgPreview) {
                                const previewContainer = document.querySelector('.form-group div div');
                                // Remove the icon if it exists
                                const icon = previewContainer.querySelector('i');
                                if (icon) {
                                    previewContainer.removeChild(icon);
                                }
                                
                                // Create and add the image
                                imgPreview = document.createElement('img');
                                imgPreview.style.width = '100%';
                                imgPreview.style.height = '100%';
                                imgPreview.style.objectFit = 'cover';
                                previewContainer.appendChild(imgPreview);
                            }
                            
                            // Update the image source
                            imgPreview.src = e.target.result;
                        };
                        
                        reader.readAsDataURL(this.files[0]);
                    }
                });
            }
            
            // Handle remove profile picture button
            const removeButton = document.getElementById('removeProfilePicture');
            if (removeButton) {
                removeButton.addEventListener('click', function() {
                    // Set the flag to remove the profile picture
                    document.getElementById('removeProfilePictureFlag').value = 'true';
                    
                    // Update the UI to show the profile picture has been removed
                    const imgContainer = document.querySelector('.form-group div div');
                    imgContainer.innerHTML = '<i class="fas fa-user-circle" style="font-size: 3rem; color: #c0c0c0;"></i>';
                    
                    // Clear the file input
                    document.getElementById('profilePicture').value = '';
                    
                    // Change the button text
                    const uploadLabel = document.querySelector('label[for="profilePicture"]');
                    uploadLabel.innerHTML = '<i class="fas fa-upload"></i> Upload Picture';
                    
                    // Hide the remove button
                    this.style.display = 'none';
                });
            }
        });
</script>

<!-- Profile Picture Modal -->
<div id="profileModal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.7);">
    <div style="margin: 10% auto; padding: 20px; max-width: 700px; position: relative;">
        <span onclick="closeProfileModal()" style="position: absolute; top: 10px; right: 25px; color: white; font-size: 35px; font-weight: bold; cursor: pointer;">&times;</span>
        <img id="modalProfileImg" style="width: 100%; max-height: 80vh; object-fit: contain; display: block; margin: 0 auto; border-radius: 5px;" src="" alt="Profile Picture">
    </div>
</div>

<script>
    // Profile picture modal functions
    function openProfileModal() {
        console.log("Opening profile modal");
        const profileImg = document.getElementById('profileImg');
        console.log("Profile image element:", profileImg);
        
        if (profileImg) {
            const modal = document.getElementById('profileModal');
            const modalImg = document.getElementById('modalProfileImg');
            
            console.log("Setting modal image src to:", profileImg.src);
            modal.style.display = "block";
            modalImg.src = profileImg.src;
        } else {
            console.error("Profile image element not found");
        }
    }
    
    function closeProfileModal() {
        document.getElementById('profileModal').style.display = "none";
    }
    
    // Close modal when clicking outside the image
    window.onclick = function(event) {
        const modal = document.getElementById('profileModal');
        if (event.target == modal) {
            closeProfileModal();
        }
    }
</script>

    <script src="${pageContext.request.contextPath}/js/webcam.js"></script>
</body>
</html>