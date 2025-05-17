<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Status - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #3498db;
            margin-bottom: 20px;
        }
        .card {
            background-color: #f9f9f9;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
        }
        .card-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .btn {
            display: inline-block;
            padding: 10px 15px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .btn-danger {
            background-color: #e74c3c;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .btn-warning {
            background-color: #f39c12;
        }
        .btn-warning:hover {
            background-color: #d68910;
        }
        .stats {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        .stat-card {
            flex: 1;
            background-color: white;
            padding: 15px;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #3498db;
            margin: 5px 0;
        }
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
        }
        .status-message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
        }
        .status-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .hidden {
            display: none;
        }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Database Maintenance</h1>
        
        <c:if test="${param.fixed eq 'true'}">
            <div class="status-message status-success">
                <i class="fas fa-check-circle"></i> Database has been successfully fixed
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="status-message status-error">
                <i class="fas fa-exclamation-circle"></i> Error fixing database: ${param.error}
            </div>
        </c:if>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-label">Total Check-in Records</div>
                <div class="stat-value">${totalCheckIns}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Orphaned Check-in Records</div>
                <div class="stat-value">${orphanedCheckIns}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Duplicate ID Sets</div>
                <div class="stat-value">${duplicateIds}</div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-title">
                <i class="fas fa-medkit"></i> One-Click Database Repair
            </div>
            <p>
                This action will directly fix duplicate record IDs by assigning new IDs to duplicate records.
                This is the most reliable way to fix database integrity issues.
            </p>
            <a href="${pageContext.request.contextPath}/admin/fix-database" class="btn btn-warning">
                <i class="fas fa-hammer"></i> Repair Database Directly
            </a>
        </div>
        
        <div class="card">
            <div class="card-title">
                <i class="fas fa-trash-alt"></i> Clean Up Orphaned Records
            </div>
            <p>
                This action will remove check-in records that don't have an associated patient.
                These orphaned records can cause errors when viewing the patient visit history.
            </p>
            <button id="cleanupBtn" class="btn btn-danger">
                <i class="fas fa-broom"></i> Clean Up Orphaned Records
            </button>
            <div id="cleanupStatus" class="status-message hidden"></div>
        </div>
        
        <div class="card">
            <div class="card-title">
                <i class="fas fa-database"></i> Fix Duplicate Record IDs
            </div>
            <p>
                This action will scan for check-in records that have duplicate IDs and fix them.
                Having multiple records with the same ID can cause errors when checking patients in or out.
            </p>
            <button id="fixDuplicatesBtn" class="btn">
                <i class="fas fa-wrench"></i> Fix Duplicate Records
            </button>
            <div id="duplicateStatus" class="status-message hidden"></div>
        </div>
        
        <div class="card">
            <div class="card-title">
                <i class="fas fa-home"></i> Admin Dashboard
            </div>
            <a href="/admin" class="btn">
                <i class="fas fa-arrow-left"></i> Return to Admin Dashboard
            </a>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const cleanupBtn = document.getElementById('cleanupBtn');
            const cleanupStatus = document.getElementById('cleanupStatus');
            const fixDuplicatesBtn = document.getElementById('fixDuplicatesBtn');
            const duplicateStatus = document.getElementById('duplicateStatus');
            
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
            
            cleanupBtn.addEventListener('click', async function() {
                cleanupBtn.disabled = true;
                cleanupBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                cleanupStatus.className = 'status-message hidden';
                
                try {
                    const response = await fetch('${pageContext.request.contextPath}/admin/cleanup-orphaned-records', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [csrfHeader]: csrfToken
                        }
                    });
                    
                    const data = await response.json();
                    
                    if (data.success) {
                        cleanupStatus.className = 'status-message status-success';
                        cleanupStatus.innerHTML = '<i class="fas fa-check-circle"></i> ' + data.message;
                    } else {
                        cleanupStatus.className = 'status-message status-error';
                        cleanupStatus.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + data.message;
                    }
                } catch (error) {
                    cleanupStatus.className = 'status-message status-error';
                    cleanupStatus.innerHTML = '<i class="fas fa-exclamation-circle"></i> An error occurred: ' + error.message;
                } finally {
                    cleanupBtn.disabled = false;
                    cleanupBtn.innerHTML = '<i class="fas fa-broom"></i> Clean Up Orphaned Records';
                }
            });
            
            fixDuplicatesBtn.addEventListener('click', async function() {
                fixDuplicatesBtn.disabled = true;
                fixDuplicatesBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                duplicateStatus.className = 'status-message hidden';
                
                try {
                    const response = await fetch('${pageContext.request.contextPath}/admin/fix-duplicate-ids', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [csrfHeader]: csrfToken
                        }
                    });
                    
                    const data = await response.json();
                    
                    if (data.success) {
                        duplicateStatus.className = 'status-message status-success';
                        duplicateStatus.innerHTML = '<i class="fas fa-check-circle"></i> ' + data.message;
                    } else {
                        duplicateStatus.className = 'status-message status-error';
                        duplicateStatus.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + data.message;
                    }
                } catch (error) {
                    duplicateStatus.className = 'status-message status-error';
                    duplicateStatus.innerHTML = '<i class="fas fa-exclamation-circle"></i> An error occurred: ' + error.message;
                } finally {
                    fixDuplicatesBtn.disabled = false;
                    fixDuplicatesBtn.innerHTML = '<i class="fas fa-wrench"></i> Fix Duplicate Records';
                }
            });
        });
    </script>
</body>
</html> 