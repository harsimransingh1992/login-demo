<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>${quote.id == null ? 'Add' : 'Edit'} Motivation Quote - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        .form-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            margin-bottom: 20px;
        }
        
        .form-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .form-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: #2c3e50;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            padding-right: 30px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .preview-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .preview-section h4 {
            margin: 0 0 15px 0;
            color: #2c3e50;
        }
        
        .preview-quote {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            padding: 20px;
            color: white;
            position: relative;
        }
        
        .preview-quote-text {
            font-size: 1.1rem;
            font-style: italic;
            margin-bottom: 10px;
            line-height: 1.6;
        }
        
        .preview-quote-author {
            font-size: 0.9rem;
            text-align: right;
            opacity: 0.9;
        }
        
        .preview-quote-category {
            position: absolute;
            top: 10px;
            right: 15px;
            background: rgba(255, 255, 255, 0.2);
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 0.7rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">${quote.id == null ? 'Add New' : 'Edit'} Motivation Quote</h1>
                <a href="${pageContext.request.contextPath}/admin/motivation-quotes" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Quotes
                </a>
            </div>
            
            <div class="form-container">
                <div class="form-header">
                    <h2><i class="fas fa-lightbulb"></i> ${quote.id == null ? 'Create New' : 'Edit'} Quote</h2>
                </div>
                
                <form method="post" action="${pageContext.request.contextPath}/admin/motivation-quotes${quote.id != null ? '/' + quote.id : ''}">
                    <div class="form-group">
                        <label for="quoteText">Quote Text *</label>
                        <textarea name="quoteText" id="quoteText" class="form-control" required 
                                  placeholder="Enter the motivational quote text...">${quote.quoteText}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="author">Author</label>
                        <input type="text" name="author" id="author" class="form-control" 
                               value="${quote.author}" placeholder="Enter the author's name (optional)">
                    </div>
                    
                    <div class="form-group">
                        <label for="category">Category</label>
                        <select name="category" id="category" class="form-control">
                            <option value="GENERAL" ${quote.category == 'GENERAL' ? 'selected' : ''}>General</option>
                            <option value="PATIENT_CARE" ${quote.category == 'PATIENT_CARE' ? 'selected' : ''}>Patient Care</option>
                            <option value="INSPIRATION" ${quote.category == 'INSPIRATION' ? 'selected' : ''}>Inspiration</option>
                            <option value="EXCELLENCE" ${quote.category == 'EXCELLENCE' ? 'selected' : ''}>Excellence</option>
                            <option value="PREVENTION" ${quote.category == 'PREVENTION' ? 'selected' : ''}>Prevention</option>
                            <option value="PERSEVERANCE" ${quote.category == 'PERSEVERANCE' ? 'selected' : ''}>Perseverance</option>
                            <option value="PASSION" ${quote.category == 'PASSION' ? 'selected' : ''}>Passion</option>
                            <option value="GROWTH" ${quote.category == 'GROWTH' ? 'selected' : ''}>Growth</option>
                            <option value="INNOVATION" ${quote.category == 'INNOVATION' ? 'selected' : ''}>Innovation</option>
                        </select>
                    </div>
                    
                    <c:if test="${quote.id != null}">
                    <div class="form-group">
                        <label for="isActive">Status</label>
                        <select name="isActive" id="isActive" class="form-control">
                            <option value="true" ${quote.isActive ? 'selected' : ''}>Active</option>
                            <option value="false" ${!quote.isActive ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                    </c:if>
                    
                    <div class="preview-section">
                        <h4><i class="fas fa-eye"></i> Preview</h4>
                        <div class="preview-quote">
                            <div class="preview-quote-category" id="previewCategory">${quote.category}</div>
                            <div class="preview-quote-text" id="previewText">"${quote.quoteText}"</div>
                            <div class="preview-quote-author" id="previewAuthor">— ${quote.author}</div>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> ${quote.id == null ? 'Create' : 'Update'} Quote
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/motivation-quotes" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Live preview functionality
        document.getElementById('quoteText').addEventListener('input', function() {
            document.getElementById('previewText').textContent = '"' + this.value + '"';
        });
        
        document.getElementById('author').addEventListener('input', function() {
            document.getElementById('previewAuthor').textContent = '— ' + this.value;
        });
        
        document.getElementById('category').addEventListener('change', function() {
            document.getElementById('previewCategory').textContent = this.value;
        });
    </script>
</body>
</html> 