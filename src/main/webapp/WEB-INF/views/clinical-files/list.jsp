<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />
                    <title>Clinical Files - PeriDesk</title>
                    <jsp:include page="/WEB-INF/views/common/head.jsp" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <script src="${pageContext.request.contextPath}/js/common.js"></script>
                    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

                        .btn-primary {
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            gap: 8px;
                            padding: 12px 24px;
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

                        .btn-primary:hover {
                            background: linear-gradient(135deg, #2980b9, #1c6ea4);
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
                            text-decoration: none;
                            color: white;
                        }

                        .card {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
                            margin-bottom: 30px;
                            overflow: hidden;
                            border: none;
                        }

                        .card-body {
                            padding: 20px;
                        }

                        .filters-container {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
                            margin-bottom: 30px;
                            padding: 20px;
                        }

                        .filter-form {
                            display: flex;
                            gap: 15px;
                            align-items: end;
                            flex-wrap: wrap;
                        }

                        .filter-group {
                            flex: 1;
                            min-width: 200px;
                        }

                        .filter-group label {
                            display: block;
                            margin-bottom: 5px;
                            color: #2c3e50;
                            font-weight: 500;
                            font-size: 0.9rem;
                        }

                        .form-select {
                            width: 100%;
                            padding: 10px 15px;
                            border: 2px solid #e9ecef;
                            border-radius: 8px;
                            font-size: 0.9rem;
                            color: #2c3e50;
                            background-color: white;
                            transition: border-color 0.3s ease;
                        }

                        .form-select:focus {
                            outline: none;
                            border-color: #3498db;
                            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
                        }

                        .btn-outline-primary {
                            padding: 10px 20px;
                            border: 2px solid #3498db;
                            background: transparent;
                            color: #3498db;
                            border-radius: 8px;
                            font-weight: 500;
                            transition: all 0.3s ease;
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            text-decoration: none;
                        }

                        .btn-outline-primary:hover {
                            background: #3498db;
                            color: white;
                            transform: translateY(-1px);
                            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
                        }

                        .files-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(320px, 380px));
                            gap: 20px;
                            margin-top: 20px;
                            justify-content: start;
                        }

                        @media (min-width: 1200px) {
                            .files-grid {
                                grid-template-columns: repeat(auto-fit, minmax(320px, 360px));
                            }
                        }

                        @media (max-width: 768px) {
                            .files-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        .file-card {
                            background: white;
                            border-radius: 12px;
                            padding: 18px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
                            transition: all 0.3s ease;
                            border: 1px solid #f0f0f0;
                            width: 100%;
                            max-width: 380px;
                            min-height: 280px;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                        }

                        .file-content {
                            flex: 1;
                        }

                        .file-card:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                        }

                        .file-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-start;
                            margin-bottom: 15px;
                        }

                        .file-number {
                            font-size: 1.1rem;
                            font-weight: 600;
                            color: #2c3e50;
                            margin: 0;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .file-number i {
                            color: #3498db;
                        }

                        .status-badge {
                            padding: 4px 12px;
                            border-radius: 20px;
                            font-size: 0.75rem;
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

                        .file-title {
                            font-size: 1rem;
                            font-weight: 500;
                            color: #2c3e50;
                            margin: 8px 0;
                            line-height: 1.3;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        .patient-info {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            color: #7f8c8d;
                            font-size: 0.85rem;
                            margin-bottom: 12px;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        .stats-row {
                            display: grid;
                            grid-template-columns: 1fr 1fr 1fr;
                            gap: 10px;
                            margin-bottom: 20px;
                            padding: 12px;
                            background: #f8f9fa;
                            border-radius: 8px;
                        }

                        .stat-item {
                            text-align: center;
                        }

                        .stat-value {
                            font-size: 1.1rem;
                            font-weight: 600;
                            margin-bottom: 2px;
                            line-height: 1.2;
                        }

                        .stat-value.primary {
                            color: #3498db;
                        }

                        .stat-value.success {
                            color: #27ae60;
                        }

                        .stat-value.warning {
                            color: #f39c12;
                        }

                        .stat-label {
                            font-size: 0.75rem;
                            color: #7f8c8d;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            line-height: 1.2;
                        }

                        .file-footer {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .file-date {
                            color: #7f8c8d;
                            font-size: 0.85rem;
                            display: flex;
                            align-items: center;
                            gap: 5px;
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
                        }

                        .btn-outline-primary.btn-sm:hover {
                            background: #3498db;
                            color: white;
                        }

                        .btn-outline-secondary.btn-sm {
                            border-color: #6c757d;
                            color: #6c757d;
                        }

                        .btn-outline-secondary.btn-sm:hover {
                            background: #6c757d;
                            color: white;
                        }

                        .btn-outline-danger.btn-sm {
                            border-color: #e74c3c;
                            color: #e74c3c;
                        }

                        .btn-outline-danger.btn-sm:hover {
                            background: #e74c3c;
                            color: white;
                        }

                        .btn-outline-success.btn-sm {
                            border-color: #27ae60;
                            color: #27ae60;
                        }

                        .btn-outline-success.btn-sm:hover {
                            background: #27ae60;
                            color: white;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
                        }

                        .empty-state i {
                            font-size: 4rem;
                            color: #bdc3c7;
                            margin-bottom: 20px;
                        }

                        .empty-state h4 {
                            color: #7f8c8d;
                            margin-bottom: 10px;
                        }

                        .empty-state p {
                            color: #95a5a6;
                            margin-bottom: 30px;
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

                        .alert-danger {
                            background-color: #fee2e2;
                            color: #dc2626;
                        }

                        .alert-danger i {
                            color: #dc2626;
                        }

                        /* DISTINCTIVE TEST STYLE */
                        body {
                            border: 5px solid red !important;
                        }
                    </style>
                </head>

                <body>
                    <div class="welcome-container">
                        <!-- Sidebar Menu -->
                        <jsp:include page="../common/menu.jsp" />

                        <!-- Main Content -->
                        <div class="main-content">
                            <!-- Header -->
                            <div class="welcome-header">
                                <i class="fas fa-folder-medical"></i>
                                Clinical Files - CUSTOM DESIGN LOADED
                                </h1>
                                <a href="${pageContext.request.contextPath}/clinical-files/create" class="btn-primary">
                                    <i class="fas fa-plus"></i> New Clinical File
                                </a>
                            </div>

                            <!-- Error Message -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <!-- Filters -->
                            <div class="filters-container">
                                <form method="get" class="filter-form">
                                    <div class="filter-group">
                                        <label for="status">Filter by Status</label>
                                        <select name="status" id="status" class="form-select">
                                            <option value="">All Statuses</option>
                                            <c:forEach items="${statuses}" var="status">
                                                <option value="${status}" ${currentStatus==status ? 'selected' : '' }>
                                                    ${status.displayName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group" style="flex: 0 0 auto;">
                                        <button type="submit" class="btn-outline-primary">
                                            <i class="fas fa-filter"></i> Apply Filter
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Clinical Files List -->
                            <c:choose>
                                <c:when test="${empty clinicalFiles}">
                                    <div class="empty-state">
                                        <i class="fas fa-folder-open"></i>
                                        <h4>No Clinical Files Found</h4>
                                        <p>Create your first clinical file to get started with patient management.</p>
                                        <a href="${pageContext.request.contextPath}/clinical-files/create"
                                            class="btn-primary">
                                            <i class="fas fa-plus"></i> Create Clinical File
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="files-grid">
                                        <c:forEach items="${clinicalFiles}" var="file">
                                            <div class="file-card">
                                                <div class="file-content">
                                                    <div class="file-header">
                                                        <h5 class="file-number">
                                                            <i class="fas fa-folder-medical"></i>
                                                            ${file.fileNumber}
                                                        </h5>
                                                        <span
                                                            class="status-badge status-${file.status.name().toLowerCase()}">
                                                            ${file.status.displayName}
                                                        </span>
                                                    </div>

                                                    <h6 class="file-title" title="${file.title}">${file.title}</h6>

                                                    <div class="patient-info" title="${file.patientFullName}">
                                                        <i class="fas fa-user"></i>
                                                        ${file.patientFullName}
                                                    </div>

                                                    <div class="stats-row">
                                                        <div class="stat-item">
                                                            <div class="stat-value primary">${file.examinationCount}
                                                            </div>
                                                            <div class="stat-label">Exams</div>
                                                        </div>
                                                        <div class="stat-item">
                                                            <div class="stat-value success">
                                                                ₹
                                                                <fmt:formatNumber value="${file.totalAmount}"
                                                                    pattern="#,##0" />
                                                            </div>
                                                            <div class="stat-label">Total</div>
                                                        </div>
                                                        <div class="stat-item">
                                                            <div class="stat-value warning">
                                                                ₹
                                                                <fmt:formatNumber value="${file.remainingAmount}"
                                                                    pattern="#,##0" />
                                                            </div>
                                                            <div class="stat-label">Pending</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="file-footer">
                                                    <div class="file-date">
                                                        <i class="fas fa-calendar"></i>
                                                        ${file.createdAtFormatted}
                                                    </div>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/clinical-files/${file.id}"
                                                            class="btn-sm btn-outline-primary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/clinical-files/${file.id}/edit"
                                                            class="btn-sm btn-outline-secondary" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:if test="${file.status.name() == 'ACTIVE'}">
                                                            <button onclick="closeFile(${file.id})"
                                                                class="btn-sm btn-outline-danger" title="Close File">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${file.status.name() == 'CLOSED'}">
                                                            <button onclick="reopenFile(${file.id})"
                                                                class="btn-sm btn-outline-success" title="Reopen File">
                                                                <i class="fas fa-redo"></i>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <script>
                        // Get CSRF token for secure requests
                        const token = document.querySelector('meta[name="_csrf"]').content;
                        const header = document.querySelector('meta[name="_csrf_header"]').content;

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
                                            // Show success message and reload
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
                                            // Show success message and reload
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
                        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
        `;
                        document.head.appendChild(style);
                    </script>
                </body>

                </html>