<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Dashboard - PeriDesk Admin</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f1c40f;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-bg);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .page-title {
            margin: 0;
            color: var(--secondary-color);
            font-size: 24px;
            font-weight: 600;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 10px 20px;
            font-weight: 500;
            border-radius: 5px;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .stats-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-card {
            text-align: center;
            padding: 20px;
            background: var(--light-bg);
            border-radius: 10px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            color: #6c757d;
            margin: 0;
        }

        .triggers-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            background-color: var(--light-bg);
            border: none;
            font-weight: 600;
            color: var(--secondary-color);
            padding: 15px;
        }

        .table td {
            padding: 15px;
            vertical-align: middle;
            border-top: 1px solid var(--border-color);
        }

        .badge {
            padding: 5px 10px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-success {
            background-color: var(--success-color);
        }

        .badge-danger {
            background-color: var(--danger-color);
        }

        .badge-warning {
            background-color: var(--warning-color);
        }

        .badge-secondary {
            background-color: #6c757d;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
            margin: 0 2px;
        }

        .modal-header {
            background-color: var(--primary-color);
            color: white;
            border-bottom: none;
        }

        .modal-header .close {
            color: white;
            opacity: 0.8;
        }

        .modal-header .close:hover {
            opacity: 1;
        }

        .form-group label {
            font-weight: 500;
            color: var(--secondary-color);
        }

        .form-control {
            border: 1px solid var(--border-color);
            border-radius: 5px;
            padding: 10px 15px;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .dropdown-search-container {
            position: relative;
        }

        .dropdown-search-container input[type="text"] {
            border-bottom-left-radius: 0;
            border-bottom-right-radius: 0;
            border-bottom: none;
        }

        .dropdown-search-container select {
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }

        .dropdown-search-container input[type="text"]:focus + select,
        .dropdown-search-container select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .dropdown-search-container.no-results input {
            border-color: #dc3545;
        }

        .dropdown-search-container.no-results select {
            border-color: #dc3545;
        }

        .cron-helper {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
            margin-top: 10px;
            font-size: 12px;
        }

        .cron-examples {
            margin-top: 10px;
        }

        .cron-example {
            display: block;
            color: var(--primary-color);
            text-decoration: none;
            padding: 2px 0;
            cursor: pointer;
        }

        .cron-example:hover {
            text-decoration: underline;
        }

        .alert {
            border: none;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-chart-line mr-2"></i>
                    Report Dashboard
                </h1>
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createTriggerModal">
                    <i class="fas fa-plus mr-2"></i>
                    Create Report Trigger
                </button>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle mr-2"></i>
                    ${error}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>

            <!-- Statistics Section -->
            <div class="stats-section">
                <h3 class="mb-4">
                    <i class="fas fa-chart-bar mr-2"></i>
                    Execution Statistics
                </h3>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">${executionStats.totalTriggers}</div>
                        <p class="stat-label">Total Triggers</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${executionStats.enabledTriggers}</div>
                        <p class="stat-label">Active Triggers</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${executionStats.successfulExecutions}</div>
                        <p class="stat-label">Successful Executions</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${executionStats.failedExecutions}</div>
                        <p class="stat-label">Failed Executions</p>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${executionStats.pendingExecutions}</div>
                        <p class="stat-label">Pending Executions</p>
                    </div>
                </div>
            </div>

            <!-- Report Triggers Section -->
            <div class="triggers-section">
                <h3 class="mb-4">
                    <i class="fas fa-cogs mr-2"></i>
                    Report Triggers
                </h3>
                
                <div class="table-responsive">
                    <table class="table" id="triggersTable">
                        <thead>
                            <tr>
                                <th>Report Name</th>
                                <th>Type</th>
                                <th>Cron Expression</th>
                                <th>Recipients</th>
                                <th>Status</th>
                                <th>Last Execution</th>
                                <th>Next Execution</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="trigger" items="${reportTriggers}">
                                <tr data-trigger-id="${trigger.id}">
                                    <td>
                                        <strong>${trigger.reportDisplayName}</strong>
                                        <c:if test="${not empty trigger.description}">
                                            <br><small class="text-muted">${trigger.description}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge badge-info">${trigger.reportGeneratorBean}</span>
                                    </td>
                                    <td>
                                        <code>${trigger.cronExpression}</code>
                                    </td>
                                    <td>
                                        <c:set var="recipientArray" value="${trigger.recipientsArray}" />
                                        <c:choose>
                                            <c:when test="${fn:length(recipientArray) <= 2}">
                                                <c:forEach var="recipient" items="${recipientArray}" varStatus="status">
                                                    ${recipient}<c:if test="${!status.last}">, </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                ${recipientArray[0]}, ${recipientArray[1]} 
                                                <span class="text-muted">+${fn:length(recipientArray) - 2} more</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${trigger.active}">
                                                <span class="badge badge-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty trigger.lastExecutionStatus}">
                                            <br>
                                            <c:choose>
                                                <c:when test="${trigger.lastExecutionStatus == 'SUCCESS'}">
                                                    <span class="badge badge-success">${trigger.lastExecutionStatus.displayName}</span>
                                                </c:when>
                                                <c:when test="${trigger.lastExecutionStatus == 'FAILED'}">
                                                    <span class="badge badge-danger">${trigger.lastExecutionStatus.displayName}</span>
                                                </c:when>
                                                <c:when test="${trigger.lastExecutionStatus == 'RUNNING'}">
                                                    <span class="badge badge-warning">${trigger.lastExecutionStatus.displayName}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-secondary">${trigger.lastExecutionStatus.displayName}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty trigger.lastExecutedDate}">
                                                <fmt:formatDate value="${trigger.lastExecutedDate}" pattern="MMM dd, yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Never</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty trigger.nextExecutionDate}">
                                                <fmt:formatDate value="${trigger.nextExecutionDate}" pattern="MMM dd, yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not scheduled</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="editTrigger('${trigger.id}')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-${trigger.active ? 'warning' : 'success'}" onclick="toggleTrigger('${trigger.id}')">
                                            <i class="fas fa-${trigger.active ? 'pause' : 'play'}"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-info" onclick="executeTrigger('${trigger.id}')">
                                            <i class="fas fa-play-circle"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteTrigger('${trigger.id}')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Create/Edit Trigger Modal -->
    <div class="modal fade" id="createTriggerModal" tabindex="-1" role="dialog" aria-labelledby="createTriggerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createTriggerModalLabel">Create Report Trigger</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="triggerForm">
                        <input type="hidden" id="triggerId" name="id">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="reportName">Report Name *</label>
                                    <input type="text" class="form-control" id="reportName" name="reportName" required>
                                    <small class="form-text text-muted">Unique identifier for the report</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="reportDisplayName">Display Name *</label>
                                    <input type="text" class="form-control" id="reportDisplayName" name="reportDisplayName" required>
                                    <small class="form-text text-muted">Human-readable name</small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="reportGeneratorBean">Report Generator *</label>
                                    <div class="dropdown-search-container">
                                        <input type="text" class="form-control mb-2" id="reportGeneratorSearch" placeholder="Search report generators..." autocomplete="off">
                                        <select class="form-control" id="reportGeneratorBean" name="reportGeneratorBean" required>
                                            <option value="">Select Report Generator</option>
                                            <!-- Options will be loaded dynamically -->
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="enabled">Status</label>
                                    <select class="form-control" id="enabled" name="enabled">
                                        <option value="true">Active</option>
                                        <option value="false">Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="cronExpression">Cron Expression *</label>
                            <input type="text" class="form-control" id="cronExpression" name="cronExpression" required placeholder="8 * * * *">
                            <div class="cron-helper">
                                <strong>Cron Format:</strong> minute hour day month dayOfWeek
                                <div class="cron-examples">
                                    <small>Examples:</small><br>
                                    <a href="#" class="cron-example" onclick="setCronExpression('0 8 * * *')">0 8 * * * - Daily at 8:00 AM</a>
                                    <a href="#" class="cron-example" onclick="setCronExpression('0 9 * * 1')">0 9 * * 1 - Every Monday at 9:00 AM</a>
                                    <a href="#" class="cron-example" onclick="setCronExpression('0 10 1 * *')">0 10 1 * * - First day of every month at 10:00 AM</a>
                                    <a href="#" class="cron-example" onclick="setCronExpression('30 18 * * 5')">30 18 * * 5 - Every Friday at 6:30 PM</a>
                                    <a href="#" class="cron-example" onclick="setCronExpression('* * * * *')">* * * * * - Every minute (for testing)</a>
                                </div>
                            </div>
                            <div id="cronValidation" class="mt-2"></div>
                        </div>

                        <div class="form-group">
                            <label for="recipients">Email Recipients *</label>
                            <textarea class="form-control" id="recipients" name="recipients" rows="3" required placeholder="admin@example.com, manager@example.com"></textarea>
                            <small class="form-text text-muted">Comma-separated email addresses</small>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="2" placeholder="Optional description of the report"></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="subject">Email Subject</label>
                                    <input type="text" class="form-control" id="subject" name="subject" placeholder="Report: {reportName}">
                                    <small class="form-text text-muted">Optional custom email subject</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="emailTemplate">Email Template</label>
                                    <textarea class="form-control" id="emailTemplate" name="emailTemplate" rows="2" placeholder="Custom email template"></textarea>
                                    <small class="form-text text-muted">Optional custom email template</small>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveTrigger()">Save Trigger</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        // CSRF token for AJAX requests
        const csrfToken = $('meta[name="_csrf"]').attr('content');
        const csrfHeader = $('meta[name="_csrf_header"]').attr('content');

        // Set up AJAX defaults
        $.ajaxSetup({
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            }
        });

        // Load available report generators on page load
        $(document).ready(function() {
            loadReportGenerators();
        });

        // Load report generators from API
        function loadReportGenerators() {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/reports/api/generators',
                method: 'GET',
                success: function(generators) {
                    const select = $('#reportGeneratorBean');
                    select.empty();
                    select.append('<option value="">Select Report Generator</option>');
                    
                    generators.forEach(function(generator) {
                        select.append('<option value="' + generator + '">' + generator + '</option>');
                    });
                    
                    // Store original options for search functionality
                    select.data('original-options', generators);
                    
                    // Setup search functionality after generators are loaded
                    setupReportGeneratorSearch();
                },
                error: function() {
                    console.error('Failed to load report generators');
                    showAlert('danger', 'Failed to load available report generators');
                }
            });
        }

        // Setup search functionality for report generators
        function setupReportGeneratorSearch() {
            console.log('Setting up search functionality'); // Debug log
            
            $('#reportGeneratorSearch').on('input', function() {
                console.log('Search input triggered'); // Debug log
                const searchTerm = $(this).val().toLowerCase();
                const select = $('#reportGeneratorBean');
                const originalOptions = select.data('original-options') || [];
                
                console.log('Search term:', searchTerm, 'Original options:', originalOptions); // Debug log
                
                // Clear current options
                select.empty();
                select.append('<option value="">Select Report Generator</option>');
                
                // If search is empty, show all options
                if (searchTerm === '') {
                    originalOptions.forEach(function(generator) {
                        select.append('<option value="' + generator + '">' + generator + '</option>');
                    });
                    // Force refresh the select element
                    select.trigger('change.select2');
                    return;
                }
                
                // Filter and add matching options
                const filteredOptions = originalOptions.filter(function(generator) {
                    return generator.toLowerCase().includes(searchTerm);
                });
                
                console.log('Filtered options:', filteredOptions); // Debug log
                
                filteredOptions.forEach(function(generator) {
                    select.append('<option value="' + generator + '">' + generator + '</option>');
                });
                
                // Show message if no results found
                if (filteredOptions.length === 0 && searchTerm.length > 0) {
                    select.append('<option value="" disabled>No matching generators found</option>');
                }
                
                // Force refresh the select element to show updated options
                select.trigger('change.select2');
                
                // Add visual feedback
                const container = $('.dropdown-search-container');
                if (filteredOptions.length === 0 && searchTerm.length > 0) {
                    container.addClass('no-results');
                } else {
                    container.removeClass('no-results');
                }
            });
            
            // Clear search when dropdown is focused
            $('#reportGeneratorBean').on('focus', function() {
                const searchInput = $('#reportGeneratorSearch');
                if (searchInput.val() !== '') {
                    searchInput.val('');
                    const originalOptions = $(this).data('original-options') || [];
                    const select = $(this);
                    
                    select.empty();
                    select.append('<option value="">Select Report Generator</option>');
                    originalOptions.forEach(function(generator) {
                        select.append('<option value="' + generator + '">' + generator + '</option>');
                    });
                    
                    // Remove no-results styling
                    $('.dropdown-search-container').removeClass('no-results');
                    
                    // Force refresh the select element
                    select.trigger('change.select2');
                }
            });
        }

        // Set cron expression from examples
        function setCronExpression(expression) {
            $('#cronExpression').val(expression);
            validateCronExpression();
        }

        // Validate cron expression
        function validateCronExpression() {
            const cronExpression = $('#cronExpression').val();
            if (!cronExpression) {
                $('#cronValidation').html('');
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/reports/api/validate-cron',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ cronExpression: cronExpression }),
                success: function(response) {
                    if (response.valid) {
                        $('#cronValidation').html('<small class="text-success"><i class="fas fa-check"></i> Valid cron expression</small>');
                        if (response.nextExecution) {
                            $('#cronValidation').append('<br><small class="text-info">Next execution: ' + new Date(response.nextExecution).toLocaleString() + '</small>');
                        }
                    } else {
                        $('#cronValidation').html('<small class="text-danger"><i class="fas fa-times"></i> ' + response.message + '</small>');
                    }
                },
                error: function() {
                    $('#cronValidation').html('<small class="text-danger"><i class="fas fa-times"></i> Error validating cron expression</small>');
                }
            });
        }

        // Validate cron expression on input
        $('#cronExpression').on('input', function() {
            clearTimeout(this.cronValidationTimeout);
            this.cronValidationTimeout = setTimeout(validateCronExpression, 500);
        });

        // Save trigger
        function saveTrigger() {
            const form = $('#triggerForm');
            const formData = {
                reportName: $('#reportName').val(),
                reportDisplayName: $('#reportDisplayName').val(),
                reportGeneratorBean: $('#reportGeneratorBean').val(),
                cronExpression: $('#cronExpression').val(),
                recipients: $('#recipients').val(),
                enabled: $('#enabled').val() === 'true',
                description: $('#description').val(),
                subject: $('#subject').val(),
                emailTemplate: $('#emailTemplate').val()
            };

            const triggerId = $('#triggerId').val();
            const isEdit = triggerId && triggerId !== '';
            const url = isEdit 
                ? '${pageContext.request.contextPath}/admin/reports/api/triggers/' + triggerId
                : '${pageContext.request.contextPath}/admin/reports/api/triggers';
            const method = isEdit ? 'PUT' : 'POST';

            $.ajax({
                url: url,
                method: method,
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(response) {
                    if (response.success) {
                        showAlert('success', response.message);
                        $('#createTriggerModal').modal('hide');
                        location.reload(); // Refresh the page to show updated data
                    } else {
                        showAlert('danger', response.message);
                    }
                },
                error: function(xhr) {
                    const response = xhr.responseJSON;
                    const message = response && response.message ? response.message : 'Error saving trigger';
                    showAlert('danger', message);
                }
            });
        }

        // Edit trigger
        function editTrigger(id) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/reports/api/triggers/' + id,
                method: 'GET',
                success: function(trigger) {
                    $('#triggerId').val(trigger.id);
                    $('#reportName').val(trigger.reportName);
                    $('#reportDisplayName').val(trigger.reportDisplayName);
                    $('#reportGeneratorBean').val(trigger.reportGeneratorBean);
                    $('#cronExpression').val(trigger.cronExpression);
                    $('#recipients').val(trigger.recipients);
                    $('#enabled').val(trigger.active ? 'true' : 'false');
                    $('#description').val(trigger.description || '');
                    $('#subject').val(trigger.subject || '');
                    $('#emailTemplate').val(trigger.emailTemplate || '');
                    
                    $('#createTriggerModalLabel').text('Edit Report Trigger');
                    $('#createTriggerModal').modal('show');
                },
                error: function() {
                    showAlert('danger', 'Error loading trigger details');
                }
            });
        }

        // Toggle trigger
        function toggleTrigger(id) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/reports/api/triggers/' + id + '/toggle',
                method: 'POST',
                success: function(response) {
                    if (response.success) {
                        showAlert('success', response.message);
                        location.reload();
                    } else {
                        showAlert('danger', response.message);
                    }
                },
                error: function() {
                    showAlert('danger', 'Error toggling trigger');
                }
            });
        }

        // Execute trigger
        function executeTrigger(id) {
            if (confirm('Are you sure you want to manually execute this report?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/reports/api/triggers/' + id + '/execute',
                    method: 'POST',
                    success: function(response) {
                        if (response.success) {
                            showAlert('success', response.message);
                            location.reload();
                        } else {
                            showAlert('danger', response.message);
                        }
                    },
                    error: function() {
                        showAlert('danger', 'Error executing trigger');
                    }
                });
            }
        }

        // Delete trigger
        function deleteTrigger(id) {
            if (confirm('Are you sure you want to delete this report trigger? This action cannot be undone.')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/reports/api/triggers/' + id,
                    method: 'DELETE',
                    success: function(response) {
                        if (response.success) {
                            showAlert('success', response.message);
                            location.reload();
                        } else {
                            showAlert('danger', response.message);
                        }
                    },
                    error: function() {
                        showAlert('danger', 'Error deleting trigger');
                    }
                });
            }
        }

        // Show alert
        function showAlert(type, message) {
            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    <i class="fas fa-` + (type === 'success' ? 'check-circle' : 'exclamation-triangle') + ` mr-2"></i>
                    ${message}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            `;
            $('.page-header').after(alertHtml);
        }

        // Reset modal on close
        $('#createTriggerModal').on('hidden.bs.modal', function () {
            $('#triggerForm')[0].reset();
            $('#triggerId').val('');
            $('#cronValidation').html('');
            $('#createTriggerModalLabel').text('Create Report Trigger');
        });

        // Auto-refresh statistics every 30 seconds
        setInterval(function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/reports/api/stats',
                method: 'GET',
                success: function(stats) {
                    $('.stat-card:nth-child(1) .stat-value').text(stats.totalTriggers);
                    $('.stat-card:nth-child(2) .stat-value').text(stats.enabledTriggers);
                    $('.stat-card:nth-child(3) .stat-value').text(stats.successfulExecutions);
                    $('.stat-card:nth-child(4) .stat-value').text(stats.failedExecutions);
                    $('.stat-card:nth-child(5) .stat-value').text(stats.pendingExecutions);
                }
            });
        }, 30000);
    </script>
</body>
</html>