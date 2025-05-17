<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Procedure Prices Management - PeriDesk Admin</title>
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
            background-color: #e67e22;
        }
        .btn-secondary {
            background-color: #95a5a6;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 0.9em;
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
        .search-box {
            display: flex;
            margin-bottom: 20px;
        }
        .search-box input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px 0 0 4px;
            font-size: 1em;
            font-family: 'Poppins', sans-serif;
        }
        .search-box button {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-left: none;
            background-color: #f8f9fa;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        /* Custom Modal Styling */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-container {
            background-color: white;
            border-radius: 8px;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .modal-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-title {
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        .modal-close {
            background: none;
            border: none;
            font-size: 1.5em;
            cursor: pointer;
            color: #95a5a6;
        }
        .modal-body {
            padding: 20px;
        }
        .modal-footer {
            padding: 15px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Procedure Prices Management</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                Operation completed successfully!
            </div>
        </c:if>
        
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                Error: ${param.error == 'not-found' ? 'Procedure price not found' : param.error}
            </div>
        </c:if>
        
        <div class="card">
            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/prices/create" class="btn">
                    <i class="fas fa-plus-circle mr-1"></i> Add New Procedure Price
                </a>
            </div>
            
            <h2>Procedure Price List</h2>
            
            <form action="${pageContext.request.contextPath}/admin/prices" method="get" class="search-box">
                <input type="text" placeholder="Search by procedure name" name="query" value="${searchQuery}">
                <button type="submit"><i class="fas fa-search"></i></button>
                <c:if test="${searchQuery != null}">
                    <a href="${pageContext.request.contextPath}/admin/prices" class="btn">Clear</a>
                </c:if>
            </form>
            
            <c:choose>
                <c:when test="${empty procedures}">
                    <p>No procedure prices found.</p>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x: auto;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Procedure Name</th>
                                    <th>City Tier</th>
                                    <th>Department</th>
                                    <th>Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="procedure" items="${procedures}">
                                    <tr>
                                        <td>${procedure.id}</td>
                                        <td>${procedure.procedureName}</td>
                                        <td>${procedure.cityTier}</td>
                                        <td>${procedure.dentalDepartment != null ? procedure.dentalDepartment.displayName : 'Not specified'}</td>
                                        <td>₹${procedure.price}</td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/prices/${procedure.id}/edit" class="btn btn-warning btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button class="btn btn-danger btn-sm delete-procedure" data-id="${procedure.id}">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
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
    
    <!-- Custom Delete Confirmation Modal -->
    <div id="deleteModal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="modal-close" id="closeModal">&times;</button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this procedure price?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" id="cancelDelete">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        $(document).ready(function() {
            var procedureIdToDelete;
            var deleteModal = document.getElementById('deleteModal');
            
            // Open modal
            $('.delete-procedure').click(function() {
                procedureIdToDelete = $(this).data('id');
                deleteModal.style.display = 'flex';
            });
            
            // Close modal when clicking cancel, X, or outside
            $('#cancelDelete, #closeModal').click(function() {
                deleteModal.style.display = 'none';
            });
            
            $(window).click(function(event) {
                if (event.target == deleteModal) {
                    deleteModal.style.display = 'none';
                }
            });
            
            // Handle delete confirmation
            $('#confirmDelete').click(function() {
                $.ajax({
                    type: 'POST',
                    url: '${pageContext.request.contextPath}/admin/prices/' + procedureIdToDelete + '/delete',
                    success: function(response) {
                        if (response.success) {
                            location.reload();
                        } else {
                            alert('Error: ' + response.message);
                        }
                    },
                    error: function() {
                        alert('Error occurred while deleting procedure price');
                    }
                });
            });
        });
    </script>
</body>
</html> 