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
    <title>Patient Pending Payments - PeriDesk</title>
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
            margin-left: 280px;
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

        .patient-info {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            border: none;
        }

        .patient-name {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .patient-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            color: #2c3e50;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-label {
            font-weight: 500;
            color: #2c3e50;
        }

        .total-pending {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            text-align: center;
            border-left: 4px solid #f57c00;
        }

        .total-amount {
            font-size: 2rem;
            font-weight: 700;
            color: #f57c00;
            margin-bottom: 5px;
        }

        .total-label {
            color: #666;
            font-size: 1.1rem;
        }

        .examinations-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            border: none;
        }

        .table-header {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 20px 30px;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
            color: #2c3e50;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        .amount-cell {
            font-weight: 600;
            text-align: right;
        }

        .pending-amount {
            color: #f57c00;
        }

        .total-amount-cell {
            color: #2e7d32;
        }

        .paid-amount-cell {
            color: #3498db;
        }

        .date-cell {
            color: #666;
            font-size: 0.9rem;
        }

        .tooth-number {
            background: #e3f2fd;
            color: #3498db;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            display: inline-block;
            min-width: 30px;
            text-align: center;
        }

        .procedure-name {
            font-weight: 500;
            color: #2c3e50;
        }

        .clinic-info {
            color: #666;
            font-size: 0.9rem;
        }

        .examination-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 4px 8px;
            border-radius: 4px;
        }

        .examination-link:hover {
            color: #2980b9;
            background-color: #f8f9fa;
            text-decoration: none;
            transform: translateY(-1px);
        }

        .examination-link:focus {
            outline: 2px solid #3498db;
            outline-offset: 2px;
        }

        .back-button {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
            text-decoration: none;
            color: white;
        }

        .no-payments {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .no-payments i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .no-payments h3 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 5px solid #f44336;
        }
    </style>
</head>

<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />

        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">
                    <i class="fas fa-credit-card"></i>
                    Patient Pending Payments
                </h1>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty patient}">
                <div class="patient-info">
                    <div class="patient-name">
                        <i class="fas fa-user"></i>
                        ${patient.firstName} ${patient.lastName}
                    </div>
                    <div class="patient-details">
                        <div class="detail-item">
                            <span class="detail-label">Registration Code:</span>
                            <span>${patient.registrationCode}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Phone:</span>
                            <span>${patient.phoneNumber}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Email:</span>
                            <span>${patient.email}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Age:</span>
                            <span>${patient.age} years</span>
                        </div>
                    </div>
                </div>

                <c:if test="${totalPendingAmount > 0}">
                    <div class="total-pending">
                        <div class="total-amount">
                            ₹<fmt:formatNumber value="${totalPendingAmount}" pattern="#,##0.00"/>
                        </div>
                        <div class="total-label">Total Pending Amount</div>
                    </div>
                </c:if>

                <div class="examinations-table">
                    <div class="table-header">
                        <i class="fas fa-list"></i>
                        Pending Examinations
                    </div>

                    <c:choose>
                        <c:when test="${not empty pendingExaminations}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Examination ID</th>
                                        <th>Tooth</th>
                                        <th>Procedure</th>
                                        <th>Date</th>
                                        <th>Clinic</th>
                                        <th>Total Amount</th>
                                        <th>Paid Amount</th>
                                        <th>Pending Amount</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="examination" items="${pendingExaminations}">
                                        <c:set var="pendingAmount" value="${examination.totalProcedureAmount - examination.totalPaidAmount}" />
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}" 
                                                   class="examination-link" title="View examination details">
                                                    #${examination.id}
                                                </a>
                                            </td>
                                            <td>
                                                <c:if test="${not empty examination.toothNumber}">
                                                    <span class="tooth-number">${examination.toothNumber}</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty examination.procedure}">
                                                    <div class="procedure-name">${examination.procedure.procedureName}</div>
                                                </c:if>
                                            </td>
                                            <td class="date-cell">
                                <c:if test="${not empty examination.examinationDate}">
                                    <c:set var="dateStr" value="${examination.examinationDate.toString()}" />
                                    <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                    <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                    <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                    <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                    ${day}/${month}/${year}
                                </c:if>
                            </td>
                                            <td class="clinic-info">
                                                <c:if test="${not empty examination.examinationClinic}">
                                                    ${examination.examinationClinic.clinicName}
                                                </c:if>
                                            </td>
                                            <td class="amount-cell total-amount-cell">
                                                ₹<fmt:formatNumber value="${examination.totalProcedureAmount}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="amount-cell paid-amount-cell">
                                                ₹<fmt:formatNumber value="${examination.totalPaidAmount}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="amount-cell pending-amount">
                                                ₹<fmt:formatNumber value="${pendingAmount}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="action-buttons">
                                                <sec:authorize access="hasRole('RECEPTIONIST')">
                                                    <c:if test="${not empty examination.examinationClinic and examination.examinationClinic.clinicId == currentClinicId}">
                                                        <button type="button" class="back-button btn-collect-payment" style="padding:8px 14px;" data-exam-id="${examination.id}" data-pending="${pendingAmount}"
                                                            data-proc="${not empty examination.procedure ? examination.procedure.procedureName : ''}"
                                                            data-tooth="${not empty examination.toothNumber ? examination.toothNumber : ''}"
                                                            data-clinic="${not empty examination.examinationClinic ? examination.examinationClinic.clinicName : ''}" data-clinic-id="${examination.examinationClinic.clinicId}">
                                                            <i class="fas fa-money-bill-wave"></i>
                                                            Collect Payment
                                                        </button>
                                                    </c:if>
                                                </sec:authorize>
                                                <button type="button" class="back-button btn-view-history" style="background:#6b7280; color:#fff; padding:8px 14px;" data-exam-id="${examination.id}">
                                                    <i class="fas fa-receipt"></i>
                                                    View History
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="no-payments">
                                <i class="fas fa-check-circle"></i>
                                <h3>No Pending Payments</h3>
                                <p>This patient has no pending payments at this time.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Overlay for modals -->
    <div class="overlay" id="overlay"></div>

    <!-- Collect Payment Form -->
    <div class="payment-form" id="paymentForm" style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #fff; border-radius: 12px; padding: 20px; width: 520px; max-width: 95vw; box-shadow: 0 10px 30px rgba(0,0,0,0.15); display: none; z-index: 1000;">
        <h3 style="margin-top: 0; color: #2c3e50;">Collect Payment</h3>
        <div class="payment-summary" id="paymentSummary" style="background:#f8fafc; border-radius:8px; padding:12px; margin-bottom:12px;">
            <!-- Summary populated dynamically -->
        </div>
        <div class="payment-form-row" style="display:flex; gap:10px; flex-wrap:wrap;">
            <select class="payment-mode-select" name="paymentMode" required style="flex:1; padding:10px; border:1px solid #e5e7eb; border-radius:8px;">
                <option value="">Select Payment Mode</option>
                <option value="CASH">Cash</option>
                <option value="CARD">Card</option>
                <option value="UPI">UPI</option>
                <option value="NET_BANKING">Net Banking</option>
                <option value="INSURANCE">Insurance</option>
                <option value="EMI">EMI</option>
            </select>
        <input type="number" class="payment-amount-input" name="paymentAmount" placeholder="Enter amount" step="1" inputmode="numeric" pattern="[0-9]*" required style="flex:1; padding:10px; border:1px solid #e5e7eb; border-radius:8px;">
        </div>
        <div class="input-error" id="paymentError" style="display:none; color:#b91c1c; font-size:12px; margin-top:6px;">Please select a payment mode and enter a valid amount.</div>
        <textarea class="payment-notes" name="paymentNotes" placeholder="Payment notes (optional)" rows="3" style="width:100%; margin-top:10px; padding:10px; border:1px solid #e5e7eb; border-radius:8px;"></textarea>
        <div class="payment-form-actions" style="display:flex; justify-content:flex-end; gap:10px; margin-top:14px;">
            <button type="button" class="btn btn-cancel" onclick="hidePaymentForm()" style="background:#e5e7eb; color:#111827; padding:10px 14px; border:none; border-radius:8px;">
                <i class="fas fa-times"></i>
                Cancel
            </button>
            <button type="button" class="btn btn-success" id="confirmPaymentBtn" onclick="collectPayment()" style="background:#10b981; color:#fff; padding:10px 14px; border:none; border-radius:8px;">
                <i class="fas fa-check"></i>
                Confirm Payment
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
                    <!-- Rows populated dynamically -->
                </tbody>
            </table>
            <div class="no-payments" id="noPayments" style="display:none;">
                <h4>No Payments Found</h4>
                <p>No payment records have been made for this examination yet.</p>
            </div>
        </div>
    </div>

    <script>
        let currentExaminationId = null;
        let isProcessingPayment = false;
        let lastClickTime = 0;
        const DEBOUNCE_DELAY = 1000;

        // Delegate button clicks to avoid inline JS with EL
        document.addEventListener('click', function(e) {
            const collectBtn = e.target.closest('.btn-collect-payment');
            if (collectBtn) {
                const examId = Number(collectBtn.getAttribute('data-exam-id'));
                const pending = Number(collectBtn.getAttribute('data-pending') || '0');
                showPaymentForm(examId, pending);
                return;
            }
            const historyBtn = e.target.closest('.btn-view-history');
            if (historyBtn) {
                const examId = Number(historyBtn.getAttribute('data-exam-id'));
                viewPaymentHistory(examId);
            }
        });

        function showPaymentForm(examinationId, remainingAmount) {
            currentExaminationId = examinationId;
            const rem = Number(remainingAmount || 0);
            document.getElementById('paymentSummary').innerHTML =
                '<div class="summary-row"><span class="summary-label">Examination ID:</span> <span class="summary-value">' + examinationId + '</span></div>' +
                '<div class="summary-row"><span class="summary-label">Remaining Amount:</span> <span class="summary-value">₹' + Math.floor(rem) + '</span></div>';
            document.getElementById('paymentForm').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
            const amountInput = document.querySelector('.payment-amount-input');
            const remInt = Math.floor(rem);
            amountInput.value = remInt > 0 ? String(remInt) : '';
            amountInput.setAttribute('max', remInt);
            validatePaymentForm();
        }

        function hidePaymentForm() {
            document.getElementById('paymentForm').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
            document.querySelector('.payment-mode-select').value = '';
            document.querySelector('.payment-amount-input').value = '';
            document.querySelector('.payment-notes').value = '';
            isProcessingPayment = false;
            document.getElementById('paymentError').style.display = 'none';
        }

        function validatePaymentForm() {
            const form = document.getElementById('paymentForm');
            const paymentMode = form.querySelector('select[name="paymentMode"]').value;
            const amountInput = form.querySelector('input[name="paymentAmount"]');
            const raw = (amountInput.value || '').trim();
            const sanitized = raw.replace(/[^\d]/g, '');
            if (sanitized !== raw) { amountInput.value = sanitized; }
            const amount = parseInt(sanitized, 10);
            const maxRemaining = parseInt(amountInput.getAttribute('max') || '0', 10);
            const confirmBtn = document.getElementById('confirmPaymentBtn');
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

            confirmBtn.disabled = !valid;
            confirmBtn.style.opacity = valid ? '1' : '0.6';
            if (!valid) {
                errorEl.textContent = message;
                errorEl.style.display = 'block';
            } else {
                errorEl.style.display = 'none';
            }
            return valid;
        }

        // Re-validate on input changes
        document.addEventListener('input', function(e) {
            if (e.target.closest('#paymentForm')) {
                if (e.target.matches('.payment-amount-input')) {
                    const r = (e.target.value || '').trim();
                    const s = r.replace(/[^\d]/g, '');
                    if (s !== r) { e.target.value = s; }
                }
                validatePaymentForm();
            }
        });

        // Close on overlay click and ESC
        document.getElementById('overlay').addEventListener('click', hidePaymentForm);
        document.getElementById('overlay').addEventListener('click', hidePaymentHistory);
        document.addEventListener('keydown', function(e){ if (e.key === 'Escape') { hidePaymentForm(); hidePaymentHistory(); }});

        function collectPayment() {
            const now = Date.now();
            if (isProcessingPayment || (now - lastClickTime < DEBOUNCE_DELAY)) return;
            lastClickTime = now;
            const form = document.getElementById('paymentForm');
            const paymentMode = form.querySelector('select[name="paymentMode"]').value;
            const amountInput = form.querySelector('input[name="paymentAmount"]');
            const amountRaw = (amountInput.value || '').trim();
            const amountSanitized = amountRaw.replace(/[^\d]/g, '');
            if (amountSanitized !== amountRaw) { amountInput.value = amountSanitized; }
            const amount = parseInt(amountSanitized, 10);
            const notes = form.querySelector('textarea[name="paymentNotes"]').value;
            if (!validatePaymentForm()) return;
            isProcessingPayment = true;
            const confirmBtn = document.getElementById('confirmPaymentBtn');
            const originalBtnText = confirmBtn.innerHTML;
            confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            confirmBtn.disabled = true;
            const requestData = {
                examinationId: currentExaminationId,
                paymentMode: paymentMode,
                notes: notes,
                paymentDetails: { amount: amount }
            };
            const metaCsrf = document.querySelector("meta[name='_csrf']");
            const inputCsrf = document.querySelector("input[name='_csrf']");
            const csrfToken = metaCsrf ? metaCsrf.content : (inputCsrf ? inputCsrf.value : null);
            fetch('${pageContext.request.contextPath}/payments/collect', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    ...(csrfToken ? { 'X-CSRF-TOKEN': csrfToken } : {})
                },
                body: JSON.stringify(requestData)
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    hidePaymentForm();
                    showToast('Payment collected successfully');
                    window.location.reload();
                } else {
                    showToast('Error: ' + (data.message || 'Payment failed'));
                }
            })
            .catch(err => {
                console.error('Error collecting payment', err);
                showToast('Error collecting payment');
            })
            .finally(() => { isProcessingPayment = false; confirmBtn.innerHTML = originalBtnText; confirmBtn.disabled = false; });
        }

        function viewPaymentHistory(examinationId) {
            document.getElementById('paymentHistoryModal').classList.add('show');
            document.getElementById('overlay').classList.add('show');
            fetch('${pageContext.request.contextPath}/payments/payment-history/' + examinationId)
                .then(r => r.json())
                .then(data => {
                    if (data.success) { displayPaymentHistory(data); }
                    else { alert('Error: ' + (data.message || 'Could not load history')); hidePaymentHistory(); }
                })
                .catch(err => { console.error('Error loading history', err); alert('Error loading history'); hidePaymentHistory(); });
        }

        function displayPaymentHistory(data) {
            const payments = data.payments || [];
            const tbody = document.querySelector('#paymentHistoryTable tbody');
            const noPayments = document.getElementById('noPayments');
            if (!payments.length) { tbody.innerHTML = ''; noPayments.style.display = 'block'; return; }
            noPayments.style.display = 'none';
            function fmtDate(ds){ if(!ds) return 'N/A'; const d=new Date(ds); return d.toLocaleDateString('en-IN'); }
            tbody.innerHTML = payments.map(p => (
                '<tr>' +
                '<td>' + fmtDate(p.paymentDate) + '</td>' +
                '<td>' + (p.transactionType || 'CAPTURE') + '</td>' +
                '<td>' + (p.paymentMode || '-') + '</td>' +
                '<td><strong>₹' + (p.amount || 0) + '</strong></td>' +
                '<td>' + (p.notes || '-') + '</td>' +
                '</tr>'
            )).join('');
        }

        function hidePaymentHistory() {
            document.getElementById('paymentHistoryModal').classList.remove('show');
            document.getElementById('overlay').classList.remove('show');
        }

        // Simple toast notifications
        function showToast(message) {
            let toast = document.getElementById('toast');
            if (!toast) {
                toast = document.createElement('div');
                toast.id = 'toast';
                toast.style.position = 'fixed';
                toast.style.bottom = '20px';
                toast.style.right = '20px';
                toast.style.background = '#111827';
                toast.style.color = '#fff';
                toast.style.padding = '10px 14px';
                toast.style.borderRadius = '8px';
                toast.style.boxShadow = '0 6px 20px rgba(0,0,0,0.2)';
                toast.style.zIndex = '2000';
                document.body.appendChild(toast);
            }
            toast.textContent = message;
            toast.style.display = 'block';
            setTimeout(() => { toast.style.display = 'none'; }, 2500);
        }
    </script>

    <style>
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

        .overlay.show { display: block; }

        .payment-history-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 20px;
            padding: 0;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            z-index: 1000;
            display: none;
            max-width: 900px;
            width: 95%;
            max-height: 85vh;
            overflow-y: auto;
        }

        .payment-history-modal.show { display: block; }

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

        .payment-history-close:hover { background: rgba(255, 255, 255, 0.3); }

        .payment-history-content { padding: 30px; }

        .payment-history-table { width: 100%; border-collapse: collapse; }

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

        .payment-history-table tr:hover { background: #f8f9fa; }

        .no-payments { text-align: center; padding: 60px 20px; color: #7f8c8d; }

        .no-payments h4 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0 0 10px 0;
        }

        .action-buttons { display: flex; align-items: center; gap: 8px; }
        .action-buttons .back-button { background: #2563eb; color: #fff; border: none; border-radius: 8px; }
        .action-buttons .btn-view-history { background: #6b7280 !important; }
        .amount-cell.pending-amount { color: #b45309; font-weight: 600; }
        .table thead th { position: sticky; top: 0; background: #f9fafb; }
    </style>
</body>

</html>