<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>Refund Management - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
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
            overflow-x: auto;
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
            font-weight: 600;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .user-info {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .refund-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .refund-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .refund-header {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 1.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .refund-header h5 {
            margin: 0;
            color: #2c3e50;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .refund-body {
            padding: 2rem;
        }
        
        .examination-item {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            background: #fff;
            transition: all 0.3s ease;
        }
        
        .examination-item:hover {
            background: #f8f9fa;
            border-color: #3498db;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.1);
        }
        
        .refund-history-item {
            border-left: 4px solid #dc3545;
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            background: #fff5f5;
            border-radius: 0 8px 8px 0;
        }
        
        .payment-item {
            border-left: 4px solid #28a745;
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            background: #f8fff8;
            border-radius: 0 8px 8px 0;
        }
        
        .status-badge {
            font-size: 0.8em;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .amount-positive {
            color: #28a745;
            font-weight: 600;
        }
        
        .amount-negative {
            color: #dc3545;
            font-weight: 600;
        }
        
        .btn {
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            transform: translateY(-1px);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            border: none;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border: none;
        }
        
        .btn-info {
            background: linear-gradient(135deg, #17a2b8, #138496);
            border: none;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
        .modal-body {
            padding: 2rem;
        }
        
        .modal-footer {
            padding: 1.5rem 2rem;
            border-top: 1px solid #dee2e6;
            background: #f8f9fa;
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .form-check-input:checked {
            background-color: #3498db;
            border-color: #3498db;
        }
        
        .form-check-label {
            font-weight: 500;
            color: #2c3e50;
        }
        
        .alert {
            border-radius: 8px;
            border: none;
            font-weight: 500;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
        }
        
        .alert-warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
        }
        
        /* Mobile responsiveness */
        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            
            .welcome-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .refund-body {
                padding: 1.5rem;
            }
            
            .modal-body {
                padding: 1.5rem;
            }
            
            .modal-footer {
                padding: 1rem 1.5rem;
            }
            
            .examination-item {
                padding: 1rem;
            }
            
            .btn-group-vertical .btn {
                margin-bottom: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <div class="welcome-message">
                    <i class="fas fa-undo-alt"></i>
                    Refund Management
                </div>
                <div class="user-info">
                    User: ${currentUser.username} | Role: ${userRole}
                </div>
            </div>

            <!-- Patient Search Section -->
            <div class="refund-card">
                <div class="refund-header">
                    <h5><i class="fas fa-search"></i> Search Patient</h5>
                </div>
                <div class="refund-body">
                    <form id="patientSearchForm">
                        <div class="row">
                            <div class="col-md-8">
                                <input type="text" class="form-control" id="registrationCode" 
                                       placeholder="Enter patient registration code" required>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Patient Details Section -->
            <div id="patientDetailsSection" class="refund-card" style="display: none;">
                <div class="refund-header">
                    <h5><i class="fas fa-user"></i> Patient Details</h5>
                </div>
                <div class="refund-body">
                    <div id="patientDetails"></div>
                </div>
            </div>

            <!-- Examinations Section -->
            <div id="examinationsSection" class="refund-card" style="display: none;">
                <div class="refund-header">
                    <h5><i class="fas fa-tooth"></i> Clinical Examinations</h5>
                </div>
                <div class="refund-body">
                    <div id="examinationsList"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Refund Modal -->
    <div class="modal fade" id="refundModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);">
                <div class="modal-header" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; border-radius: 12px 12px 0 0; border: none;">
                    <h5 class="modal-title"><i class="fas fa-undo-alt"></i> Process Refund</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="refundForm">
                        <input type="hidden" id="refundExaminationId">
                        
                        <div class="mb-3">
                            <label class="form-label">Refund Type</label>
                            <div>
                                <input type="radio" id="fullRefund" name="refundType" value="full" class="form-check-input">
                                <label for="fullRefund" class="form-check-label me-3">Full Refund</label>
                                
                                <input type="radio" id="partialRefund" name="refundType" value="partial" class="form-check-input">
                                <label for="partialRefund" class="form-check-label">Partial Refund</label>
                            </div>
                        </div>

                        <div id="partialRefundSection" style="display: none;">
                            <div class="mb-3">
                                <label for="refundAmount" class="form-label">Refund Amount</label>
                                <input type="number" class="form-control" id="refundAmount" step="0.01" min="0">
                            </div>
                            
                            <div class="mb-3">
                                <label for="originalPayment" class="form-label">Original Payment (Optional)</label>
                                <select class="form-select" id="originalPayment">
                                    <option value="">Select original payment</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="refundReason" class="form-label">Refund Reason</label>
                            <textarea class="form-control" id="refundReason" rows="3" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="processRefundBtn">
                        <i class="fas fa-undo-alt"></i> Process Refund
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- History Modal -->
    <div class="modal fade" id="historyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);">
                <div class="modal-header" style="background: linear-gradient(135deg, #17a2b8, #138496); color: white; border-radius: 12px 12px 0 0; border: none;">
                    <h5 class="modal-title"><i class="fas fa-history"></i> Refund History</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="refundHistoryContent"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Setup CSRF token for all AJAX requests
            var token = $('meta[name="_csrf"]').attr('content');
            var header = $('meta[name="_csrf_header"]').attr('content');
            
            $(document).ajaxSend(function(e, xhr, options) {
                xhr.setRequestHeader(header, token);
            });
            
            let currentExaminations = [];
            const userRole = '${userRole}';
            
            // Patient search form submission
            $('#patientSearchForm').on('submit', function(e) {
                e.preventDefault();
                const registrationCode = $('#registrationCode').val().trim();
                if (registrationCode) {
                    searchPatient(registrationCode);
                }
            });

            // Refund type change handler
            $('input[name="refundType"]').on('change', function() {
                if ($(this).val() === 'partial') {
                    $('#partialRefundSection').show();
                    loadRefundablePayments($('#refundExaminationId').val());
                } else {
                    $('#partialRefundSection').hide();
                }
            });

            // Process refund button click
            $('#processRefundBtn').on('click', function() {
                processRefund();
            });

            function searchPatient(registrationCode) {
                $.get('/pending-payments/search', { registrationCode: registrationCode })
                    .done(function(response) {
                        if (response.success && response.patient) {
                            displayPatientDetails(response.patient);
                            loadExaminations(response.patient.id);
                        } else {
                            showAlert('Patient not found', 'warning');
                        }
                    })
                    .fail(function() {
                        showAlert('Error searching for patient', 'danger');
                    });
            }

            function displayPatientDetails(patient) {
                const patientHtml = `
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Name:</strong> ${patient.firstName} ${patient.lastName}</p>
                            <p><strong>Registration Code:</strong> ${patient.registrationCode}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Phone:</strong> ${patient.phoneNumber || 'N/A'}</p>
                            <p><strong>Email:</strong> ${patient.email || 'N/A'}</p>
                        </div>
                    </div>
                `;
                $('#patientDetails').html(patientHtml);
                $('#patientDetailsSection').show();
            }

            function loadExaminations(patientId) {
                $.get('/pending-payments/examinations', { patientId: patientId })
                    .done(function(examinations) {
                        currentExaminations = examinations;
                        displayExaminations(examinations);
                    })
                    .fail(function() {
                        showAlert('Error loading examinations', 'danger');
                    });
            }

            function displayExaminations(examinations) {
                if (!examinations || examinations.length === 0) {
                    $('#examinationsList').html('<p class="text-muted">No examinations found for this patient.</p>');
                    $('#examinationsSection').show();
                    return;
                }

                let examinationsHtml = '';
                const currentUserId = '${currentUser.id}';
                
                examinations.forEach(function(exam) {
                    const canRefund = userRole === 'ADMIN' || userRole === 'CLINIC_OWNER' 
                                     || (exam.assignedDoctor && exam.assignedDoctor.id === currentUserId) 
                                     || (exam.opdDoctor && exam.opdDoctor.id === currentUserId);
                    
                    const examDate = new Date(exam.examinationDate);
                    const formattedDate = examDate.toLocaleDateString();
                    
                    examinationsHtml += '<div class="examination-item">' +
                        '<div class="row">' +
                            '<div class="col-md-8">' +
                                '<h6>Tooth: ' + exam.toothNumber + ' - ' + (exam.procedure ? exam.procedure.procedureName : 'N/A') + '</h6>' +
                                '<p class="mb-1"><strong>Doctor:</strong> ' + (exam.assignedDoctor ? exam.assignedDoctor.firstName + ' ' + exam.assignedDoctor.lastName : 'N/A') + '</p>' +
                                '<p class="mb-1"><strong>Date:</strong> ' + formattedDate + '</p>' +
                                '<p class="mb-1"><strong>Status:</strong> <span class="badge bg-info status-badge">' + exam.procedureStatus + '</span></p>' +
                            '</div>' +
                            '<div class="col-md-4 text-end">' +
                                '<p class="mb-1"><strong>Total:</strong> <span class="amount-positive">₹' + (exam.totalProcedureAmount || 0) + '</span></p>' +
                                '<p class="mb-1"><strong>Paid:</strong> <span class="amount-positive">₹' + (exam.totalPaidAmount || 0) + '</span></p>' +
                                '<p class="mb-1"><strong>Refunded:</strong> <span class="amount-negative">₹' + (exam.totalRefundedAmount || 0) + '</span></p>' +
                                '<p class="mb-3"><strong>Net Paid:</strong> <span class="amount-positive">₹' + (exam.netPaidAmount || 0) + '</span></p>' +
                                '<div class="btn-group-vertical d-grid gap-2">' +
                                    (canRefund && exam.netPaidAmount > 0 ? 
                                        '<button class="btn btn-danger btn-sm" onclick="openRefundModal(' + exam.id + ')">' +
                                            '<i class="fas fa-undo-alt"></i> Refund' +
                                        '</button>' : '') +
                                    '<button class="btn btn-info btn-sm" onclick="viewRefundHistory(' + exam.id + ')">' +
                                        '<i class="fas fa-history"></i> History' +
                                    '</button>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                });

                $('#examinationsList').html(examinationsHtml);
                $('#examinationsSection').show();
            }

            window.openRefundModal = function(examinationId) {
                $('#refundExaminationId').val(examinationId);
                $('#refundForm')[0].reset();
                $('#partialRefundSection').hide();
                $('#refundModal').modal('show');
            };

            window.viewRefundHistory = function(examinationId) {
                $.get('/refunds/history/' + examinationId)
                    .done(function(refunds) {
                        displayRefundHistory(refunds);
                        $('#historyModal').modal('show');
                    })
                    .fail(function() {
                        showAlert('Error loading refund history', 'danger');
                    });
            };

            function displayRefundHistory(refunds) {
                if (!refunds || refunds.length === 0) {
                    $('#refundHistoryContent').html('<p class="text-muted">No refund history found.</p>');
                    return;
                }

                let historyHtml = '';
                refunds.forEach(function(refund) {
                    const refundDate = new Date(refund.refundApprovalDate);
                    const formattedRefundDate = refundDate.toLocaleString();
                    
                    historyHtml += '<div class="refund-history-item">' +
                        '<div class="d-flex justify-content-between">' +
                            '<div>' +
                                '<strong>' + refund.refundType + ' Refund</strong>' +
                                '<p class="mb-1">Amount: <span class="amount-negative">₹' + Math.abs(refund.amount) + '</span></p>' +
                                '<p class="mb-1">Reason: ' + refund.refundReason + '</p>' +
                                '<small class="text-muted">' +
                                    'Processed by: ' + refund.refundApprovedBy.firstName + ' ' + refund.refundApprovedBy.lastName +
                                    ' on ' + formattedRefundDate +
                                '</small>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                });

                $('#refundHistoryContent').html(historyHtml);
            }

            function loadRefundablePayments(examinationId) {
                $.get('/refunds/refundable-payments/' + examinationId)
                    .done(function(payments) {
                        let optionsHtml = '<option value="">Select original payment</option>';
                        payments.forEach(function(payment) {
                            const paymentDate = new Date(payment.paymentDate);
                            const formattedPaymentDate = paymentDate.toLocaleDateString();
                            optionsHtml += '<option value="' + payment.id + '">₹' + payment.amount + ' - ' + payment.paymentMode + ' (' + formattedPaymentDate + ')</option>';
                        });
                        $('#originalPayment').html(optionsHtml);
                    })
                    .fail(function() {
                        showAlert('Error loading refundable payments', 'danger');
                    });
            }

            function processRefund() {
                const examinationId = $('#refundExaminationId').val();
                const refundType = $('input[name="refundType"]:checked').val();
                const reason = $('#refundReason').val().trim();

                if (!refundType || !reason) {
                    showAlert('Please fill all required fields', 'warning');
                    return;
                }

                let url, data;
                if (refundType === 'full') {
                    url = '/refunds/full/' + examinationId;
                    data = { reason: reason };
                } else {
                    const amount = parseFloat($('#refundAmount').val());
                    if (!amount || amount <= 0) {
                        showAlert('Please enter a valid refund amount', 'warning');
                        return;
                    }
                    
                    url = '/refunds/partial/' + examinationId;
                    data = {
                        amount: amount,
                        reason: reason
                    };
                    
                    // Only add originalPaymentId if a value is selected
                    const originalPayment = $('#originalPayment').val();
                    if (originalPayment && originalPayment !== '') {
                        data.originalPaymentId = originalPayment;
                    }
                }

                $.post(url, data)
                    .done(function(response) {
                        if (response.success) {
                            showAlert('Refund processed successfully', 'success');
                            $('#refundModal').modal('hide');
                            // Reload examinations to show updated amounts
                            const patientId = currentExaminations.length > 0 ? currentExaminations[0].patient.id : null;
                            if (patientId) {
                                loadExaminations(patientId);
                            }
                        } else {
                            showAlert(response.message || 'Error processing refund', 'danger');
                        }
                    })
                    .fail(function() {
                        showAlert('Error processing refund', 'danger');
                    });
            }

            function showAlert(message, type) {
                const alertHtml = `
                    <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                `;
                $('body').prepend(alertHtml);
                
                // Auto-dismiss after 5 seconds
                setTimeout(function() {
                    $('.alert').alert('close');
                }, 5000);
            }
        });
    </script>
</body>
</html>