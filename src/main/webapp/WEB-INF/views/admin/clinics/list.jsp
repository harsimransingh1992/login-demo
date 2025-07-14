<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clinics - PeriDesk</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f1c40f;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-bg);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .main-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .page-title {
            margin: 0;
            color: var(--secondary-color);
            font-size: 24px;
            font-weight: 600;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            border-top: none;
            font-weight: 600;
            color: var(--secondary-color);
        }

        .table td {
            vertical-align: middle;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 8px 16px;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-danger {
            background-color: var(--danger-color);
            border-color: var(--danger-color);
            padding: 8px 16px;
            font-weight: 500;
        }

        .btn-danger:hover {
            background-color: #c0392b;
            border-color: #c0392b;
        }

        .alert {
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .badge {
            padding: 6px 12px;
            font-weight: 500;
            border-radius: 20px;
        }

        .badge-tier1 {
            background-color: var(--primary-color);
            color: white;
        }

        .badge-tier2 {
            background-color: var(--warning-color);
            color: var(--secondary-color);
        }

        .badge-tier3 {
            background-color: var(--secondary-color);
            color: white;
        }

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">Clinics</h1>
                <a href="${pageContext.request.contextPath}/admin/clinics/new" class="btn btn-primary">
                    <i class="fas fa-plus"></i> New Clinic
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" role="alert">
                    ${successMessage}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Clinic ID</th>
                            <th>Name</th>
                            <th>City Tier</th>
                            <th>Owner</th>
                            <th>Doctors</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${clinics}" var="clinic">
                            <tr>
                                <td>${clinic.clinicId}</td>
                                <td>${clinic.clinicName}</td>
                                <td>
                                    <span class="badge badge-${clinic.cityTier.name().toLowerCase()}">
                                        ${clinic.cityTier}
                                    </span>
                                </td>
                                <td>${clinic.owner.username}</td>
                                <td>${clinic.doctors.size()}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/clinics/edit/${clinic.id}" 
                                       class="btn btn-primary btn-sm">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <button type="button" class="btn btn-danger btn-sm" 
                                            onclick="deleteClinic(${clinic.id})">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        function deleteClinic(clinicId) {
            if (confirm('Are you sure you want to delete this clinic?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/clinics/' + clinicId + '/delete',
                    type: 'POST',
                    success: function(response) {
                        if (response.success) {
                            location.reload();
                        } else {
                            alert('Error deleting clinic: ' + (response.message || 'Unknown error'));
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('Error deleting clinic: ' + error);
                    }
                });
            }
        }
    </script>
</body>
</html> 