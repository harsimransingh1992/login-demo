<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Search by Registration ID - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        .search-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            padding: 12px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
        }
        
        .search-button {
            padding: 12px 24px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .search-button:hover {
            background: #45a049;
        }
        
        .result-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .no-results {
            text-align: center;
            padding: 20px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Search by Registration ID</h1>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-secondary"><i class="fas fa-power-off"></i> Logout</button>
                </form>
            </div>
            
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/patients/search/registration" method="get" class="search-form">
                    <input type="text" name="registrationCode" class="search-input" 
                           placeholder="Enter SDC registration code (e.g., SDC2024031)" 
                           pattern="SDC\d{6,}" 
                           title="Please enter a valid SDC code (e.g., SDC2024031)"
                           required>
                    <button type="submit" class="search-button">
                        <i class="fas fa-search"></i>
                        Search
                    </button>
                </form>
            </div>

            <div class="result-container">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <c:if test="${not empty patient}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Registration Code</th>
                                <th>Name</th>
                                <th>Date of Birth</th>
                                <th>Gender</th>
                                <th>Phone</th>
                                <th>Email</th>
                                <th>Registration Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>${patient.registrationCode}</td>
                                <td><a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="patient-link">${patient.firstName} ${patient.lastName}</a></td>
                                <td><fmt:formatDate value="${patient.dateOfBirth}" pattern="dd/MM/yyyy"/></td>
                                <td>${patient.gender}</td>
                                <td>${patient.phoneNumber}</td>
                                <td>${patient.email}</td>
                                <td><fmt:formatDate value="${patient.registrationDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <div class="action-buttons">
                                        <button onclick="editPatient('${patient.id}')" class="btn-edit"><i class="fas fa-edit"></i> Edit</button>
                                        <c:choose>
                                            <c:when test="${!patient.checkedIn}">
                                                <button onclick="checkIn('${patient.id}')" class="btn-primary"><i class="fas fa-user-check"></i> Check In</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button onclick="uncheck('${patient.id}')" class="btn-danger"><i class="fas fa-user-times"></i> Check Out</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </c:if>
                
                <c:if test="${empty patient && not empty registrationCode}">
                    <div class="no-results">
                        <i class="fas fa-search fa-3x"></i>
                        <h3>No patient found with registration code: ${registrationCode}</h3>
                        <p>Please check the code and try again.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function editPatient(patientId) {
            window.location.href = "${pageContext.request.contextPath}/patients/edit/" + patientId;
        }
        
        async function checkIn(patientId) {
            try {
                const url = "${pageContext.request.contextPath}/patients/checkin/" + patientId;
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    },
                    credentials: 'same-origin'
                });

                if (response.ok) {
                    window.location.reload();
                } else {
                    console.error('Error response:', response.status, response.statusText);
                }
            } catch (error) {
                console.error('Request failed:', error);
            }
        }

        async function uncheck(patientId) {
            try {
                const url = "${pageContext.request.contextPath}/patients/uncheck/" + patientId;
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    },
                    credentials: 'same-origin'
                });

                if (response.ok) {
                    window.location.reload();
                } else {
                    console.error('Error response:', response.status, response.statusText);
                }
            } catch (error) {
                console.error('Request failed:', error);
            }
        }
    </script>
</body>
</html> 