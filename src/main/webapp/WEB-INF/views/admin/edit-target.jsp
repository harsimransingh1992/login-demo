<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Doctor Target - PeriDesk</title>
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
            max-width: 800px;
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
            padding: 30px;
            margin-bottom: 20px;
        }
        .card h2 {
            margin-top: 0;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #2c3e50;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
        }
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
            margin-bottom: 10px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
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
        .btn-secondary {
            background-color: #95a5a6;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .required {
            color: #e74c3c;
        }
        .help-text {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
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
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Edit Doctor Target</h1>
        <p>Update target configuration for doctors based on city tiers</p>
        
        <form action="${pageContext.request.contextPath}/logout" method="post" style="position: absolute; top: 20px; right: 20px;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-secondary">Logout</button>
        </form>
    </div>
    
    <div class="container">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
        </c:if>
        
        <div class="card">
            <h2>Target Configuration</h2>
            <p>Update the target configuration for doctors based on their clinic's city tier.</p>
            
            <form method="POST" action="${pageContext.request.contextPath}/admin/targets/${target.id}/edit">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="id" value="${target.id}"/>
                
                <div class="form-group">
                    <label for="cityTier">City Tier <span class="required">*</span></label>
                    <select id="cityTier" name="cityTier" class="form-control" required>
                        <option value="">-- Select City Tier --</option>
                        <c:forEach var="tier" items="${cityTiers}">
                            <option value="${tier}" ${target.cityTier == tier ? 'selected' : ''}>${tier.displayName}</option>
                        </c:forEach>
                    </select>
                    <div class="help-text">Select the city tier this target applies to</div>
                </div>
                
                <div class="form-group">
                    <label for="monthlyRevenueTarget">Monthly Revenue Target (₹) <span class="required">*</span></label>
                    <input type="number" id="monthlyRevenueTarget" name="monthlyRevenueTarget" class="form-control" 
                           step="0.01" min="0" required value="${target.monthlyRevenueTarget}" placeholder="e.g., 500000">
                    <div class="help-text">Set the monthly revenue target in Indian Rupees</div>
                </div>
                
                <div class="form-group">
                    <label for="monthlyPatientTarget">Monthly Patient Target <span class="required">*</span></label>
                    <input type="number" id="monthlyPatientTarget" name="monthlyPatientTarget" class="form-control" 
                           min="1" required value="${target.monthlyPatientTarget}" placeholder="e.g., 100">
                    <div class="help-text">Set the target number of patients per month</div>
                </div>
                
                <div class="form-group">
                    <label for="monthlyProcedureTarget">Monthly Procedure Target <span class="required">*</span></label>
                    <input type="number" id="monthlyProcedureTarget" name="monthlyProcedureTarget" class="form-control" 
                           min="1" required value="${target.monthlyProcedureTarget}" placeholder="e.g., 150">
                    <div class="help-text">Set the target number of procedures per month</div>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" class="form-control" rows="3" 
                              placeholder="Optional description for this target configuration">${target.description}</textarea>
                    <div class="help-text">Provide additional context about this target configuration</div>
                </div>
                
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="isActive" name="isActive" value="true" ${target.isActive ? 'checked' : ''}>
                        <label for="isActive">Active Target</label>
                    </div>
                    <div class="help-text">Check this box to make this target active for doctors</div>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Update Target
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/targets" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
        
        <div class="card">
            <h3>Current Target Information</h3>
            <p><strong>Target ID:</strong> ${target.id}</p>
            <p><strong>City Tier:</strong> ${target.cityTier.displayName}</p>
            <p><strong>Status:</strong> 
                <c:choose>
                    <c:when test="${target.isActive}">
                        <span style="color: #27ae60; font-weight: 600;">Active</span>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #e74c3c; font-weight: 600;">Inactive</span>
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
</body>
</html> 