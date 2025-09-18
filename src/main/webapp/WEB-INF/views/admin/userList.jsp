<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management - PeriDesk Admin</title>
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

        .admin-container {
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

        .btn-add-user {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-add-user:hover {
            background: #2980b9;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }

        .users-table {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table {
            margin: 0;
        }

        .table th {
            background: var(--light-bg);
            border-bottom: 2px solid var(--border-color);
            color: var(--secondary-color);
            font-weight: 600;
            padding: 15px;
        }

        .table td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }

        .role-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            color: white;
        }

        .role-ADMIN { background-color: var(--danger-color); }
        .role-DOCTOR { background-color: var(--success-color); }
        .role-OPD_DOCTOR { background-color: var(--info-color); }
        .role-STAFF { background-color: var(--primary-color); }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-action {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
            border: none;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-view { background-color: var(--primary-color); }
        .btn-edit { background-color: var(--warning-color); }
        .btn-reset { background-color: var(--success-color); }
        .btn-delete { background-color: var(--danger-color); }

        .btn-action:hover {
            transform: translateY(-2px);
            color: white;
        }

        .modal-content {
            border-radius: 10px;
            border: none;
        }

        .modal-header {
            background: var(--light-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 20px;
        }

        .modal-title {
            color: var(--secondary-color);
            font-weight: 600;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            border-top: 1px solid var(--border-color);
            padding: 15px 20px;
        }

        .alert {
            border-radius: 5px;
            margin-bottom: 20px;
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert i {
            font-size: 20px;
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
    <div class="admin-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">User Management</h1>
                <a href="/admin/users/new" class="btn-add-user">
                    <i class="fas fa-user-plus"></i> Add New User
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${successMessage}</span>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <div class="users-table">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Clinic</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="user">
                                <tr>
                                    <td>${user.username}</td>
                                    <td>${user.firstName} ${user.lastName}</td>
                                    <td>
                                        <span class="role-badge role-${user.role}">
                                            ${user.role.displayName}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty user.clinic}">
                                                <a href="/clinics/${user.clinic.id}">${user.clinic.clinicName}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not assigned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>${user.phoneNumber}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="/admin/users/${user.id}" class="btn-action btn-view" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="/admin/users/${user.id}/edit" class="btn-action btn-edit" title="Edit User">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button type="button" class="btn-action btn-reset" title="Reset Password" 
                                                    onclick="showResetPasswordModal('${user.id}', '${user.username}')">
                                                <i class="fas fa-key"></i>
                                            </button>
                                            <button type="button" class="btn-action btn-delete" title="Delete User"
                                                    onclick="showDeleteModal('${user.id}', '${user.username}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="7" class="text-center">No users found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Reset Password Modal -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reset Password</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to reset the password for user <strong id="resetUsername"></strong>?</p>
                    <p class="text-warning">The user will be required to change their password on next login.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <form id="resetPasswordForm" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-warning">Reset Password</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete User</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete user <strong id="deleteUsername"></strong>?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <form id="deleteUserForm" method="post">
                        <button type="submit" class="btn btn-danger">Delete User</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function showResetPasswordModal(userId, username) {
            $('#resetUsername').text(username);
            $('#resetPasswordForm').attr('action', '/admin/users/' + userId + '/reset-password');
            $('#resetPasswordModal').modal('show');
        }

        function showDeleteModal(userId, username) {
            $('#deleteUsername').text(username);
            $('#deleteUserForm').attr('action', '/admin/users/' + userId + '/delete');
            $('#deleteUserModal').modal('show');
        }

        $(document).ready(function() {
            // Close modals when clicking outside
            $('.modal').on('click', function(e) {
                if ($(e.target).is('.modal')) {
                    $(this).modal('hide');
                }
            });

            // Close modals when pressing escape key
            $(document).on('keydown', function(e) {
                if (e.key === 'Escape') {
                    $('.modal').modal('hide');
                }
            });
        });
    </script>
</body>
</html> 