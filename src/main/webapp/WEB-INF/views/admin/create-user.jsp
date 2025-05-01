<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create User - PeriDesk Admin</title>
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
        <h1>Create New User</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>User Information</h2>
            
            <c:if test="${error != null}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/users/create" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="form-group">
                    <label for="username">Username (Clinic ID)</label>
                    <input type="text" id="username" name="username" class="form-control" required />
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" class="form-control" required />
                        <span class="password-toggle" onclick="togglePassword('password')">Show</span>
                    </div>
                </div>
                
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn">Cancel</a>
                    <button type="submit" class="btn">Create User</button>
                </div>
            </form>
        </div>
    </div>
    
    <div class="footer">
        <p>© 2024 PeriDesk Admin Console. All access is logged and monitored.</p>
    </div>
</body>
</html> 