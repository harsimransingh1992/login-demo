<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Motivation Quotes Management - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        .quotes-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            margin-bottom: 20px;
        }
        
        .quotes-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .quotes-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
        }
        
        .quote-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }
        
        .quote-item:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .quote-text {
            font-size: 1.1rem;
            font-style: italic;
            color: #2c3e50;
            margin-bottom: 10px;
            line-height: 1.6;
        }
        
        .quote-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
            color: #7f8c8d;
        }
        
        .quote-author {
            font-weight: 500;
            color: #3498db;
        }
        
        .quote-category {
            background: #e3f2fd;
            color: #1976d2;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .quote-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.8rem;
            border-radius: 4px;
        }
        
        .no-quotes {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        
        .no-quotes i {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Motivation Quotes Management</h1>
                <a href="${pageContext.request.contextPath}/admin/motivation-quotes/new" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Quote
                </a>
            </div>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <div class="quotes-container">
                <div class="quotes-header">
                    <h2><i class="fas fa-lightbulb"></i> Motivation Quotes</h2>
                    <span class="quote-count">${quotes.size()} quotes</span>
                </div>
                
                <c:choose>
                    <c:when test="${empty quotes}">
                        <div class="no-quotes">
                            <i class="fas fa-lightbulb"></i>
                            <h3>No motivation quotes found</h3>
                            <p>Start by adding some inspiring quotes for your doctors.</p>
                            <a href="${pageContext.request.contextPath}/admin/motivation-quotes/new" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Add First Quote
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${quotes}" var="quote">
                            <div class="quote-item">
                                <div class="quote-text">"${quote.quoteText}"</div>
                                <div class="quote-meta">
                                    <div>
                                        <span class="quote-author">— ${quote.author}</span>
                                        <span class="quote-category">${quote.category}</span>
                                    </div>
                                    <div>
                                        <fmt:formatDate value="${quote.createdAt}" pattern="MMM dd, yyyy" />
                                    </div>
                                </div>
                                <div class="quote-actions">
                                    <a href="${pageContext.request.contextPath}/admin/motivation-quotes/${quote.id}/edit" class="btn btn-sm btn-primary">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/motivation-quotes/${quote.id}/delete" style="display: inline;" 
                                          onsubmit="return confirm('Are you sure you want to delete this quote?')">
                                        <button type="submit" class="btn btn-sm btn-secondary">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html> 