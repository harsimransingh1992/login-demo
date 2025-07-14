<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Clinic | PeriDesk</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Edit Clinic</h4>
                    </div>
                    <div class="card-body">
                        <form:form action="/clinics/${clinic.id}" method="post" modelAttribute="clinic">
                            <form:hidden path="id" />
                            
                            <div class="form-group">
                                <label for="clinicId">Clinic ID</label>
                                <form:input path="clinicId" class="form-control" required="true" />
                                <small class="form-text text-muted">A unique identifier for the clinic</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="clinicName">Clinic Name</label>
                                <form:input path="clinicName" class="form-control" required="true" />
                            </div>
                            
                            <div class="form-group">
                                <label for="cityTier">City Tier</label>
                                <form:select path="cityTier" class="form-control">
                                    <form:option value="TIER1">Tier 1 - Metro Cities</form:option>
                                    <form:option value="TIER2">Tier 2 - Large Cities</form:option>
                                    <form:option value="TIER3">Tier 3 - Small Cities</form:option>
                                    <form:option value="TIER4">Tier 4 - Rural Areas</form:option>
                                </form:select>
                            </div>
                            
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Update Clinic</button>
                                <a href="/clinics/${clinic.id}" class="btn btn-secondary ml-2">Cancel</a>
                            </div>
                        </form:form>
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