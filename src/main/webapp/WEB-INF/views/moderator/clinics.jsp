<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clinic Revenue Insights</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/moderator-insights.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
      .moderator-container {
        width: 100%;
        box-sizing: border-box;
      }
    </style>
</head>
<body>
<jsp:include page="moderator-menu.jsp" />
<div class="moderator-container">
    <div class="heading-main">Clinic Revenue Insights</div>
    <div class="heading-desc">View and filter revenue collected by each clinic for a selected period. Use the filters below to focus your analysis.</div>
    <form id="revenueForm" method="get" action="" onsubmit="return validateRevenueForm();">
        <div class="filter-bar-modern">
            <div>
                <label for="clinicId">Clinic:</label><br>
                <select id="clinicId" name="clinicId" style="min-width:180px;">
                    <option value="">All Clinics</option>
                    <c:forEach var="clinic" items="${allClinics}">
                        <option value="${clinic.clinicId}" <c:if test="${clinic.clinicId == selectedClinicId}">selected</c:if>>${clinic.clinicName}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label for="startDate">Start Date:</label><br>
                <input type="date" id="startDate" name="startDate" value="${param.startDate}">
            </div>
            <div>
                <label for="endDate">End Date:</label><br>
                <input type="date" id="endDate" name="endDate" value="${param.endDate}">
            </div>
            <div>
                <label for="month">Or Month:</label><br>
                <input type="month" id="month" name="month" value="${param.month}">
            </div>
            <div class="search-pill">
                <i class="fas fa-search"></i>
                <input type="text" id="clinicSearch" placeholder="Search clinic...">
            </div>
            <div>
                <button type="submit">Show Revenue</button>
            </div>
            <div>
                <button type="button" onclick="clearForm()" style="background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);">Clear All</button>
            </div>
        </div>
    </form>
    <div id="formError" style="color: #c0392b; margin-top: 10px; display: none;"></div>
    <script>
        function clearForm() {
            document.getElementById('clinicId').value = '';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('month').value = '';
            document.getElementById('clinicSearch').value = '';
            document.getElementById('formError').style.display = 'none';
            
            // Re-enable all fields
            document.getElementById('startDate').disabled = false;
            document.getElementById('endDate').disabled = false;
            document.getElementById('month').disabled = false;
            
            console.log('Form cleared');
        }
        
        function validateRevenueForm() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const month = document.getElementById('month').value;
            const errorDiv = document.getElementById('formError');
            if (!startDate && !endDate && !month) {
                errorDiv.textContent = 'Please select a start date, end date, or month.';
                errorDiv.style.display = 'block';
                return false;
            }
            errorDiv.style.display = 'none';
            return true;
        }
        // Disable date pickers if month is selected, and vice versa
        function toggleDateMonthFields() {
            const startDate = document.getElementById('startDate');
            const endDate = document.getElementById('endDate');
            const month = document.getElementById('month');
            if (month.value) {
                startDate.disabled = true;
                endDate.disabled = true;
            } else {
                startDate.disabled = false;
                endDate.disabled = false;
            }
            if (startDate.value || endDate.value) {
                month.disabled = true;
            } else {
                month.disabled = false;
            }
        }
        document.getElementById('month').addEventListener('input', toggleDateMonthFields);
        document.getElementById('startDate').addEventListener('input', toggleDateMonthFields);
        document.getElementById('endDate').addEventListener('input', toggleDateMonthFields);
        // Initial call
        toggleDateMonthFields();
        
        // Ensure calendar pickers work properly
        document.addEventListener('DOMContentLoaded', function() {
            const dateInputs = document.querySelectorAll('input[type="date"], input[type="month"]');
            console.log('Found date inputs:', dateInputs.length);
            
            dateInputs.forEach(function(input, index) {
                console.log('Date input', index, ':', input.type, input.id, input.name);
                
                // Ensure the input is properly configured
                input.style.position = 'relative';
                input.style.zIndex = '10';
                
                // Add click event listener as fallback
                input.addEventListener('click', function(e) {
                    console.log('Date input clicked:', this.type, this.value);
                    // Force focus to ensure calendar opens
                    this.focus();
                    
                    // Try to show the picker programmatically
                    if (this.type === 'date' || this.type === 'month') {
                        this.showPicker && this.showPicker();
                    }
                });
                
                // Add focus event listener
                input.addEventListener('focus', function(e) {
                    console.log('Date input focused:', this.type, this.value);
                });
                
                // Add change event listener
                input.addEventListener('change', function(e) {
                    console.log('Date input changed:', this.type, this.value);
                });
            });
            
            // Test if we can programmatically open a date picker
            const testDateInput = document.getElementById('startDate');
            if (testDateInput) {
                console.log('Test date input found:', testDateInput);
                // Try to show picker after a delay
                setTimeout(() => {
                    if (testDateInput.showPicker) {
                        console.log('showPicker method available');
                    } else {
                        console.log('showPicker method not available');
                    }
                }, 1000);
            }
        });
        
        // Sorting functionality
        let currentSortColumn = -1;
        let currentSortDirection = 'asc';
        
        function sortTable(columnIndex) {
            const table = document.getElementById('clinicTableBody');
            const rows = Array.from(table.getElementsByTagName('tr'));
            const headers = document.querySelectorAll('.sortable-header');
            
            // Clear previous sort indicators
            headers.forEach(header => {
                header.classList.remove('sort-asc', 'sort-desc');
            });
            
            // Determine sort direction
            if (currentSortColumn === columnIndex) {
                currentSortDirection = currentSortDirection === 'asc' ? 'desc' : 'asc';
            } else {
                currentSortColumn = columnIndex;
                currentSortDirection = 'asc';
            }
            
            // Add sort indicator to current column
            headers[columnIndex].classList.add(currentSortDirection === 'asc' ? 'sort-asc' : 'sort-desc');
            
            // Sort the rows
            rows.sort((a, b) => {
                const aValue = getCellValue(a, columnIndex);
                const bValue = getCellValue(b, columnIndex);
                
                let comparison = 0;
                
                if (columnIndex === 4) { // Revenue column
                    // Extract numeric value from revenue
                    const aNum = parseFloat(aValue.replace(/[^\d.-]/g, '')) || 0;
                    const bNum = parseFloat(bValue.replace(/[^\d.-]/g, '')) || 0;
                    comparison = aNum - bNum;
                } else if (columnIndex === 3) { // Doctors column
                    // Numeric comparison for doctor count
                    const aNum = parseInt(aValue) || 0;
                    const bNum = parseInt(bValue) || 0;
                    comparison = aNum - bNum;
                } else {
                    // String comparison for other columns
                    comparison = aValue.localeCompare(bValue, undefined, {numeric: true, sensitivity: 'base'});
                }
                
                return currentSortDirection === 'asc' ? comparison : -comparison;
            });
            
            // Reorder the table
            rows.forEach(row => table.appendChild(row));
            
            console.log(`Sorted by column ${columnIndex} in ${currentSortDirection} order`);
        }
        
        function getCellValue(row, columnIndex) {
            const cell = row.getElementsByTagName('td')[columnIndex];
            if (columnIndex === 4) { // Revenue column
                return cell.getAttribute('data-revenue') || cell.textContent;
            }
            return cell.textContent.trim();
        }
        
        // Clinic search filter for cards
        document.getElementById('clinicSearch').addEventListener('input', function() {
            const search = this.value.toLowerCase();
            const cards = document.querySelectorAll('.clinic-card');
            let anyVisible = false;
            cards.forEach(card => {
                const name = card.querySelector('.clinic-title')?.textContent?.toLowerCase() || '';
                if (name.includes(search)) {
                    card.style.display = '';
                    anyVisible = true;
                } else {
                    card.style.display = 'none';
                }
            });
            document.getElementById('noResultsCard').style.display = anyVisible ? 'none' : '';
        });
    </script>
    <style>
  .clinic-list-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 12px;
    margin-bottom: 32px;
  }
  .clinic-list-table th, .clinic-list-table td {
    padding: 16px 18px;
    background: #fff;
    border-radius: 8px;
    text-align: left;
    font-size: 1.08em;
  }
  .clinic-list-table th {
    color: #1565c0;
    font-weight: 700;
    background: #f4f6fa;
    border-bottom: 2px solid #e1e4ea;
  }
  
  .sortable-header {
    cursor: pointer;
    user-select: none;
    transition: background-color 0.2s ease;
    position: relative;
  }
  
  .sortable-header:hover {
    background-color: #e2e8f0 !important;
  }
  
  .sortable-header i {
    margin-left: 8px;
    font-size: 0.9em;
    color: #6b7280;
    transition: color 0.2s ease;
  }
  
  .sortable-header.sort-asc i {
    color: #2563eb;
  }
  
  .sortable-header.sort-desc i {
    color: #2563eb;
  }
  
  .sortable-header.sort-asc i::before {
    content: "\f0de"; /* fa-sort-up */
  }
  
  .sortable-header.sort-desc i::before {
    content: "\f0dd"; /* fa-sort-down */
  }
  
  .sortable-header.sort-asc,
  .sortable-header.sort-desc {
    background-color: #dbeafe !important;
  }
  .clinic-list-table tr {
    box-shadow: 0 2px 8px #e1e4ea;
    transition: box-shadow 0.18s, transform 0.18s;
  }
  .clinic-list-table tr:hover td {
    box-shadow: 0 6px 24px #b3c6e4;
    background: #f7fafc;
    color: #2563eb;
  }
  
  /* Enhanced Filter Bar Styles */
  .filter-bar-modern {
    display: flex;
    flex-wrap: wrap;
    gap: 40px;
    align-items: flex-end;
    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    padding: 32px 36px;
    margin-bottom: 32px;
    border: 1px solid #e2e8f0;
    position: relative;
    z-index: 1;
  }
  
  .filter-bar-modern > div {
    min-width: 220px;
    position: relative;
    z-index: 2;
    margin-bottom: 8px;
  }
  
  .filter-bar-modern label {
    display: block;
    font-weight: 600;
    color: #374151;
    margin-bottom: 12px;
    font-size: 0.95em;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
  
  .filter-bar-modern select,
  .filter-bar-modern input[type="date"],
  .filter-bar-modern input[type="month"] {
    width: 100%;
    padding: 14px 18px;
    border: 2px solid #d1d5db;
    border-radius: 10px;
    font-size: 1em;
    background: #fff;
    color: #374151;
    transition: all 0.2s ease;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    position: relative;
    z-index: 3;
    margin-bottom: 8px;
    /* Ensure calendar pickers are visible */
    appearance: auto;
    -webkit-appearance: auto;
    -moz-appearance: auto;
  }
  
  .filter-bar-modern select:focus,
  .filter-bar-modern input[type="date"]:focus,
  .filter-bar-modern input[type="month"]:focus {
    outline: none;
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    transform: translateY(-1px);
    z-index: 10;
  }
  
  .filter-bar-modern select:hover,
  .filter-bar-modern input[type="date"]:hover,
  .filter-bar-modern input[type="month"]:hover {
    border-color: #9ca3af;
  }
  
  /* Simplified calendar picker styles */
  .filter-bar-modern input[type="date"],
  .filter-bar-modern input[type="month"] {
    /* Remove any custom styling that might hide the picker */
    background-image: none;
    background-position: initial;
    background-repeat: initial;
    background-size: initial;
    padding-right: 18px; /* Reset padding */
  }
  
  /* Ensure dropdown arrows are visible */
  .filter-bar-modern select {
    appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 16px center;
    background-size: 18px;
    padding-right: 50px;
  }
  
  .filter-bar-modern button {
    background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
    color: #fff;
    padding: 16px 32px;
    border: none;
    border-radius: 12px;
    font-size: 1.05em;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    min-width: 160px;
    position: relative;
    z-index: 2;
    margin-top: 8px;
  }
  
  .filter-bar-modern button:hover {
    background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
  }
  
  .filter-bar-modern button:active {
    transform: translateY(0);
    box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
  }
  
  .search-pill {
    display: flex;
    align-items: center;
    background: #fff;
    border-radius: 12px;
    border: 2px solid #d1d5db;
    padding: 12px 20px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    transition: all 0.2s ease;
    position: relative;
    z-index: 2;
    min-width: 200px;
  }
  
  .search-pill:focus-within {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    z-index: 10;
  }
  
  .search-pill input {
    border: none;
    outline: none;
    background: transparent;
    font-size: 1em;
    margin-left: 12px;
    width: 180px;
    color: #374151;
  }
  
  .search-pill input::placeholder {
    color: #9ca3af;
  }
  
  .search-pill i {
    color: #6b7280;
    font-size: 1.1em;
  }
  
  @media (max-width: 700px) {
    .clinic-list-table th, .clinic-list-table td { 
      padding: 10px 6px; 
      font-size: 0.98em; 
    }
    .filter-bar-modern {
      padding: 20px 24px;
      gap: 24px;
    }
    .filter-bar-modern > div {
      min-width: 180px;
    }
  }
</style>
    <c:choose>
        <c:when test="${not empty clinicRevenueList}">
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
            <table class="clinic-list-table">
              <thead>
                <tr>
                  <th onclick="sortTable(0)" class="sortable-header">
                    Clinic Name <i class="fas fa-sort" id="sort-icon-0"></i>
                  </th>
                  <th onclick="sortTable(1)" class="sortable-header">
                    Clinic Code <i class="fas fa-sort" id="sort-icon-1"></i>
                  </th>
                  <th onclick="sortTable(2)" class="sortable-header">
                    City Tier <i class="fas fa-sort" id="sort-icon-2"></i>
                  </th>
                  <th onclick="sortTable(3)" class="sortable-header">
                    Doctors <i class="fas fa-sort" id="sort-icon-3"></i>
                  </th>
                  <th onclick="sortTable(4)" class="sortable-header">
                    Collected Revenue <i class="fas fa-sort" id="sort-icon-4"></i>
                  </th>
                  <th>
                    To Be Collected
                  </th>
                  <th>
                    Pending Revenue
                  </th>
                  <th>
                    YTD Projected Revenue
                  </th>
                </tr>
              </thead>
              <tbody id="clinicTableBody">
                <c:forEach var="row" items="${clinicRevenueList}">
                  <tr>
                    <td>${row.clinicName}</td>
                    <td>${row.clinicId}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty row.cityTier}">${row.cityTier.displayName}</c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                    <td>${row.doctorCount}</td>
                    <td data-revenue="${row.collectedRevenue}">₹ <fmt:formatNumber value="${row.collectedRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                    <td>₹ <fmt:formatNumber value="${row.toBeCollectedRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                    <td>₹ <fmt:formatNumber value="${row.pendingRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                    <td>₹ <fmt:formatNumber value="${row.ytdProjectedRevenue}" type="number" groupingUsed="true" minFractionDigits="2" /></td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
            <div id="noResultsCard" class="empty-state-modern" style="display:none;">
                <i class="fas fa-search"></i><br>
                No clinics found for your search.
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state-modern">
                <i class="fas fa-hospital"></i><br>
                No revenue data to display for the selected period.<br>
                <span style="color:#888; font-size:0.95em;">Try adjusting the date range or month, or check if clinics have recorded payments in this period.</span>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html> 