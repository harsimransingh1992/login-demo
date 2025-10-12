<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <meta name="_csrf" content="${_csrf.token}" />
                        <meta name="_csrf_header" content="${_csrf.headerName}" />
                        <title>Patient Payment Ledger - PeriDesk</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="${pageContext.request.contextPath}/js/common.js"></script>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
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

                            .payments-header {
                                background: white;
                                border-radius: 15px;
                                padding: 30px;
                                margin-bottom: 30px;
                                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                            }

                            .payments-title {
                                font-size: 2.2rem;
                                font-weight: 700;
                                color: #2c3e50;
                                margin: 0 0 25px 0;
                                display: flex;
                                align-items: center;
                                gap: 15px;
                            }

                            .search-section {
                                background: #f8f9fa;
                                border-radius: 12px;
                                padding: 25px;
                                margin-bottom: 30px;
                            }

                            .search-form {
                                display: flex;
                                gap: 15px;
                                align-items: center;
                                max-width: 600px;
                            }

                            .search-label {
                                display: block;
                                margin-bottom: 8px;
                                font-weight: 600;
                                color: #2c3e50;
                            }

                            .form-group {
                                flex: 3;
                                margin: 0;
                            }

                            .search-input {
                                width: 100%;
                                padding: 12px 16px;
                                border: 2px solid #e9ecef;
                                border-radius: 8px;
                                font-size: 1rem;
                                transition: all 0.3s ease;
                            }

                            .search-input:focus {
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

                            .btn-info {
                                background: linear-gradient(135deg, #17a2b8, #138496);
                                color: white;
                            }

                            .btn-info:hover {
                                background: linear-gradient(135deg, #138496, #117a8b);
                                transform: translateY(-2px);
                                box-shadow: 0 4px 12px rgba(23, 162, 184, 0.3);
                            }

                            .btn-secondary {
                                background: #6c757d;
                                color: white;
                            }

                            .btn-cancel {
                                background: #6c757d;
                                color: white;
                            }

                            .patient-info {
                                background: white;
                                border-radius: 15px;
                                padding: 25px;
                                margin-bottom: 30px;
                                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                                display: none;
                            }

                            .patient-info.show {
                                display: block;
                            }

                            .patient-header {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                margin-bottom: 20px;
                                padding-bottom: 15px;
                                border-bottom: 2px solid #f1f3f4;
                            }

                            .patient-name {
                                font-size: 1.5rem;
                                font-weight: 700;
                                color: #2c3e50;
                            }

                            .patient-meta {
                                display: flex;
                                gap: 20px;
                                color: #7f8c8d;
                                font-size: 0.95rem;
                            }

                            .examinations-section {
                                background: white;
                                border-radius: 15px;
                                padding: 25px;
                                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                            }

                            .section-title {
                                font-size: 1.3rem;
                                font-weight: 600;
                                color: #2c3e50;
                                margin-bottom: 20px;
                                display: flex;
                                align-items: center;
                                gap: 10px;
                            }

                            .examinations-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
                                gap: 20px;
                            }

                            .examination-card {
                                border: 2px solid #e9ecef;
                                border-radius: 12px;
                                padding: 15px;
                                transition: all 0.3s ease;
                                margin-bottom: 10px;
                            }

                            .examination-card:hover {
                                border-color: #3498db;
                                box-shadow: 0 4px 12px rgba(52, 152, 219, 0.1);
                            }

                            .examination-header {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                margin-bottom: 10px;
                            }

                            .examination-title {
                                font-weight: 600;
                                color: #2c3e50;
                                font-size: 1rem;
                            }

                            .payment-status {
                                padding: 4px 12px;
                                border-radius: 20px;
                                font-size: 0.8rem;
                                font-weight: 600;
                            }

                            .status-pending {
                                background: #fff3cd;
                                color: #856404;
                            }

                            .status-partial {
                                background: #d1ecf1;
                                color: #0c5460;
                            }

                            .status-completed {
                                background: #d4edda;
                                color: #155724;
                            }

                            .status-no_charge {
                                background: #e2e3e5;
                                color: #383d41;
                            }

                            .text-success {
                                color: #28a745 !important;
                            }

                            .text-danger {
                                color: #dc3545 !important;
                            }

                            .text-warning {
                                color: #ffc107 !important;
                            }

                            .examination-details {
                                margin-bottom: 15px;
                            }

                            .detail-row {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                margin-bottom: 8px;
                                flex-wrap: wrap;
                                gap: 15px;
                            }

                            .detail-item {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                font-size: 0.9rem;
                            }

                            .detail-label {
                                color: #7f8c8d;
                                font-weight: 500;
                            }

                            .detail-value {
                                font-weight: 600;
                                color: #2c3e50;
                            }

                            .payment-actions {
                                display: flex;
                                gap: 8px;
                                justify-content: flex-end;
                            }

                            .no-records {
                                text-align: center;
                                padding: 60px 20px;
                                color: #7f8c8d;
                            }

                            .no-records i {
                                font-size: 3rem;
                                margin-bottom: 20px;
                                color: #bdc3c7;
                            }

                            .overlay {
                                position: fixed;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                background: rgba(0, 0, 0, 0.5);
                                z-index: 999;
                                display: none;
                            }

                            .overlay.show {
                                display: block;
                            }

                            .payment-form {
                                position: fixed;
                                top: 50%;
                                left: 50%;
                                transform: translate(-50%, -50%);
                                background: white;
                                border-radius: 15px;
                                padding: 30px;
                                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                                z-index: 1000;
                                display: none;
                                max-width: 500px;
                                width: 90%;
                            }

                            .payment-form.show {
                                display: block;
                            }

                            .payment-summary {
                                background: #f8f9fa;
                                border-radius: 8px;
                                padding: 20px;
                                margin-bottom: 20px;
                            }

                            .summary-row {
                                display: flex;
                                justify-content: space-between;
                                margin-bottom: 8px;
                            }

                            .summary-label {
                                font-weight: 500;
                                color: #7f8c8d;
                            }

                            .summary-value {
                                font-weight: 600;
                                color: #2c3e50;
                            }

                            .payment-form-row {
                                display: flex;
                                flex-direction: column;
                                gap: 15px;
                                margin-bottom: 20px;
                            }

                            .payment-mode-select {
                                padding: 12px;
                                border: 2px solid #e9ecef;
                                border-radius: 8px;
                                font-size: 1rem;
                            }

                            .payment-amount-input {
                                padding: 12px;
                                border: 2px solid #e9ecef;
                                border-radius: 8px;
                                font-size: 1rem;
                            }

                            .payment-notes {
                                padding: 12px;
                                border: 2px solid #e9ecef;
                                border-radius: 8px;
                                font-size: 1rem;
                                resize: vertical;
                            }

                            .payment-form-actions {
                                display: flex;
                                gap: 15px;
                                justify-content: flex-end;
                            }

                            /* Success Modal Styles */
                            .success-modal {
                                position: fixed;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                background: rgba(0, 0, 0, 0.5);
                                z-index: 1001;
                                display: none;
                                justify-content: center;
                                align-items: center;
                            }

                            .success-modal.show {
                                display: flex;
                            }

                            .success-modal-content {
                                background: white;
                                border-radius: 20px;
                                padding: 40px;
                                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
                                text-align: center;
                                max-width: 450px;
                                width: 90%;
                                animation: successModalSlideIn 0.3s ease-out;
                            }

                            @keyframes successModalSlideIn {
                                from {
                                    opacity: 0;
                                    transform: scale(0.8) translateY(-20px);
                                }
                                to {
                                    opacity: 1;
                                    transform: scale(1) translateY(0);
                                }
                            }

                            .success-icon {
                                font-size: 4rem;
                                color: #27ae60;
                                margin-bottom: 20px;
                                animation: successIconPulse 0.6s ease-out;
                            }

                            @keyframes successIconPulse {
                                0% {
                                    transform: scale(0);
                                }
                                50% {
                                    transform: scale(1.1);
                                }
                                100% {
                                    transform: scale(1);
                                }
                            }

                            .success-title {
                                font-size: 1.5rem;
                                font-weight: 700;
                                color: #2c3e50;
                                margin: 0 0 20px 0;
                            }

                            .success-details {
                                background: #f8f9fa;
                                border-radius: 10px;
                                padding: 20px;
                                margin-bottom: 25px;
                                text-align: left;
                            }

                            .success-detail-row {
                                display: flex;
                                justify-content: space-between;
                                margin-bottom: 8px;
                                font-size: 0.95rem;
                            }

                            .success-detail-row:last-child {
                                margin-bottom: 0;
                            }

                            .success-detail-label {
                                font-weight: 500;
                                color: #7f8c8d;
                            }

                            .success-detail-value {
                                font-weight: 600;
                                color: #2c3e50;
                            }

                            .payment-history-modal {
                                position: fixed;
                                top: 50%;
                                left: 50%;
                                transform: translate(-50%, -50%);
                                background: white;
                                border-radius: 20px;
                                padding: 0;
                                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                                z-index: 1001;
                                display: none;
                                max-width: 900px;
                                width: 95%;
                                max-height: 85vh;
                                overflow-y: auto;
                            }

                            .payment-history-modal.show {
                                display: block;
                            }

                            .payment-history-header {
                                display: flex;
                                justify-content: space-between;
                                align-items: flex-start;
                                padding: 30px 30px 20px 30px;
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                border-radius: 20px 20px 0 0;
                            }

                            .payment-history-title {
                                font-size: 1.8rem;
                                font-weight: 700;
                                margin: 0 0 8px 0;
                                display: flex;
                                align-items: center;
                                gap: 12px;
                            }

                            .payment-history-close {
                                background: rgba(255, 255, 255, 0.2);
                                border: none;
                                font-size: 1.2rem;
                                color: white;
                                cursor: pointer;
                                padding: 10px;
                                border-radius: 50%;
                                transition: all 0.3s ease;
                            }

                            .payment-history-close:hover {
                                background: rgba(255, 255, 255, 0.3);
                            }

                            .payment-history-content {
                                padding: 30px;
                            }

                            .payment-history-table {
                                width: 100%;
                                border-collapse: collapse;
                            }

                            .payment-history-table th {
                                background: #f8f9fa;
                                padding: 15px 20px;
                                text-align: left;
                                font-weight: 600;
                                color: #2c3e50;
                                border-bottom: 2px solid #e9ecef;
                            }

                            .payment-history-table td {
                                padding: 15px 20px;
                                border-bottom: 1px solid #f1f3f4;
                                color: #2c3e50;
                            }

                            .payment-history-table tr:hover {
                                background: #f8f9fa;
                            }

                            .no-payments {
                                text-align: center;
                                padding: 60px 20px;
                                color: #7f8c8d;
                            }

                            .no-payments h4 {
                                font-size: 1.2rem;
                                font-weight: 600;
                                color: #2c3e50;
                                margin: 0 0 10px 0;
                            }

                            /* Today's Pending Payments Styles */
                            .today-pending-section {
                                background: white;
                                border-radius: 20px;
                                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                                margin-bottom: 30px;
                                overflow: hidden;
                            }

                            .section-header {
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                padding: 25px 30px;
                                color: white;
                            }

                            .section-title {
                                font-size: 1.5rem;
                                font-weight: 700;
                                margin: 0;
                                display: flex;
                                align-items: center;
                                gap: 12px;
                            }

                            .today-pending-content {
                                padding: 0;
                            }

                            .today-pending-content .table {
                                margin: 0;
                                border-radius: 0;
                            }

                            .today-pending-content .table th {
                                background: #f8f9fa;
                                padding: 15px 20px;
                                font-weight: 600;
                                color: #2c3e50;
                                border: none;
                                border-bottom: 2px solid #e9ecef;
                            }

                            .today-pending-content .table td {
                                padding: 15px 20px;
                                border: none;
                                border-bottom: 1px solid #f1f3f4;
                                color: #2c3e50;
                            }

                            .today-pending-content .table tr:hover {
                                background: #f8f9fa;
                            }

                            .loading-spinner {
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                gap: 10px;
                                padding: 40px;
                                color: #7f8c8d;
                            }

                            .loading-spinner i {
                                font-size: 1.2rem;
                            }

                            .collect-payment-btn {
                                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                                border: none;
                                color: white;
                                padding: 8px 16px;
                                border-radius: 8px;
                                font-size: 0.9rem;
                                font-weight: 600;
                                cursor: pointer;
                                transition: all 0.3s ease;
                                display: flex;
                                align-items: center;
                                gap: 6px;
                            }

                            .collect-payment-btn:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
                            }

                            .examination-id-link {
                                color: #667eea;
                                text-decoration: none;
                                font-weight: 600;
                            }

                            .examination-id-link:hover {
                                color: #764ba2;
                                text-decoration: underline;
                            }

                            .examination-id {
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                padding: 4px 8px;
                                border-radius: 6px;
                                font-size: 0.85rem;
                                font-weight: 600;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="welcome-container">
                            <jsp:include page="/WEB-INF/views/common/menu.jsp" />
                            <div class="main-content">
                                <div class="payments-header">
                                    <h1 class="payments-title">
                                        <i class="fas fa-book"></i>
                                        Patient Payment Ledger
                                    </h1>
                                    <p style="color: #7f8c8d; margin: 0;">Complete payment history and transaction
                                        ledger for all patient examinations</p>
                                </div>

                                <div class="today-pending-section">
                                    <div class="section-header">
                                        <h2 class="section-title">
                                            <i class="fas fa-calendar-day"></i>
                                            Today's Pending Payments
                                        </h2>
                                    </div>
                                    <div class="today-pending-content" id="todayPendingContent">
                                        <table class="table table-striped" id="todayPendingTable">
                                            <thead>
                                                <tr>
                                                    <th>Examination ID</th>
                                                    <th>Registration Code</th>
                                                    <th>Patient Name</th>
                                                    <th>Phone Number</th>
                                                    <th>Procedure</th>
                                                    <th>Total Amount</th>
                                                    <th>Paid Amount</th>
                                                    <th>Remaining Amount</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td colspan="9" class="text-center">
                                                        <div class="loading-spinner" id="todayLoadingSpinner">
                                                            <i class="fas fa-spinner fa-spin"></i>
                                                            Loading today's pending payments...
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="search-section">
                                    <label for="registrationCode" class="search-label">Patient Registration Code</label>
                                    <form class="search-form" id="patientSearchForm" onsubmit="return false;">
                                        <input type="text" id="registrationCode" name="registrationCode"
                                            class="search-input" placeholder="Enter registration code" required>
                                        <button type="button" class="btn btn-primary search-btn"
                                            onclick="handleSearch()">
                                            <i class="fas fa-search"></i>
                                            Search Patient
                                        </button>
                                    </form>
                                </div>

                                <div class="patient-info" id="patientInfo">
                                    <div class="patient-header">
                                        <div>
                                            <div class="patient-name" id="patientName"></div>
                                            <div class="patient-meta" id="patientMeta"></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="examinations-section" id="examinationsSection" style="display: none;">
                                    <h2 class="section-title">
                                        <i class="fas fa-stethoscope"></i>
                                        Examinations & Payments
                                    </h2>
                                    <div class="examinations-grid" id="examinationsGrid">
                                        <!-- Examinations will be loaded here -->
                                    </div>
                                </div>

                                <div class="no-records" id="noRecords">
                                    <i class="fas fa-search"></i>
                                    <p>Search for a patient by registration code to view their complete payment history
                                        and transaction ledger.</p>
                                </div>
                            </div>
                        </div>

                        <div class="overlay" id="overlay"></div>

                        <div class="payment-form" id="paymentForm">
                            <h3 style="margin-top: 0; color: #2c3e50;">Collect Payment</h3>
                            <div class="payment-summary" id="paymentSummary">
                                <!-- Payment summary will be populated here -->
                            </div>
                            <div class="payment-form-row">
                                <select class="payment-mode-select" name="paymentMode" required>
                                    <option value="">Select Payment Mode</option>
                                    <option value="CASH">Cash</option>
                                    <option value="CARD">Card</option>
                                    <option value="UPI">UPI</option>
                                    <option value="NET_BANKING">Net Banking</option>
                                    <option value="INSURANCE">Insurance</option>
                                    <option value="EMI">EMI</option>
                                </select>
                                <input type="number" class="payment-amount-input" name="paymentAmount"
                                    placeholder="Enter payment amount" step="1" inputmode="numeric" pattern="[0-9]*" required>
                                <div class="input-error" id="paymentError" style="display:none; color:#b91c1c; font-size:12px; margin-top:6px;">Please select a payment mode and enter a valid amount.</div>
                                <textarea class="payment-notes" name="paymentNotes"
                                    placeholder="Payment notes (optional)" rows="3"></textarea>
                            </div>
                            <div class="payment-form-actions">
                                <button type="button" class="btn btn-cancel" onclick="hidePaymentForm()">
                                    <i class="fas fa-times"></i>
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-success" onclick="collectPayment()">
                                    <i class="fas fa-check"></i>
                                    Confirm Payment
                                </button>
                            </div>
                        </div>

                        <!-- Success Modal -->
                        <div class="success-modal" id="successModal">
                            <div class="success-modal-content">
                                <div class="success-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <h3 class="success-title">Payment Collected Successfully!</h3>
                                <div class="success-details" id="successDetails">
                                    <!-- Payment details will be populated here -->
                                </div>
                                <button type="button" class="btn btn-primary" onclick="hideSuccessModal()">
                                    <i class="fas fa-check"></i>
                                    OK
                                </button>
                            </div>
                        </div>

                        <!-- Payment History Modal -->
                        <div class="payment-history-modal" id="paymentHistoryModal">
                            <div class="payment-history-header">
                                <div class="header-content">
                                    <h2 class="payment-history-title">
                                        <i class="fas fa-receipt"></i>
                                        Payment History
                                    </h2>
                                </div>
                                <button class="payment-history-close" onclick="hidePaymentHistory()" title="Close">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>

                            <div class="payment-history-content">
                                <table class="payment-history-table" id="paymentHistoryTable">
                                    <thead>
                                        <tr>
                                            <th>Date & Time</th>
                                            <th>Type</th>
                                            <th>Payment Mode</th>
                                            <th>Amount</th>
                                            <th>Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Payment history rows will be dynamically added here -->
                                    </tbody>
                                </table>

                                <div class="no-payments" id="noPayments">
                                    <h4>No Payments Found</h4>
                                    <p>No payment records have been made for this examination yet.</p>
                                </div>
                            </div>
                        </div>

                        <script>
                            let currentExaminationId = null;
                            let currentPatient = null;

                            function handleSearch() {
                                const registrationCode = document.getElementById('registrationCode').value.trim();
                                if (!registrationCode) {
                                    alert('Please enter a registration code');
                                    return;
                                }
                                searchPatient(registrationCode);
                            }

                            // Also handle Enter key press
                            document.getElementById('registrationCode').addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault();
                                    handleSearch();
                                }
                            });

                            function searchPatient(registrationCode) {
                                // Show loading state
                                const searchBtn = document.querySelector('.search-btn');
                                const originalText = searchBtn.innerHTML;
                                searchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Searching...';
                                searchBtn.disabled = true;

                                fetch('${pageContext.request.contextPath}/payments/search-patient?registrationCode=' + encodeURIComponent(registrationCode))
                                    .then(response => response.json())
                                    .then(data => {
                                        console.log('Search response:', data);
                                        if (data.success) {
                                            displayPatientInfo(data.patient);
                                            displayExaminations(data.examinations);
                                        } else {
                                            alert('Patient not found: ' + data.message);
                                            // Hide patient info if search fails
                                            document.getElementById('patientInfo').classList.remove('show');
                                            document.getElementById('examinationsSection').style.display = 'none';
                                            document.getElementById('noRecords').style.display = 'block';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('Error searching for patient');
                                    })
                                    .finally(() => {
                                        // Restore button state
                                        searchBtn.innerHTML = originalText;
                                        searchBtn.disabled = false;
                                    });
                            }

                            function displayPatientInfo(patient) {
                                currentPatient = patient;
                                document.getElementById('patientName').textContent = patient.firstName + ' ' + patient.lastName;
                                document.getElementById('patientMeta').innerHTML =
                                    '<span><i class="fas fa-id-card"></i> ' + patient.registrationCode + '</span>' +
                                    '<span><i class="fas fa-phone"></i> ' + patient.phoneNumber + '</span>' +
                                    '<span><i class="fas fa-birthday-cake"></i> Age: ' + patient.age + '</span>';
                                document.getElementById('patientInfo').classList.add('show');
                            }

                            function displayExaminations(examinations) {
                                const grid = document.getElementById('examinationsGrid');
                                const section = document.getElementById('examinationsSection');
                                const noRecords = document.getElementById('noRecords');

                                if (examinations.length === 0) {
                                    section.style.display = 'none';
                                    noRecords.style.display = 'block';
                                    noRecords.innerHTML = '<i class="fas fa-info-circle"></i><p>No examinations found for this patient.</p>';
                                    return;
                                }

                                section.style.display = 'block';
                                noRecords.style.display = 'none';

                                grid.innerHTML = examinations.map(exam => {
                                    const totalPaid = exam.totalPaidAmount || 0;
                                    const totalRefunded = exam.totalRefunded || 0;
                                    const netPaid = exam.netPaidAmount || 0;
                                    const remaining = exam.remainingAmount || 0;
                                    const status = exam.paymentStatus || 'PENDING';
                                    const paymentCount = exam.paymentCount || 0;

                                    // Determine action buttons based on status
                                    let actionButton = '';
                                    if (remaining > 0) {
                                        actionButton = '<button class="btn btn-success" onclick="showPaymentForm(' + exam.id + ', ' + remaining + ')">' +
                                            '<i class="fas fa-money-bill-wave"></i>' +
                                            'Collect Payment' +
                                            '</button>';
                                    } else if (status === 'COMPLETED') {
                                        actionButton = '<span class="btn btn-secondary" style="cursor: default;">' +
                                            '<i class="fas fa-check"></i>' +
                                            'Payment Complete' +
                                            '</span>';
                                    } else if (status === 'NO_CHARGE') {
                                        actionButton = '<span class="btn btn-light" style="cursor: default;">' +
                                            '<i class="fas fa-gift"></i>' +
                                            'No Charge' +
                                            '</span>';
                                    }

                                    // Payment history button
                                    let historyButton = '';
                                    if (paymentCount > 0) {
                                        historyButton = '<button class="btn btn-info" onclick="viewPaymentHistory(' + exam.id + ')">' +
                                            '<i class="fas fa-history"></i>' +
                                            'Payment History (' + paymentCount + ')' +
                                            '</button>';
                                    } else {
                                        historyButton = '<button class="btn btn-info" onclick="viewPaymentHistory(' + exam.id + ')">' +
                                            '<i class="fas fa-history"></i>' +
                                            'Payment History' +
                                            '</button>';
                                    }

                                    // Enhanced examination card
                                    return '<div class="examination-card" data-examination-id="' + exam.id + '">' +
                                        '<div class="examination-header">' +
                                        '<div class="examination-title">' +
                                        'Tooth ' + exam.toothNumber + ' - ' + (exam.procedure ? exam.procedure.procedureName : 'No Procedure') +
                                        '</div>' +
                                        '<span class="payment-status status-' + status.toLowerCase() + '">' + getStatusDisplayName(status) + '</span>' +
                                        '</div>' +
                                        '<div class="examination-details">' +
                                        '<div class="detail-row">' +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-id-badge"></i> Exam ID:</span>' +
                                        '<span class="detail-value">' + exam.id + '</span>' +
                                        '</div>' +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-calendar"></i> Date:</span>' +
                                        '<span class="detail-value">' + formatDate(exam.examinationDate) + '</span>' +
                                        '</div>' +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-file-invoice-dollar"></i> Total:</span>' +
                                        '<span class="detail-value">₹' + (exam.totalProcedureAmount || 0) + '</span>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="detail-row">' +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-check-circle"></i> Paid:</span>' +
                                        '<span class="detail-value text-success">₹' + totalPaid + '</span>' +
                                        '</div>' +
                                        (totalRefunded > 0 ?
                                            '<div class="detail-item">' +
                                            '<span class="detail-label"><i class="fas fa-undo"></i> Refunded:</span>' +
                                            '<span class="detail-value text-danger">₹' + totalRefunded + '</span>' +
                                            '</div>' : '') +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-calculator"></i> Net:</span>' +
                                        '<span class="detail-value">₹' + netPaid + '</span>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="detail-row">' +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-clock"></i> Remaining:</span>' +
                                        '<span class="detail-value ' + (remaining > 0 ? 'text-warning' : 'text-success') + '">₹' + remaining + '</span>' +
                                        '</div>' +
                                        '<div class="detail-item">' +
                                        '<span class="detail-label"><i class="fas fa-receipt"></i> Transactions:</span>' +
                                        '<span class="detail-value">' + paymentCount + '</span>' +
                                        '</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="payment-actions">' +
                                        actionButton +
                                        historyButton +
                                        '</div>' +
                                        '</div>';
                                }).join('');
                            }

                            // Helper functions
                            function getStatusDisplayName(status) {
                                switch (status) {
                                    case 'PENDING': return 'Pending';
                                    case 'PARTIAL': return 'Partial';
                                    case 'COMPLETED': return 'Completed';
                                    case 'NO_CHARGE': return 'No Charge';
                                    default: return status;
                                }
                            }

                            function formatDate(dateString) {
                                if (!dateString) return 'N/A';
                                const date = new Date(dateString);
                                return date.toLocaleDateString('en-IN');
                            }

                            // Payment form functions
                            function showPaymentForm(examinationId, remainingAmount) {
                                currentExaminationId = examinationId;
                                document.getElementById('paymentSummary').innerHTML =
                                    '<div class="summary-row">' +
                                    '<span class="summary-label">Examination ID:</span>' +
                                    '<span class="summary-value">' + examinationId + '</span>' +
                                    '</div>' +
                                    '<div class="summary-row">' +
                                    '<span class="summary-label">Remaining Amount:</span>' +
                                    '<span class="summary-value">₹' + Math.floor(Number(remainingAmount || 0)) + '</span>' +
                                    '</div>';

                                document.getElementById('paymentForm').classList.add('show');
                                document.getElementById('overlay').classList.add('show');

                                // Prefill amount and set max to remaining
                                const amountInput = document.querySelector('.payment-amount-input');
                                const rem = Number(remainingAmount || 0);
                                const remInt = Math.floor(rem);
                                if (amountInput) {
                                    amountInput.value = remInt > 0 ? String(remInt) : '';
                                    amountInput.setAttribute('max', remInt);
                                }
                                // Reset any previous error and validate
                                const errorEl = document.getElementById('paymentError');
                                if (errorEl) { errorEl.style.display = 'none'; }
                                validatePaymentForm();
                            }

                            function hidePaymentForm() {
                                document.getElementById('paymentForm').classList.remove('show');
                                document.getElementById('overlay').classList.remove('show');

                                // Reset form
                                document.querySelector('.payment-mode-select').value = '';
                                document.querySelector('.payment-amount-input').value = '';
                                document.querySelector('.payment-notes').value = '';

                                // Reset processing state and button when form is closed
                                isProcessingPayment = false;
                                const confirmButton = document.querySelector('button[onclick="collectPayment()"]');
                                if (confirmButton) {
                                    confirmButton.disabled = false;
                                    confirmButton.innerHTML = '<i class="fas fa-check"></i> Confirm Payment';
                                    confirmButton.style.opacity = '1';
                                }
                            }

                            // Variable to track payment processing state
                            let isProcessingPayment = false;
                            let lastClickTime = 0;
                            const DEBOUNCE_DELAY = 1000; // 1 second debounce

                            function collectPayment() {
                                const currentTime = Date.now();
                                
                                // Prevent multiple clicks during processing
                                if (isProcessingPayment) {
                                    return;
                                }

                                // Debounce mechanism - prevent rapid successive clicks
                                if (currentTime - lastClickTime < DEBOUNCE_DELAY) {
                                    return;
                                }
                                lastClickTime = currentTime;

                                const form = document.getElementById('paymentForm');
                                const paymentMode = form.querySelector('select[name="paymentMode"]').value;
                                const amountInput = form.querySelector('input[name="paymentAmount"]');
                                // sanitize and parse integer amount
                                const amountRaw = (amountInput.value || '').trim();
                                const amountSanitized = amountRaw.replace(/[^\d]/g, '');
                                if (amountSanitized !== amountRaw) { amountInput.value = amountSanitized; }
                                const amount = parseInt(amountSanitized, 10);
                                const notes = form.querySelector('textarea[name="paymentNotes"]').value;
                                const confirmButton = form.querySelector('button[onclick="collectPayment()"]');

                                // Run validation, including remaining cap
                                if (!validatePaymentForm()) {
                                    return;
                                }

                                // Validate payment mode
                                if (!paymentMode) {
                                    alert('Please select a payment mode.');
                                    return;
                                }

                                // Validate payment amount
                                if (!Number.isInteger(amount) || amount <= 0) {
                                    alert('Please enter a valid payment amount.');
                                    amountInput.focus();
                                    return;
                                }

                                // Set processing state and disable button
                                isProcessingPayment = true;
                                if (confirmButton) {
                                    confirmButton.disabled = true;
                                    confirmButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                                    confirmButton.style.opacity = '0.6';
                                }

                                const requestData = {
                                    examinationId: currentExaminationId,
                                    paymentMode: paymentMode,
                                    notes: notes,
                                    paymentDetails: {
                                        amount: amount
                                    }
                                };

                                fetch('${pageContext.request.contextPath}/payments/collect', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        'X-CSRF-TOKEN': document.querySelector("meta[name='_csrf']").content
                                    },
                                    body: JSON.stringify(requestData)
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            hidePaymentForm();
                                            
                                            // Show success modal with payment details
                                            showSuccessModal(data.payment, requestData);

                                            // Refresh the patient data
                                            if (currentPatient && currentPatient.registrationCode) {
                                                searchPatient(currentPatient.registrationCode);
                                            }
                                        } else {
                                            alert('Error: ' + data.message);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('Error collecting payment');
                                    })
                                    .finally(() => {
                                        // Reset processing state and re-enable button
                                        isProcessingPayment = false;
                                        if (confirmButton) {
                                            confirmButton.disabled = false;
                                            confirmButton.innerHTML = '<i class="fas fa-check"></i> Confirm Payment';
                                            confirmButton.style.opacity = '1';
                                        }
                                    });
                            }

                            // Validate payment mode and amount against remaining
                            function validatePaymentForm() {
                                const form = document.getElementById('paymentForm');
                                const paymentMode = form.querySelector('select[name="paymentMode"]').value;
                                const amountInput = form.querySelector('input[name="paymentAmount"]');
                                // sanitize input to digits only
                                const raw = (amountInput.value || '').trim();
                                const sanitized = raw.replace(/[^\d]/g, '');
                                if (sanitized !== raw) { amountInput.value = sanitized; }
                                const amount = parseInt(sanitized, 10);
                                const maxRemaining = parseInt(amountInput.getAttribute('max') || '0', 10);
                                const confirmButton = form.querySelector('button[onclick="collectPayment()"]');
                                const errorEl = document.getElementById('paymentError');
                                let valid = true;
                                let message = '';

                                if (!paymentMode) {
                                    valid = false;
                                    message = 'Please select a payment mode.';
                                } else if (!Number.isInteger(amount) || isNaN(amount) || amount <= 0) {
                                    valid = false;
                                    message = 'Please enter a valid amount greater than 0.';
                                } else if (amount > maxRemaining) {
                                    valid = false;
                                    const maxStr = '₹' + (Number.isFinite(maxRemaining) ? maxRemaining : 0);
                                    message = 'Amount exceeds remaining balance (' + maxStr + ').';
                                }

                                if (confirmButton) {
                                    confirmButton.disabled = !valid;
                                    confirmButton.style.opacity = valid ? '1' : '0.6';
                                }
                                if (errorEl) {
                                    if (!valid) {
                                        errorEl.textContent = message;
                                        errorEl.style.display = 'block';
                                    } else {
                                        errorEl.style.display = 'none';
                                    }
                                }
                                return valid;
                            }

                            // Re-validate on input changes inside the form
                            document.addEventListener('input', function(e) {
                                if (e.target.closest('#paymentForm')) {
                                    // enforce digits-only on amount input
                                    if (e.target.matches('.payment-amount-input')) {
                                        const raw = (e.target.value || '').trim();
                                        const sanitized = raw.replace(/[^\d]/g, '');
                                        if (sanitized !== raw) { e.target.value = sanitized; }
                                    }
                                    validatePaymentForm();
                                }
                            });

                            // Payment History Functions
                            function viewPaymentHistory(examinationId) {
                                // Show the modal first
                                document.getElementById('paymentHistoryModal').classList.add('show');
                                document.getElementById('overlay').classList.add('show');

                                // Load payment history data
                                fetch('${pageContext.request.contextPath}/payments/payment-history/' + examinationId)
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            displayPaymentHistory(data);
                                        } else {
                                            alert('Error: ' + data.message);
                                            hidePaymentHistory();
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('Error loading payment history');
                                        hidePaymentHistory();
                                    });
                            }

                            function displayPaymentHistory(data) {
                                const payments = data.payments;

                                // Update payment history table
                                const tableBody = document.querySelector('#paymentHistoryTable tbody');
                                const noPayments = document.getElementById('noPayments');

                                if (payments.length === 0) {
                                    tableBody.innerHTML = '';
                                    noPayments.style.display = 'block';
                                } else {
                                    noPayments.style.display = 'none';
                                    tableBody.innerHTML = payments.map(payment => {
                                        const paymentDate = formatDate(payment.paymentDate);
                                        const paymentAmount = '₹' + payment.amount;
                                        const paymentNotes = payment.notes || '-';
                                        const transactionType = payment.transactionType || 'CAPTURE';

                                        return '<tr>' +
                                            '<td>' + paymentDate + '</td>' +
                                            '<td>' + transactionType + '</td>' +
                                            '<td>' + payment.paymentMode + '</td>' +
                                            '<td><strong>' + paymentAmount + '</strong></td>' +
                                            '<td>' + paymentNotes + '</td>' +
                                            '</tr>';
                                    }).join('');
                                }
                            }

                            function hidePaymentHistory() {
                                document.getElementById('paymentHistoryModal').classList.remove('show');
                                document.getElementById('overlay').classList.remove('show');
                            }

                            // Today's Pending Payments Functions
                            function loadTodayPendingPayments() {
                                fetch('${pageContext.request.contextPath}/payments/today-pending')
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            const examinations = data.examinations || [];
                                            const tbody = document.querySelector('#todayPendingTable tbody');
                                            tbody.innerHTML = '';

                                            if (examinations.length === 0) {
                                                tbody.innerHTML = '<tr><td colspan="9" class="text-center">No pending payments for today</td></tr>';
                                            } else {
                                                examinations.forEach(function(exam) {
                                                    const row = '<tr>' +
                                                        '<td><a href="${pageContext.request.contextPath}/patients/examination/' + exam.id + '" class="examination-id-link"><span class="examination-id">' + exam.id + '</span></a></td>' +
                                                        '<td>' + (exam.patient ? exam.patient.registrationCode : 'N/A') + '</td>' +
                                                        '<td>' + (exam.patient ? exam.patient.firstName + ' ' + exam.patient.lastName : 'N/A') + '</td>' +
                                                        '<td>' + (exam.patient ? exam.patient.phoneNumber : 'N/A') + '</td>' +
                                                        '<td>' + (exam.procedure ? exam.procedure.procedureName : 'N/A') + '</td>' +
                                                        '<td>₹' + (exam.totalProcedureAmount || 0) + '</td>' +
                                                        '<td>₹' + (exam.totalPaidAmount || 0) + '</td>' +
                                                        '<td>₹' + (exam.remainingAmount || 0) + '</td>' +
                                                        '<td>' +
                                                            '<button class="btn btn-success collect-payment-btn" onclick="showPaymentForm(' + exam.id + ', ' + exam.remainingAmount + ')">' +
                                                                '<i class="fas fa-money-bill-wave"></i>' +
                                                                'Collect Payment' +
                                                            '</button>' +
                                                        '</td>' +
                                                        '</tr>';
                                                    tbody.innerHTML += row;
                                                });
                                            }
                                        } else {
                                            document.querySelector('#todayPendingTable tbody').innerHTML = '<tr><td colspan="9" class="text-center text-danger">Error loading data</td></tr>';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error loading today\'s pending payments:', error);
                                        document.querySelector('#todayPendingTable tbody').innerHTML = '<tr><td colspan="9" class="text-center text-danger">Error loading data</td></tr>';
                                    });
                            }

                            // Success Modal Functions
                            function showSuccessModal(paymentData, requestData) {
                                const modal = document.getElementById('successModal');
                                const detailsContainer = modal.querySelector('.success-details');
                                
                                // Format payment details
                                const paymentDate = new Date().toLocaleDateString('en-IN', {
                                    year: 'numeric',
                                    month: 'long',
                                    day: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                });
                                
                                var detailsHtml = 
                                    '<div class="success-detail-row">' +
                                        '<span class="success-detail-label">Examination ID:</span>' +
                                        '<span class="success-detail-value">' + requestData.examinationId + '</span>' +
                                    '</div>' +
                                    '<div class="success-detail-row">' +
                                        '<span class="success-detail-label">Amount Paid:</span>' +
                                        '<span class="success-detail-value">₹' + requestData.paymentDetails.amount + '</span>' +
                                    '</div>' +
                                    '<div class="success-detail-row">' +
                                        '<span class="success-detail-label">Payment Mode:</span>' +
                                        '<span class="success-detail-value">' + requestData.paymentMode + '</span>' +
                                    '</div>' +
                                    '<div class="success-detail-row">' +
                                        '<span class="success-detail-label">Date & Time:</span>' +
                                        '<span class="success-detail-value">' + paymentDate + '</span>' +
                                    '</div>';
                                
                                if (requestData.notes) {
                                    detailsHtml += 
                                        '<div class="success-detail-row">' +
                                            '<span class="success-detail-label">Notes:</span>' +
                                            '<span class="success-detail-value">' + requestData.notes + '</span>' +
                                        '</div>';
                                }
                                
                                detailsContainer.innerHTML = detailsHtml;
                                
                                modal.classList.add('show');
                            }

                            function hideSuccessModal() {
                                document.getElementById('successModal').classList.remove('show');
                            }

                            // Close modal when clicking overlay
                            document.getElementById('overlay').addEventListener('click', function () {
                                hidePaymentForm();
                                hidePaymentHistory();
                                hideSuccessModal();
                            });

                            // Close payment history modal with ESC key
                            document.addEventListener('keydown', function (e) {
                                if (e.key === 'Escape') {
                                    hidePaymentHistory();
                                    hidePaymentForm();
                                    hideSuccessModal();
                                }
                            });

                            // Initialize today's pending payments on page load
                            document.addEventListener('DOMContentLoaded', function() {
                                loadTodayPendingPayments();
                            });
                        </script>
                    </body>

                    </html>