<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Procedure Price - PeriDesk Admin</title>
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
        .btn-secondary {
            background-color: #95a5a6;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #2c3e50;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
            font-family: 'Poppins', sans-serif;
        }
        .text-danger {
            color: #e74c3c;
            font-size: 0.9em;
            margin-top: 5px;
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
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .text-right {
            text-align: right;
        }
        .required-label::after {
            content: " *";
            color: #e74c3c;
            font-weight: bold;
        }
        
        .required-note {
            color: #e74c3c;
            font-size: 0.9em;
            margin-top: 20px;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Add New Procedure Price</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <c:if test="${error != null}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <div class="card">
            <h2>Procedure Price Details</h2>
            <p class="required-note">All fields are mandatory</p>
            
            <form:form method="POST" action="${pageContext.request.contextPath}/admin/prices/create" modelAttribute="procedure">
                <div class="form-group">
                    <label for="procedureName" class="required-label">Procedure Name</label>
                    <form:input path="procedureName" class="form-control" required="required" />
                    <form:errors path="procedureName" cssClass="text-danger" />
                </div>
                
                <div class="form-group">
                    <label for="cityTier" class="required-label">City Tier</label>
                    <form:select path="cityTier" class="form-control" required="required">
                        <form:option value="" label="-- Select City Tier --" />
                        <form:options items="${cityTiers}" />
                    </form:select>
                    <form:errors path="cityTier" cssClass="text-danger" />
                </div>
                
                <div class="form-group">
                    <label for="dentalDepartment" class="required-label">Department</label>
                    <form:select path="dentalDepartment" class="form-control" required="required">
                        <form:option value="" label="-- Select Department --" />
                        <form:options items="${dentalDepartments}" />
                    </form:select>
                    <form:errors path="dentalDepartment" cssClass="text-danger" />
                </div>
                
                <div class="form-group">
                    <label for="price" class="required-label">Price (₹)</label>
                    <form:input path="price" type="number" step="0.01" class="form-control" required="required" min="0.01" />
                    <form:errors path="price" cssClass="text-danger" />
                </div>
                
                <div class="form-group text-right">
                    <a href="${pageContext.request.contextPath}/admin/prices" class="btn btn-secondary">
                        <i class="fas fa-times mr-1"></i> Cancel
                    </a>
                    <button type="submit" class="btn">
                        <i class="fas fa-save mr-1"></i> Save
                    </button>
                </div>
            </form:form>
        </div>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/admin/prices" class="btn">Back to Price List</a>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</body>
</html> 