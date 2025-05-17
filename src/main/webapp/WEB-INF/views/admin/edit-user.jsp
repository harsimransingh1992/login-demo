<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - PeriDesk Admin</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            border: none;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            transition: background-color 0.3s;
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
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
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
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
        }
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        .actions {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .error-message {
            color: #e74c3c;
            margin-top: 5px;
            font-size: 0.9em;
        }
        .password-container {
            position: relative;
        }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            user-select: none;
            color: #3498db;
            font-size: 14px;
        }
        .warning-text {
            color: #e67e22;
            font-size: 0.9em;
            margin-top: 5px;
        }
        .info-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
        }
        .info-section h3 {
            margin-top: 0;
            color: #2c3e50;
            font-size: 1.1em;
        }
        .info-section p {
            margin-bottom: 0;
            color: #7f8c8d;
            font-size: 0.9em;
        }
    </style>
    <script>
        function togglePassword(inputId) {
            const passwordInput = document.getElementById(inputId);
            const toggleText = document.querySelector(`.password-toggle[onclick*="${inputId}"]`);
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleText.innerText = "Hide";
            } else {
                passwordInput.type = "password";
                toggleText.innerText = "Show";
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>Edit User</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>User Information</h2>
            
            <div class="info-section">
                <h3>User ID: ${user.id}</h3>
                <p>Editing the information below will update this user's settings in the system.</p>
            </div>
            
            <c:if test="${error != null}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/users/${user.id}/edit" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="form-group">
                    <label for="username">Username (Clinic ID)</label>
                    <input type="text" id="username" name="username" class="form-control" value="${user.username}" required />
                </div>
                
                <div class="form-group">
                    <label for="cityTier">City Tier</label>
                    <select id="cityTier" name="cityTier" class="form-control">
                        <option value="">-- Select City Tier --</option>
                        <option value="TIER1" ${user.cityTier == 'TIER1' ? 'selected' : ''}>Tier 1 - Metro Cities</option>
                        <option value="TIER2" ${user.cityTier == 'TIER2' ? 'selected' : ''}>Tier 2 - Large Cities</option>
                        <option value="TIER3" ${user.cityTier == 'TIER3' ? 'selected' : ''}>Tier 3 - Small Cities</option>
                        <option value="TIER4" ${user.cityTier == 'TIER4' ? 'selected' : ''}>Tier 4 - Rural Areas</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password (leave blank to keep current)</label>
                    <div class="password-container">
                        <input type="password" id="newPassword" name="newPassword" class="form-control" />
                        <span class="password-toggle" onclick="togglePassword('newPassword')">Show</span>
                    </div>
                    <p class="warning-text">Note: If entered, this will reset the user's password.</p>
                </div>
                
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn">Cancel</a>
                    <button type="submit" class="btn">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
</body>
</html> 