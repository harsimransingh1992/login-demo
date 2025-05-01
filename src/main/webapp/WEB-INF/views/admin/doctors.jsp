<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Management - PeriDesk Admin</title>
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
    </style>
    <script>
        function deleteDoctor(id) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                const token = document.querySelector('meta[name="_csrf"]').content;
                
                fetch('${pageContext.request.contextPath}/admin/doctors/' + id + '/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': token
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.reload();
                    } else {
                        alert('Error: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while deleting the doctor.');
                });
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>Doctor Management</h1>
        <p>PeriDesk Admin Console</p>
    </div>
    
    <div class="container">
        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                Doctor has been created successfully.
            </div>
        </c:if>
        
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                Doctor has been updated successfully.
            </div>
        </c:if>
        
        <c:if test="${param.error == 'not-found'}">
            <div class="alert alert-danger">
                Doctor not found.
            </div>
        </c:if>
        
        <div class="card">
            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/doctors/create" class="btn">Add New Doctor</a>
            </div>
            
            <h2>Doctor List</h2>
            
            <c:choose>
                <c:when test="${empty doctors}">
                    <p>No doctors found in the system.</p>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x: auto;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Doctor Name</th>
                                    <th>Assigned Clinic</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doctor" items="${doctors}">
                                    <tr>
                                        <td>${doctor.id}</td>
                                        <td>${doctor.doctorName}</td>
                                        <td>${doctor.onboardClinic.username}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/edit" class="btn">Edit</a>
                                            <button onclick="deleteDoctor(${doctor.id})" class="btn btn-danger">Delete</button>
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
</body>
</html> 