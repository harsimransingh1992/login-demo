<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${clinic.id == null ? 'New Clinic' : 'Edit Clinic'} - PeriDesk</title>
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

        .form-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 500;
            color: var(--secondary-color);
            margin-bottom: 8px;
        }

        .form-control {
            border: 1px solid var(--border-color);
            border-radius: 5px;
            padding: 10px 15px;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 10px 20px;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            padding: 10px 20px;
            font-weight: 500;
        }

        .btn-secondary:hover {
            background-color: #1a252f;
            border-color: #1a252f;
        }

        .alert {
            border-radius: 5px;
            margin-bottom: 20px;
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
                <h1 class="page-title">${clinic.id == null ? 'New Clinic' : 'Edit Clinic'}</h1>
                <a href="${pageContext.request.contextPath}/admin/clinics" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Clinics
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

            <div class="form-container">
                <c:choose>
                    <c:when test="${clinic.id == null}">
                        <form:form action="${pageContext.request.contextPath}/admin/clinics/save" method="POST" modelAttribute="clinic">
                            <form:hidden path="id" />
                            
                            <div class="form-group">
                                <label for="clinicId" class="form-label">Clinic ID</label>
                                <form:input path="clinicId" id="clinicId" class="form-control" required="true" />
                                <form:errors path="clinicId" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <label for="cityTier" class="form-label">City Tier</label>
                                <form:select path="cityTier" id="cityTier" class="form-control" required="true">
                                    <form:options items="${cityTiers}" />
                                </form:select>
                                <form:errors path="cityTier" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <label for="owner.id" class="form-label">Clinic Owner</label>
                                <form:select path="owner.id" id="owner" class="form-control" required="true">
                                    <form:option value="">Select Owner</form:option>
                                    <form:options items="${users}" itemValue="id" itemLabel="username" />
                                </form:select>
                                <form:errors path="owner" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <label for="clinicName" class="form-label">Clinic Name</label>
                                <form:input path="clinicName" id="clinicName" class="form-control" required="true" />
                                <form:errors path="clinicName" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Create Clinic
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/clinics" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form:form>
                    </c:when>
                    <c:otherwise>
                        <form:form action="${pageContext.request.contextPath}/admin/clinics/edit/${clinic.id}" method="POST" modelAttribute="clinic">
                            <form:hidden path="id" />
                            
                            <div class="form-group">
                                <label for="clinicName" class="form-label">Clinic Name</label>
                                <form:input path="clinicName" id="clinicName" class="form-control" required="true" />
                                <form:errors path="clinicName" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Update Clinic
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/clinics" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form:form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 