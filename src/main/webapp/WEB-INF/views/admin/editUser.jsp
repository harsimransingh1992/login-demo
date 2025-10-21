<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User | Admin Console</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .required-field::after {
            content: " *";
            color: red;
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
                        <li class="breadcrumb-item active" aria-current="page">Edit User</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fas fa-user-edit"></i> Edit User: ${user.username}</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                ${errorMessage}
                            </div>
                        </c:if>
                        
                        <form:form action="/admin/users/${user.id}" method="post" modelAttribute="user">
                            <form:hidden path="id" />
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="username" class="required-field">Username</label>
                                    <form:input path="username" class="form-control" required="true" />
                                    <small class="form-text text-muted">Must be unique</small>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="password">Password</label>
                                    <div class="input-group">
                                        <div class="form-control bg-light text-muted">
                                            <i class="fas fa-lock"></i> Password not shown
                                        </div>
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#resetPasswordModal">
                                                Reset Password
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="firstName" class="required-field">First Name</label>
                                    <form:input path="firstName" class="form-control" required="true" />
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="lastName" class="required-field">Last Name</label>
                                    <form:input path="lastName" class="form-control" required="true" />
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="email">Email</label>
                                    <form:input path="email" type="email" class="form-control" />
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="phoneNumber">Phone Number</label>
                                    <form:input path="phoneNumber" class="form-control" />
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="role" class="required-field">Role</label>
                                    <form:select path="role" class="form-control" required="true" id="role">
                                        <c:forEach items="${roles}" var="role">
                                            <form:option value="${role}">${role.displayName}</form:option>
                                        </c:forEach>
                                    </form:select>
                                </div>
                                <div class="form-group col-md-6" id="clinicGroup">
                                    <label for="clinic.id">Assign to Clinic</label>
                                    <form:select path="clinic.id" class="form-control" id="clinicId">
                                        <form:option value="" label="-- No Clinic --" />
                                        <c:forEach items="${clinics}" var="clinic">
                                            <form:option value="${clinic.id}">${clinic.clinicName}</form:option>
                                        </c:forEach>
                                    </form:select>
                                </div>
                            </div>
                            
                            <!-- Cross-Clinic Schedule Access -->
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <div class="custom-control custom-switch">
                                        <form:checkbox path="hasCrossClinicApptAccess" class="custom-control-input" id="crossClinicSwitch" />
                                        <label class="custom-control-label" for="crossClinicSwitch">Allow cross-clinic schedule access</label>
                                    </div>
                                </div>
                                <div class="form-group col-md-6" id="accessibleClinicsGroup" style="display:none;">
                                    <label for="accessibleClinicsSelect">Accessible Clinics</label>
                                    <form:select path="accessibleClinicIds" class="form-control" id="accessibleClinicsSelect" multiple="true">
                                        <c:forEach items="${clinics}" var="clinic">
                                            <form:option value="${clinic.id}">${clinic.clinicName}</form:option>
                                        </c:forEach>
                                    </form:select>
                                    <small class="form-text text-muted">Select clinics the user can view when cross-clinic access is enabled.</small>
                                </div>
                            </div>
                            
                            <div class="form-row" id="specializationRow" style="display: none;">
                                <div class="form-group col-md-6">
                                    <label for="specialization" class="required-field">Dental Specialization</label>
                                    <form:select path="specialization" id="specialization" class="form-control">
                                        <form:option value="" label="-- Select Specialization --" />
                                        <form:option value="Orthodontist">Orthodontist</form:option>
                                        <form:option value="Periodontist">Periodontist</form:option>
                                        <form:option value="Endodontist">Endodontist</form:option>
                                        <form:option value="Oral Surgeon">Oral Surgeon</form:option>
                                        <form:option value="Pediatric Dentist">Pediatric Dentist</form:option>
                                        <form:option value="Prosthodontist">Prosthodontist</form:option>
                                        <form:option value="General Dentist">General Dentist</form:option>
                                    </form:select>
                                </div>
                            </div>
                            
                            <!-- Professional Details Section -->
                            <div id="professionalDetails" style="display: none;">
                                <h5 class="mt-4 mb-3 border-bottom pb-2">Professional Details</h5>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6" id="licenseNumberGroup">
                                        <label for="licenseNumber">License Number</label>
                                        <form:input path="licenseNumber" class="form-control" />
                                    </div>
                                    <div class="form-group col-md-6" id="licenseExpiryGroup">
                                        <label for="licenseExpiryDate">License Expiry Date</label>
                                        <form:input path="licenseExpiryDate" type="date" class="form-control" />
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6" id="qualificationGroup">
                                        <label for="qualification">Qualification</label>
                                        <form:input path="qualification" class="form-control" placeholder="e.g., BDS, MDS, PhD" />
                                    </div>
                                    <div class="form-group col-md-6" id="designationGroup">
                                        <label for="designation">Designation/Position</label>
                                        <form:input path="designation" class="form-control" placeholder="e.g., Senior Dentist, Head of Department" />
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6" id="joiningDateGroup">
                                        <label for="joiningDate">Joining Date</label>
                                        <form:input path="joiningDate" type="date" class="form-control" />
                                    </div>
                                    <div class="form-group col-md-6" id="isActiveGroup">
                                        <label for="isActive">Status</label>
                                        <div class="form-control">
                                            <div class="custom-control custom-switch">
                                                <form:checkbox path="isActive" class="custom-control-input" id="activeStatusSwitch" />
                                                <label class="custom-control-label" for="activeStatusSwitch">Active</label>
                                            </div>
                                            <div class="custom-control custom-switch mt-2">
                                                <form:checkbox path="canRefund" class="custom-control-input" id="canRefundSwitch" />
                                                <label class="custom-control-label" for="canRefundSwitch">Can Process Refunds</label>
                                            </div>
                                            <div class="custom-control custom-switch mt-2">
                                                <form:checkbox path="canApplyDiscount" class="custom-control-input" id="canApplyDiscountSwitch" />
                                                <label class="custom-control-label" for="canApplyDiscountSwitch">Can Apply Discounts</label>
                                            </div>
                                            <div class="custom-control custom-switch mt-2">
                                                <form:checkbox path="canDeleteExamination" class="custom-control-input" id="canDeleteExaminationSwitch" />
                                                <label class="custom-control-label" for="canDeleteExaminationSwitch">Can Delete Examinations</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Contact Information Section -->
                            <div id="contactInfoSection" style="display: none;">
                                <h5 class="mt-4 mb-3 border-bottom pb-2">Additional Contact Information</h5>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6" id="emergencyContactGroup">
                                        <label for="emergencyContact">Emergency Contact</label>
                                        <form:input path="emergencyContact" class="form-control" placeholder="Emergency contact number" />
                                    </div>
                                    <div class="form-group col-md-6" id="addressGroup">
                                        <label for="address">Address</label>
                                        <form:input path="address" class="form-control" />
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Bio Section -->
                            <div id="bioSection" style="display: none;">
                                <div class="form-group">
                                    <label for="bio">Professional Biography</label>
                                    <form:textarea path="bio" class="form-control" rows="4" placeholder="Brief professional background, specialties, and experience" />
                                </div>
                            </div>
                            
                            <hr id="formDivider" style="display: none;">
                            <div class="form-group text-right">
                                <a href="/admin/users/${user.id}" class="btn btn-secondary mr-2">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Update User
                                </button>
                            </div>
                        </form:form>
                        
                        <!-- Reset Password Modal -->
                        <div class="modal fade" id="resetPasswordModal" tabindex="-1" role="dialog" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Reset Password</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        Are you sure you want to reset the password for user <strong>${user.username}</strong>?
                                        <p class="text-warning mt-2">The password will be reset to the default: "changeme".</p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                        <form action="/admin/users/${user.id}/reset-password" method="post">
                                            <button type="submit" class="btn btn-warning">Reset Password</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            // Show/hide clinic selection based on role
            function updateFormVisibility() {
                const role = $('#role').val();
                
                // Reset all sections to hidden first
                $('#specializationRow').hide();
                $('#professionalDetails').hide();
                $('#contactInfoSection').hide();
                $('#bioSection').hide();
                $('#formDivider').hide();
                $('#specialization').prop('required', false);
                
                // Clinic owner handling
                if (role === 'CLINIC_OWNER') {
                    $('#clinicGroup').hide();
                    $('#contactInfoSection').show();
                    $('#formDivider').show();
                } else {
                    $('#clinicGroup').show();
                }
                
                // Role-specific field display
                switch(role) {
                    case 'DOCTOR':
                    case 'OPD_DOCTOR':
                        // Show all professional fields for doctors
                        $('#specializationRow').show();
                        $('#specialization').prop('required', true);
                        $('#professionalDetails').show();
                        $('#licenseNumberGroup').show();
                        $('#licenseExpiryGroup').show();
                        $('#qualificationGroup').show();
                        $('#designationGroup').show();
                        $('#contactInfoSection').show();
                        $('#bioSection').show();
                        $('#formDivider').show();
                        break;
                        
                    case 'STAFF':
                        // Show limited professional fields for staff
                        $('#professionalDetails').show();
                        $('#licenseNumberGroup').hide();
                        $('#licenseExpiryGroup').hide();
                        $('#qualificationGroup').show();
                        $('#designationGroup').show();
                        $('#contactInfoSection').show();
                        $('#joiningDateGroup').show();
                        $('#isActiveGroup').show();
                        $('#formDivider').show();
                        break;
                        
                    case 'RECEPTIONIST':
                        // Show receptionist-specific fields
                        $('#professionalDetails').show();
                        $('#licenseNumberGroup').hide();
                        $('#licenseExpiryGroup').hide();
                        $('#qualificationGroup').show();
                        $('#designationGroup').show();
                        $('#contactInfoSection').show();
                        $('#joiningDateGroup').show();
                        $('#isActiveGroup').show();
                        $('#formDivider').show();
                        break;
                        
                    case 'ADMIN':
                        // Show minimal fields for admin
                        $('#isActiveGroup').show();
                        $('#professionalDetails').show();
                        $('#licenseNumberGroup').hide();
                        $('#licenseExpiryGroup').hide();
                        $('#qualificationGroup').hide();
                        $('#designationGroup').hide();
                        $('#joiningDateGroup').hide();
                        $('#contactInfoSection').show();
                        $('#formDivider').show();
                        break;
                        
                    default:
                        // Default handling for any other roles
                        $('#contactInfoSection').show();
                        $('#isActiveGroup').show();
                        $('#professionalDetails').show();
                        $('#licenseNumberGroup').hide();
                        $('#licenseExpiryGroup').hide();
                        $('#qualificationGroup').hide();
                        $('#designationGroup').hide();
                        $('#joiningDateGroup').hide();
                        $('#formDivider').show();
                }
            }
            
            function updateAccessibleClinicsVisibility() {
                const enabled = $('#crossClinicSwitch').is(':checked');
                if (enabled) {
                    $('#accessibleClinicsGroup').show();
                } else {
                    $('#accessibleClinicsGroup').hide();
                }
            }
            
            // Run on page load
            updateFormVisibility();
            updateAccessibleClinicsVisibility();
            
            // Run when role changes
            $('#role').change(updateFormVisibility);
            $('#crossClinicSwitch').change(updateAccessibleClinicsVisibility);
        });
    </script>
</body>
</html>