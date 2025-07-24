<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/menu.css">
<style>
  .moderator-card-menu-list {
    display: flex;
    flex-direction: column;
    gap: 1.1rem;
    margin: 2.2rem 0 2.2rem 0;
    padding: 0 1.2rem;
  }
  .moderator-card-menu-item {
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    border-radius: 1rem;
    box-shadow: 0 2px 8px rgba(30,41,59,0.07);
    padding: 1.1rem 1.2rem;
    text-decoration: none;
    color: #2d3748;
    font-weight: 500;
    font-size: 1.08rem;
    transition: box-shadow 0.18s, transform 0.18s, color 0.18s, background 0.18s;
    border: 1px solid #e2e8f0;
    position: relative;
  }
  .moderator-card-menu-item:hover {
    box-shadow: 0 4px 16px rgba(30,41,59,0.13);
    transform: translateY(-2px) scale(1.03);
    color: #2563eb;
    background: #f1f5fd;
    border-color: #2563eb;
  }
  .sidebar-menu {
    width: 280px;
    min-height: 100vh;
    background: #f8fafc;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.07);
    display: flex;
    flex-direction: column;
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    z-index: 1000;
  }
  .logo {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 1.1rem;
    margin-bottom: 0.5rem;
  }
  .logo img {
    width: 36px;
    height: 36px;
    margin-bottom: 0.2rem;
  }
  .logo h1 {
    font-size: 1.1rem;
    font-weight: 700;
    color: #2d3748;
    margin: 0;
    letter-spacing: 0.01em;
  }
  .user-info {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1rem 1.5rem;
    border-bottom: 1px solid #e2e8f0;
  }
  .user-name {
    font-weight: 600;
    color: #2d3748;
    margin: 0;
    font-size: 1rem;
  }
  .footer {
    padding: 1rem 1.5rem;
    border-top: 1px solid #e2e8f0;
    margin-top: auto;
    text-align: center;
    color: #64748b;
    font-size: 0.95rem;
    opacity: 0.85;
  }
  .footer .powered-by {
    font-weight: 600;
  }
  .footer .navtech {
    color: #2563eb;
    font-weight: 700;
    margin-left: 0.2em;
  }
</style>
<div class="sidebar-menu" id="sidebarMenu">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
        <h1>PeriDesk</h1>
    </div>
    <div class="user-info">
        <h4 class="user-name">Moderator</h4>
    </div>
    <div class="moderator-card-menu-list">
        <a href="${pageContext.request.contextPath}/moderator/dashboard" class="moderator-card-menu-item">
            Home
        </a>
        <a href="${pageContext.request.contextPath}/moderator/doctors-performance" class="moderator-card-menu-item">
            Doctors Performance
        </a>
        <a href="${pageContext.request.contextPath}/moderator/clinics" class="moderator-card-menu-item">
            Revenue Insights
        </a>
        <a href="${pageContext.request.contextPath}/moderator/pending-payments" class="moderator-card-menu-item">
            Pending Payments
        </a>
        <a href="${pageContext.request.contextPath}/moderator/department-revenue" class="moderator-card-menu-item">
            Department Revenue
        </a>
        <a href="${pageContext.request.contextPath}/moderator/clinics-dashboard" class="moderator-card-menu-item">
            Clinics Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/moderator/customer-insights" class="moderator-card-menu-item">
            Customer Insights
        </a>
        <a href="${pageContext.request.contextPath}/moderator/tooth-exam-insights" class="moderator-card-menu-item">
            Tooth Examination Insights
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="moderator-card-menu-item">
            Logout
        </a>
    </div>
    <div class="footer">
        <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
        <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
    </div>
</div> 