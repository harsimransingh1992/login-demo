<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Details | Admin Console</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .role-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        .role-ADMIN { background-color: #dc3545; }
        .role-CLINIC_OWNER { background-color: #6f42c1; }
        .role-DOCTOR { background-color: #28a745; }
        .role-STAFF { background-color: #17a2b8; }
        .role-RECEPTIONIST { background-color: #fd7e14; }
        
        .detail-label {
            font-weight: bold;
            color: #495057;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin">Admin Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/users">User Management</a></li>
                        <li class="breadcrumb-item active" aria-current="page">User Details</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>
        
        <div class="row">
            <div class="col-md-10 offset-md-1">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0"><i class="fas fa-user"></i> User Details</h4>
                        <div>
                            <a href="/admin/users" class="btn btn-sm btn-light mr-2">
                                <i class="fas fa-arrow-left"></i> Back to Users
                            </a>
                            <a href="/admin/users/${user.id}/edit" class="btn btn-sm btn-warning">
                                <i class="fas fa-edit"></i> Edit User
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-12">
                                <h5 class="border-bottom pb-2">${user.firstName} ${user.lastName}</h5>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Username:</strong> ${user.username}</p>
                                        <p><strong>Role:</strong> <span class="badge badge-info">${user.role.displayName}</span></p>
                                        <p><strong>Email:</strong> ${user.email}</p>
                                        <p><strong>Phone:</strong> ${user.phoneNumber}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Status:</strong> 
                                            <c:choose>
                                                <c:when test="${user.isActive == true}">
                                                    <span class="badge badge-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <c:if test="${not empty user.clinic}">
                                            <p><strong>Assigned to Clinic:</strong> ${user.clinic.clinicName}</p>
                                        </c:if>
                                        <c:if test="${not empty user.joiningDate}">
                            <p><strong>Joined on:</strong> ${user.joiningDate}</p>
                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${user.role == 'DOCTOR'}">
                            <!-- Doctor-specific section -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <h5 class="border-bottom pb-2">Professional Details</h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Specialization:</strong> ${user.specialization}</p>
                                            <p><strong>License Number:</strong> ${user.licenseNumber}</p>
                                            <c:if test="${not empty user.licenseExpiryDate}">
                                <p><strong>License Expires:</strong> ${user.licenseExpiryDate}</p>
                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Qualification:</strong> ${user.qualification}</p>
                                            <p><strong>Designation:</strong> ${user.designation}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${user.role == 'STAFF' || user.role == 'RECEPTIONIST'}">
                            <!-- Staff/receptionist-specific section -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <h5 class="border-bottom pb-2">Staff Details</h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Qualification:</strong> ${user.qualification}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Designation:</strong> ${user.designation}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty user.address || not empty user.emergencyContact}">
                            <!-- Additional contact information -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <h5 class="border-bottom pb-2">Additional Contact Information</h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <c:if test="${not empty user.address}">
                                                <p><strong>Address:</strong> ${user.address}</p>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <c:if test="${not empty user.emergencyContact}">
                                                <p><strong>Emergency Contact:</strong> ${user.emergencyContact}</p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty user.bio}">
                            <!-- Bio information for doctors -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <h5 class="border-bottom pb-2">Professional Biography</h5>
                                    <p>${user.bio}</p>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="row">
                            <div class="col-md-12 text-right">
                                <a href="/admin/users" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Users
                                </a>
                                <a href="/admin/users/${user.id}/edit" class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Edit User
                                </a>
                                <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#deleteUserModal">
                                    <i class="fas fa-trash-alt"></i> Delete User
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Delete User Modal -->
        <div class="modal fade" id="deleteUserModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Delete User</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete the user <strong>${user.username}</strong>?</p>
                        <p class="text-danger">This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <form action="/admin/users/${user.id}/delete" method="post">
                            <button type="submit" class="btn btn-danger">Delete User</button>
                        </form>
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