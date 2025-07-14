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
    
    <a href="${pageContext.request.contextPath}/welcome" class="action-card">
        <i class="fas fa-clipboard-list"></i>
        <div class="card-text">
            <h3>Waiting Lobby</h3>
            <p>View waiting patients</p>
        </div>
    </a>
    
    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
        <a href="${pageContext.request.contextPath}/patients/register" class="action-card">
            <i class="fas fa-user-plus"></i>
            <div class="card-text">
                <h3>Register Patient</h3>
                <p>Add new patient</p>
            </div>
        </a>
    </sec:authorize>
    
    <a href="${pageContext.request.contextPath}/patients/list" class="action-card">
        <i class="fas fa-users"></i>
        <div class="card-text">
            <h3>View Patients</h3>
            <p>Manage records</p>
        </div>
    </a>
    
    
    <sec:authorize access="hasAnyRole('RECEPTIONIST', 'DOCTOR')">
        <a href="${pageContext.request.contextPath}/appointments/management" class="action-card">
            <i class="fas fa-calendar-alt"></i>
            <div class="card-text">
                <h3>Appointment Management</h3>
                <p>Manage patient appointments</p>
            </div>
        </a>
    </sec:authorize>
    
    <sec:authorize access="hasRole('RECEPTIONIST')">
        <a href="${pageContext.request.contextPath}/receptionist/appointments/tracking" class="action-card">
            <i class="fas fa-search"></i>
            <div class="card-text">
                <h3>Follow-up Tracking</h3>
                <p>Track no-shows & cancellations</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/payments/pending" class="action-card">
            <i class="fas fa-money-bill-wave"></i>
            <div class="card-text">
                <h3>Pending Payments</h3>
                <p>Manage payment status</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/payments/reconciliation" class="action-card">
            <i class="fas fa-balance-scale"></i>
            <div class="card-text">
                <h3>Reconciliation</h3>
                <p>Manage reconciliation</p>
            </div>
        </a>
    </sec:authorize>
    
    <sec:authorize access="hasRole('DOCTOR')">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="action-card">
            <i class="fas fa-chart-line"></i>
            <div class="card-text">
                <h3>My Dashboard</h3>
                <p>View your patient stats</p>
            </div>
        </a>
    </sec:authorize>
    
    <sec:authorize access="hasAnyRole('DOCTOR', 'RECEPTIONIST')">
        <a href="${pageContext.request.contextPath}/visits" class="action-card">
            <i class="fas fa-calendar-check"></i>
            <div class="card-text">
                <h3>Patient Visits</h3>
                <p>Track patient history</p>
            </div>
        </a>
    </sec:authorize>
    
    <sec:authorize access="hasRole('ADMIN')">
        <a href="${pageContext.request.contextPath}/admin" class="action-card">
            <i class="fas fa-cog"></i>
            <div class="card-text">
                <h3>Admin Panel</h3>
                <p>System administration</p>
            </div>
        </a>
        
        <a href="${pageContext.request.contextPath}/admin/clinics" class="action-card">
            <i class="fas fa-clinic-medical"></i>
            <div class="card-text">
                <h3>Clinic Management</h3>
                <p>Manage clinics</p>
            </div>
        </a>
        
        <a href="${pageContext.request.contextPath}/admin/reports" class="action-card">
                <i class="fas fa-chart-bar"></i>
            <div class="card-text">
                <h3>Reports</h3>
                <p>View system reports</p>
            </div>
            </a>
    </sec:authorize>
    
    <a href="${pageContext.request.contextPath}/logout" class="action-card">
        <i class="fas fa-sign-out-alt"></i>
        <div class="card-text">
            <h3>Logout</h3>
            <p>Exit the system</p>
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