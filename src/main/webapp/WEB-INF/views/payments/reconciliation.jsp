<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Reconciliation - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            justify-content: flex-end;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
        }
        
        .reconciliation-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            position: relative;
            overflow: hidden;
        }
        
        .reconciliation-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(to right, #2ecc71, #27ae60);
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .page-title {
            font-size: 24px;
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
        }
        
        .date-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .date-selector input[type="date"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.95rem;
            color: #2c3e50;
        }
        
        .reconciliation-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .reconciliation-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e9ecef;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .reconciliation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .card-title {
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .card-value {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .payment-mode-breakdown,
        .transaction-type-breakdown {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            margin-top: 30px;
        }
        
        .breakdown-title {
            font-size: 18px;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .breakdown-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .breakdown-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            transition: transform 0.3s ease;
        }
        
        .breakdown-item:hover {
            transform: translateY(-3px);
        }
        
        .breakdown-label {
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 8px;
        }
        
        .breakdown-amount {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .reconciliation-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        .btn i {
            font-size: 1rem;
        }
        
        .btn-reconcile {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
        }
        
        .btn-reconcile:hover {
            background: linear-gradient(135deg, #27ae60, #219a52);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.2);
        }
        
        .btn-print {
            background: #3498db;
            color: white;
        }
        
        .btn-print:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .transaction-list {
            margin-top: 30px;
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
        }
        
        .transaction-title {
            font-size: 18px;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .transaction-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 0.9rem;
        }
        
        .transaction-table th {
            background: white;
            padding: 8px 10px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
            font-size: 0.85rem;
        }
        
        .transaction-table td {
            padding: 8px 10px;
            border-bottom: 1px solid #e9ecef;
            color: #4b5563;
            font-size: 0.85rem;
        }
        
        .transaction-table tr:hover {
            background-color: white;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }
        
        .status-reconciled {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .exam-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .exam-link:hover {
            color: #2980b9;
            text-decoration: underline;
        }
        
        /* Transaction Type Badges */
        .transaction-type-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        
        .transaction-type-capture {
            background: #d4edda;
            color: #155724;
        }
        
        .transaction-type-refund {
            background: #f8d7da;
            color: #721c24;
        }
        
        .transaction-type-authorization {
            background: #fff3cd;
            color: #856404;
        }
        
        .transaction-type-void {
            background: #e2e3e5;
            color: #383d41;
        }
        
        /* Amount styling */
        .text-success {
            color: #28a745 !important;
            font-weight: 600;
        }
        
        .text-danger {
            color: #dc3545 !important;
            font-weight: 600;
        }
        
        /* Enhanced reconciliation cards */
        .reconciliation-card.net-collections {
            background: linear-gradient(135deg, #e8f5e9 0%, #f1f8e9 100%);
            border-left: 4px solid #4caf50;
        }
        
        .reconciliation-card.total-refunds {
            background: linear-gradient(135deg, #ffebee 0%, #fce4ec 100%);
            border-left: 4px solid #f44336;
        }
        
        .reconciliation-card.gross-collections {
            background: linear-gradient(135deg, #e3f2fd 0%, #e1f5fe 100%);
            border-left: 4px solid #2196f3;
        }
        
        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            
            .reconciliation-container {
                padding: 20px;
            }
            
            .reconciliation-grid {
                grid-template-columns: 1fr;
            }
            
            .breakdown-grid {
                grid-template-columns: 1fr;
            }
            
            .transaction-table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
            
            .transaction-table th,
            .transaction-table td {
                padding: 6px 8px;
                font-size: 0.8rem;
            }
            
            .reconciliation-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
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
                <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-secondary btn-small">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>

            <div class="reconciliation-container">
                <div class="page-header">
                    <h1 class="page-title">Payment Reconciliation</h1>
                    <div class="date-selector">
                        <input type="date" id="reconciliationDate" class="form-control" value="${pageContext.request.getParameter('date') != null ? pageContext.request.getParameter('date') : java.time.LocalDate.now()}">
                    </div>
                </div>
                
                <div class="reconciliation-grid">
                    <div class="reconciliation-card net-collections">
                        <div class="card-title">
                            <i class="fas fa-chart-line"></i>
                            Net Collections
                        </div>
                        <div class="card-value">₹<span id="netCollections">0.00</span></div>
                    </div>
                    <div class="reconciliation-card gross-collections">
                        <div class="card-title">
                            <i class="fas fa-money-bill-wave"></i>
                            Gross Collections
                        </div>
                        <div class="card-value">₹<span id="grossCollections">0.00</span></div>
                    </div>
                    <div class="reconciliation-card total-refunds">
                        <div class="card-title">
                            <i class="fas fa-undo"></i>
                            Total Refunds
                        </div>
                        <div class="card-value">₹<span id="totalRefunds">0.00</span></div>
                    </div>
                    <div class="reconciliation-card">
                        <div class="card-title">
                            <i class="fas fa-exchange-alt"></i>
                            Total Transactions
                        </div>
                        <div class="card-value"><span id="totalTransactions">0</span></div>
                    </div>
                </div>
                
                <div class="payment-mode-breakdown">
                    <h3 class="breakdown-title">
                        <i class="fas fa-chart-pie"></i>
                        Payment Mode Breakdown
                    </h3>
                    <div class="breakdown-grid" id="paymentModeBreakdown">
                        <!-- Will be populated by JavaScript -->
                    </div>
                </div>
                
                <div class="transaction-type-breakdown">
                    <h3 class="breakdown-title">
                        <i class="fas fa-exchange-alt"></i>
                        Transaction Type Summary
                    </h3>
                    <div class="breakdown-grid" id="transactionTypeBreakdown">
                        <!-- Will be populated by JavaScript -->
                    </div>
                </div>
                
                <div class="transaction-list">
                    <h3 class="transaction-title">
                        <i class="fas fa-list"></i>
                        Daily Transactions
                    </h3>
                    <table class="transaction-table">
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>Exam ID</th>
                                <th>Exam Date</th>
                                <th>Patient</th>
                                <th>Registration ID</th>
                                <th>Procedure</th>
                                <th>Transaction Type</th>
                                <th>Amount</th>
                                <th>Payment Mode</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody id="transactionList">
                            <!-- Will be populated by JavaScript -->
                        </tbody>
                    </table>
                </div>
                
                <div class="reconciliation-actions">
                    <button type="button" class="btn btn-print" id="printButton" onclick="printReconciliation()" style="display: none;">
                        <i class="fas fa-print"></i> Print Report
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        function loadReconciliationData() {
            const dateInput = document.getElementById('reconciliationDate');
            const date = dateInput.value;
            
            if (!date) {
                console.error('Date is required');
                return;
            }
            
            fetch(contextPath + '/payments/reconciliation/data?date=' + encodeURIComponent(date))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    updateReconciliationUI(data);
                })
                .catch(error => {
                    console.error('Error loading reconciliation data:', error);
                    alert('Error loading reconciliation data');
                });
        }
        
        function updateReconciliationUI(data) {
            // Calculate gross collections, refunds, and net collections
            let grossCollections = 0;
            let totalRefunds = 0;
            
            if (data.transactions) {
                data.transactions.forEach(transaction => {
                    const amount = parseFloat(transaction.amount);
                    const transactionType = transaction.transactionType || 'CAPTURE';
                    
                    if (transactionType === 'REFUND') {
                        totalRefunds += amount;
                    } else if (transactionType === 'CAPTURE' || transactionType === 'AUTHORIZATION') {
                        grossCollections += amount;
                    }
                });
            }
            
            const netCollections = grossCollections - totalRefunds;
            
            // Update summary cards
            document.getElementById('netCollections').textContent = netCollections.toFixed(2);
            document.getElementById('grossCollections').textContent = grossCollections.toFixed(2);
            document.getElementById('totalRefunds').textContent = totalRefunds.toFixed(2);
            document.getElementById('totalTransactions').textContent = data.totalTransactions;
            
            // Update payment mode breakdown
            const breakdownContainer = document.getElementById('paymentModeBreakdown');
            breakdownContainer.innerHTML = '';
            
            if (data.paymentModeBreakdown && Object.keys(data.paymentModeBreakdown).length > 0) {
                Object.entries(data.paymentModeBreakdown).forEach(([mode, amount]) => {
                    const item = document.createElement('div');
                    item.className = 'breakdown-item';
                    item.innerHTML = 
                        '<div class="breakdown-label">' + mode + '</div>' +
                        '<div class="breakdown-amount">₹' + parseFloat(amount).toFixed(2) + '</div>';
                    breakdownContainer.appendChild(item);
                });
            } else {
                breakdownContainer.innerHTML = '<div class="breakdown-item">No payment data available</div>';
            }
            
            // Update transaction type breakdown
            const transactionTypeContainer = document.getElementById('transactionTypeBreakdown');
            transactionTypeContainer.innerHTML = '';
            
            let transactionTypeSummary = {
                'CAPTURE': 0,
                'REFUND': 0,
                'AUTHORIZATION': 0,
                'VOID': 0
            };
            
            if (data.transactions) {
                data.transactions.forEach(transaction => {
                    const amount = parseFloat(transaction.amount);
                    const transactionType = transaction.transactionType || 'CAPTURE';
                    transactionTypeSummary[transactionType] = (transactionTypeSummary[transactionType] || 0) + amount;
                });
            }
            
            Object.entries(transactionTypeSummary).forEach(([type, amount]) => {
                if (amount > 0) {
                    const item = document.createElement('div');
                    item.className = 'breakdown-item';
                    const prefix = type === 'REFUND' ? '-₹' : '₹';
                    const amountClass = type === 'REFUND' ? 'text-danger' : 'text-success';
                    item.innerHTML = 
                        '<div class="breakdown-label">' + type + '</div>' +
                        '<div class="breakdown-amount ' + amountClass + '">' + prefix + amount.toFixed(2) + '</div>';
                    transactionTypeContainer.appendChild(item);
                }
            });
            
            if (transactionTypeContainer.innerHTML === '') {
                transactionTypeContainer.innerHTML = '<div class="breakdown-item">No transaction data available</div>';
            }
            
            // Update transaction list
            const transactionList = document.getElementById('transactionList');
            transactionList.innerHTML = '';
            
            // Show/hide print button based on data availability
            const printButton = document.getElementById('printButton');
            const dateInput = document.getElementById('reconciliationDate');
            const hasDate = dateInput.value && dateInput.value.trim() !== '';
            
            if (data.transactions && data.transactions.length > 0) {
                data.transactions.forEach(transaction => {
                    const row = document.createElement('tr');
                    const date = new Date(transaction.collectionDate);
                    const timeString = date.toLocaleTimeString('en-US', { 
                        hour: '2-digit', 
                        minute: '2-digit',
                        hour12: true 
                    });
                    
                    const statusClass = transaction.status === 'RECONCILED' ? 'status-reconciled' : 'status-pending';
                    
                    // Determine transaction type styling
                    const transactionType = transaction.transactionType || 'CAPTURE';
                    const isRefund = transactionType === 'REFUND';
                    const amountClass = isRefund ? 'text-danger' : 'text-success';
                    const amountPrefix = isRefund ? '-₹' : '₹';
                    
                    // Format examination date
                    const examDate = transaction.examinationDate ? new Date(transaction.examinationDate).toLocaleDateString('en-GB') : 'N/A';
                    
                    row.innerHTML = 
                        '<td>' + timeString + '</td>' +
                        '<td><a href="' + contextPath + '/examination/' + transaction.examinationId + '" class="exam-link" target="_blank">' + transaction.examinationId + '</a></td>' +
                        '<td>' + examDate + '</td>' +
                        '<td>' + transaction.patientName + '</td>' +
                        '<td>' + (transaction.patientRegistrationCode || 'N/A') + '</td>' +
                        '<td>' + transaction.procedureName + '</td>' +
                        '<td><span class="transaction-type-badge transaction-type-' + transactionType.toLowerCase() + '">' + transactionType + '</span></td>' +
                        '<td class="' + amountClass + '">' + amountPrefix + parseFloat(transaction.amount).toFixed(2) + '</td>' +
                        '<td>' + transaction.paymentMode + '</td>' +
                        '<td><span class="status-badge ' + statusClass + '">' + transaction.status + '</span></td>';
                    transactionList.appendChild(row);
                });
                
                // Show print button when there are transactions
                printButton.style.display = 'inline-flex';
            } else {
                transactionList.innerHTML = '<tr><td colspan="10" style="text-align: center;">No transactions found</td></tr>';
                
                // Hide print button when no transactions
                printButton.style.display = 'none';
            }
        }
        
        function printReconciliation() {
            const date = document.getElementById('reconciliationDate').value;
            window.open(contextPath + '/payments/reconciliation/print?date=' + date, '_blank');
        }
        
        // Load reconciliation data when date changes
        document.getElementById('reconciliationDate').addEventListener('change', loadReconciliationData);
        
        // Load initial reconciliation data
        document.addEventListener('DOMContentLoaded', loadReconciliationData);
    </script>
</body>
</html> 