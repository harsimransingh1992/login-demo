<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${clinic.clinicName} | PeriDesk</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .tier-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        .tier-TIER1 { background-color: #28a745; }
        .tier-TIER2 { background-color: #17a2b8; }
        .tier-TIER3 { background-color: #ffc107; color: #212529; }
        .tier-TIER4 { background-color: #6c757d; }
        
        .doctor-card {
            margin-bottom: 15px;
            transition: transform 0.2s;
        }
        .doctor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row mb-4">
            <div class="col-md-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/clinics">Clinics</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${clinic.clinicName}</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Clinic Information</h4>
                    </div>
                    <div class="card-body">
                        <h2>${clinic.clinicName}</h2>
                        <p class="text-muted">ID: ${clinic.clinicId}</p>
                        
                        <div class="mb-3">
                            <span class="badge badge-pill tier-${clinic.cityTier} tier-badge">
                                ${clinic.cityTier.displayName}
                            </span>
                        </div>
                        
                        <c:if test="${not empty clinic.owner}">
                            <div class="mt-4">
                                <h5>Owner</h5>
                                <p>
                                    <strong>${clinic.owner.firstName} ${clinic.owner.lastName}</strong><br>
                                    ${clinic.owner.email}<br>
                                    ${clinic.owner.phoneNumber}
                                </p>
                            </div>
                        </c:if>
                        
                        <div class="mt-4">
                            <a href="/clinics/${clinic.id}/edit" class="btn btn-primary">Edit Clinic</a>
                            <form action="/clinics/${clinic.id}/delete" method="post" class="d-inline ml-2" 
                                  onsubmit="return confirm('Are you sure you want to delete this clinic?');">
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Onboarded Doctors</h4>
                        <a href="/doctors/new?clinicId=${clinic.id}" class="btn btn-sm btn-light">Add Doctor</a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty clinic.onboardedDoctors}">
                                <div class="row">
                                    <c:forEach items="${clinic.onboardedDoctors}" var="doctor">
                                        <div class="col-md-6">
                                            <div class="card doctor-card">
                                                <div class="card-body">
                                                    <h5 class="card-title">${doctor.doctorName}</h5>
                                                    <p class="card-text">
                                                        <c:if test="${not empty doctor.doctorMobileNumber}">
                                                            <strong>Phone:</strong> ${doctor.doctorMobileNumber}<br>
                                                        </c:if>
                                                    </p>
                                                    <a href="/doctors/${doctor.id}" class="btn btn-sm btn-outline-primary">View Profile</a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    No doctors have been onboarded to this clinic yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 