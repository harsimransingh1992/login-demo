<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/menu.css">

<!-- Mobile menu toggle button -->
<button class="menu-toggle" id="menuToggle">
    <i class="fas fa-bars"></i>
</button>

<!-- Overlay for mobile menu -->
<div class="overlay" id="overlay"></div>

<div class="sidebar-menu" id="sidebarMenu">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
        <h1>PeriDesk</h1>
    </div>
    
    <!-- Current User Info -->
    <div class="user-info">
        <h4 class="user-name">
            Hi, <sec:authentication property="name" />
        </h4>
    </div>

    <sec:authorize access="!hasRole('MODERATOR')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/welcome')}" />
        <a href="${pageContext.request.contextPath}/welcome" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-clipboard-list"></i>
            <div class="card-text">
                <h3>Waiting Lobby</h3>
            </div>
        </a>
    </sec:authorize>
    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/patients/register')}" />
        <a href="${pageContext.request.contextPath}/patients/register" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-user-plus"></i>
            <div class="card-text">
                <h3>Register Patient</h3>
            </div>
        </a>
    </sec:authorize>
    <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/patients/list')}" />
    <a href="${pageContext.request.contextPath}/patients/list" class="action-card${isActive ? ' active' : ''}">
        <i class="fas fa-users"></i>
        <div class="card-text">
            <h3>View Patients</h3>
        </div>
    </a>
    <div class="menu-divider"></div>

    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'DOCTOR', 'OPD_DOCTOR')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/appointments/management')}" />
        <a href="${pageContext.request.contextPath}/appointments/management" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-calendar-alt"></i>
            <div class="card-text">
                <h3>Appointment Management</h3>
            </div>
        </a>
    </sec:authorize>

    <sec:authorize access="hasRole('RECEPTIONIST')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/receptionist/appointments/tracking')}" />
        <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-search"></i>
            <div class="card-text">
                <h3>Follow-up Tracking</h3>
            </div>
        </a>
    </sec:authorize>
    <sec:authorize access="hasAnyRole('DOCTOR', 'OPD_DOCTOR', 'RECEPTIONIST')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/visits')}" />
        <a href="${pageContext.request.contextPath}/visits" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-calendar-check"></i>
            <div class="card-text">
                <h3>Patient Visits</h3>
            </div>
        </a>
    </sec:authorize>
    <sec:authorize access="hasRole('OPD_DOCTOR')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/clinical-files')}" />
        <div class="action-card disabled-menu-item" style="cursor: not-allowed; opacity: 0.6; pointer-events: none;">
            <i class="fas fa-folder-open"></i>
            <div class="card-text">
                <h3>Clinical Files</h3>
                <small style="color: #f39c12; font-weight: 500;">(Under Construction)</small>
            </div>
        </div>
    </sec:authorize>
    <div class="menu-divider"></div>

    <sec:authorize access="hasRole('RECEPTIONIST')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/payments/pending')}" />
        <a href="${pageContext.request.contextPath}/payments/pending" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-money-bill-wave"></i>
            <div class="card-text">
                <h3>Pending Payments</h3>
            </div>
        </a>
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/payments/reconciliation')}" />
        <a href="${pageContext.request.contextPath}/payments/reconciliation" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-balance-scale"></i>
            <div class="card-text">
                <h3>Reconciliation</h3>
            </div>
        </a>
    </sec:authorize>
    <sec:authorize access="hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR') or hasRole('STAFF')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/payment-management')}" />
        <div class="action-card disabled-menu-item" style="cursor: not-allowed; opacity: 0.6; pointer-events: none;">
            <i class="fas fa-credit-card"></i>
            <div class="card-text">
                <h3>Payment Management</h3>
                <small style="color: #f39c12; font-weight: 500;">(Under Construction)</small>
            </div>
        </div>
    </sec:authorize>
    <div class="menu-divider"></div>

    <sec:authorize access="hasRole('DOCTOR') or hasRole('OPD_DOCTOR')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/doctor/dashboard')}" />
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-chart-line"></i>
            <div class="card-text">
                <h3>My Dashboard</h3>
            </div>
        </a>
    </sec:authorize>
    <sec:authorize access="hasRole('MODERATOR')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/moderator/tooth-exam-dashboard')}" />
        <a href="${pageContext.request.contextPath}/moderator/tooth-exam-dashboard" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-tooth"></i>
            <div class="card-text">
                <h3>Tooth Exam Dashboard</h3>
            </div>
        </a>
    </sec:authorize>
    <sec:authorize access="hasRole('ADMIN')">
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/admin')}" />
        <a href="${pageContext.request.contextPath}/admin" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-cog"></i>
            <div class="card-text">
                <h3>Admin Panel</h3>
            </div>
        </a>
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/admin/clinics')}" />
        <a href="${pageContext.request.contextPath}/admin/clinics" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-clinic-medical"></i>
            <div class="card-text">
                <h3>Clinic Management</h3>
            </div>
        </a>
        <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/admin/reports')}" />
        <a href="${pageContext.request.contextPath}/admin/reports" class="action-card${isActive ? ' active' : ''}">
            <i class="fas fa-chart-bar"></i>
            <div class="card-text">
                <h3>Reports</h3>
            </div>
        </a>
    </sec:authorize>
    <div class="menu-divider"></div>

    <c:set var="isActive" value="${pageContext.request.requestURI == pageContext.request.contextPath.concat('/logout')}" />
    <a href="${pageContext.request.contextPath}/logout" class="action-card${isActive ? ' active' : ''}">
        <i class="fas fa-power-off"></i>
        <div class="card-text">
            <h3>Logout</h3>
        </div>
    </a>
    <div class="footer">
        <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
        <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
    </div>
</div>

<!-- Mobile menu JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const menuToggle = document.getElementById('menuToggle');
        const sidebarMenu = document.getElementById('sidebarMenu');
        const overlay = document.getElementById('overlay');
        
        if (menuToggle && sidebarMenu && overlay) {
            menuToggle.addEventListener('click', function() {
                sidebarMenu.classList.toggle('active');
                overlay.classList.toggle('active');
            });
            
            overlay.addEventListener('click', function() {
                sidebarMenu.classList.remove('active');
                overlay.classList.remove('active');
            });
        }
    });
</script>