<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Appointment Follow-up - PeriDesk</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .welcome-container {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
            background: #f8f9fa;
        }
        
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .page-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .page-subtitle {
            color: #7f8c8d;
            margin: 0;
        }
        
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-group label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .form-control {
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #27ae60, #229954);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .btn-secondary:disabled {
            background: #6c757d;
            color: white;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.8rem;
        }
        
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.2rem;
            color: white;
        }
        
        .stat-card.no-show .stat-icon {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }
        
        .stat-card.cancelled .stat-icon {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }
        
        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #7f8c8d;
            font-weight: 500;
        }
        
        .appointments-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f1f3f4;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .appointments-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .appointments-table th,
        .appointments-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }
        
        .appointments-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .appointments-table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-no-show {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-cancelled {
            background: #fff3cd;
            color: #856404;
        }
        
        .notes-cell {
            max-width: 300px;
            word-wrap: break-word;
        }
        
        .notes-text {
            font-size: 0.9rem;
            color: #2c3e50;
            line-height: 1.4;
            white-space: pre-line;
        }
        
        .notes-input {
            width: 100%;
            min-height: 80px;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 0.9rem;
            font-family: inherit;
            resize: vertical;
        }
        
        .notes-input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-direction: column;
        }
        
        .no-appointments {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .no-appointments i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #bdc3c7;
        }
        
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding: 10px 0;
            border-top: 1px solid #e9ecef;
        }
        
        .pagination-info {
            font-size: 0.9rem;
            color: #555;
        }
        
        .pagination-controls {
            display: flex;
            gap: 10px;
        }
        
        .pagination-button {
            padding: 8px 12px;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            background-color: #f8f9fa;
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .pagination-button:hover {
            background-color: #e9ecef;
            color: #2980b9;
        }
        
        .pagination-button.active {
            background-color: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .page-size-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .page-size-selector label {
            font-size: 0.9rem;
            color: #555;
        }
        
        .page-size-selector select {
            padding: 8px 12px;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            background-color: #f8f9fa;
            color: #3498db;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .page-size-selector select:hover {
            background-color: #e9ecef;
            color: #2980b9;
        }
        
        @media (max-width: 768px) {
            .filter-form {
                grid-template-columns: 1fr;
            }
            
            .stats-section {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .appointments-table {
                font-size: 0.9rem;
            }
            
            .appointments-table th,
            .appointments-table td {
                padding: 10px 8px;
            }
            
            .notes-cell {
                max-width: 200px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-search"></i>
                    Appointment Follow-up
                </h1>
                <p class="page-subtitle">Track no-show and cancelled appointments</p>
            </div>
            
            <div class="filter-section">
                <form class="filter-form" id="filterForm" method="get" action="${pageContext.request.contextPath}/receptionist/appointments/tracking">
                    <div class="form-group">
                        <label for="startDate">Start Date</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" value="${startDate}" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" value="${endDate}" required>
                    </div>
                    <div class="form-group">
                        <label for="statusFilter">Status</label>
                        <select id="statusFilter" name="statusFilter" class="form-control">
                            <option value="">All Statuses</option>
                            <c:forEach var="status" items="${appointmentStatuses}">
                                <option value="${status}"<c:if test="${statusFilter == status.toString()}"> selected="selected"</c:if>>${status.displayName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                            Search
                        </button>
                    </div>
                </form>
            </div>
            
            <div class="stats-section" id="statsSection" style="display: none;">
                <div class="stat-card no-show">
                    <div class="stat-icon">
                        <i class="fas fa-user-times"></i>
                    </div>
                    <div class="stat-number" id="noShowCount">0</div>
                    <div class="stat-label">No Shows</div>
                </div>
                <div class="stat-card cancelled">
                    <div class="stat-icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-number" id="cancelledCount">0</div>
                    <div class="stat-label">Cancelled</div>
                </div>
            </div>
            
            <div class="appointments-section" id="appointmentsSection">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-list"></i>
                        Appointments for Follow-up
                    </h2>
                </div>
                <table class="appointments-table" id="appointmentsTable">
                    <thead>
                        <tr>
                            <th>Patient Name</th>
                            <th>Phone Number</th>
                            <th>Appointment Date</th>
                            <th>Status</th>
                            <th>Notes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="appointmentsTableBody">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appointment" items="${appointments}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty appointment.patient}">
                                                    ${appointment.patient.firstName} ${appointment.patient.lastName}
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${appointment.patientName != null ? appointment.patientName : 'Walk-in Patient'}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty appointment.patient}">
                                                    ${appointment.patient.phoneNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${appointment.patientMobile != null ? appointment.patientMobile : 'N/A'}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            ${appointment.appointmentDateTimeStr}
                                        </td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                                ${appointment.status}
                                            </span>
                                        </td>
                                        <td class="notes-cell">
                                            <c:choose>
                                                <c:when test="${not empty appointment.notes}">
                                                    <div class="notes-text">${appointment.notes}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <em style="color: #7f8c8d;">No notes</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="action-buttons">
                                            <c:set var="isCompleted" value="${appointment.status == 'COMPLETED'}"/>
                                            <c:set var="hasNotes" value="${not empty appointment.notes}"/>
                                            <c:set var="shouldDisable" value="${isCompleted or hasNotes}"/>
                                            <button class="btn ${shouldDisable ? 'btn-secondary' : 'btn-success'} btn-sm" title="${isCompleted ? 'Cannot add notes to completed appointments' : (hasNotes ? 'Notes already added - cannot edit further' : 'Add follow-up notes')}" ${shouldDisable ? 'disabled' : ''} onclick="showNotesInput(${appointment.id})">
                                                <i class="fas fa-edit"></i> Add Notes
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="no-appointments">
                                        <i class="fas fa-calendar-times"></i>
                                        <p>No appointments found for the selected criteria.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <c:if test="${totalPages > 1 or not empty appointments}">
                <div class="pagination-container">
                    <div class="pagination-info">
                        Showing ${(currentPage * pageSize) + 1} to ${(currentPage * pageSize) + fn:length(appointments)} of ${totalItems} appointments
                    </div>
                    <div class="pagination-controls">
                        <div class="page-size-selector">
                            <label for="pageSize">Show:</label>
                            <select id="pageSize" onchange="changePageSize(this.value)">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                        <c:if test="${currentPage > 0}">
                            <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking?startDate=${startDate}&endDate=${endDate}&statusFilter=${statusFilter}&page=${currentPage - 1}&pageSize=${pageSize}&sort=${sort}&direction=${direction}" class="pagination-button">
                                <i class="fas fa-chevron-left"></i> Previous
                            </a>
                        </c:if>
                        <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == currentPage}">
                                    <span class="pagination-button active">${pageNum + 1}</span>
                                </c:when>
                                <c:when test="${pageNum == 0}">
                                    <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking?startDate=${startDate}&endDate=${endDate}&statusFilter=${statusFilter}&page=${pageNum}&pageSize=${pageSize}&sort=${sort}&direction=${direction}" class="pagination-button">${pageNum + 1}</a>
                                </c:when>
                                <c:when test="${pageNum == totalPages - 1}">
                                    <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking?startDate=${startDate}&endDate=${endDate}&statusFilter=${statusFilter}&page=${pageNum}&pageSize=${pageSize}&sort=${sort}&direction=${direction}" class="pagination-button">${pageNum + 1}</a>
                                </c:when>
                                <c:when test="${pageNum >= currentPage - 2 and pageNum <= currentPage + 2}">
                                    <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking?startDate=${startDate}&endDate=${endDate}&statusFilter=${statusFilter}&page=${pageNum}&pageSize=${pageSize}&sort=${sort}&direction=${direction}" class="pagination-button">${pageNum + 1}</a>
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
                            <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking?startDate=${startDate}&endDate=${endDate}&statusFilter=${statusFilter}&page=${currentPage + 1}&pageSize=${pageSize}&sort=${sort}&direction=${direction}" class="pagination-button">
                                Next <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                    <!-- Optionally add sort controls here if needed -->
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Set default dates (last 30 days)
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const thirtyDaysAgo = new Date();
            thirtyDaysAgo.setDate(today.getDate() - 30);
            document.getElementById('endDate').value = today.toISOString().split('T')[0];
            document.getElementById('startDate').value = thirtyDaysAgo.toISOString().split('T')[0];
            // Initial search
            // searchAppointments(0); // This function is no longer needed
        });
        
        // The following functions are no longer needed as pagination is server-side
        // function updatePagination() {
        //     const container = document.getElementById('paginationContainer');
        //     const info = document.getElementById('paginationInfo');
        //     const controls = document.getElementById('paginationControls');
        //     const pageSizeSelect = document.getElementById('pageSizeSelect');
        //     if (totalAppointments === 0) {
        //         container.style.display = 'none';
        //         return;
        //     }
        //     container.style.display = 'flex';
        //     // Info text
        //     const start = (currentPage * pageSize) + 1;
        //     const end = Math.min((currentPage * pageSize) + document.getElementById('appointmentsTableBody').rows.length, totalAppointments);
        //     info.textContent = `Showing ${start} to ${end} of ${totalAppointments} appointments`;
        //     // Page size selector
        //     pageSizeSelect.value = pageSize;
        //     // Page buttons
        //     let html = '';
        //     if (currentPage > 0) {
        //         html += `<a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" class="pagination-button"><i class="fas fa-chevron-left"></i> Previous</a>`;
        //     }
        //     // Show up to 5 page numbers, with ellipsis if needed
        //     let startPage = Math.max(0, currentPage - 2);
        //     let endPage = Math.min(totalPages - 1, currentPage + 2);
        //     if (currentPage <= 2) endPage = Math.min(4, totalPages - 1);
        //     if (currentPage >= totalPages - 3) startPage = Math.max(0, totalPages - 5);
        //     for (let i = startPage; i <= endPage; i++) {
        //         if (i === currentPage) {
        //             html += `<span class="pagination-button active">${i + 1}</span>`;
        //         } else {
        //             html += `<a href="javascript:void(0)" onclick="goToPage(${i})" class="pagination-button">${i + 1}</a>`;
        //         }
        //     }
        //     if (endPage < totalPages - 1) {
        //         html += `<span class="pagination-button">...</span>`;
        //         html += `<a href="javascript:void(0)" onclick="goToPage(${totalPages - 1})" class="pagination-button">${totalPages}</a>`;
        //     }
        //     if (currentPage < totalPages - 1) {
        //         html += `<a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" class="pagination-button">Next <i class="fas fa-chevron-right"></i></a>`;
        //     }
        //     controls.innerHTML = html;
        // }
        // function goToPage(page) {
        //     searchAppointments(page);
        // }
        // function changePageSize(size) {
        //     searchAppointments(0, size);
        // }
        
        function displayStats(stats) {
            document.getElementById('noShowCount').textContent = stats.noShow || 0;
            document.getElementById('cancelledCount').textContent = stats.cancelled || 0;
            document.getElementById('statsSection').style.display = 'grid';
        }
        
        // The following functions are no longer needed as pagination is server-side
        // function displayAppointments(appointments) {
        //     const tableBody = document.getElementById('appointmentsTableBody');
        //     const section = document.getElementById('appointmentsSection');
        //     const noAppointments = document.getElementById('noAppointments');
            
        //     if (appointments.length === 0) {
        //         section.style.display = 'block';
        //         tableBody.innerHTML = '';
        //         noAppointments.style.display = 'block';
        //         return;
        //     }
            
        //     section.style.display = 'block';
        //     noAppointments.style.display = 'none';
            
        //     tableBody.innerHTML = appointments.map(appointment => {
        //         const statusClass = 'status-' + appointment.status.toLowerCase().replace('_', '-');
        //         const statusText = appointment.status.replace('_', ' ');
                
        //         const notesDisplay = appointment.notes ? 
        //             '<div class="notes-text">' + appointment.notes + '</div>' : 
        //             '<em style="color: #7f8c8d;">No notes</em>';
                
        //         // Check if appointment is completed or already has notes
        //         const isCompleted = appointment.status === 'COMPLETED';
        //         const hasNotes = appointment.notes && appointment.notes.trim() !== '';
        //         const shouldDisable = isCompleted || hasNotes;
                
        //         const buttonClass = shouldDisable ? 'btn btn-secondary btn-sm' : 'btn btn-success btn-sm';
        //         let buttonTitle = 'Add follow-up notes';
                
        //         if (isCompleted) {
        //             buttonTitle = 'Cannot add notes to completed appointments';
        //         } else if (hasNotes) {
        //             buttonTitle = 'Notes already added - cannot edit further';
        //         }
                
        //         let buttonHtml = '<button class="' + buttonClass + '" onclick="showNotesInput(' + appointment.id + ')" title="' + buttonTitle + '"';
        //         if (shouldDisable) {
        //             buttonHtml += ' disabled';
        //         }
        //         buttonHtml += '><i class="fas fa-edit"></i> Add Notes</button>';
                
        //         return '<tr>' +
        //             '<td>' + appointment.patientName + '</td>' +
        //             '<td>' + appointment.phoneNumber + '</td>' +
        //             '<td>' + formatDateTime(appointment.appointmentDate) + '</td>' +
        //             '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
        //             '<td class="notes-cell">' + notesDisplay + '</td>' +
        //             '<td class="action-buttons">' + buttonHtml + '</td>' +
        //             '</tr>';
        //     }).join('');
        // }
        
        // The following functions are no longer needed as pagination is server-side
        // function formatDateTime(dateString) {
        //     try {
        //         // Handle different date string formats
        //         let date;
                
        //         if (typeof dateString === 'string') {
        //             // Remove any extra quotes or formatting
        //             const cleanDateString = dateString.replace(/['"]/g, '');
        //             date = new Date(cleanDateString);
        //         } else {
        //             date = new Date(dateString);
        //         }
                
        //         // Check if date is valid
        //         if (isNaN(date.getTime())) {
        //             console.error('Invalid date string:', dateString);
        //             return 'Invalid Date';
        //         }
                
        //         // Format date as DD/MM/YYYY
        //         const day = String(date.getDate()).padStart(2, '0');
        //         const month = String(date.getMonth() + 1).padStart(2, '0');
        //         const year = date.getFullYear();
                
        //         // Format time as HH:MM AM/PM
        //         const hours = date.getHours();
        //         const minutes = String(date.getMinutes()).padStart(2, '0');
        //         const ampm = hours >= 12 ? 'PM' : 'AM';
        //         const displayHours = hours % 12 || 12;
                
        //         return day + '/' + month + '/' + year + ' ' + displayHours + ':' + minutes + ' ' + ampm;
        //     } catch (error) {
        //         console.error('Error formatting date:', error, 'Date string:', dateString);
        //         return 'Invalid Date';
        //     }
        // }
        
        // The following functions are no longer needed as pagination is server-side
        // function showNotesInput(appointmentId) {
        //     const button = event.target.closest('button');
            
        //     // Check if button is disabled (completed appointment)
        //     if (button.disabled) {
        //         return;
        //     }
            
        //     const row = button.closest('tr');
        //     const notesCell = row.querySelector('.notes-cell');
        //     const currentNotes = notesCell.querySelector('.notes-text') ? 
        //         notesCell.querySelector('.notes-text').textContent : '';
            
        //     notesCell.innerHTML = 
        //         '<textarea class="notes-input" placeholder="Enter follow-up notes...">' + currentNotes + '</textarea>' +
        //         '<div style="margin-top: 10px;">' +
        //             '<button class="btn btn-success btn-sm" onclick="saveNotes(' + appointmentId + ', this)">' +
        //                 '<i class="fas fa-save"></i> Save' +
        //             '</button>' +
        //             '<button class="btn btn-secondary btn-sm" onclick="cancelNotes(this)" style="margin-left: 5px;">' +
        //                 '<i class="fas fa-times"></i> Cancel' +
        //             '</button>' +
        //         '</div>';
        // }
        
        // The following functions are no longer needed as pagination is server-side
        // function saveNotes(appointmentId, button) {
        //     const row = button.closest('tr');
        //     const notesCell = row.querySelector('.notes-cell');
        //     const notesInput = notesCell.querySelector('.notes-input');
        //     const notes = notesInput.value.trim();
            
        //     if (!notes) {
        //         alert('Please enter some notes');
        //         return;
        //     }
            
        //     const requestData = {
        //         appointmentId: appointmentId,
        //         notes: notes
        //     };
            
        //     fetch('${pageContext.request.contextPath}/receptionist/appointments/save-notes', {
        //         method: 'POST',
        //         headers: {
        //             'Content-Type': 'application/json',
        //             'X-CSRF-TOKEN': document.querySelector("meta[name='_csrf']").content
        //         },
        //         body: JSON.stringify(requestData)
        //     })
        //     .then(response => response.json())
        //     .then(data => {
        //         if (data.success) {
        //             // Update the display
        //             notesCell.innerHTML = '<div class="notes-text">' + notes + '</div>';
                    
        //             // Disable the Add Notes button
        //             const actionCell = row.querySelector('.action-buttons');
        //             const addNotesButton = actionCell.querySelector('button');
        //             addNotesButton.disabled = true;
        //             addNotesButton.className = 'btn btn-secondary btn-sm';
        //             addNotesButton.title = 'Notes already added - cannot edit further';
                    
        //             alert('Notes saved successfully!');
        //         } else {
        //             alert('Error: ' + data.message);
        //         }
        //     })
        //     .catch(error => {
        //         console.error('Error:', error);
        //         alert('Error saving notes');
        //     });
        // }
        
        // The following functions are no longer needed as pagination is server-side
        // function cancelNotes(button) {
        //     const row = button.closest('tr');
        //     const notesCell = row.querySelector('.notes-cell');
        //     notesCell.innerHTML = '<em style="color: #7f8c8d;">No notes</em>';
        // }
    </script>
</body>
</html> 