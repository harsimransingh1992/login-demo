<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>Historic Data - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />

    <!-- Historic Data page styles moved to external CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/historic-data.css">
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-database"></i>
                    Historic Data
                </h1>
            </div>

            <!-- Simple selector: nothing is shown by default until a category is selected -->
            <div class="selector" role="tablist" aria-label="Historic Data categories">
                <button class="segmented-btn" data-target="payments" aria-controls="paymentsSection" aria-selected="false">Payments</button>
                <button class="segmented-btn" data-target="refunds" aria-controls="refundsSection" aria-selected="false">Refunds</button>
                <button class="segmented-btn" data-target="visits" aria-controls="visitsSection" aria-selected="false">Patient Visits</button>
            </div>

            <!-- Empty state shown until a category is selected -->
            <div id="emptyState" class="empty-state">
                Select a category above to view historic data. Nothing is shown by default.
            </div>

            <!-- Payments section (hidden until selected) -->
            <div id="paymentsSection" class="card" style="display:none;" role="tabpanel" aria-labelledby="payments">
                <h2 class="section-title"><i class="fas fa-credit-card"></i> Payments</h2>
                <p class="placeholder">View pending items and historic insights for payments.</p>
                <div class="filters mb-3" aria-label="Payments date range filters">
                    <div class="row g-2 align-items-end">
                        <div class="col-sm-4">
                            <label for="paymentsStartDate" class="form-label">Start Date</label>
                            <input id="paymentsStartDate" type="date" class="form-control" />
                        </div>
                        <div class="col-sm-4">
                            <label for="paymentsEndDate" class="form-label">End Date</label>
                            <input id="paymentsEndDate" type="date" class="form-control" />
                        </div>
                        <div class="col-sm-4 d-flex gap-2">
                            <button id="loadPaymentsAnalytics" class="btn btn-dark flex-fill">
                                <i class="fas fa-chart-line"></i> Load Analytics
                            </button>
                            <button id="loadPendingList" class="btn btn-primary flex-fill">
                                <i class="fas fa-hourglass-half"></i> View Pending Payments
                            </button>
                        </div>
                    </div>
                </div>
                <div id="paymentsAnalytics" class="analytics" aria-live="polite">
                    <div id="analyticsCards" class="row g-3"></div>
                    <div id="analyticsMeta" class="mt-2 small text-muted"></div>
                    <div id="analyticsError" class="alert alert-warning d-none mt-2" role="alert"></div>
                </div>
                <div id="pendingListContainer" class="mt-3" aria-live="polite">
                    <div id="pendingListError" class="alert alert-warning d-none" role="alert"></div>
                    <!-- Added: toolbar with status filter, page size, and record count -->
                    <div id="pendingListToolbar" class="d-flex flex-wrap align-items-end gap-3 mb-2" style="display:none;">
                      <div>
                        <label for="paymentStatusFilter" class="form-label mb-0 small">Payment Status (optional)</label>
                        <select id="paymentStatusFilter" class="form-select form-select-sm" aria-label="Payment status filter">
                          <option value="ALL" selected>All</option>
                          <option value="PARTIAL">Partial</option>
                          <option value="COMPLETE">Complete</option>
                        </select>
                      </div>
                      <div>
                        <label for="pageSizeSelect" class="form-label mb-0 small">Page Size</label>
                        <select id="pageSizeSelect" class="form-select form-select-sm" aria-label="Page size">
                          <option value="10" selected>10</option>
                          <option value="25">25</option>
                          <option value="50">50</option>
                        </select>
                      </div>
                      <div class="ms-auto small text-muted" id="pendingListMeta" aria-live="polite"></div>
                    </div>
                    <div id="pendingListContent" class="table-responsive" style="display:none;">
                      <table class="table table-striped align-middle" id="pendingListTable">
                        <thead>
                          <tr>
                            <th>Examination ID</th>
                            <th>Registration Code</th>
                            <th>Patient</th>
                            <th>Phone</th>
                            <th>Procedure</th>
                            <th>Total</th>
                            <th>Paid</th>
                            <th>Pending</th>
                            <th>Status</th>
                          </tr>
                        </thead>
                        <tbody></tbody>
                      </table>
                    </div>
                    <!-- Added: pagination controls -->
                    <div id="pendingListPagination" class="d-flex justify-content-between align-items-center mt-2" style="display:none;">
                      <button id="prevPageBtn" class="btn btn-outline-secondary btn-sm" disabled><i class="fas fa-chevron-left"></i> Prev</button>
                      <div class="small" id="currentPageDisplay">Page 1</div>
                      <button id="nextPageBtn" class="btn btn-outline-secondary btn-sm" disabled>Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                    <div id="pendingListEmpty" class="empty-state" style="display:none;">No pending examinations found for the selected range.</div>
                </div>
            </div>

            <!-- Refunds section (hidden until selected) -->
            <div id="refundsSection" class="card" style="display:none;" role="tabpanel" aria-labelledby="refunds">
                <h2 class="section-title"><i class="fas fa-file-invoice-dollar"></i> Refunds</h2>
                <p class="placeholder">Coming soon: historic refunds and outstanding requests overview.</p>
            </div>

            <!-- Patient Visits section (hidden until selected) -->
            <div id="visitsSection" class="card" style="display:none;" role="tabpanel" aria-labelledby="visits">
                <h2 class="section-title"><i class="fas fa-user-check"></i> Patient Visits</h2>
                <p class="placeholder">Coming soon: overdue follow-ups and pending visit confirmations.</p>
            </div>
        </div>
    </div>

    <!-- Historic Data page scripts moved to external JS -->
    <script src="${pageContext.request.contextPath}/js/historic-data.js"></script>
</body>
</html>