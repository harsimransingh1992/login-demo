<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Welcome - PeriDesk</title>
                        <meta name="_csrf" content="${_csrf.token}" />
                        <jsp:include page="/WEB-INF/views/common/head.jsp" />
                        <!-- Preload critical resources -->
                        <link rel="preload"
                            href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                            as="style" onload="this.onload=null;this.rel='stylesheet'">
                        <link rel="preload"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" as="style"
                            onload="this.onload=null;this.rel='stylesheet'">

                        <!-- Critical CSS inline -->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <link rel="stylesheet"
                            href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

                        <!-- Non-critical CSS with fallback -->
                        <noscript>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        </noscript>

                        <!-- Defer non-critical JavaScript -->
                        <script src="https://code.jquery.com/jquery-3.6.4.min.js" defer></script>
                        <script src="${pageContext.request.contextPath}/js/common.js" defer></script>

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

                            .btn-secondary:disabled {
                                background: #6c757d !important;
                                border-color: #6c757d !important;
                                cursor: not-allowed;
                                opacity: 0.6;
                            }

                            .btn-secondary:disabled:hover {
                                background: #6c757d !important;
                                border-color: #6c757d !important;
                                box-shadow: none;
                                transform: none;
                            }

                            .btn-secondary i {
                                font-size: 0.9rem;
                            }

                            .card {
                                background: white;
                                border-radius: 12px;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
                                margin-bottom: 30px;
                                overflow: hidden;
                            }

                            .card-header {
                                padding: 20px;
                                background: #f8f9fa;
                                border-bottom: 1px solid #f0f0f0;
                            }

                            .card-title {
                                margin: 0;
                                font-size: 1.2rem;
                                color: #2c3e50;
                                font-weight: 600;
                            }

                            .card-body {
                                padding: 20px;
                            }

                            .profile-info {
                                display: grid;
                                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                                gap: 20px;
                            }

                            .info-group {
                                margin-bottom: 15px;
                            }

                            .info-label {
                                font-size: 0.85rem;
                                color: #7f8c8d;
                                margin-bottom: 5px;
                            }

                            .info-value {
                                font-size: 1rem;
                                color: #2c3e50;
                                font-weight: 500;
                            }

                            .role-badge {
                                display: inline-block;
                                padding: 5px 10px;
                                border-radius: 20px;
                                font-size: 0.75rem;
                                font-weight: 500;
                                color: white;
                                text-align: center;
                            }

                            .role-ADMIN {
                                background-color: #dc3545;
                            }

                            .role-CLINIC_OWNER {
                                background-color: #6f42c1;
                            }

                            .role-DOCTOR {
                                background-color: #28a745;
                            }

                            .role-STAFF {
                                background-color: #17a2b8;
                            }

                            .role-RECEPTIONIST {
                                background-color: #fd7e14;
                            }

                            .table {
                                width: 100%;
                                border-collapse: collapse;
                                background: white;
                                border-radius: 12px;
                                overflow: hidden;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
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

                            .patient-link {
                                color: #3498db;
                                text-decoration: none;
                                font-weight: 500;
                                transition: color 0.2s;
                            }

                            .patient-link:hover {
                                color: #2980b9;
                                text-decoration: underline;
                            }

                            .btn-primary {
                                background: linear-gradient(135deg, #3498db, #2980b9);
                                color: white;
                                border: none;
                                border-radius: 6px;
                                padding: 8px 16px;
                                font-size: 0.85rem;
                                font-weight: 500;
                                cursor: pointer;
                                transition: all 0.3s;
                                text-decoration: none;
                                display: inline-block;
                                margin-right: 5px;
                            }

                            .btn-primary:hover {
                                background: linear-gradient(135deg, #2980b9, #1c6ea4);
                                box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
                            }

                            .btn-danger {
                                background: linear-gradient(135deg, #e74c3c, #c0392b);
                                color: white;
                                border: none;
                                border-radius: 6px;
                                padding: 8px 16px;
                                font-size: 0.85rem;
                                font-weight: 500;
                                cursor: pointer;
                                transition: all 0.3s;
                                text-decoration: none;
                                display: inline-block;
                            }

                            .btn-danger:hover {
                                background: linear-gradient(135deg, #c0392b, #a82315);
                                box-shadow: 0 4px 8px rgba(231, 76, 60, 0.2);
                            }

                            .btn-danger:disabled {
                                background: linear-gradient(135deg, #bdc3c7, #95a5a6);
                                cursor: not-allowed;
                                opacity: 0.6;
                            }

                            .btn-danger:disabled:hover {
                                background: linear-gradient(135deg, #bdc3c7, #95a5a6);
                                box-shadow: none;
                                transform: none;
                            }

                            /* Blinking Payment Status Styles */
                            .blinking-payment-btn {
                                animation: blinkPayment 2s infinite;
                                position: relative;
                                overflow: hidden;
                            }

                            .blinking-payment-btn .payment-text {
                                display: inline-block;
                                animation: textAlternate 2s infinite;
                            }

                            @keyframes blinkPayment {
                                0%, 50% {
                                    background: linear-gradient(135deg, #f39c12, #e67e22);
                                    box-shadow: 0 0 10px rgba(243, 156, 18, 0.5);
                                }
                                51%, 100% {
                                    background: linear-gradient(135deg, #e67e22, #d35400);
                                    box-shadow: 0 0 15px rgba(230, 126, 34, 0.7);
                                }
                            }

                            @keyframes textAlternate {
                                0%, 49% {
                                    opacity: 1;
                                }
                                50%, 100% {
                                    opacity: 0;
                                }
                            }

                            .blinking-payment-btn .payment-text-alt {
                                position: absolute;
                                left: 50%;
                                top: 50%;
                                transform: translate(-50%, -50%);
                                animation: textAlternateReverse 2s infinite;
                                white-space: nowrap;
                            }

                            @keyframes textAlternateReverse {
                                0%, 49% {
                                    opacity: 0;
                                }
                                50%, 100% {
                                    opacity: 1;
                                }
                            }
                            }

                            /* Blinking Pending Payment Notification Styles */
                            .pending-payment-notification {
                                position: fixed;
                                top: 20px;
                                right: 20px;
                                background: linear-gradient(135deg, #f39c12, #e67e22);
                                color: white;
                                padding: 15px 20px;
                                border-radius: 10px;
                                box-shadow: 0 8px 25px rgba(243, 156, 18, 0.3);
                                cursor: pointer;
                                z-index: 1000;
                                display: flex;
                                align-items: center;
                                gap: 10px;
                                font-weight: 600;
                                font-size: 1rem;
                                animation: blinkNotification 2s infinite;
                                transition: all 0.3s ease;
                                border: 2px solid rgba(255, 255, 255, 0.2);
                            }

                            .pending-payment-notification:hover {
                                transform: scale(1.05);
                                box-shadow: 0 12px 35px rgba(243, 156, 18, 0.4);
                                background: linear-gradient(135deg, #e67e22, #d35400);
                            }

                            .pending-payment-notification i {
                                font-size: 1.2rem;
                                animation: pulse 1s infinite;
                            }

                            @keyframes blinkNotification {
                                0%, 50% {
                                    opacity: 1;
                                }
                                51%, 100% {
                                    opacity: 0.8;
                                }
                            }

                            @keyframes pulse {
                                0%, 100% {
                                    transform: scale(1);
                                }
                                50% {
                                    transform: scale(1.1);
                                }
                            }

                            .notification-text {
                                position: relative;
                            }

                            @keyframes simpleBlink {
                                0%, 50% {
                                    opacity: 1;
                                    background: linear-gradient(135deg, #f39c12, #e67e22);
                                }
                                51%, 100% {
                                    opacity: 0.9;
                                    background: linear-gradient(135deg, #e67e22, #d35400);
                                }
                            }

                            .action-buttons {
                                display: flex;
                                gap: 8px;
                                align-items: center;
                            }

                            .no-patients-message {
                                padding: 20px;
                                text-align: center;
                                color: #7f8c8d;
                                background: #f8f9fa;
                                border-radius: 8px;
                                font-size: 1rem;
                            }

                            .no-patients-message i {
                                margin-right: 10px;
                                color: #3498db;
                            }

                            .time-display {
                                display: flex;
                                align-items: center;
                                gap: 5px;
                            }

                            .time-display i {
                                color: #3498db;
                                font-size: 0.9rem;
                            }

                            .no-data {
                                color: #999;
                                font-style: italic;
                                font-size: 0.9rem;
                            }

                            /* Waiting time styles */
                            .waiting-time {
                                font-family: monospace;
                                font-size: 0.9rem;
                                font-weight: 500;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                                white-space: nowrap;
                            }

                            .waiting-time i {
                                color: #e74c3c;
                                font-size: 0.9rem;
                            }

                            .waiting-time.short {
                                color: #27ae60;
                            }

                            .waiting-time.medium {
                                color: #f39c12;
                            }

                            .waiting-time.long {
                                color: #e74c3c;
                            }

                            /* Patient info and avatar styles */
                            .patient-info {
                                display: flex;
                                align-items: center;
                                gap: 12px;
                            }

                            .patient-avatar {
                                width: 50px;
                                height: 50px;
                                border-radius: 50%;
                                object-fit: cover;
                                cursor: pointer;
                                border: 2px solid #e0e0e0;
                                transition: all 0.3s ease;
                            }

                            .patient-avatar:hover {
                                border-color: #3498db;
                                transform: scale(1.05);
                            }

                            .patient-details {
                                display: flex;
                                gap: 10px;
                                font-size: 0.85rem;
                                color: #666;
                            }

                            .patient-details .age,
                            .patient-details .gender {
                                display: inline-flex;
                                align-items: center;
                                gap: 4px;
                            }

                            .patient-details .age::before {
                                content: '\f1fd';
                                font-family: 'Font Awesome 5 Free';
                                font-weight: 900;
                                color: #3498db;
                            }

                            .patient-details .gender::before {
                                content: '\f183';
                                font-family: 'Font Awesome 5 Free';
                                font-weight: 900;
                                color: #e74c3c;
                            }

                            /* Avatar Placeholder Styles */
                            .avatar-placeholder {
                                width: 50px;
                                height: 50px;
                                border-radius: 50%;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                cursor: pointer;
                                border: 2px solid #e0e0e0;
                                transition: all 0.3s ease;
                                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                            }

                            .avatar-placeholder:hover {
                                border-color: #3498db;
                                transform: scale(1.05);
                                box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
                            }

                            .avatar-icon {
                                font-size: 24px;
                                color: #6c757d;
                            }

                            /* Male Avatar Colors */
                            .avatar-icon.male-child {
                                color: #007bff;
                            }

                            .avatar-icon.male-adult {
                                color: #0056b3;
                            }

                            .avatar-icon.male-senior {
                                color: #004085;
                            }

                            /* Female Avatar Colors */
                            .avatar-icon.female-child {
                                color: #e83e8c;
                            }

                            .avatar-icon.female-adult {
                                color: #c73e6b;
                            }

                            .avatar-icon.female-senior {
                                color: #a52a5a;
                            }

                            /* Neutral Avatar Color */
                            .avatar-icon.neutral {
                                color: #6c757d;
                            }

                            /* Avatar Info Tooltip */
                            .avatar-tooltip {
                                position: absolute;
                                background: rgba(0, 0, 0, 0.8);
                                color: white;
                                padding: 8px 12px;
                                border-radius: 6px;
                                font-size: 12px;
                                z-index: 1000;
                                pointer-events: none;
                                white-space: nowrap;
                                opacity: 0;
                                transition: opacity 0.3s ease;
                            }

                            .avatar-tooltip.show {
                                opacity: 1;
                            }

                            /* Image Modal Styles */
                            .image-modal {
                                display: none;
                                position: fixed;
                                z-index: 1000;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                background-color: rgba(0, 0, 0, 0.9);
                                overflow: auto;
                            }

                            .modal-content {
                                margin: auto;
                                display: block;
                                max-width: 90%;
                                max-height: 90vh;
                                position: relative;
                                top: 50%;
                                transform: translateY(-50%);
                            }

                            .modal-close {
                                position: absolute;
                                top: 15px;
                                right: 35px;
                                color: #f1f1f1;
                                font-size: 40px;
                                font-weight: bold;
                                cursor: pointer;
                                z-index: 1001;
                            }

                            /* Custom tooltip styles */
                            .tooltip-container {
                                position: relative;
                                display: inline-block;
                            }

                            .tooltip-container .tooltip-text {
                                visibility: hidden;
                                width: 250px;
                                background-color: #333;
                                color: #fff;
                                text-align: center;
                                border-radius: 6px;
                                padding: 8px 12px;
                                position: absolute;
                                z-index: 1000;
                                bottom: 125%;
                                left: 50%;
                                margin-left: -125px;
                                opacity: 0;
                                transition: opacity 0.3s;
                                font-size: 0.85rem;
                                font-weight: 400;
                            }

                            .tooltip-container .tooltip-text::after {
                                content: "";
                                position: absolute;
                                top: 100%;
                                left: 50%;
                                margin-left: -5px;
                                border-width: 5px;
                                border-style: solid;
                                border-color: #333 transparent transparent transparent;
                            }

                            .tooltip-container:hover .tooltip-text {
                                visibility: visible;
                                opacity: 1;
                            }

                            /* Sortable table header styles */
                            .sortable-header {
                                cursor: pointer;
                                transition: background-color 0.2s ease;
                                user-select: none;
                            }

                            .sortable-header:hover {
                                background-color: rgba(52, 152, 219, 0.1);
                            }

                            .sortable-header i {
                                transition: transform 0.2s ease;
                            }

                            .sortable-header:hover i {
                                transform: scale(1.1);
                            }

                            /* Patient Color Code Styles */
                            .patient-color-strip {
                                transition: all 0.3s ease;
                            }

                            .patient-color-badge {
                                transition: all 0.3s ease;
                                cursor: help;
                            }

                            .patient-color-badge:hover {
                                transform: scale(1.2);
                                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3) !important;
                            }

                            /* Row hover effect with color strip */
                            .table tr:hover .patient-color-strip {
                                width: 6px;
                                box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
                            }

                            /* Color-specific styles for better visibility */
                            .color-code-blue {
                                background-color: #0066CC !important;
                            }

                            .color-code-yellow {
                                background-color: #FFD700 !important;
                            }

                            .color-code-no-code {
                                background-color: #E0E0E0 !important;
                            }

                            /* Patient Color Indicator Styles */
                            .patient-color-indicator {
                                transition: all 0.3s ease;
                                cursor: help;
                                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
                            }

                            .patient-color-indicator:hover {
                                transform: scale(1.05);
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
                            }

                            /* Ensure text is readable on different color backgrounds */
                            .patient-color-indicator[style*="#FFD700"] {
                                color: #333 !important;
                                text-shadow: none;
                            }
                        </style>
                    </head>

                    <body>
                        <!-- Image Modal -->
                        <div id="imageModal" class="image-modal">
                            <span class="modal-close">&times;</span>
                            <img class="modal-content" id="modalImage">
                        </div>



                        <div class="welcome-container">
                            <jsp:include page="/WEB-INF/views/common/menu.jsp" />

                            <div class="main-content">
                                <div class="welcome-header">
                                    <h1 class="welcome-message">Welcome, <span>
                                            <c:choose>
                                                <c:when test="${not empty username}">
                                                    ${username}
                                                </c:when>
                                                <c:otherwise>
                                                    <sec:authentication property="principal.username" />
                                                </c:otherwise>
                                            </c:choose>
                                        </span>!</h1>
                                    <a href="${pageContext.request.contextPath}/logout" class="btn-secondary">
                                        <i class="fas fa-power-off"></i> Logout
                                    </a>
                                </div>



                                <c:if test="${not empty errorMessage}">
                                    <div class="card" style="border-left: 4px solid #e74c3c; margin-bottom: 20px;">
                                        <div class="card-body">
                                            <div style="color: #e74c3c;">
                                                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="card">
                                    <div class="card-header">
                                        <h2 class="card-title"><i class="fas fa-clock"></i> Waiting Patients</h2>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty waitingPatients}">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 60px;">#</th>
                                                            <th>Patient Name</th>
                                                            <th class="sortable-header" onclick="sortTable()">
                                                                Check-in Time <i class="fas fa-sort"
                                                                    style="margin-left: 5px; color: #3498db;"></i>
                                                            </th>
                                                            <th>Assigned Doctor</th>
                                                            <th>Waiting Time</th>
                                                            <th>Payment Status</th>
                                                            <th style="text-align: center;">Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${waitingPatients}" var="patient"
                                                            varStatus="status">
                                                            <tr>
                                                                <td
                                                                    style="text-align: center; font-weight: bold; color: #3498db; position: relative;">
                                                                    <!-- Color Code Strip -->
                                                                    <c:if
                                                                        test="${not empty patient.colorCode && patient.colorCode != 'NO_CODE'}">
                                                                        <div class="patient-color-strip"
                                                                            style="position: absolute; left: 0; top: 0; bottom: 0; width: 4px; background-color: ${patient.colorCode.hexColor}; border-radius: 0 2px 2px 0;">
                                                                        </div>
                                                                    </c:if>
                                                                    ${status.count}
                                                                </td>
                                                                <td>
                                                                    <div class="patient-info"
                                                                        style="position: relative;">
                                                                        <!-- Color Code Badge -->
                                                                        <c:if
                                                                            test="${not empty patient.colorCode && patient.colorCode != 'NO_CODE'}">
                                                                            <div class="patient-color-badge"
                                                                                style="position: absolute; top: -5px; right: -5px; width: 12px; height: 12px; border-radius: 50%; background-color: ${patient.colorCode.hexColor}; border: 2px solid white; box-shadow: 0 1px 3px rgba(0,0,0,0.2);"
                                                                                title="${patient.colorCode.displayName}">
                                                                            </div>
                                                                        </c:if>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty patient.profilePicturePath}">
                                                                                <img src="${pageContext.request.contextPath}/uploads/${patient.profilePicturePath}"
                                                                                    alt="Profile" class="patient-avatar"
                                                                                    onclick="openImageModal(this.src)">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div class="avatar-placeholder"
                                                                                    onclick="showAvatarInfo('${patient.firstName}', '${patient.lastName}', '${patient.gender}', '${patient.age}')">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${patient.gender == 'MALE'}">
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${patient.age < 18}">
                                                                                                    <i
                                                                                                        class="fas fa-child avatar-icon male-child"></i>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${patient.age < 60}">
                                                                                                    <i
                                                                                                        class="fas fa-user avatar-icon male-adult"></i>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <i
                                                                                                        class="fas fa-user-tie avatar-icon male-senior"></i>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${patient.gender == 'FEMALE'}">
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${patient.age < 18}">
                                                                                                    <i
                                                                                                        class="fas fa-child avatar-icon female-child"></i>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${patient.age < 60}">
                                                                                                    <i
                                                                                                        class="fas fa-user avatar-icon female-adult"></i>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <i
                                                                                                        class="fas fa-user-tie avatar-icon female-senior"></i>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <i
                                                                                                class="fas fa-user avatar-icon neutral"></i>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div>
                                                                            <div
                                                                                style="display: flex; align-items: center; gap: 8px;">
                                                                                <strong>${patient.firstName}
                                                                                    ${patient.lastName}</strong>
                                                                                <c:if
                                                                                    test="${not empty patient.colorCode && patient.colorCode != 'NO_CODE'}">
                                                                                    <span
                                                                                        class="patient-color-indicator"
                                                                                        style="display: inline-block; padding: 2px 8px; border-radius: 12px; font-size: 0.7rem; font-weight: 500; color: white; background-color: ${patient.colorCode.hexColor};"
                                                                                        title="${patient.colorCode.displayName}">
                                                                                        ${patient.colorCode.displayName}
                                                                                    </span>
                                                                                </c:if>
                                                                            </div>
                                                                            <div class="patient-details">
                                                                                <c:if test="${not empty patient.age}">
                                                                                    <span class="age">${patient.age}
                                                                                        years</span>
                                                                                </c:if>
                                                                                <span
                                                                                    class="gender">${patient.gender}</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty patient.currentCheckInRecord && not empty patient.currentCheckInRecord.checkInTime}">
                                                                            <fmt:parseDate
                                                                                value="${patient.currentCheckInRecord.checkInTime}"
                                                                                pattern="yyyy-MM-dd'T'HH:mm:ss"
                                                                                var="parsedDate" type="both" />
                                                                            <fmt:formatDate value="${parsedDate}"
                                                                                pattern="hh:mm a" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="no-data">Not available</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty patient.currentCheckInRecord && not empty patient.currentCheckInRecord.assignedDoctor}">
                                                                            <sec:authorize
                                                                                access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                                                <select
                                                                                    onchange="changeDoctorAssignment('${patient.id}', '${patient.firstName} ${patient.lastName}', this.value)"
                                                                                    class="doctor-select"
                                                                                    style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 0.85rem; background: white;">
                                                                                    <option value="">No doctor assigned
                                                                                    </option>
                                                                                    <c:forEach items="${clinicDoctors}"
                                                                                        var="doctor">
                                                                                        <option value="${doctor.id}"
                                                                                            <c:if test="${not empty patient.currentCheckInRecord.assignedDoctor and doctor.id == patient.currentCheckInRecord.assignedDoctor.id}">selected</c:if>>
                                                                                            Dr. ${doctor.firstName}
                                                                                            ${doctor.lastName}
                                                                                        </option>
                                                                                    </c:forEach>
                                                                                </select>
                                                                            </sec:authorize>
                                                                            <sec:authorize
                                                                                access="!hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                                                <div
                                                                                    style="display: flex; align-items: center; gap: 8px;">
                                                                                    <i class="fas fa-user-md"
                                                                                        style="color: #27ae60; font-size: 0.9rem;"></i>
                                                                                    <span
                                                                                        style="font-weight: 500; color: #2c3e50;">
                                                                                        Dr.
                                                                                        ${patient.currentCheckInRecord.assignedDoctor.firstName}
                                                                                        ${patient.currentCheckInRecord.assignedDoctor.lastName}
                                                                                    </span>
                                                                                </div>
                                                                            </sec:authorize>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <sec:authorize
                                                                                access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                                                <select
                                                                                    onchange="changeDoctorAssignment('${patient.id}', '${patient.firstName} ${patient.lastName}', this.value)"
                                                                                    class="doctor-select"
                                                                                    style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 0.85rem; background: white;">
                                                                                    <option value="">No doctor assigned
                                                                                    </option>
                                                                                    <c:forEach items="${clinicDoctors}"
                                                                                        var="doctor">
                                                                                        <option value="${doctor.id}">
                                                                                            Dr. ${doctor.firstName}
                                                                                            ${doctor.lastName}
                                                                                        </option>
                                                                                    </c:forEach>
                                                                                </select>
                                                                            </sec:authorize>
                                                                            <sec:authorize
                                                                                access="!hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                                                <div
                                                                                    style="display: flex; align-items: center; gap: 8px;">
                                                                                    <i class="fas fa-user-slash"
                                                                                        style="color: #95a5a6; font-size: 0.9rem;"></i>
                                                                                    <span class="no-data">Not
                                                                                        assigned</span>
                                                                                </div>
                                                                            </sec:authorize>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:if
                                                                        test="${not empty patient.currentCheckInRecord && not empty patient.currentCheckInRecord.checkInTime}">
                                                                        <div class="waiting-time"
                                                                            data-checkin="${patient.currentCheckInRecord.checkInTime}">
                                                                            <i class="fas fa-clock"></i>
                                                                            <span class="time-value">00:00:00</span>
                                                                        </div>
                                                                    </c:if>
                                                                </td>
                                                                <td style="text-align: center;">
                                                                    <c:choose>
                                                                        <c:when test="${patient.pendingPayments > 0}">
                                                                            <a href="${pageContext.request.contextPath}/payments/patient/${patient.id}" 
                                                                               class="btn btn-warning btn-sm blinking-payment-btn" 
                                                                               style="text-decoration: none; color: #fff; position: relative;">
                                                                                <i class="fas fa-exclamation-triangle"></i> 
                                                                                <span class="payment-text">Pending Payment</span>
                                                                                <span class="payment-text-alt">
                                                                                    Click to View
                                                                                </span>
                                                                            </a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-success" style="background-color: #27ae60;">
                                                                                <i class="fas fa-check-circle"></i> Paid
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td style="text-align: center;">
                                                                    <div class="action-buttons"
                                                                        style="justify-content: center;">
                                                                        <a href="${pageContext.request.contextPath}/patients/details/${patient.id}"
                                                                            class="btn btn-primary btn-sm">
                                                                            <i class="fas fa-user"></i> View
                                                                        </a>
                                                                        <sec:authorize access="!hasRole('DOCTOR') and !hasRole('OPD_DOCTOR')">
                                                                            <button
                                                                                onclick="checkoutPatient(${patient.id})"
                                                                                class="btn btn-danger btn-sm">
                                                                                <i class="fas fa-sign-out-alt"></i>
                                                                                Check Out
                                                                            </button>
                                                                        </sec:authorize>
                                                                        <sec:authorize access="hasRole('DOCTOR') or hasRole('OPD_DOCTOR')">
                                                                            <div class="tooltip-container">
                                                                                <button class="btn btn-secondary btn-sm"
                                                                                    style="opacity: 0.6; cursor: not-allowed; background: #6c757d; border-color: #6c757d;"
                                                                                    disabled>
                                                                                    <i class="fas fa-sign-out-alt"></i>
                                                                                    Check Out
                                                                                </button>
                                                                                <span class="tooltip-text">Please
                                                                                    contact front desk/receptionist to
                                                                                    checkout</span>
                                                                            </div>
                                                                        </sec:authorize>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-patients-message">
                                                    <i class="fas fa-info-circle"></i> No patients currently waiting.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            // Simple notification function
                            function showNotification(message, isError) {
                                // Create notification element
                                const notification = document.createElement('div');
                                notification.style.position = 'fixed';
                                notification.style.top = '20px';
                                notification.style.right = '20px';
                                notification.style.padding = '12px 20px';
                                notification.style.borderRadius = '6px';
                                notification.style.color = 'white';
                                notification.style.fontWeight = '500';
                                notification.style.zIndex = '9999';
                                notification.style.maxWidth = '300px';
                                notification.style.wordWrap = 'break-word';
                                notification.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
                                notification.style.transition = 'all 0.3s ease';
                                notification.style.background = isError ? '#dc3545' : '#28a745';
                                notification.textContent = message;

                                document.body.appendChild(notification);

                                // Remove after 3 seconds
                                setTimeout(function () {
                                    if (notification.parentNode) {
                                        notification.parentNode.removeChild(notification);
                                    }
                                }, 3000);
                            }

                            // Table sorting functionality
                            let sortDirection = 'asc'; // Default sort is ascending (earliest first)

                            function sortTable() {
                                const table = document.querySelector('.table');
                                const tbody = table.querySelector('tbody');
                                const rows = Array.from(tbody.querySelectorAll('tr'));

                                // Toggle sort direction
                                sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';

                                // Update sort icon
                                const sortIcon = document.querySelector('.sortable-header i');
                                sortIcon.className = sortDirection === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';

                                // Sort rows based on check-in time
                                rows.sort((a, b) => {
                                    const timeA = getCheckInTime(a);
                                    const timeB = getCheckInTime(b);

                                    if (timeA === null && timeB === null) return 0;
                                    if (timeA === null) return 1;
                                    if (timeB === null) return -1;

                                    if (sortDirection === 'asc') {
                                        return timeA - timeB;
                                    } else {
                                        return timeB - timeA;
                                    }
                                });

                                // Reorder rows in the table
                                rows.forEach(row => tbody.appendChild(row));

                                // Update row numbers
                                updateRowNumbers();

                                // Show notification
                                const direction = sortDirection === 'asc' ? 'earliest first' : 'latest first';
                                showNotification(`Sorted by check-in time: ${direction}`, false);
                            }

                            function getCheckInTime(row) {
                                const timeCell = row.querySelector('td:nth-child(3)'); // Check-in time column
                                const timeText = timeCell.textContent.trim();

                                if (timeText === 'Not available') return null;

                                // Parse time like "02:30 PM" to get minutes since midnight
                                const timeMatch = timeText.match(/(\d{1,2}):(\d{2})\s*(AM|PM)/i);
                                if (!timeMatch) return null;

                                let hours = parseInt(timeMatch[1]);
                                const minutes = parseInt(timeMatch[2]);
                                const period = timeMatch[3].toUpperCase();

                                if (period === 'PM' && hours !== 12) hours += 12;
                                if (period === 'AM' && hours === 12) hours = 0;

                                return hours * 60 + minutes;
                            }

                            function updateRowNumbers() {
                                const rows = document.querySelectorAll('.table tbody tr');
                                rows.forEach((row, index) => {
                                    const numberCell = row.querySelector('td:first-child');
                                    if (numberCell) {
                                        numberCell.textContent = index + 1;
                                    }
                                });
                            }

                            // Image Modal functionality
                            const modal = document.getElementById("imageModal");
                            const modalImg = document.getElementById("modalImage");
                            const closeBtn = document.getElementsByClassName("modal-close")[0];

                            function openImageModal(imgSrc) {
                                modal.style.display = "block";
                                modalImg.src = imgSrc;
                            }

                            // Close modal when clicking the close button
                            closeBtn.onclick = function () {
                                modal.style.display = "none";
                            }

                            // Close modal when clicking outside the image
                            modal.onclick = function (event) {
                                if (event.target === modal) {
                                    modal.style.display = "none";
                                }
                            }

                            // Close modal with Escape key
                            document.addEventListener('keydown', function (event) {
                                if (event.key === "Escape") {
                                    modal.style.display = "none";
                                }
                            });

                            function checkoutPatient(patientId) {
                                if (confirm('Are you sure you want to check out this patient?')) {
                                    $.ajax({
                                        url: '${pageContext.request.contextPath}/patients/uncheck/' + patientId,
                                        type: 'POST',
                                        headers: {
                                            'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content')
                                        },
                                        success: function (response) {
                                            location.reload();
                                        },
                                        error: function () {
                                            alert('An error occurred while checking out the patient.');
                                        }
                                    });
                                }
                            }

                            function checkInPatient(patientId) {
                                const csrfToken = document.querySelector("meta[name='_csrf']").content;

                                fetch(`${pageContext.request.contextPath}/patients/checkin/${patientId}`, {
                                    method: 'POST',
                                    headers: {
                                        'X-CSRF-TOKEN': csrfToken
                                    }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            showNotification('Patient checked in successfully');
                                            window.location.reload();
                                        } else {
                                            showNotification(data.message || 'Error checking in patient', true);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        showNotification('Error checking in patient', true);
                                    });
                            }

                            // Initialize and update waiting times
                            function updateWaitingTimes() {
                                const now = new Date();

                                document.querySelectorAll('.waiting-time').forEach(function (element) {
                                    const checkInTimeStr = element.getAttribute('data-checkin');
                                    if (checkInTimeStr) {
                                        const checkInTime = new Date(checkInTimeStr);
                                        const diffMs = now - checkInTime;

                                        // Calculate hours, minutes, seconds
                                        const totalSeconds = Math.floor(diffMs / 1000);
                                        const hours = Math.floor(totalSeconds / 3600);
                                        const minutes = Math.floor((totalSeconds % 3600) / 60);
                                        const seconds = totalSeconds % 60;

                                        // Format the time with leading zeros
                                        const timeDisplay = [
                                            hours.toString().padStart(2, '0'),
                                            minutes.toString().padStart(2, '0'),
                                            seconds.toString().padStart(2, '0')
                                        ].join(':');

                                        // Update the time value
                                        const timeValueElement = element.querySelector('.time-value');
                                        if (timeValueElement) {
                                            timeValueElement.textContent = timeDisplay;
                                        }

                                        // Update the styling based on waiting time
                                        element.classList.remove('short', 'medium', 'long');
                                        const totalMinutes = hours * 60 + minutes;
                                        if (totalMinutes < 15) {
                                            element.classList.add('short');
                                        } else if (totalMinutes < 30) {
                                            element.classList.add('medium');
                                        } else {
                                            element.classList.add('long');
                                        }
                                    }
                                });
                            }

                            // Initial update
                            updateWaitingTimes();

                            // Update every second
                            setInterval(updateWaitingTimes, 1000);

                            // Avatar Info functionality
                            function showAvatarInfo(firstName, lastName, gender, age) {
                                // Create tooltip content
                                var ageGroup = '';
                                if (age < 18) {
                                    ageGroup = 'Child';
                                } else if (age < 60) {
                                    ageGroup = 'Adult';
                                } else {
                                    ageGroup = 'Senior';
                                }

                                // Create and show a simple tooltip
                                var tooltip = document.createElement('div');
                                tooltip.className = 'avatar-tooltip show';
                                tooltip.innerHTML = firstName + ' ' + lastName + '<br>' +
                                    '<small>' + gender + ' • ' + age + ' years (' + ageGroup + ')</small><br>' +
                                    '<small><i>No profile picture available</i></small>';

                                // Position the tooltip near the clicked element
                                var event = window.event;
                                tooltip.style.left = (event.pageX + 10) + 'px';
                                tooltip.style.top = (event.pageY - 10) + 'px';

                                document.body.appendChild(tooltip);

                                // Remove tooltip after 3 seconds
                                setTimeout(function () {
                                    if (tooltip.parentNode) {
                                        tooltip.parentNode.removeChild(tooltip);
                                    }
                                }, 3000);
                            }

                            // Doctor assignment change functions - simplified since we use server-side rendering

                            async function changeDoctorAssignment(patientId, patientName, newDoctorId) {
                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/change-doctor-assignment', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                        },
                        body: JSON.stringify({
                            patientId: patientId,
                            doctorId: newDoctorId
                        }),
                        credentials: 'same-origin'
                    });

                    if (response.ok) {
                        const result = await response.json();
                        if (result.success) {
                            showNotification('Doctor assignment updated successfully!', false);
                            // Reload page to show updated assignment
                            setTimeout(() => {
                                window.location.reload();
                            }, 1000);
                        } else {
                            showNotification('Error: ' + (result.message || 'Failed to update doctor assignment'), true);
                            // Reset the dropdown to previous value
                            window.location.reload();
                        }
                    } else {
                        showNotification('Failed to update doctor assignment. Please try again.', true);
                        // Reset the dropdown to previous value
                        window.location.reload();
                    }
                } catch (error) {
                    console.error('Error updating doctor assignment:', error);
                    showNotification('Network error. Please try again.', true);
                    // Reset the dropdown to previous value
                    window.location.reload();
                }
            }

                            // Auto-refresh functionality has been removed

                        </script>

                        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
                            defer></script>
                    </body>

                    </html>