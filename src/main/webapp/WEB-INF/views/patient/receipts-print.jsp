<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Print Receipts - ${fn:escapeXml(patient.firstName)} ${fn:escapeXml(patient.lastName)}</title>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <style>
        body { font-family: 'Poppins', sans-serif; background: #f0f5fa; color: #2c3e50; }
        .container { max-width: 1100px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .header { padding: 20px 24px; border-bottom: 1px solid #e9ecef; display: flex; justify-content: space-between; align-items: center; }
        .header-title { margin: 0; font-size: 1.4rem; display: flex; gap: 10px; align-items: center; }
        .patient-meta { margin-top: 6px; color: #6c757d; font-size: 0.95rem; }
        .actions { display: flex; gap: 10px; align-items: center; }
        .btn { display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; border-radius: 8px; border: none; cursor: pointer; font-weight: 500; }
        .btn-primary { background: linear-gradient(135deg,#3498db,#2980b9); color: #fff; }
        .btn-secondary { background: linear-gradient(135deg, #95a5a6, #7f8c8d); color: #fff; }
        .btn-outline { border: 2px solid #3498db; background: transparent; color: #3498db; }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .content { padding: 18px 24px; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .loading { text-align: center; padding: 18px; color: #6c757d; }
        .message { text-align: center; padding: 18px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #e9ecef; font-size: 0.95rem; }
        th { text-align: left; background: #f8fafc; }
        .select-cell { width: 44px; }
        .receipt-row { transition: background 0.15s ease; }
        .receipt-row.selected { background: #e8f4fd; }
        .checkbox { width: 18px; height: 18px; accent-color: #3498db; }
        .footer-note { margin-top: 12px; font-size: 0.9rem; color: #6c757d; }

        /* Print formatting */
        @media print {
            html, body { background: #fff; height: auto; margin: 0; padding: 0; }
            /* Hide screen-only elements */
            .header, .toolbar, .footer-note, #loading, #message, #receiptsTable { display: none !important; }
            /* Show and position print content */
            #printContent { 
                display: block !important; 
                position: static !important;
                margin: 0 !important;
                padding: 0 !important;
                width: 100% !important;
                height: auto !important;
                visibility: visible !important;
            }
            .container { 
                box-shadow: none !important; 
                border-radius: 0 !important;
                margin: 0 !important;
                padding: 0 !important;
            }
            .content {
                padding: 0 !important;
            }
            /* Receipt styling for print */
            .receipt-sheet { 
                page-break-inside: avoid; 
                margin: 0 auto 20px auto !important;
                border: 1px solid #000 !important;
                box-shadow: none !important;
                padding: 15px !important;
                width: calc(100% - 4px) !important; /* Account for 2px border (1px each side) */
                max-width: 100% !important;
                box-sizing: border-box !important;
            }
            /* Ensure table content fits within receipt boundaries */
            .receipt-table { 
                width: 100% !important;
                table-layout: fixed !important;
                border-collapse: collapse !important;
            }
            .receipt-table th, .receipt-table td { 
                word-wrap: break-word !important;
                overflow-wrap: break-word !important;
                padding: 6px 4px !important;
                font-size: 0.9rem !important;
            }
        }
        @page { size: A4; margin: 12mm; }
        .print-only { display: none; }
        .receipt-card { border: 1px dashed #cbd5e1; border-radius: 8px; padding: 10px 12px; margin-bottom: 10px; }
        .receipt-head { display: flex; justify-content: space-between; margin-bottom: 6px; }
        .receipt-meta { font-size: 0.95rem; color: #475569; }
        .receipt-amount { font-weight: 600; }
        /* Standard receipt layout */
        .receipt-sheet { border: 1px solid #e5e7eb; border-radius: 8px; padding: 16px; margin: 10px 0; background: #fff; }
        .receipt-title { font-weight: 600; font-size: 1.1rem; text-align: center; margin-bottom: 8px; }
        .receipt-info { display: flex; justify-content: space-between; font-size: 0.95rem; color: #475569; margin-bottom: 8px; }
        .receipt-table { width: 100%; border-collapse: collapse; margin-top: 6px; }
        .receipt-table th, .receipt-table td { border-bottom: 1px solid #e5e7eb; padding: 8px; font-size: 0.95rem; }
        .receipt-table th { text-align: left; background: #f8fafc; }
        .receipt-footer { margin-top: 10px; font-size: 0.9rem; color: #475569; display: flex; justify-content: space-between; }
        .signature-line { margin-top: 18px; height: 1px; background: #e5e7eb; }
        .signature-label { margin-top: 6px; font-size: 0.85rem; color: #6b7280; text-align: right; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1 class="header-title"><i class="fas fa-receipt"></i> Print Receipts</h1>
                <div class="patient-meta">
                    <strong>${fn:escapeXml(patient.firstName)} ${fn:escapeXml(patient.lastName)}</strong>
                    &nbsp;•&nbsp; ID: ${patient.id}
                    <c:if test="${not empty patient.registrationCode}">&nbsp;•&nbsp; Reg: ${fn:escapeXml(patient.registrationCode)}</c:if>
                    <c:if test="${not empty patient.phoneNumber}">&nbsp;•&nbsp; Phone: ${fn:escapeXml(patient.phoneNumber)}</c:if>
                </div>
            </div>
            <div class="actions">
                <a class="btn btn-outline nav-back" href="${pageContext.request.contextPath}/patients/details/${patient.id}"><i class="fas fa-arrow-left"></i> Back to Details</a>
                <button id="printSelectedBtn" class="btn btn-primary"><i class="fas fa-print"></i> Print Selected</button>
                <button id="printAllBtn" class="btn btn-secondary"><i class="fas fa-file-alt"></i> Print All</button>
            </div>
        </div>
        <div class="content">
            <div id="loading" class="loading"><i class="fas fa-spinner fa-spin"></i> Loading payment transactions…</div>
            <div id="message" class="message" style="display:none;"></div>

            <div class="toolbar">
                <div>
                    <label><input type="checkbox" id="selectAll" class="checkbox"> Select All</label>
                </div>
                <div id="summary" class="receipt-meta"></div>
            </div>

            <table id="receiptsTable" style="display:none;">
                <thead>
                    <tr>
                        <th class="select-cell"></th>
                        <th>Date</th>
                        <th>Procedure</th>
                        <th>Amount</th>
                        <th>Type</th>
                        <th>Method</th>
                        <th>Remarks</th>
                    </tr>
                </thead>
                <tbody id="receiptsBody"></tbody>
            </table>

            <!-- Print-only content container -->
            <div id="printContent" class="print-only"></div>

            <div class="footer-note">Tip: Use “Print Selected” to print only the checked receipts.</div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        // Ensure patientId is a valid JS value even if EL renders empty
        const patientId = Number('${patient.id}') || 0;
        let transactions = [];
        let selectedIds = new Set();

        function formatDate(d) {
            try {
                const safe = (d || '').replace(' ', 'T');
                const dt = new Date(safe);
                return isNaN(dt.getTime()) ? d : dt.toLocaleString('en-IN');
            } catch (_) { return d; }
        }

        function renderTable() {
            const body = document.getElementById('receiptsBody');
            body.innerHTML = '';
            let paid = 0, refunded = 0;
            transactions.forEach(tx => {
                const isRefund = !!tx.refund;
                const amt = Math.abs(parseFloat(tx.amount || 0) || 0);
                if (isRefund) refunded += amt; else paid += amt;

                const tr = document.createElement('tr');
                tr.className = 'receipt-row' + (selectedIds.has(tx.paymentId) ? ' selected' : '');
                tr.innerHTML =
                    '<td class="select-cell">' +
                        '<input type="checkbox" class="checkbox row-check" data-id="' + tx.paymentId + '" ' + (selectedIds.has(tx.paymentId) ? 'checked' : '') + ' />' +
                    '</td>' +
                    '<td>' + formatDate(tx.paymentDate) + '</td>' +
                    '<td>' + (tx.procedureName || 'N/A') + '</td>' +
                    '<td class="receipt-amount">' + (isRefund ? '-₹' + amt.toFixed(2) : '₹' + amt.toFixed(2)) + '</td>' +
                    '<td>' + (isRefund ? 'REFUND' : (tx.transactionType || 'COLLECTED')) + '</td>' +
                    '<td>' + (tx.paymentMode || 'N/A') + '</td>' +
                    '<td>' + (tx.remarks || '-') + '</td>';
                body.appendChild(tr);
            });
            const net = paid - refunded;
            document.getElementById('summary').textContent = 'Paid: ₹' + paid.toFixed(2) + ' • Net: ₹' + net.toFixed(2);
            document.getElementById('receiptsTable').style.display = transactions.length ? 'table' : 'none';
        }

        function updateSelectionVisual() {
            document.querySelectorAll('.row-check').forEach(cb => {
                const id = cb.getAttribute('data-id');
                const row = cb.closest('tr');
                if (selectedIds.has(id)) row.classList.add('selected'); else row.classList.remove('selected');
            });
        }

        function buildPrintContent(items) {
            const container = document.getElementById('printContent');
            container.innerHTML = '';

            const sheet = document.createElement('div');
            sheet.className = 'receipt-sheet';

            const clinicName = '${currentUserClinicName}' || 'Clinic';
            const printTimestamp = new Date().toLocaleString('en-IN');
            
            const title = '<div class="receipt-title">' + clinicName + '</div>';
            const subtitle = '<div class="receipt-title" style="font-size: 1rem; margin-bottom: 12px;">' + (items.length > 1 ? 'Receipt Summary' : 'Receipt') + '</div>';
            const info = '<div class="receipt-info">' +
                '<div>Print Date: ' + printTimestamp + '</div>' +
                '<div>Patient: ${patient.firstName} ${patient.lastName} (ID: ${patient.id})</div>' +
            '</div>';

            let rows = '';
            let paid = 0, refunded = 0;
            items.forEach(tx => {
                const isRefund = !!tx.refund;
                const amt = Math.abs(parseFloat(tx.amount || 0) || 0);
                if (isRefund) refunded += amt; else paid += amt;
                rows += '<tr>' +
                    '<td>' + formatDate(tx.paymentDate) + '</td>' +
                    '<td>' + (tx.procedureName || 'N/A') + (isRefund ? ' (Refund)' : '') + '</td>' +
                    '<td>' + (isRefund ? 'REFUND' : (tx.transactionType || 'COLLECTED')) + '</td>' +
                    '<td>' + (tx.paymentMode || 'N/A') + '</td>' +
                    '<td style="text-align:right;">' + (isRefund ? '-' : '') + amt.toFixed(2) + '</td>' +
                '</tr>';
            });

            const thead = '<thead><tr>' +
                '<th>Date</th>' +
                '<th>Procedure</th>' +
                '<th>Type</th>' +
                '<th>Method</th>' +
                '<th style="text-align:right;">Amount (₹)</th>' +
            '</tr></thead>';

            const table = '<table class="receipt-table">' + thead + '<tbody>' + rows + '</tbody></table>';

            const net = paid - refunded;
            const footer = '<div class="receipt-footer">' +
                '<div>Paid: ₹' + paid.toFixed(2) + '</div>' +
                '<div>Net: ' + (net < 0 ? '-₹' + Math.abs(net).toFixed(2) : '₹' + net.toFixed(2)) + '</div>' +
            '</div>' +
            '<div class="signature-line"></div>' +
            '<div class="signature-label">Authorized Signature</div>';

            sheet.innerHTML = title + subtitle + info + table + footer;
            container.appendChild(sheet);
        }

        function doPrint(items) {
            buildPrintContent(items);
            window.print();
        }

        function showMessage(text) {
            const m = document.getElementById('message');
            m.textContent = text;
            m.style.display = 'block';
            setTimeout(() => { m.style.display = 'none'; }, 2500);
        }

        // Event wiring
        document.addEventListener('change', (e) => {
            if (e.target && e.target.classList.contains('row-check')) {
                const id = e.target.getAttribute('data-id');
                if (e.target.checked) selectedIds.add(id); else selectedIds.delete(id);
                updateSelectionVisual();
                const allChecked = document.querySelectorAll('.row-check').length && document.querySelectorAll('.row-check:checked').length === document.querySelectorAll('.row-check').length;
                document.getElementById('selectAll').checked = allChecked;
            } else if (e.target && e.target.id === 'selectAll') {
                const isChecked = e.target.checked;
                document.querySelectorAll('.row-check').forEach(cb => {
                    cb.checked = isChecked; const id = cb.getAttribute('data-id');
                    if (isChecked) selectedIds.add(id); else selectedIds.delete(id);
                });
                updateSelectionVisual();
            }
        });

        document.getElementById('printSelectedBtn').addEventListener('click', () => {
            if (!transactions.length) { showMessage('No payment transactions to print'); return; }
            const items = transactions.filter(tx => selectedIds.has(String(tx.paymentId)) || selectedIds.has(tx.paymentId));
            if (!items.length) { showMessage('Please select at least one payment'); return; }
            doPrint(items);
        });

        document.getElementById('printAllBtn').addEventListener('click', () => {
            if (!transactions.length) { showMessage('No payment transactions to print'); return; }
            doPrint(transactions);
        });

        // Load transactions
        fetch(contextPath + '/payment-management/patient/' + patientId + '/transactions', { headers: { 'Accept': 'application/json' }})
            .then(async (resp) => {
                const ct = (resp.headers && resp.headers.get) ? (resp.headers.get('content-type') || '') : '';
                let data = [];
                if (ct.includes('application/json')) data = await resp.json(); else { try { data = JSON.parse(await resp.text()); } catch (_) {} }
                return Array.isArray(data) ? data : [];
            })
            .then((data) => {
                transactions = data || [];
                document.getElementById('loading').style.display = 'none';
                if (!transactions.length) {
                    const msg = document.getElementById('message');
                    msg.innerHTML = '<i class="fas fa-info-circle"></i> No payment transactions found for this patient.';
                    msg.style.display = 'block';
                } else {
                    renderTable();
                }
            })
            .catch(() => {
                document.getElementById('loading').style.display = 'none';
                const msg = document.getElementById('message');
                msg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error loading payments. Please try again.';
                msg.style.display = 'block';
            });
    </script>
</body>
</html>