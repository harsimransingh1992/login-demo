<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Visits - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    
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
        
        .welcome-message span {
            color: #3498db;
            font-weight: 600;
        }
        
        .btn-secondary {
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
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .btn-secondary i {
            font-size: 0.9rem;
        }
        
        .table-responsive {
            overflow-x: auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }
        
        .table thead {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .table th {
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 0.95rem;
            white-space: nowrap;
        }
        
        .table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover {
            background-color: #f9f9f9;
        }
        
        .status-badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-checked-in {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-checked-out {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .status-neutral {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .no-results {
            text-align: center;
            color: #7f8c8d;
            padding: 25px !important;
        }
        
        h1 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 20px;
        }
        
        .text-muted {
            color: #6c757d;
            font-style: italic;
        }
        
        /* Filter styles */
        .filter-container {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 20px;
        }
        
        .filter-form {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .form-group label {
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .form-control {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.9rem;
            color: #2c3e50;
            min-width: 150px;
        }
        
        .btn-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 0.9rem;
            text-decoration: none;
            text-align: center;
            border: none;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .btn-clear {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
        }
        
        .btn-clear:hover {
            background: linear-gradient(135deg, #7f8c8d, #6c7b7d);
        }
        
        .form-check {
            display: flex;
            align-items: center;
            margin: 0;
        }
        
        .form-check-input {
            width: 18px;
            height: 18px;
            margin-right: 8px;
            cursor: pointer;
        }
        
        .form-check-label {
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.9rem;
            cursor: pointer;
            margin: 0;
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
        
        @media (max-width: 768px) {
            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }
            
            .form-control {
                min-width: auto;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .welcome-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .pagination-container {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            
            .pagination-controls {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Patient Visit History</h1>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-secondary"><i class="fas fa-sign-out-alt"></i> Logout</button>
                </form>
            </div>

            <!-- Filter Section -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/visits" method="get" class="filter-form">
                    <div class="form-group">
                        <label for="patientRegistrationCode">Patient Registration Code:</label>
                        <input type="text" id="patientRegistrationCode" name="patientRegistrationCode" 
                               class="form-control" value="${param.patientRegistrationCode}" 
                               placeholder="Enter registration code">
                    </div>
                    <div class="form-group">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" 
                               class="form-control" value="${param.startDate}"
                               max="${java.time.LocalDate.now()}">
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" 
                               class="form-control" value="${param.endDate}"
                               max="${java.time.LocalDate.now()}">
                    </div>
                    <div class="form-group">
                        <div class="form-check" style="margin-top: 25px;">
                            <input type="checkbox" id="searchWithinClinic" name="searchWithinClinic" 
                                   class="form-check-input" value="true" 
                                   ${param.searchWithinClinic == 'true' ? 'checked' : ''}>
                            <label class="form-check-label" for="searchWithinClinic" style="margin-left: 5px;">
                                Search Within This Clinic
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-search"></i> Filter
                        </button>
                    </div>
                    <div class="form-group">
                        <a href="${pageContext.request.contextPath}/visits" class="btn-primary btn-clear">
                            <i class="fas fa-times"></i> Clear
                        </a>
                    </div>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Visit Date</th>
                            <th>Patient Registration Code</th>
                            <th>Patient Name</th>
                            <th>Clinic Name</th>
                            <th>Check-in Time</th>
                            <th>Check-out Time</th>
                            <th>Time Spent</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty visits}">
                                <c:forEach var="record" items="${visits}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.checkInTime}">
                                                    <fmt:parseDate value="${record.checkInTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCheckInDate" type="both"/>
                                                    <fmt:formatDate value="${parsedCheckInDate}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.patient and not empty record.patient.registrationCode}">
                                                    <a href="${pageContext.request.contextPath}/patients/details/${record.patient.id}" 
                                                       class="text-primary text-decoration-none" 
                                                       style="font-weight: 500;">
                                                        ${record.patient.registrationCode}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.patient}">
                                                    ${record.patient.firstName} ${record.patient.lastName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.clinic}">
                                                    ${record.clinic.clinicId} (${record.clinic.clinicName})
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.checkInTime}">
                                                    <fmt:parseDate value="${record.checkInTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCheckInTime" type="both"/>
                                                    <fmt:formatDate value="${parsedCheckInTime}" pattern="hh:mm:ss a"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.checkOutTime}">
                                                    <fmt:parseDate value="${record.checkOutTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCheckOutTime" type="both"/>
                                                    <fmt:formatDate value="${parsedCheckOutTime}" pattern="hh:mm:ss a"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty record.checkInTime and not empty record.checkOutTime}">
                                                    <fmt:parseDate value="${record.checkInTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCheckInForDuration" type="both"/>
                                                    <fmt:parseDate value="${record.checkOutTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCheckOutForDuration" type="both"/>
                                                    <c:set var="durationInMillis" value="${parsedCheckOutForDuration.time - parsedCheckInForDuration.time}"/>
                                                    <c:set var="durationInHours" value="${durationInMillis / (1000 * 60 * 60)}"/>
                                                    <c:set var="hours" value="${Math.floor(durationInHours)}"/>
                                                    <c:set var="minutes" value="${Math.floor((durationInHours - hours) * 60)}"/>
                                                    <c:choose>
                                                        <c:when test="${hours > 0}">
                                                            ${hours}h ${minutes}m
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${minutes}m
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="no-results">
                                        <c:choose>
                                            <c:when test="${not empty param.patientRegistrationCode or not empty param.startDate or not empty param.endDate}">
                                                No visits found for the specified criteria.
                                            </c:when>
                                            <c:otherwise>
                                                No patient visits recorded yet.
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination Controls -->
            <c:if test="${totalPages > 1 or not empty visits}">
                <div class="pagination-container">
                    <div class="pagination-info">
                        Showing ${(currentPage * pageSize) + 1} to ${(currentPage * pageSize) + fn:length(visits)} of ${totalItems} visits
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
                                <option value="checkInTime" ${sort == 'checkInTime' ? 'selected' : ''}>Check-in Time</option>
                                <option value="checkOutTime" ${sort == 'checkOutTime' ? 'selected' : ''}>Check-out Time</option>
                                <option value="patientRegistrationCode" ${sort == 'patientRegistrationCode' ? 'selected' : ''}>Patient Registration</option>
                                <option value="clinicName" ${sort == 'clinicName' ? 'selected' : ''}>Clinic Name</option>
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