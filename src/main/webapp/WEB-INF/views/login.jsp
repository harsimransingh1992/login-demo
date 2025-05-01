<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>PeriDesk - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f0f5fa;
            color: #2c3e50;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .main-content {
            width: 100%;
            max-width: 550px;
            padding: 20px;
        }
        
        .form-container {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
            width: 100%;
        }
        
        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(to right, #3498db, #2980b9);
        }
        
        .logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo img {
            width: 60px;
            height: 60px;
            filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
            margin-bottom: 15px;
        }
        
        .logo h1 {
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 0 0 10px 0;
            font-weight: 600;
        }
        
        .logo p {
            color: #7f8c8d;
            margin: 0;
            font-size: 1rem;
        }
        
        .form-section {
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 1.2rem;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            font-weight: 600;
        }
        
        .section-title i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .form-group label .required {
            color: #e74c3c;
            margin-left: 4px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
            outline: none;
            background-color: #fff;
        }
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            user-select: none;
            color: #3498db;
            font-size: 14px;
            opacity: 0.7;
            transition: opacity 0.2s;
        }
        
        .password-toggle:hover {
            opacity: 1;
        }
        
        button {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
        }
        
        button:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.4);
        }
        
        .error, .success {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
        }
        
        .error {
            background-color: #fee;
            color: #e74c3c;
            border-left: 4px solid #e74c3c;
        }
        
        .success {
            background-color: #e3f8e3;
            color: #27ae60;
            border-left: 4px solid #27ae60;
        }
        
        .footer {
            margin-top: 25px;
            text-align: center;
            font-size: 12px;
            color: #999;
        }
        
        .copyright {
            margin: 5px 0;
        }
        
        .powered-by {
            color: #3498db;
            font-weight: 500;
        }
        
        .navtech {
            color: #2c3e50;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .main-content {
                padding: 15px;
            }
            
            .form-container {
                padding: 25px;
            }
            
            .logo h1 {
                font-size: 1.5rem;
            }
            
            .logo p {
                font-size: 0.9rem;
            }
        }
    </style>
    <script>
        function togglePassword(inputId) {
            const passwordInput = document.getElementById(inputId);
            const toggleText = document.querySelector(`.password-toggle[onclick*="${inputId}"]`);
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleText.innerHTML = '<i class="fas fa-eye-slash"></i>';
            } else {
                passwordInput.type = "password";
                toggleText.innerHTML = '<i class="fas fa-eye"></i>';
            }
        }
    </script>
</head>
<body>
    <div class="main-content">
        <div class="form-container">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
                <h1>PeriDesk</h1>
                <p>Welcome back! Please login to your account.</p>
            </div>
            
            <c:if test="${param.error != null}">
                <div class="error">
                    <i class="fas fa-exclamation-circle"></i> Invalid Clinic ID or password. Please try again.
                </div>
            </c:if>
            <c:if test="${param.logout != null}">
                <div class="success">
                    <i class="fas fa-check-circle"></i> You have been successfully logged out.
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-user"></i> Login Details</h3>
                    <div class="form-group">
                        <label for="username">Clinic ID <span class="required">*</span></label>
                        <input type="text" id="username" name="username" required placeholder="Enter your Clinic ID">
                    </div>
                    <div class="form-group">
                        <label for="password">Password <span class="required">*</span></label>
                        <div class="password-container">
                            <input type="password" id="password" name="password" required placeholder="Enter your password">
                            <span class="password-toggle" onclick="togglePassword('password')"><i class="fas fa-eye"></i></span>
                        </div>
                    </div>
                </div>
                
                <button type="submit">Sign In</button>
            </form>
            
            <div class="footer">
                <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
                <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
            </div>
        </div>
    </div>
</body>
</html>