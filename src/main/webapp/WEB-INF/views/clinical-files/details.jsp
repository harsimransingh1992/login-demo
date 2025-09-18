<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Clinical File Details - PeriDesk</title>
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
        
        .welcome-message {
            font-size: 1.5rem;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .welcome-message i {
            color: #3498db;
        }
        
        .header-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .btn-primary, .btn-secondary, .btn-outline-primary {
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
            text-decoration: none;
            color: white;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #7f8c8d, #6c7b7d);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(149, 165, 166, 0.2);
            text-decoration: none;
            color: white;
        }
        
        .btn-outline-primary {
            border: 2px solid #3498db;
            background: transparent;
            color: #3498db;
        }
        
        .btn-outline-primary:hover {
            background: #3498db;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
            text-decoration: none;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
            overflow: hidden;
            border: none;
        }
        
        .card-header {
            padding: 20px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
        }
        
        .card-header.secondary {
            background: linear-gradient(135deg, #27ae60, #229954);
        }
        
        .card-header.info {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }
        
        .card-header.warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }
        
        .card-title {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-body {
            padding: 25px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .info-label {
            font-size: 0.85rem;
            color: #7f8c8d;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            font-size: 1rem;
            color: #2c3e50;
            font-weight: 600;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            border-left: 4px solid;
            transition: transform 0.2s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
        }
        
        .stat-card.primary {
            border-left-color: #3498db;
        }
        
        .stat-card.success {
            border-left-color: #27ae60;
        }
        
        .stat-card.warning {
            border-left-color: #f39c12;
        }
        
        .stat-card.info {
            border-left-color: #17a2b8;
        }
        
        .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-value.primary { color: #3498db; }
        .stat-value.success { color: #27ae60; }
        .stat-value.warning { color: #f39c12; }
        .stat-value.info { color: #17a2b8; }
        
        .stat-label {
            font-size: 0.85rem;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-closed {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .status-archived {
            background-color: #e2e3e5;
            color: #383d41;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .table-modern {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .table-modern thead {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
        }
        
        .table-modern th {
            border: none;
            padding: 15px;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .table-modern td {
            border: none;
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }
        
        .table-modern tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #bdc3c7;
            margin-bottom: 20px;
        }
        
        .empty-state h5 {
            color: #7f8c8d;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #95a5a6;
            margin-bottom: 30px;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.8rem;
            border-radius: 6px;
            border: 1px solid;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s ease;
        }
        
        .btn-outline-primary.btn-sm {
            border-color: #3498db;
            color: #3498db;
            background: transparent;
        }
        
        .btn-outline-primary.btn-sm:hover {
            background: #3498db;
            color: white;
        }
        
        .btn-outline-secondary.btn-sm {
            border-color: #6c757d;
            color: #6c757d;
            background: transparent;
        }
        
        .btn-outline-secondary.btn-sm:hover {
            background: #6c757d;
            color: white;
        }
        
        .btn-outline-success.btn-sm {
            border-color: #27ae60;
            color: #27ae60;
            background: transparent;
        }
        
        .btn-outline-success.btn-sm:hover {
            background: #27ae60;
            color: white;
        }
        
        .btn-outline-warning.btn-sm {
            border-color: #f39c12;
            color: #f39c12;
            background: transparent;
        }
        
        .btn-outline-warning.btn-sm:hover {
            background: #f39c12;
            color: white;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .alert-danger {
            background-color: #fee2e2;
            color: #dc2626;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">
                    <i class="fas fa-folder-medical"></i>
                    Clinical File Details
                </h1>
                <div class="header-actions">
                    <button onclick="printReport()" class="btn-outline-primary">
                        <i class="fas fa-print"></i> Print
                    </button>
                    <button onclick="exportReport()" class="btn-outline-primary">
                        <i class="fas fa-download"></i> Export
                    </button>
                    <a href="${pageContext.request.contextPath}/clinical-files" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>
            
            <!-- File Information -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-file-medical"></i> File Information
                    </h2>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">File Reference</div>
                            <div class="info-value">${clinicalFile.fileNumber}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Patient Name</div>
                            <div class="info-value">${clinicalFile.patientFullName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">File Status</div>
                            <div class="info-value">
                                <span class="status-badge status-${clinicalFile.status.name().toLowerCase()}">
                                    ${clinicalFile.status.displayName}
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Created Date</div>
                            <div class="info-value">${clinicalFile.createdAtFormatted}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Last Updated</div>
                            <div class="info-value">${clinicalFile.updatedAtFormatted}</div>
                        </div>
                        <c:if test="${not empty clinicalFile.closedAtFormatted}">
                            <div class="info-item">
                                <div class="info-label">Closed Date</div>
                                <div class="info-value">${clinicalFile.closedAtFormatted}</div>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Treatment Summary -->
                    <div class="stats-grid">
                        <div class="stat-card primary">
                            <div class="stat-value primary">${clinicalFile.examinationCount}</div>
                            <div class="stat-label">Procedures</div>
                        </div>
                        <div class="stat-card success">
                            <div class="stat-value success">₹<fmt:formatNumber value="${clinicalFile.totalAmount}" pattern="#,##0"/></div>
                            <div class="stat-label">Total Value</div>
                        </div>
                        <div class="stat-card warning">
                            <div class="stat-value warning">₹<fmt:formatNumber value="${clinicalFile.remainingAmount}" pattern="#,##0"/></div>
                            <div class="stat-label">Outstanding</div>
                        </div>
                        <div class="stat-card info">
                            <div class="stat-value info">₹<fmt:formatNumber value="${clinicalFile.totalPaidAmount != null ? clinicalFile.totalPaidAmount : 0}" pattern="#,##0"/></div>
                            <div class="stat-label">Collected</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- File Notes & Actions -->
            <div class="card">
                <div class="card-header info">
                    <h3 class="card-title">
                        <i class="fas fa-sticky-note"></i> Notes & Actions
                    </h3>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">File Title</div>
                            <div class="info-value">${clinicalFile.title}</div>
                        </div>
                        <c:if test="${not empty clinicalFile.notes}">
                            <div class="info-item">
                                <div class="info-label">Notes</div>
                                <div class="info-value">${clinicalFile.notes}</div>
                            </div>
                        </c:if>
                    </div>
                    
                    <div class="header-actions" style="margin-top: 20px;">
                        <c:if test="${clinicalFile.status.name() == 'ACTIVE'}">
                            <button onclick="closeFile(${clinicalFile.id})" class="btn-outline-warning">
                                <i class="fas fa-times"></i> Close File
                            </button>
                        </c:if>
                        <c:if test="${clinicalFile.status.name() == 'CLOSED'}">
                            <button onclick="reopenFile(${clinicalFile.id})" class="btn-outline-success">
                                <i class="fas fa-redo"></i> Reopen File
                            </button>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/clinical-files/${clinicalFile.id}/edit" class="btn-outline-primary">
                            <i class="fas fa-edit"></i> Edit File
                        </a>
                        <button onclick="addProcedure()" class="btn-primary">
                            <i class="fas fa-plus"></i> Add Procedure
                        </button>
                    </div>
                </div>
            </div>

            <!-- Treatment Procedures -->
            <div class="card">
                <div class="card-header secondary">
                    <h3 class="card-title">
                        <i class="fas fa-stethoscope"></i> Treatment Procedures
                    </h3>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty clinicalFile.examinations}">
                            <div class="empty-state">
                                <i class="fas fa-clipboard-list"></i>
                                <h5>No Treatment Procedures Found</h5>
                                <p>This clinical file does not contain any treatment procedures.</p>
                                <a href="${pageContext.request.contextPath}/patients/examination/create?fileId=${clinicalFile.id}" class="btn-primary">
                                    <i class="fas fa-plus"></i> Add Procedure
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-modern">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Procedure Type</th>
                                            <th>Tooth/Condition</th>
                                            <th>Date</th>
                                            <th>Doctor</th>
                                            <th>Value</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${clinicalFile.examinations}" var="exam" varStatus="status">
                                            <tr>
                                                <td><strong>${status.count}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${exam.toothNumber == 'GENERAL_CONSULTATION'}">
                                                            <span class="status-badge status-pending">General Consultation</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-active">Tooth ${exam.toothNumber.toString().replace('TOOTH_', '')}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty exam.toothCondition}">
                                                        ${exam.toothCondition}
                                                    </c:if>
                                                    <c:if test="${empty exam.toothCondition}">
                                                        <span style="color: #95a5a6;">Not specified</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty exam.examinationDateFormatted}">
                                                        ${exam.examinationDateFormatted}
                                                    </c:if>
                                                    <c:if test="${empty exam.examinationDateFormatted}">
                                                        <span style="color: #95a5a6;">Not recorded</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty exam.assignedDoctorName}">
                                                        ${exam.assignedDoctorName}
                                                    </c:if>
                                                    <c:if test="${empty exam.assignedDoctorName}">
                                                        <span style="color: #95a5a6;">Not assigned</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty exam.procedure}">
                                                        <span style="color: #27ae60; font-weight: 600;">₹<fmt:formatNumber value="${exam.procedure.price}" pattern="#,##0"/></span>
                                                    </c:if>
                                                    <c:if test="${empty exam.procedure}">
                                                        <span style="color: #95a5a6;">No procedure</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-active">Completed</span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/patients/examination/${exam.id}" 
                                                           class="btn-sm btn-outline-primary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <button class="btn-sm btn-outline-secondary" title="Edit" onclick="editExamination(${exam.id})">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>
    
    <script>
        // Get CSRF token for secure requests
        const token = document.querySelector('meta[name="_csrf"]').content;
        const header = document.querySelector('meta[name="_csrf_header"]').content;
        
        function printReport() {
            window.print();
        }
        
        function exportReport() {
            // Implementation for exporting report
            alert('Export functionality will be implemented soon.');
        }
        
        function closeFile(fileId) {
            if (confirm('Are you sure you want to close this clinical file? This action will mark the file as completed.')) {
                const contextPath = '${pageContext.request.contextPath}';
                fetch(contextPath + '/clinical-files/' + fileId + '/close', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [header]: token
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Clinical file closed successfully', 'success');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        showNotification('Error: ' + (data.message || 'Failed to close file'), 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('An error occurred while closing the file.', 'error');
                });
            }
        }

        function reopenFile(fileId) {
            if (confirm('Are you sure you want to reopen this clinical file? This will allow further modifications.')) {
                const contextPath = '${pageContext.request.contextPath}';
                fetch(contextPath + '/clinical-files/' + fileId + '/reopen', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [header]: token
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Clinical file reopened successfully', 'success');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        showNotification('Error: ' + (data.message || 'Failed to reopen file'), 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('An error occurred while reopening the file.', 'error');
                });
            }
        }
        
        function addProcedure() {
            const contextPath = '${pageContext.request.contextPath}';
            const fileId = '${clinicalFile.id}';
            window.location.href = contextPath + '/patients/examination/create?fileId=' + fileId;
        }
        
        function editExamination(examId) {
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/patients/examination/' + examId + '/edit';
        }
        
        function showNotification(message, type) {
            // Create notification element
            const notification = document.createElement('div');
            notification.className = 'alert alert-' + (type === 'success' ? 'success' : 'danger');
            notification.style.cssText = 
                'position: fixed;' +
                'top: 20px;' +
                'right: 20px;' +
                'z-index: 9999;' +
                'min-width: 300px;' +
                'animation: slideIn 0.3s ease;';
            notification.innerHTML = 
                '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-triangle') + '"></i> ' +
                message;
            
            // Add to page
            document.body.appendChild(notification);
            
            // Remove after 3 seconds
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }
        
        // Add CSS animations
        const style = document.createElement('style');
        style.textContent = 
            '@keyframes slideIn {' +
                'from { transform: translateX(100%); opacity: 0; }' +
                'to { transform: translateX(0); opacity: 1; }' +
            '}' +
            '@keyframes slideOut {' +
                'from { transform: translateX(0); opacity: 1; }' +
                'to { transform: translateX(100%); opacity: 0; }' +
            '}';
        document.head.appendChild(style);
    </script>
</body>
</html>
                auditType: auditType,
                qualityRating: qualityRating || null,
                auditNotes: auditNotes,
                recommendations: recommendations,
                auditStatus: 'PENDING'
            };
            
            // Submit audit via AJAX
            fetch('${pageContext.request.contextPath}/api/clinical-audits', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                },
                body: JSON.stringify(auditData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Audit saved successfully!');
                    $('#newAuditModal').modal('hide');
                    location.reload();
                } else {
                    alert('Error: ' + (data.message || 'Failed to save audit'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error saving audit. Please try again.');
            });
        }
        
        // View audit details
        function viewAuditDetails(auditId) {
            // TODO: Implement view audit details functionality
            alert('View audit details for ID: ' + auditId);
        }
        
        // Edit audit
        function editAudit(auditId) {
            // TODO: Implement edit audit functionality
            alert('Edit audit for ID: ' + auditId);
        }
        
        // Audit specific examination
        function auditExamination(examId) {
            // TODO: Implement examination-specific audit
            alert('Audit examination ID: ' + examId);
        }
        
        // Approve clinical file
        function approveClinicalFile() {
            if (confirm('Are you sure you want to approve this clinical file? This action will be recorded in the audit trail.')) {
                const auditData = {
                    clinicalFileId: ${clinicalFile.id},
                    auditType: 'APPROVAL',
                    auditStatus: 'APPROVED',
                    auditNotes: 'Clinical file approved by senior doctor',
                    recommendations: 'File meets all clinical standards'
                };
                
                submitAuditData(auditData);
            }
        }
        
        // Request revision
        function requestRevision() {
            const reason = prompt('Please specify the reason for requesting revision:');
            if (reason) {
                const auditData = {
                    clinicalFileId: ${clinicalFile.id},
                    auditType: 'REVISION_REQUEST',
                    auditStatus: 'REVISION_REQUESTED',
                    auditNotes: 'Revision requested: ' + reason,
                    recommendations: reason
                };
                
                submitAuditData(auditData);
            }
        }
        
        // Submit audit data
        function submitAuditData(auditData) {
            fetch('${pageContext.request.contextPath}/api/clinical-audits', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                },
                body: JSON.stringify(auditData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Action completed successfully!');
                    location.reload();
                } else {
                    alert('Error: ' + (data.message || 'Failed to complete action'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error completing action. Please try again.');
            });
        }
        
        // Print audit report
        function printAuditReport() {
            window.print();
        }
        
        // Export audit report
        function exportAuditReport() {
            alert('Export functionality will be implemented here.');
        }
    </script>
</body>
</html>
