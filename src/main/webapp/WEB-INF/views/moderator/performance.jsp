<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clinic Performance Overview</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
        <h1 style="margin:0;">Clinic Performance Overview</h1>
        <a href="${pageContext.request.contextPath}/moderator/clinics" style="background:#3498db; color:#fff; padding:8px 18px; border-radius:4px; text-decoration:none; font-weight:600;">Go to Revenue Insights</a>
    </div>
    <c:choose>
        <c:when test="${not empty clinicRevenueList}">
            <%-- Calculate summary metrics in JSP --%>
            <c:set var="totalRevenue" value="0" />
            <c:set var="topClinic" value="" />
            <c:set var="topRevenue" value="0" />
            <c:set var="lowClinic" value="" />
            <c:set var="lowRevenue" value="" />
            <c:set var="nonZeroCount" value="0" />
            <c:forEach var="row" items="${clinicRevenueList}">
                <c:set var="totalRevenue" value="${totalRevenue + row.revenue}" />
                <c:if test="${row.revenue > topRevenue}">
                    <c:set var="topRevenue" value="${row.revenue}" />
                    <c:set var="topClinic" value="${row.clinicName}" />
                </c:if>
                <c:if test="${(lowRevenue == '' || (row.revenue < lowRevenue && row.revenue > 0))}">
                    <c:set var="lowRevenue" value="${row.revenue}" />
                    <c:set var="lowClinic" value="${row.clinicName}" />
                </c:if>
                <c:if test="${row.revenue > 0}">
                    <c:set var="nonZeroCount" value="${nonZeroCount + 1}" />
                </c:if>
            </c:forEach>
            <c:set var="avgRevenue" value="${nonZeroCount > 0 ? totalRevenue / nonZeroCount : 0}" />
            <div style="display: flex; gap: 24px; flex-wrap: wrap; margin-bottom: 28px;">
                <div style="flex:1; min-width: 180px; background:#f7fafc; border-radius:8px; padding:18px 20px; box-shadow:0 1px 4px #e1e4ea;">
                    <div style="font-size:0.95em; color:#888;">Total Revenue</div>
                    <div style="font-size:1.5em; color:#1a7f37; font-weight:600;">₹ <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></div>
                </div>
                <div style="flex:1; min-width: 180px; background:#f7fafc; border-radius:8px; padding:18px 20px; box-shadow:0 1px 4px #e1e4ea;">
                    <div style="font-size:0.95em; color:#888;">Average Revenue per Clinic</div>
                    <div style="font-size:1.3em; color:#1565c0; font-weight:600;">₹ <fmt:formatNumber value="${avgRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></div>
                </div>
                <div style="flex:1; min-width: 180px; background:#f7fafc; border-radius:8px; padding:18px 20px; box-shadow:0 1px 4px #e1e4ea;">
                    <div style="font-size:0.95em; color:#888;">Top Performing Clinic</div>
                    <div style="font-size:1.1em; color:#1a237e; font-weight:600;">${topClinic}</div>
                    <div style="font-size:1.1em; color:#1a7f37;">₹ <fmt:formatNumber value="${topRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></div>
                    <c:if test="${totalRevenue > 0}">
                        <div style="font-size:0.95em; color:#888;">(${(topRevenue * 100.0 / totalRevenue) < 1 ? '<1' : (topRevenue * 100.0 / totalRevenue)?string('0.0')}% of total)</div>
                    </c:if>
                </div>
                <div style="flex:1; min-width: 180px; background:#f7fafc; border-radius:8px; padding:18px 20px; box-shadow:0 1px 4px #e1e4ea;">
                    <div style="font-size:0.95em; color:#888;">Lowest Performing Clinic</div>
                    <div style="font-size:1.1em; color:#b71c1c; font-weight:600;">${lowClinic}</div>
                    <div style="font-size:1.1em; color:#b71c1c;">₹ <fmt:formatNumber value="${lowRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></div>
                    <c:if test="${totalRevenue > 0}">
                        <div style="font-size:0.95em; color:#888;">(${(lowRevenue * 100.0 / totalRevenue) < 1 ? '<1' : (lowRevenue * 100.0 / totalRevenue)?string('0.0')}% of total)</div>
                    </c:if>
                </div>
            </div>
            <div style="margin-bottom: 18px; color: #555; font-size: 1.1em;">
                <b>Period:</b>
                <c:choose>
                    <c:when test="${not empty param.month}">
                        <fmt:parseDate value="${param.month}-01" pattern="yyyy-MM-dd" var="monthDate"/>
                        <fmt:formatDate value="${monthDate}" pattern="MMMM yyyy"/>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${not empty param.startDate}">
                            <fmt:parseDate value="${param.startDate}" pattern="yyyy-MM-dd" var="startD"/>
                            <fmt:formatDate value="${startD}" pattern="dd MMM yyyy"/>
                        </c:if>
                        <c:if test="${not empty param.endDate}">
                            <span> to </span>
                            <fmt:parseDate value="${param.endDate}" pattern="yyyy-MM-dd" var="endD"/>
                            <fmt:formatDate value="${endD}" pattern="dd MMM yyyy"/>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
            <div style="margin-top: 32px;">
                <h3 style="margin-bottom: 12px;">Clinic Revenue Ranking</h3>
                <ol style="padding-left: 24px;">
                    <c:forEach var="row" items="${clinicRevenueList}">
                        <li><b>${row.clinicName}</b>: ₹ <fmt:formatNumber value="${row.revenue}" type="number" groupingUsed="true" minFractionDigits="2" /></li>
                    </c:forEach>
                </ol>
            </div>
        </c:when>
        <c:otherwise>
            <div class="no-data">
                No revenue data to display for the selected period.<br>
                <span style="color:#888; font-size:0.95em;">Try adjusting the date range or month, or check if clinics have recorded payments in this period.</span>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html> 