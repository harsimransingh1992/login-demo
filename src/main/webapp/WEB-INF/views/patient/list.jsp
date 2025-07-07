<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Patient List - PeriDesk</title>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
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
        
        .main-content {
            flex: 1;
            padding: 40px;
            position: relative;
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

    .search-container {
        margin: 20px 0;
        padding: 15px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .search-form {
        display: flex;
        gap: 10px;
        align-items: stretch;
    }

    .search-select {
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 6px;
        background-color: #fff;
        font-size: 14px;
        color: #333;
        min-width: 220px;
        cursor: pointer;
        transition: border-color 0.3s ease;
        height: 42px;
        box-sizing: border-box;
    }

    .search-select:hover {
        border-color: #007bff;
    }

    .search-select:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
    }

    .search-input {
        flex: 1;
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        transition: border-color 0.3s ease;
        min-width: 400px;
        height: 42px;
        box-sizing: border-box;
    }

    .search-input:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
    }

    .search-button {
        padding: 6px 10px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 11px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 3px;
        transition: background-color 0.3s ease;
        white-space: nowrap;
        min-width: 70px;
        height: 42px;
        box-sizing: border-box;
    }

    .search-button:hover {
        background-color: #0056b3;
    }

    .search-button i {
        font-size: 11px;
    }
    
    /* Pagination styles */
    .pagination-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
        padding: 15px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .pagination-info {
        color: #666;
        font-size: 14px;
    }
    
    .pagination-controls {
        display: flex;
        gap: 10px;
        align-items: center;
    }
    
    .pagination-button {
        padding: 8px 12px;
        border: 1px solid #ddd;
        background: white;
        color: #333;
        text-decoration: none;
        border-radius: 4px;
        font-size: 14px;
        transition: all 0.3s ease;
        cursor: pointer;
    }
    
    .pagination-button:hover {
        background: #f8f9fa;
        border-color: #007bff;
        color: #007bff;
    }
    
    .pagination-button:disabled {
        background: #f8f9fa;
        color: #6c757d;
        cursor: not-allowed;
        border-color: #dee2e6;
    }
    
    .pagination-button.active {
        background: #007bff;
        color: white;
        border-color: #007bff;
    }
    
    .page-size-selector {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .page-size-selector select {
        padding: 6px 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
    }
    
    .sort-controls {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .sort-controls select {
        padding: 6px 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
    }
    
    .audit-info {
        font-size: 0.85rem;
        color: #495057;
        font-weight: 500;
    }
    
    .text-muted {
        color: #6c757d;
        font-style: italic;
    }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Patient Records</h1>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-secondary"><i class="fas fa-sign-out-alt"></i> Logout</button>
                </form>
            </div>
            
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/patients/search" method="get" class="search-form">
                    <select name="searchType" class="search-select" required>
                        <option value="name">Search by Name</option>
                        <option value="phone">Search by Phone</option>
                        <option value="registration">Search by Registration Code</option>
                        <option value="examination">Search by Examination ID</option>
                    </select>
                    <input type="text" name="query" class="search-input" placeholder="Enter search term..." required>
                    <button type="submit" class="search-button">
                        <i class="fas fa-search"></i>
                        Search
                    </button>
                </form>
            </div>

            <h1>Patient List</h1>
            <div class="table-responsive">
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
                            <th>Created By</th>
                            <th>Registered At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty patients}">
                            <tr>
                                <td colspan="9" class="no-results">No patients found</td>
                            </tr>
                        </c:if>
                        <c:forEach items="${patients}" var="patient">
                            <tr>
                                <td>${patient.registrationCode}</td>
                                <td><a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="patient-link">${patient.firstName} ${patient.lastName}</a></td>
                                <td><fmt:formatDate value="${patient.dateOfBirth}" pattern="dd/MM/yyyy"/></td>
                                <td>${patient.gender}</td>
                                <td>${patient.phoneNumber}</td>
                                <td>${patient.email}</td>
                                <td><fmt:formatDate value="${patient.registrationDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty patient.createdBy}">
                                            <span class="audit-info">${patient.createdBy}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty patient.registeredClinic}">
                                            <span class="audit-info">${patient.registeredClinic}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
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
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('DOCTOR')">
                                        <span style="color: #6c757d; font-style: italic; font-size: 0.9em;">Disabled for Doctor Role</span>
                                    </sec:authorize>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination Controls -->
            <c:if test="${totalPages > 1 or not empty patients}">
                <div class="pagination-container">
                    <div class="pagination-info">
                        Showing ${(currentPage * pageSize) + 1} to ${(currentPage * pageSize) + fn:length(patients)} of ${totalItems} patients
                    </div>
                    
                    <div class="pagination-controls">
                        <!-- Page Size Selector -->
                        <div class="page-size-selector">
                            <label for="pageSize">Show:</label>
                            <select id="pageSize" onchange="changePageSize(this.value)">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                        
                        <!-- Sort Controls -->
                        <div class="sort-controls">
                            <label for="sort">Sort by:</label>
                            <select id="sort" onchange="changeSort(this.value)">
                                <option value="id" ${sort == 'id' ? 'selected' : ''}>ID</option>
                                <option value="firstName" ${sort == 'firstName' ? 'selected' : ''}>Name</option>
                                <option value="registrationDate" ${sort == 'registrationDate' ? 'selected' : ''}>Registration Date</option>
                                <option value="dateOfBirth" ${sort == 'dateOfBirth' ? 'selected' : ''}>Date of Birth</option>
                            </select>
                            <select id="direction" onchange="changeDirection(this.value)">
                                <option value="desc" ${direction == 'desc' ? 'selected' : ''}>Desc</option>
                                <option value="asc" ${direction == 'asc' ? 'selected' : ''}>Asc</option>
                            </select>
                        </div>
                        
                        <!-- Navigation Buttons -->
                        <c:if test="${currentPage > 0}">
                            <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" class="pagination-button">
                                <i class="fas fa-chevron-left"></i> Previous
                            </a>
                        </c:if>
                        
                        <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == currentPage}">
                                    <span class="pagination-button active">${pageNum + 1}</span>
                                </c:when>
                                <c:when test="${pageNum == 0}">
                                    <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                </c:when>
                                <c:when test="${pageNum == totalPages - 1}">
                                    <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                </c:when>
                                <c:when test="${pageNum >= currentPage - 2 and pageNum <= currentPage + 2}">
                                    <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                </c:when>
                                <c:when test="${pageNum == currentPage - 3}">
                                    <span class="pagination-button">...</span>
                                </c:when>
                                <c:when test="${pageNum == currentPage + 3}">
                                    <span class="pagination-button">...</span>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages - 1}">
                            <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" class="pagination-button">
                                Next <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
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
                    window.location.reload(); // Reload page on successful check-in
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
                    window.location.reload(); // Reload page on successful check-out
                } else {
                    console.error('Error response:', response.status, response.statusText);
                }
            } catch (error) {
                console.error('Request failed:', error);
            }
        }
        
        // Pagination functions
        function goToPage(page) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page);
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
        
        function changePageSize(size) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('pageSize', size);
            urlParams.set('page', '0'); // Reset to first page when changing size
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
        
        function changeSort(sort) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('sort', sort);
            urlParams.set('page', '0'); // Reset to first page when changing sort
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
        
        function changeDirection(direction) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('direction', direction);
            urlParams.set('page', '0'); // Reset to first page when changing direction
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }
    </script>
</body>
</html> 