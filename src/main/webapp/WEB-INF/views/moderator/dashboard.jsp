<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome Moderator - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <style>
      .dashboard-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 32px;
        margin: 36px 0 36px 0;
        justify-items: center;
      }
      .dashboard-card {
        background: #fff;
        border-radius: 14px;
        box-shadow: 0 2px 12px #e1e4ea;
        padding: 32px 24px 28px 24px;
        min-width: 200px;
        min-height: 120px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        transition: box-shadow 0.2s, transform 0.2s;
        position: relative;
      }
      .dashboard-card:hover {
        box-shadow: 0 6px 24px #b3c6e4;
        transform: translateY(-2px) scale(1.02);
      }
      .dashboard-card-title {
        font-size: 1.1em;
        color: #888;
        font-weight: 600;
        margin-bottom: 10px;
        text-align: center;
        letter-spacing: 0.5px;
      }
      .dashboard-card-value {
        font-size: 2.1em;
        color: #1565c0;
        font-weight: 700;
        margin-bottom: 0;
        text-align: center;
      }
      .dashboard-card-icon {
        font-size: 2.2em;
        margin-bottom: 10px;
        color: #2563eb;
      }
      @media (max-width: 700px) {
        .dashboard-cards { gap: 16px; }
        .dashboard-card { padding: 18px 8px; min-width: 120px; }
        .dashboard-card-title { font-size: 1em; }
        .dashboard-card-value { font-size: 1.3em; }
      }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container" style="text-align:center;">
    <h1 style="margin-top: 24px; color: #1565c0;">Welcome, Business Moderator!</h1>
    <p style="font-size:1.2em; color:#444; margin: 18px 0 32px 0;">
        You have access to powerful business insights across all clinics.<br>
        Use the dashboard below to analyze performance, monitor revenue, and drive growth.
    </p>
    <div class="dashboard-cards">
      <div class="dashboard-card">
        <div class="dashboard-card-icon"><i class="fas fa-hospital"></i></div>
        <div class="dashboard-card-title">Total Clinics</div>
        <div class="dashboard-card-value">${totalClinics}</div>
      </div>
      <div class="dashboard-card">
        <div class="dashboard-card-icon"><i class="fas fa-user-md"></i></div>
        <div class="dashboard-card-title">Total Doctors</div>
        <div class="dashboard-card-value">
          <c:choose>
            <c:when test="${not empty totalDoctors}">${totalDoctors}</c:when>
            <c:otherwise>-</c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="dashboard-card">
        <div class="dashboard-card-icon"><i class="fas fa-users"></i></div>
        <div class="dashboard-card-title">Total Patients</div>
        <div class="dashboard-card-value">${totalPatients}</div>
      </div>
    </div>
    <div style="margin: 36px auto 0 auto; max-width: 500px; background: #f7fafc; border-radius: 10px; padding: 28px 24px; box-shadow: 0 1px 8px #e1e4ea;">
        <h3 style="color:#2c3e50; margin-bottom: 12px;">Today's Business Inspiration</h3>
        <div style="font-size:1.1em; color:#444; font-style:italic;">
            <c:choose>
                <c:when test="${not empty motivationQuote}">
                    "${motivationQuote.quoteText}"<br>
                    <span style="font-size:0.95em; color:#888;">
                        — <c:out value="${motivationQuote.author}" default="Unknown"/>
                    </span>
                </c:when>
                <c:otherwise>
                    "Success in business requires training, discipline and hard work. But if you're not frightened by these things, the opportunities are just as great today as they ever were."<br>
                    <span style="font-size:0.95em; color:#888;">— David Rockefeller</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html> 