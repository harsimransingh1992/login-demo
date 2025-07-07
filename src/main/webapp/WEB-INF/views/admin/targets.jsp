<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Targets Management - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            position: relative;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card h2 {
            margin-top: 0;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
            margin-bottom: 10px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .btn-success {
            background-color: #27ae60;
        }
        .btn-success:hover {
            background-color: #229954;
        }
        .btn-warning {
            background-color: #f39c12;
        }
        .btn-warning:hover {
            background-color: #e67e22;
        }
        .btn-danger {
            background-color: #e74c3c;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
        }
        .table tr:hover {
            background-color: #f8f9fa;
        }
        .status-active {
            color: #27ae60;
            font-weight: 600;
        }
        .status-inactive {
            color: #e74c3c;
            font-weight: 600;
        }
        .tier-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            color: white;
        }
        .tier-TIER1 {
            background-color: #e74c3c;
        }
        .tier-TIER2 {
            background-color: #f39c12;
        }
        .tier-TIER3 {
            background-color: #3498db;
        }
        .tier-TIER4 {
            background-color: #95a5a6;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .actions {
            margin-top: 20px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #bdc3c7;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Doctor Targets Management</h1>
        <p>Configure monthly targets for doctors based on city tiers</p>
        
        <form action="${pageContext.request.contextPath}/logout" method="post" style="position: absolute; top: 20px; right: 20px;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-danger">Logout</button>
        </form>
    </div>
    
    <div class="container">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
        </c:if>
        
        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                Target has been created successfully.
            </div>
        </c:if>
        
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                ${param.error}
            </div>
        </c:if>
        
        <div class="card">
            <h2>Target Configuration</h2>
            <p>Manage monthly targets for doctors based on their clinic's city tier. These targets help doctors track their performance and progress.</p>
            
            <a href="${pageContext.request.contextPath}/admin/targets/new" class="btn btn-success">
                <i class="fas fa-plus"></i> Create New Target
            </a>
        </div>
        
        <div class="card">
            <h2>Current Targets</h2>
            
            <c:choose>
                <c:when test="${empty targets}">
                    <div class="empty-state">
                        <i class="fas fa-chart-line"></i>
                        <h3>No targets configured</h3>
                        <p>Create your first target configuration to get started.</p>
                        <a href="${pageContext.request.contextPath}/admin/targets/new" class="btn btn-success">
                            <i class="fas fa-plus"></i> Create First Target
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x: auto;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>City Tier</th>
                                    <th>Monthly Revenue Target</th>
                                    <th>Monthly Patient Target</th>
                                    <th>Monthly Procedure Target</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="target" items="${targets}">
                                    <tr>
                                        <td>
                                            <span class="tier-badge tier-${target.cityTier}">
                                                ${target.cityTier.displayName}
                                            </span>
                                        </td>
                                        <td>₹<fmt:formatNumber value="${target.monthlyRevenueTarget}" type="number" maxFractionDigits="2"/></td>
                                        <td>${target.monthlyPatientTarget} patients</td>
                                        <td>${target.monthlyProcedureTarget} procedures</td>
                                        <td>${target.description}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${target.isActive}">
                                                    <span class="status-active">
                                                        <i class="fas fa-check-circle"></i> Active
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-inactive">
                                                        <i class="fas fa-times-circle"></i> Inactive
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/targets/${target.id}/edit" class="btn btn-sm">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            
                                            <c:choose>
                                                <c:when test="${target.isActive}">
                                                    <button onclick="deactivateTarget(${target.id})" class="btn btn-warning btn-sm">
                                                        <i class="fas fa-pause"></i> Deactivate
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button onclick="activateTarget(${target.id})" class="btn btn-success btn-sm">
                                                        <i class="fas fa-play"></i> Activate
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <button onclick="deleteTarget(${target.id})" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/admin" class="btn">Back to Dashboard</a>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
    
    <script>
        function deleteTarget(targetId) {
            if (confirm('Are you sure you want to delete this target? This action cannot be undone.')) {
                fetch('${pageContext.request.contextPath}/admin/targets/' + targetId + '/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Target deleted successfully');
                        location.reload();
                    } else {
                        alert('Error deleting target: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting target');
                });
            }
        }
        
        function activateTarget(targetId) {
            if (confirm('Are you sure you want to activate this target?')) {
                fetch('${pageContext.request.contextPath}/admin/targets/' + targetId + '/activate', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Target activated successfully');
                        location.reload();
                    } else {
                        alert('Error activating target: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error activating target');
                });
            }
        }
        
        function deactivateTarget(targetId) {
            if (confirm('Are you sure you want to deactivate this target?')) {
                fetch('${pageContext.request.contextPath}/admin/targets/' + targetId + '/deactivate', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Target deactivated successfully');
                        location.reload();
                    } else {
                        alert('Error deactivating target: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deactivating target');
                });
            }
        }
    </script>
</body>
</html> 