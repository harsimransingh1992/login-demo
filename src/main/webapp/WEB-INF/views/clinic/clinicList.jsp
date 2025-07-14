<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clinics | PeriDesk</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .clinic-card {
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .clinic-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .tier-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .tier-TIER1 { background-color: #28a745; }
        .tier-TIER2 { background-color: #17a2b8; }
        .tier-TIER3 { background-color: #ffc107; }
        .tier-TIER4 { background-color: #6c757d; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Clinics</h1>
            <a href="/clinics/new" class="btn btn-primary">Add New Clinic</a>
        </div>
        
        <c:if test="${param.error != null}">
            <div class="alert alert-danger" role="alert">
                ${param.error}
            </div>
        </c:if>
        
        <div class="row">
            <c:forEach items="${clinics}" var="clinic">
                <div class="col-md-4">
                    <div class="card clinic-card">
                        <div class="card-body">
                            <span class="badge badge-pill tier-${clinic.cityTier} tier-badge">
                                ${clinic.cityTier.displayName}
                            </span>
                            <h5 class="card-title">${clinic.clinicName}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">ID: ${clinic.clinicId}</h6>
                            <p class="card-text">
                                <strong>Doctors:</strong> ${clinic.onboardedDoctors.size()}
                            </p>
                            <div class="d-flex justify-content-between mt-3">
                                <a href="/clinics/${clinic.id}" class="btn btn-sm btn-info">View Details</a>
                                <a href="/clinics/${clinic.id}/edit" class="btn btn-sm btn-secondary">Edit</a>
                                <form action="/clinics/${clinic.id}/delete" method="post" onsubmit="return confirm('Are you sure you want to delete this clinic?');">
                                    <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty clinics}">
                <div class="col-12">
                    <div class="alert alert-info" role="alert">
                        No clinics found. Click "Add New Clinic" to create one.
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 