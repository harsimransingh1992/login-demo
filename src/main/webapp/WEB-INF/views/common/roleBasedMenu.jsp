<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div class="sidebar-menu">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
        <h1>PeriDesk</h1>
    </div>
    
    <!-- Common options for all roles -->
    <a href="${pageContext.request.contextPath}/welcome" class="action-card">
        <i class="fas fa-home"></i>
        <div class="card-text">
            <h3>Dashboard</h3>
            <p>Main overview</p>
        </div>
    </a>

    <!-- Appointment scheduling for all roles -->
    <a href="${pageContext.request.contextPath}/appointments/create" class="action-card">
        <i class="fas fa-calendar-plus"></i>
        <div class="card-text">
            <h3>Schedule Appointment</h3>
            <p>Book a new appointment</p>
        </div>
    </a>

    <!-- Admin only options -->
    <sec:authorize access="hasRole('ADMIN')">
        <a href="${pageContext.request.contextPath}/admin" class="action-card">
            <i class="fas fa-tools"></i>
            <div class="card-text">
                <h3>Admin Panel</h3>
                <p>System management</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
            <i class="fas fa-users-cog"></i>
            <div class="card-text">
                <h3>User Management</h3>
                <p>Manage system users</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/clinics" class="action-card">
            <i class="fas fa-clinic-medical"></i>
            <div class="card-text">
                <h3>Clinic Management</h3>
                <p>Manage dental clinics</p>
            </div>
        </a>
    </sec:authorize>
    
    <!-- Clinic Owner options -->
    <sec:authorize access="hasRole('CLINIC_OWNER')">
        <a href="${pageContext.request.contextPath}/clinic/dashboard" class="action-card">
            <i class="fas fa-chart-line"></i>
            <div class="card-text">
                <h3>Clinic Dashboard</h3>
                <p>Performance overview</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/clinic/staff" class="action-card">
            <i class="fas fa-user-md"></i>
            <div class="card-text">
                <h3>Staff Management</h3>
                <p>Manage clinic staff</p>
            </div>
        </a>
    </sec:authorize>
    
    <!-- Doctor options -->
    <sec:authorize access="hasRole('DOCTOR')">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="action-card">
            <i class="fas fa-stethoscope"></i>
            <div class="card-text">
                <h3>Doctor Dashboard</h3>
                <p>Personal overview</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/doctor/appointments" class="action-card">
            <i class="fas fa-calendar-check"></i>
            <div class="card-text">
                <h3>My Appointments</h3>
                <p>View scheduled patients</p>
            </div>
        </a>
    </sec:authorize>
    
    <!-- Receptionist options -->
    <sec:authorize access="hasRole('RECEPTIONIST')">
        <a href="${pageContext.request.contextPath}/appointments/management" class="action-card">
            <i class="fas fa-calendar-alt"></i>
            <div class="card-text">
                <h3>Appointment Management</h3>
                <p>Manage patient appointments</p>
            </div>
        </a>
    </sec:authorize>
    
    <!-- Common options for staff roles (Doctor, Staff, Receptionist) -->
    <sec:authorize access="hasAnyRole('DOCTOR', 'STAFF', 'RECEPTIONIST', 'CLINIC_OWNER')">
        <a href="${pageContext.request.contextPath}/patients/list" class="action-card">
            <i class="fas fa-users"></i>
            <div class="card-text">
                <h3>Patient List</h3>
                <p>View all patients</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/patients/register" class="action-card">
            <i class="fas fa-user-plus"></i>
            <div class="card-text">
                <h3>Register Patient</h3>
                <p>Add new patient</p>
            </div>
        </a>
    </sec:authorize>
    
    <!-- Profile and logout options for all authenticated users -->
    <sec:authorize access="isAuthenticated()">
        <a href="${pageContext.request.contextPath}/profile" class="action-card">
            <i class="fas fa-user-circle"></i>
            <div class="card-text">
                <h3>My Profile</h3>
                <p>Account settings</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="action-card">
            <i class="fas fa-power-off"></i>
            <div class="card-text">
                <h3>Sign Out</h3>
                <p>Log out of your account</p>
            </div>
        </a>
    </sec:authorize>
    
    <div class="footer">
        <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
        <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
    </div>
</div> 