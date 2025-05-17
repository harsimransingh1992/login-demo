<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - PeriDesk Admin</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            font-family: 'Poppins', sans-serif;
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
        .btn-success {
            background-color: #27ae60;
        }
        .btn-success:hover {
            background-color: #218c53;
        }
        .btn-secondary {
            background-color: #95a5a6;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th,
        .table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
        }
        .table tr:hover {
            background-color: #f5f5f5;
        }
        .actions {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 0.9em;
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
        .tier-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .tier-1 {
            background-color: #f1c40f;
            color: #7d6608;
        }
        .tier-2 {
            background-color: #3498db;
            color: #fff;
        }
        .tier-3 {
            background-color: #27ae60;
            color: #fff;
        }
        .tier-not-set {
            background-color: #95a5a6;
            color: #fff;
        }
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            position: relative;
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .close-modal {
            position: absolute;
            right: 20px;
            top: 10px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #aaa;
        }
        .close-modal:hover {
            color: #555;
        }
        .modal-header {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .modal-body {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Poppins', sans-serif;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>User Management</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                User has been created successfully.
            </div>
        </c:if>
        
        <c:if test="${param.tierUpdated != null}">
            <div class="alert alert-success">
                City tier has been updated successfully.
            </div>
        </c:if>
        
        <c:if test="${param.success eq 'updated'}">
            <div class="alert alert-success">
                User has been updated successfully.
            </div>
        </c:if>
        
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                ${param.error}
            </div>
        </c:if>
        
        <div class="card">
            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn">Create New User</a>
            </div>
            
            <h2>User List</h2>
            
            <c:choose>
                <c:when test="${empty users}">
                    <p>No users found in the system.</p>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x: auto;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Number of Doctors</th>
                                    <th>City Tier</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.onboardDoctors.size()}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty user.cityTier}">
                                                    <span class="tier-badge tier-${user.cityTier}">Tier ${user.cityTier}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="tier-badge tier-not-set">Not Set</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/doctors?clinic=${user.id}" class="btn btn-sm">View Doctors</a>
                                            <button class="btn btn-secondary btn-sm edit-tier" data-user-id="${user.id}" data-username="${user.username}" data-tier="${user.cityTier}">
                                                <i class="fas fa-city"></i> Edit Tier
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/users/${user.id}/edit" class="btn btn-sm">
                                                <i class="fas fa-user-edit"></i> Edit User
                                            </a>
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
    
    <!-- City Tier Edit Modal -->
    <div id="tierModal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <div class="modal-header">
                <h3>Edit City Tier</h3>
            </div>
            <div class="modal-body">
                <form id="tierForm" method="post" action="${pageContext.request.contextPath}/admin/users/update-tier">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" id="userId" name="userId" value="">
                    
                    <div class="form-group">
                        <label>Username:</label>
                        <p id="usernameDisplay"></p>
                    </div>
                    
                    <div class="form-group">
                        <label for="cityTier">City Tier:</label>
                        <select id="cityTier" name="cityTier" class="form-control">
                            <option value="">-- Select Tier --</option>
                            <option value="1">Tier 1 - Metro Cities</option>
                            <option value="2">Tier 2 - Large Cities</option>
                            <option value="3">Tier 3 - Small Cities</option>
                            <option value="4">Tier 4 - Rural Areas</option>
                        </select>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary close-button">Cancel</button>
                        <button type="submit" class="btn btn-success">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Modal handling
            const modal = document.getElementById('tierModal');
            const closeButtons = document.querySelectorAll('.close-modal, .close-button');
            const editButtons = document.querySelectorAll('.edit-tier');
            
            // Form elements
            const userIdInput = document.getElementById('userId');
            const usernameDisplay = document.getElementById('usernameDisplay');
            const cityTierSelect = document.getElementById('cityTier');
            
            // Open modal when edit button is clicked
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-user-id');
                    const username = this.getAttribute('data-username');
                    const currentTier = this.getAttribute('data-tier');
                    
                    userIdInput.value = userId;
                    usernameDisplay.textContent = username;
                    
                    // Set the current tier in the dropdown
                    if (currentTier) {
                        // Extract the number from TIER1, TIER2, etc.
                        const tierNumber = currentTier.replace('TIER', '');
                        cityTierSelect.value = tierNumber;
                    } else {
                        cityTierSelect.value = "";
                    }
                    
                    modal.style.display = 'block';
                });
            });
            
            // Close the modal
            closeButtons.forEach(button => {
                button.addEventListener('click', function() {
                    modal.style.display = 'none';
                });
            });
            
            // Close modal when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html> 