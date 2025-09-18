<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Payment Management - PeriDesk</title>
                        <meta name="_csrf" content="${_csrf.token}" />
                        <meta name="_csrf_header" content="${_csrf.headerName}" />
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
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
                                padding: 20px;
                                position: relative;
                                overflow-x: auto;
                            }

                            /* Amazon-style header */
                            .page-header {
                                background: linear-gradient(135deg, #232f3e, #37475a);
                                color: white;
                                padding: 20px;
                                border-radius: 8px;
                                margin-bottom: 20px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            }

                            .page-title {
                                font-size: 1.8rem;
                                font-weight: 600;
                                margin: 0;
                                display: flex;
                                align-items: center;
                                gap: 12px;
                            }

                            .user-info {
                                color: #cbd5e0;
                                font-size: 0.9rem;
                                margin-top: 8px;
                            }

                            /* Amazon-style search section */
                            .search-section {
                                background: white;
                                border-radius: 8px;
                                padding: 20px;
                                margin-bottom: 20px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                border: 1px solid #e1e8ed;
                            }

                            .search-header {
                                font-size: 1.1rem;
                                font-weight: 600;
                                color: #232f3e;
                                margin-bottom: 15px;
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .search-filters {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                gap: 15px;
                                margin-bottom: 20px;
                            }

                            .filter-group {
                                display: flex;
                                flex-direction: column;
                            }

                            .filter-label {
                                font-size: 0.85rem;
                                font-weight: 500;
                                color: #555;
                                margin-bottom: 5px;
                            }

                            .form-control,
                            .form-select {
                                border: 1px solid #d5dbdb;
                                border-radius: 4px;
                                padding: 8px 12px;
                                font-size: 0.9rem;
                                transition: all 0.2s;
                            }

                            .form-control:focus,
                            .form-select:focus {
                                border-color: #ff9900;
                                box-shadow: 0 0 0 2px rgba(255, 153, 0, 0.2);
                                outline: none;
                            }

                            .search-actions {
                                display: flex;
                                gap: 10px;
                                justify-content: flex-end;
                            }

                            .btn-amazon {
                                background: #ff9900;
                                border: 1px solid #e47911;
                                color: white;
                                padding: 8px 20px;
                                border-radius: 4px;
                                font-weight: 500;
                                transition: all 0.2s;
                            }

                            .btn-amazon:hover {
                                background: #e47911;
                                color: white;
                                transform: translateY(-1px);
                            }

                            .btn-secondary-amazon {
                                background: #f7f8f8;
                                border: 1px solid #d5dbdb;
                                color: #232f3e;
                                padding: 8px 20px;
                                border-radius: 4px;
                                font-weight: 500;
                                transition: all 0.2s;
                            }

                            .btn-secondary-amazon:hover {
                                background: #e9ecef;
                                color: #232f3e;
                            }

                            /* Results section */
                            .results-section {
                                background: white;
                                border-radius: 8px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                border: 1px solid #e1e8ed;
                                overflow: hidden;
                            }

                            .results-header {
                                background: #f7f8f8;
                                padding: 15px 20px;
                                border-bottom: 1px solid #e1e8ed;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            .results-title {
                                font-size: 1rem;
                                font-weight: 600;
                                color: #232f3e;
                                margin: 0;
                            }

                            .results-count {
                                font-size: 0.85rem;
                                color: #666;
                            }

                            /* Transaction table */
                            .transaction-table {
                                width: 100%;
                                border-collapse: collapse;
                            }

                            .transaction-table th {
                                background: #f7f8f8;
                                padding: 12px;
                                text-align: left;
                                font-weight: 600;
                                font-size: 0.85rem;
                                color: #232f3e;
                                border-bottom: 1px solid #e1e8ed;
                                white-space: nowrap;
                            }

                            .transaction-table td {
                                padding: 15px 12px;
                                border-bottom: 1px solid #f0f0f0;
                                font-size: 0.9rem;
                                vertical-align: top;
                            }

                            .transaction-row {
                                transition: background-color 0.2s;
                            }

                            .transaction-row:hover {
                                background: #f8f9fa;
                            }

                            /* Transaction card for mobile */
                            .transaction-card {
                                display: none;
                                background: white;
                                border: 1px solid #e1e8ed;
                                border-radius: 8px;
                                margin-bottom: 15px;
                                padding: 15px;
                            }

                            .transaction-card-header {
                                display: flex;
                                justify-content: between;
                                align-items: flex-start;
                                margin-bottom: 10px;
                            }

                            .transaction-id {
                                font-weight: 600;
                                color: #232f3e;
                            }

                            .transaction-amount {
                                font-weight: 600;
                                font-size: 1.1rem;
                            }

                            .amount-positive {
                                color: #067d62;
                            }

                            .amount-negative {
                                color: #d13212;
                            }

                            /* Status badges */
                            .status-badge {
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.75rem;
                                font-weight: 500;
                                text-transform: uppercase;
                            }

                            .badge-success {
                                background: #d4edda;
                                color: #155724;
                            }

                            .badge-warning {
                                background: #fff3cd;
                                color: #856404;
                            }

                            .badge-danger {
                                background: #f8d7da;
                                color: #721c24;
                            }

                            .badge-info {
                                background: #d1ecf1;
                                color: #0c5460;
                            }

                            /* Transaction type badges */
                            .transaction-type-capture {
                                background: #d4edda;
                                color: #155724;
                                font-weight: 600;
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.8rem;
                            }

                            .transaction-type-refund {
                                background: #f8d7da;
                                color: #721c24;
                                font-weight: 600;
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.8rem;
                            }

                            .transaction-type-authorization {
                                background: #fff3cd;
                                color: #856404;
                                font-weight: 600;
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.8rem;
                            }

                            .transaction-type-void {
                                background: #e2e3e5;
                                color: #383d41;
                                font-weight: 600;
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.8rem;
                            }

                            /* Action buttons */
                            .action-buttons {
                                display: flex;
                                gap: 5px;
                            }

                            .btn-action {
                                padding: 4px 8px;
                                border: none;
                                border-radius: 4px;
                                font-size: 0.75rem;
                                cursor: pointer;
                                transition: all 0.2s;
                            }

                            .btn-view {
                                background: #e3f2fd;
                                color: #1976d2;
                            }

                            .btn-view:hover {
                                background: #bbdefb;
                            }

                            .btn-refund {
                                background: #ffebee;
                                color: #d32f2f;
                            }

                            .btn-refund:hover {
                                background: #ffcdd2;
                            }

                            .btn-history {
                                background: #f3e5f5;
                                color: #7b1fa2;
                            }

                            .btn-history:hover {
                                background: #e1bee7;
                            }

                            /* Pagination */
                            .pagination-container {
                                padding: 20px;
                                display: flex;
                                justify-content: between;
                                align-items: center;
                                border-top: 1px solid #e1e8ed;
                            }

                            .pagination-info {
                                font-size: 0.85rem;
                                color: #666;
                            }

                            .pagination {
                                margin: 0;
                            }

                            .page-link {
                                color: #232f3e;
                                border: 1px solid #d5dbdb;
                                padding: 6px 12px;
                            }

                            .page-link:hover {
                                background: #f7f8f8;
                                color: #232f3e;
                            }

                            .page-item.active .page-link {
                                background: #ff9900;
                                border-color: #ff9900;
                            }

                            /* Loading state */
                            .loading-overlay {
                                position: absolute;
                                top: 0;
                                left: 0;
                                right: 0;
                                bottom: 0;
                                background: rgba(255, 255, 255, 0.8);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                z-index: 1000;
                            }

                            .loading-spinner {
                                width: 40px;
                                height: 40px;
                                border: 4px solid #f3f3f3;
                                border-top: 4px solid #ff9900;
                                border-radius: 50%;
                                animation: spin 1s linear infinite;
                            }

                            @keyframes spin {
                                0% {
                                    transform: rotate(0deg);
                                }

                                100% {
                                    transform: rotate(360deg);
                                }
                            }

                            /* Empty state */
                            .empty-state {
                                text-align: center;
                                padding: 60px 20px;
                                color: #666;
                            }

                            .empty-state i {
                                font-size: 4rem;
                                color: #ccc;
                                margin-bottom: 20px;
                            }

                            .empty-state h3 {
                                color: #232f3e;
                                margin-bottom: 10px;
                            }

                            /* Responsive design */
                            @media (max-width: 768px) {
                                .main-content {
                                    padding: 15px;
                                }

                                .search-filters {
                                    grid-template-columns: 1fr;
                                }

                                .search-actions {
                                    justify-content: stretch;
                                }

                                .search-actions .btn {
                                    flex: 1;
                                }

                                .transaction-table {
                                    display: none;
                                }

                                .transaction-card {
                                    display: block;
                                }

                                .results-header {
                                    flex-direction: column;
                                    align-items: flex-start;
                                    gap: 10px;
                                }
                            }

                            /* Detail modal styles */
                            .modal-header-custom {
                                background: linear-gradient(135deg, #232f3e, #37475a);
                                color: white;
                                border-radius: 8px 8px 0 0;
                            }

                            .detail-row {
                                display: flex;
                                justify-content: space-between;
                                padding: 8px 0;
                                border-bottom: 1px solid #f0f0f0;
                            }

                            .detail-label {
                                font-weight: 500;
                                color: #666;
                                min-width: 150px;
                            }

                            .detail-value {
                                color: #232f3e;
                                font-weight: 500;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="welcome-container">
                            <jsp:include page="/WEB-INF/views/common/menu.jsp" />

                            <div class="main-content">
                                <!-- Page Header -->
                                <div class="page-header">
                                    <h1 class="page-title">
                                        <i class="fas fa-credit-card"></i>
                                        Payment Management
                                    </h1>
                                    <div class="user-info">
                                        User: ${currentUser.username} | Role: ${userRole}
                                    </div>
                                </div>

                                <!-- Search Section -->
                                <div class="search-section">
                                    <div class="search-header">
                                        <i class="fas fa-search"></i>
                                        Search Payment Transactions
                                    </div>

                                    <form id="searchForm">
                                        <div class="search-filters">
                                            <div class="filter-group">
                                                <label class="filter-label">Search Term</label>
                                                <input type="text" class="form-control" id="searchTerm"
                                                    placeholder="Enter search term...">
                                            </div>

                                            <div class="filter-group">
                                                <label class="filter-label">Search By</label>
                                                <select class="form-select" id="searchType">
                                                    <option value="ALL">All Fields</option>
                                                    <option value="EXAMINATION_ID">Examination ID</option>
                                                    <option value="PATIENT_ID">Patient ID</option>
                                                    <option value="REGISTRATION_CODE">Registration Code</option>
                                                    <option value="PATIENT_NAME">Patient Name</option>
                                                    <option value="TRANSACTION_REF">Transaction Reference</option>
                                                </select>
                                            </div>

                                            <div class="filter-group">
                                                <label class="filter-label">Payment Mode</label>
                                                <select class="form-select" id="paymentMode">
                                                    <option value="ALL">All Modes</option>
                                                    <c:forEach var="mode" items="${paymentModes}">
                                                        <option value="${mode}">${mode}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="filter-group">
                                                <label class="filter-label">Transaction Type</label>
                                                <select class="form-select" id="paymentStatus">
                                                    <option value="ALL">All Types</option>
                                                    <option value="PAYMENT">Payments</option>
                                                    <option value="REFUND">Refunds</option>
                                                </select>
                                            </div>

                                            <div class="filter-group">
                                                <label class="filter-label">Start Date</label>
                                                <input type="datetime-local" class="form-control" id="startDate">
                                            </div>

                                            <div class="filter-group">
                                                <label class="filter-label">End Date</label>
                                                <input type="datetime-local" class="form-control" id="endDate">
                                            </div>
                                        </div>

                                        <div class="search-actions">
                                            <button type="button" class="btn btn-secondary-amazon" id="clearBtn">
                                                <i class="fas fa-times"></i> Clear
                                            </button>
                                            <button type="submit" class="btn btn-amazon" id="searchBtn">
                                                <i class="fas fa-search"></i> Search
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Results Section -->
                                <div class="results-section" id="resultsSection" style="display: none;">
                                    <div class="results-header">
                                        <h3 class="results-title">Payment Transactions</h3>
                                        <span class="results-count" id="resultsCount">0 results</span>
                                    </div>

                                    <div class="position-relative">
                                        <div class="loading-overlay" id="loadingOverlay" style="display: none;">
                                            <div class="loading-spinner"></div>
                                        </div>

                                        <!-- Desktop Table View -->
                                        <table class="transaction-table" id="transactionTable">
                                            <thead>
                                                <tr>
                                                    <th>Transaction ID</th>
                                                    <th>Date & Time</th>
                                                    <th>Patient</th>
                                                    <th>Examination</th>
                                                    <th>Amount</th>
                                                    <th>Mode</th>
                                                    <th>Type</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody id="transactionTableBody">
                                            </tbody>
                                        </table>

                                        <!-- Mobile Card View -->
                                        <div id="transactionCards"></div>

                                        <!-- Empty State -->
                                        <div class="empty-state" id="emptyState" style="display: none;">
                                            <i class="fas fa-receipt"></i>
                                            <h3>No transactions found</h3>
                                            <p>Try adjusting your search criteria or date range.</p>
                                        </div>
                                    </div>

                                    <!-- Pagination -->
                                    <div class="pagination-container" id="paginationContainer">
                                        <div class="pagination-info" id="paginationInfo"></div>
                                        <nav>
                                            <ul class="pagination" id="pagination"></ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Transaction Detail Modal -->
                        <div class="modal fade" id="transactionDetailModal" tabindex="-1">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header modal-header-custom">
                                        <h5 class="modal-title">
                                            <i class="fas fa-receipt"></i>
                                            Transaction Details
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white"
                                            data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body" id="transactionDetailBody">
                                        <!-- Transaction details will be loaded here -->
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Close</button>
                                        <button type="button" class="btn btn-danger" id="refundBtn"
                                            style="display: none;">
                                            <i class="fas fa-undo"></i> Process Refund
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            $(document).ready(function () {
                                let currentPage = 0;
                                let currentSize = 20;
                                let currentData = null;

                                // Search form submission
                                $('#searchForm').on('submit', function (e) {
                                    e.preventDefault();
                                    currentPage = 0;
                                    searchTransactions();
                                });

                                // Clear button
                                $('#clearBtn').on('click', function () {
                                    $('#searchForm')[0].reset();
                                    $('#resultsSection').hide();
                                });

                                function searchTransactions() {
                                    const searchData = {
                                        searchTerm: $('#searchTerm').val(),
                                        searchType: $('#searchType').val(),
                                        paymentMode: $('#paymentMode').val(),
                                        paymentStatus: $('#paymentStatus').val(),
                                        startDate: $('#startDate').val(),
                                        endDate: $('#endDate').val(),
                                        page: currentPage,
                                        size: currentSize
                                    };

                                    showLoading(true);

                                    $.get('/payment-management/search', searchData)
                                        .done(function (response) {
                                            currentData = response;
                                            displayResults(response);
                                            $('#resultsSection').show();
                                        })
                                        .fail(function (xhr) {
                                            console.error('Search failed:', xhr);
                                            showAlert('Search failed. Please try again.', 'danger');
                                        })
                                        .always(function () {
                                            showLoading(false);
                                        });
                                }

                                function displayResults(data) {
                                    const transactions = data.content;
                                    const totalElements = data.totalElements;

                                    // Update results count
                                    $('#resultsCount').text(`\${totalElements} result\${totalElements !== 1 ? 's' : ''}`);

                                    if (transactions.length === 0) {
                                        $('#transactionTable tbody').empty();
                                        $('#transactionCards').empty();
                                        $('#emptyState').show();
                                        $('#paginationContainer').hide();
                                        return;
                                    }

                                    $('#emptyState').hide();
                                    $('#paginationContainer').show();

                                    // Populate table (desktop)
                                    const tableBody = $('#transactionTableBody');
                                    tableBody.empty();

                                    transactions.forEach(function (transaction) {
                                        const row = createTableRow(transaction);
                                        tableBody.append(row);
                                    });

                                    // Populate cards (mobile)
                                    const cardsContainer = $('#transactionCards');
                                    cardsContainer.empty();

                                    transactions.forEach(function (transaction) {
                                        const card = createTransactionCard(transaction);
                                        cardsContainer.append(card);
                                    });

                                    // Update pagination
                                    updatePagination(data);
                                }

                                function createTableRow(transaction) {
                                    const isRefund = transaction.refund;
                                    const amountClass = isRefund ? 'amount-negative' : 'amount-positive';
                                    const amountPrefix = isRefund ? '-' : '';

                                    return `
                    <tr class="transaction-row">
                        <td>
                            <strong>#\${transaction.paymentId}</strong>
                            \${transaction.transactionReference ? '<br><small class="text-muted">' + transaction.transactionReference + '</small>' : ''}
                        </td>
                        <td>
                            \${formatDateTime(transaction.paymentDate)}
                        </td>
                        <td>
                            <strong>\${transaction.patientName || 'N/A'}</strong>
                            <br><small class="text-muted">\${transaction.patientRegistrationCode || ''}</small>
                        </td>
                        <td>
                            <strong>Exam #\${transaction.examinationId || 'N/A'}</strong>
                            <br><small class="text-muted">Tooth: \${transaction.toothNumber || 'N/A'}</small>
                        </td>
                        <td>
                            <span class="\${amountClass}">
                                \${amountPrefix}₹\${Math.abs(transaction.amount).toFixed(2)}
                            </span>
                        </td>
                        <td>
                            <span class="badge badge-info">\${transaction.paymentMode}</span>
                        </td>
                        <td>
                            <span class="transaction-type-\${transaction.transactionType ? transaction.transactionType.toLowerCase() : 'unknown'}">
                                \${transaction.transactionType === 'CAPTURE' ? 'Payment' : 
                                  transaction.transactionType === 'REFUND' ? 'Refund' : 
                                  transaction.transactionType || 'N/A'}
                            </span>
                        </td>
                        <td>
                            <span class="status-badge \${transaction.paymentStatusBadgeClass}">
                                \${transaction.paymentStatusText}
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-action btn-view" onclick="viewTransaction(\${transaction.paymentId})" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </button>
                                \${transaction.canRefund ? 
                                    '<button class="btn-action btn-refund" onclick="processRefund(' + transaction.paymentId + ')" title="Process Refund"><i class="fas fa-undo"></i></button>' : 
                                    ''
                                }
                                <button class="btn-action btn-history" onclick="viewHistory(\${transaction.paymentId})" title="View History">
                                    <i class="fas fa-history"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
                                }

                                function createTransactionCard(transaction) {
                                    const isRefund = transaction.refund;
                                    const amountClass = isRefund ? 'amount-negative' : 'amount-positive';
                                    const amountPrefix = isRefund ? '-' : '';

                                    return `
                    <div class="transaction-card">
                        <div class="transaction-card-header">
                            <div>
                                <div class="transaction-id">#\${transaction.paymentId}</div>
                                <small class="text-muted">\${formatDateTime(transaction.paymentDate)}</small>
                            </div>
                            <div class="transaction-amount \${amountClass}">
                                \${amountPrefix}₹\${Math.abs(transaction.amount).toFixed(2)}
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-6">
                                <small class="text-muted">Patient:</small><br>
                                <strong>\${transaction.patientName || 'N/A'}</strong>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Examination:</small><br>
                                <strong>#\${transaction.examinationId || 'N/A'}</strong>
                            </div>
                        </div>
                        
                        <div class="row mt-2">
                            <div class="col-6">
                                <span class="badge badge-info">\${transaction.paymentMode}</span>
                            </div>
                            <div class="col-6">
                                <span class="transaction-type-\${transaction.transactionType ? transaction.transactionType.toLowerCase() : 'unknown'}">
                                    \${transaction.transactionType === 'CAPTURE' ? 'Payment' : 
                                      transaction.transactionType === 'REFUND' ? 'Refund' : 
                                      transaction.transactionType || 'N/A'}
                                </span>
                            </div>
                            <div class="col-6">
                                <span class="status-badge \${transaction.paymentStatusBadgeClass}">
                                    \${transaction.paymentStatusText}
                                </span>
                            </div>
                        </div>
                        
                        <div class="action-buttons mt-3">
                            <button class="btn-action btn-view" onclick="viewTransaction(\${transaction.paymentId})">
                                <i class="fas fa-eye"></i> View
                            </button>
                            \${transaction.canRefund ? 
                                '<button class="btn-action btn-refund" onclick="processRefund(' + transaction.paymentId + ')"><i class="fas fa-undo"></i> Refund</button>' : 
                                ''
                            }
                            <button class="btn-action btn-history" onclick="viewHistory(\${transaction.paymentId})">
                                <i class="fas fa-history"></i> History
                            </button>
                        </div>
                    </div>
                `;
                                }

                                function updatePagination(data) {
                                    const totalPages = data.totalPages;
                                    const currentPageNum = data.number;
                                    const totalElements = data.totalElements;

                                    // Update pagination info
                                    const startItem = currentPageNum * currentSize + 1;
                                    const endItem = Math.min((currentPageNum + 1) * currentSize, totalElements);
                                    $('#paginationInfo').text(`Showing \${startItem}-\${endItem} of \${totalElements} results`);

                                    // Update pagination controls
                                    const pagination = $('#pagination');
                                    pagination.empty();

                                    if (totalPages <= 1) return;

                                    // Previous button
                                    pagination.append(`
                    <li class="page-item \${currentPageNum === 0 ? 'disabled' : ''}">
                        <a class="page-link" href="#" onclick="changePage(\${currentPageNum - 1})">Previous</a>
                    </li>
                `);

                                    // Page numbers
                                    const startPage = Math.max(0, currentPageNum - 2);
                                    const endPage = Math.min(totalPages - 1, currentPageNum + 2);

                                    for (let i = startPage; i <= endPage; i++) {
                                        pagination.append(`
                        <li class="page-item \${i === currentPageNum ? 'active' : ''}">
                            <a class="page-link" href="#" onclick="changePage(\${i})">\${i + 1}</a>
                        </li>
                    `);
                                    }

                                    // Next button
                                    pagination.append(`
                    <li class="page-item \${currentPageNum === totalPages - 1 ? 'disabled' : ''}">
                        <a class="page-link" href="#" onclick="changePage(\${currentPageNum + 1})">Next</a>
                    </li>
                `);
                                }

                                window.changePage = function (page) {
                                    if (page < 0 || (currentData && page >= currentData.totalPages)) return;
                                    currentPage = page;
                                    searchTransactions();
                                };

                                window.viewTransaction = function (paymentId) {
                                    $.get(`/payment-management/transaction/\${paymentId}`)
                                        .done(function (transaction) {
                                            displayTransactionDetails(transaction);
                                            $('#transactionDetailModal').modal('show');
                                        })
                                        .fail(function () {
                                            showAlert('Failed to load transaction details', 'danger');
                                        });
                                };

                                window.processRefund = function (paymentId) {
                                    // TODO: Implement refund functionality
                                    showAlert('Refund functionality will be implemented in the next phase', 'info');
                                };

                                window.viewHistory = function (paymentId) {
                                    // TODO: Implement history view
                                    showAlert('History view will be implemented in the next phase', 'info');
                                };

                                function displayTransactionDetails(transaction) {
                                    const detailsHtml = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Payment Information</h6>
                            <div class="detail-row">
                                <span class="detail-label">Transaction ID:</span>
                                <span class="detail-value">#\${transaction.paymentId}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Amount:</span>
                                <span class="detail-value \${transaction.refund ? 'amount-negative' : 'amount-positive'}">
                                    \${transaction.refund ? '-' : ''}₹\${Math.abs(transaction.amount).toFixed(2)}
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Payment Mode:</span>
                                <span class="detail-value">\${transaction.paymentMode}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Date & Time:</span>
                                <span class="detail-value">\${formatDateTime(transaction.paymentDate)}</span>
                            </div>
                            \${transaction.transactionReference ? 
                                '<div class="detail-row"><span class="detail-label">Reference:</span><span class="detail-value">' + transaction.transactionReference + '</span></div>' : 
                                ''
                            }
                            \${transaction.remarks ? 
                                '<div class="detail-row"><span class="detail-label">Remarks:</span><span class="detail-value">' + transaction.remarks + '</span></div>' : 
                                ''
                            }
                        </div>
                        <div class="col-md-6">
                            <h6>Patient & Examination</h6>
                            <div class="detail-row">
                                <span class="detail-label">Patient:</span>
                                <span class="detail-value">\${transaction.patientName || 'N/A'}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Registration Code:</span>
                                <span class="detail-value">\${transaction.patientRegistrationCode || 'N/A'}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Examination ID:</span>
                                <span class="detail-value">#\${transaction.examinationId || 'N/A'}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Tooth Number:</span>
                                <span class="detail-value">\${transaction.toothNumber || 'N/A'}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Procedure:</span>
                                <span class="detail-value">\${transaction.procedureName || 'N/A'}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Transaction Type:</span>
                                <span class="detail-value transaction-type-\${transaction.transactionType ? transaction.transactionType.toLowerCase() : 'unknown'}">
                                    \${transaction.transactionType === 'CAPTURE' ? 'Payment' : 
                                      transaction.transactionType === 'REFUND' ? 'Refund' : 
                                      transaction.transactionType || 'N/A'}
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Doctor:</span>
                                <span class="detail-value">\${transaction.assignedDoctorName || transaction.opdDoctorName || 'N/A'}</span>
                            </div>
                        </div>
                    </div>
                    
                    \${transaction.refund ? `
                                        < hr >
                        <h6>Refund Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">Refund Type:</span>
                                    <span class="detail-value">\${transaction.refundType}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Refund Reason:</span>
                                    <span class="detail-value">\${transaction.refundReason || 'N/A'}</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">Approved By:</span>
                                    <span class="detail-value">\${transaction.refundApprovedByName || 'N/A'}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Approval Date:</span>
                                    <span class="detail-value">\${transaction.refundApprovalDate ? formatDateTime(transaction.refundApprovalDate) : 'N/A'}</span>
                                </div>
                            </div>
                        </div>
                                    ` : ''}
                `;

                                    $('#transactionDetailBody').html(detailsHtml);

                                    // Show/hide refund button
                                    if (transaction.canRefund) {
                                        $('#refundBtn').show().off('click').on('click', function () {
                                            processRefund(transaction.paymentId);
                                        });
                                    } else {
                                        $('#refundBtn').hide();
                                    }
                                }

                                function showLoading(show) {
                                    if (show) {
                                        $('#loadingOverlay').show();
                                    } else {
                                        $('#loadingOverlay').hide();
                                    }
                                }

                                function showAlert(message, type) {
                                    const alertHtml = `
                    <div class="alert alert-\${type} alert-dismissible fade show" role="alert">
                        \${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                `;
                                    $('body').prepend(alertHtml);

                                    setTimeout(function () {
                                        $('.alert').alert('close');
                                    }, 5000);
                                }

                                function formatDateTime(dateTimeString) {
                                    if (!dateTimeString) return 'N/A';
                                    const date = new Date(dateTimeString);
                                    return date.toLocaleString('en-IN', {
                                        year: 'numeric',
                                        month: 'short',
                                        day: '2-digit',
                                        hour: '2-digit',
                                        minute: '2-digit'
                                    });
                                }
                            });
                        </script>
                    </body>

                    </html>