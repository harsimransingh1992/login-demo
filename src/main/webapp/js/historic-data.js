(function(){
  const buttons = document.addEventListener ? document.querySelectorAll('.segmented-btn') : [];
  const emptyState = document.getElementById('emptyState');
  const sections = {
    payments: document.getElementById('paymentsSection'),
    refunds: document.getElementById('refundsSection'),
    visits: document.getElementById('visitsSection')
  };
  const paymentsPlaceholder = sections.payments ? sections.payments.querySelector('.placeholder') : null;

  function hideAll() {
    Object.values(sections).forEach(function(el){ if (el) el.style.display = 'none'; });
    buttons.forEach(function(btn){ btn.classList.remove('active'); btn.setAttribute('aria-selected', 'false'); });
  }

  buttons.forEach(function(btn){
    btn.addEventListener('click', function(){
      var target = btn.getAttribute('data-target');
      hideAll();
      if (sections[target]) {
        sections[target].style.display = 'block';
        btn.classList.add('active');
        btn.setAttribute('aria-selected', 'true');
        if (emptyState) emptyState.style.display = 'none';
        if (target === 'payments' && paymentsPlaceholder) paymentsPlaceholder.style.display = 'none';
      }
    });
  });

  // Payments analytics logic
  var startInput = document.getElementById('paymentsStartDate');
  var endInput = document.getElementById('paymentsEndDate');
  var loadBtn = document.getElementById('loadPaymentsAnalytics');
  var cardsContainer = document.getElementById('analyticsCards');
  var metaEl = document.getElementById('analyticsMeta');
  var errorEl = document.getElementById('analyticsError');

  function renderAnalytics(analytics) {
    if (!cardsContainer) return;
    var items = [
      { label: 'Total Revenue', value: analytics.totalRevenue, icon: 'fa-sack-dollar', format: 'currency' },
      { label: 'Total Paid', value: analytics.totalPaid, icon: 'fa-money-bill-wave', format: 'currency' },
      { label: 'Pending Amount', value: analytics.pendingAmount, icon: 'fa-hourglass-half', format: 'currency' },
      { label: 'Collection Rate', value: analytics.collectionRate + '%', icon: 'fa-chart-line', format: 'text' },
      { label: 'Avg Payment', value: analytics.avgPayment, icon: 'fa-coins', format: 'currency' },
      { label: 'Total Examinations', value: analytics.totalExaminations, icon: 'fa-notes-medical', format: 'number' },
      { label: 'Pending Count', value: analytics.pendingCount, icon: 'fa-clock', format: 'number' },
      { label: 'Completed Count', value: analytics.completedCount, icon: 'fa-check-circle', format: 'number' }
    ];
    var html = items.map(function(item){
      var displayVal = item.value;
      if (item.format === 'currency') {
        displayVal = new Intl.NumberFormat(undefined, { style: 'currency', currency: 'INR' }).format(Number(item.value || 0));
      }
      return (
        '<div class="col-sm-6 col-md-3">' +
          '<div class="card">' +
            '<div class="d-flex align-items-center gap-2">' +
              '<i class="fas ' + item.icon + '"></i>' +
              '<div>' +
                '<div class="small text-muted">' + item.label + '</div>' +
                '<div class="fw-bold">' + displayVal + '</div>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>'
      );
    }).join('');
    cardsContainer.innerHTML = html;
    if (paymentsPlaceholder) paymentsPlaceholder.style.display = 'none';
  }

  function loadAnalytics() {
    if (!loadBtn) return;
    var startDate = startInput && startInput.value ? startInput.value : '';
    var endDate = endInput && endInput.value ? endInput.value : '';
    var url = window.location.origin + '/payments/analytics';
    var params = [];
    if (startDate) params.push('startDate=' + encodeURIComponent(startDate));
    if (endDate) params.push('endDate=' + encodeURIComponent(endDate));
    if (params.length) url += '?' + params.join('&');

    if (errorEl) { errorEl.classList.add('d-none'); errorEl.textContent = ''; }
    if (cardsContainer) { cardsContainer.innerHTML = '<div class="text-muted">Loading analytics...</div>'; }
    if (paymentsPlaceholder) paymentsPlaceholder.style.display = 'none';

    fetch(url, { credentials: 'include' })
      .then(function(res){ return res.json(); })
      .then(function(data){
        if (data && data.success && data.analytics) {
          renderAnalytics(data.analytics);
          if (metaEl) {
            var parts = [];
            if (startDate) parts.push('From ' + startDate);
            if (endDate) parts.push('to ' + endDate);
            metaEl.textContent = parts.join(' ');
          }
        } else {
          throw new Error(data && data.message ? data.message : 'Failed to load analytics');
        }
      })
      .catch(function(err){
        if (cardsContainer) cardsContainer.innerHTML = '';
        if (errorEl) { errorEl.textContent = 'Error: ' + err.message; errorEl.classList.remove('d-none'); }
      });
  }

  if (loadBtn) {
    loadBtn.addEventListener('click', loadAnalytics);
  }

  // Pending list loader
  var pendingBtn = document.getElementById('loadPendingList');
  var pendingContent = document.getElementById('pendingListContent');
  var pendingTableBody = document.querySelector('#pendingListTable tbody');
  var pendingError = document.getElementById('pendingListError');
  var pendingEmpty = document.getElementById('pendingListEmpty');

  function formatCurrencyINR(num) {
    try {
      return new Intl.NumberFormat(undefined, { style: 'currency', currency: 'INR' }).format(Number(num || 0));
    } catch (e) {
      return '₹' + (Number(num || 0).toFixed(2));
    }
  }

  function renderPendingList(items) {
    if (!pendingTableBody) return;
    var rows = items.map(function(item){
      // Normalize keys and support nested structures from backend
      var examId = item.examinationId || item.examinationid || item.examId || item.examid || item.id;
      var patient = item.patient || {};
      var patId = patient.id || item.patientId || item.patientid;
      var regCode = patient.registrationCode || item.registrationCode || item.registrationcode;
      var fullName = ((patient.firstName || '') + (patient.lastName ? (' ' + patient.lastName) : '')).trim();
      if (!fullName) fullName = item.patientName || '';
      var phone = patient.phoneNumber || item.patientPhone || '';
      var procedure = item.procedure || {};
      var procedureName = procedure.procedureName || item.procedureName || '';
      var totalAmount = (item.totalProcedureAmount != null ? item.totalProcedureAmount : item.totalAmount);
      var paidAmount = (item.totalPaidAmount != null ? item.totalPaidAmount : item.paidAmount);
      var pendingAmount = (item.remainingAmount != null ? item.remainingAmount : item.pendingAmount);
      var status = item.paymentStatus || '';

      var examLink = '<a href="' + window.location.origin + '/patients/examination/' + (examId || '') + '" target="_blank">' + (examId || '') + '</a>';
      var patientLink = '<a href="' + window.location.origin + '/payments/patient/' + (patId || '') + '" target="_blank">' + (regCode || (patId ? '#' + patId : '')) + '</a>';
      return (
        '<tr>' +
          '<td>' + examLink + '</td>' +
          '<td>' + patientLink + '</td>' +
          '<td>' + fullName + '</td>' +
          '<td>' + phone + '</td>' +
          '<td>' + procedureName + '</td>' +
          '<td>' + formatCurrencyINR(totalAmount) + '</td>' +
          '<td>' + formatCurrencyINR(paidAmount) + '</td>' +
          '<td>' + formatCurrencyINR(pendingAmount) + '</td>' +
          '<td>' + status + '</td>' +
        '</tr>'
      );
    }).join('');
    pendingTableBody.innerHTML = rows;
    if (pendingContent) pendingContent.style.display = 'block';
    if (pendingEmpty) pendingEmpty.style.display = 'none';
    if (paymentsPlaceholder) paymentsPlaceholder.style.display = 'none';
  }

  // State for pending list
  var allPendingItems = [];
  var filteredPendingItems = [];
  var currentPage = 1;
  var pageSize = 10;
  
  var toolbarEl = document.getElementById('pendingListToolbar');
  var statusSelect = document.getElementById('paymentStatusFilter');
  var pageSizeSelect = document.getElementById('pageSizeSelect');
  var metaDisplay = document.getElementById('pendingListMeta');
  var paginationEl = document.getElementById('pendingListPagination');
  var prevBtn = document.getElementById('prevPageBtn');
  var nextBtn = document.getElementById('nextPageBtn');
  var pageDisplay = document.getElementById('currentPageDisplay');
  
  function applyFilterAndPaginate() {
    // Filter by status if selected
    var status = statusSelect ? statusSelect.value : 'ALL';
    if (status && status !== 'ALL') {
      filteredPendingItems = allPendingItems.filter(function(item){
        var s = item.paymentStatus || item.status || '';
        return s && s.toUpperCase() === status;
      });
    } else {
      filteredPendingItems = allPendingItems.slice();
    }
    // Reset current page if beyond bounds
    var totalRecords = filteredPendingItems.length;
    var totalPages = Math.max(1, Math.ceil(totalRecords / pageSize));
    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;
  
    // Slice for current page
    var startIdx = (currentPage - 1) * pageSize;
    var pageItems = filteredPendingItems.slice(startIdx, startIdx + pageSize);
  
    // Render rows
    renderPendingList(pageItems);
  
    // Update meta and pagination controls
    if (metaDisplay) {
      var endIdx = Math.min(startIdx + pageSize, totalRecords);
      metaDisplay.textContent = (totalRecords === 0) ? 'No records' : ('Showing ' + (startIdx + 1) + '-' + endIdx + ' of ' + totalRecords + ' records');
    }
    if (paginationEl) paginationEl.style.display = totalRecords > 0 ? 'flex' : 'none';
    if (toolbarEl) toolbarEl.style.display = totalRecords > 0 ? 'flex' : 'none';
    if (pageDisplay) pageDisplay.textContent = 'Page ' + currentPage + ' of ' + totalPages;
    if (prevBtn) prevBtn.disabled = currentPage <= 1;
    if (nextBtn) nextBtn.disabled = currentPage >= totalPages;
  }
  
  function onStatusChange() {
    currentPage = 1;
    applyFilterAndPaginate();
  }
  
  function onPageSizeChange() {
    var val = pageSizeSelect ? parseInt(pageSizeSelect.value, 10) : 10;
    pageSize = isNaN(val) ? 10 : val;
    currentPage = 1;
    applyFilterAndPaginate();
  }
  
  function goPrevPage() {
    if (currentPage > 1) {
      currentPage -= 1;
      applyFilterAndPaginate();
    }
  }
  
  function goNextPage() {
    var totalRecords = filteredPendingItems.length;
    var totalPages = Math.max(1, Math.ceil(totalRecords / pageSize));
    if (currentPage < totalPages) {
      currentPage += 1;
      applyFilterAndPaginate();
    }
  }
  
  if (statusSelect) statusSelect.addEventListener('change', onStatusChange);
  if (pageSizeSelect) pageSizeSelect.addEventListener('change', onPageSizeChange);
  if (prevBtn) prevBtn.addEventListener('click', goPrevPage);
  if (nextBtn) nextBtn.addEventListener('click', goNextPage);
  
  // Update loadPendingList to store items and initialize pagination
  function loadPendingList() {
    if (!pendingBtn) return;
    var startDate = startInput && startInput.value ? startInput.value : '';
    var endDate = endInput && endInput.value ? endInput.value : '';
    var url = window.location.origin + '/payments/pending-list';
    var params = [];
    if (startDate) params.push('startDate=' + encodeURIComponent(startDate));
    if (endDate) params.push('endDate=' + encodeURIComponent(endDate));
    if (params.length) url += '?' + params.join('&');
  
    if (pendingError) { pendingError.classList.add('d-none'); pendingError.textContent = ''; }
    if (pendingEmpty) pendingEmpty.style.display = 'none';
    if (pendingContent) { pendingContent.style.display = 'block'; }
    if (pendingTableBody) { pendingTableBody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">Loading pending examinations...</td></tr>'; }
    if (paymentsPlaceholder) paymentsPlaceholder.style.display = 'none';
  
    fetch(url, { credentials: 'include' })
      .then(function(res){ return res.json(); })
      .then(function(data){
        if (data && data.success) {
          var items = data.examinations || [];
          if (items.length === 0) {
            if (pendingContent) pendingContent.style.display = 'none';
            if (pendingEmpty) pendingEmpty.style.display = 'block';
            if (toolbarEl) toolbarEl.style.display = 'none';
            if (paginationEl) paginationEl.style.display = 'none';
            if (metaDisplay) metaDisplay.textContent = '';
            return;
          }
          // Store items and reset state
          allPendingItems = items;
          currentPage = 1;
          var val = pageSizeSelect ? parseInt(pageSizeSelect.value, 10) : 10;
          pageSize = isNaN(val) ? 10 : val;
          applyFilterAndPaginate();
        } else {
          throw new Error((data && data.message) || 'Failed to load pending list');
        }
      })
      .catch(function(err){
        if (pendingContent) pendingContent.style.display = 'none';
        if (pendingEmpty) pendingEmpty.style.display = 'none';
        if (pendingError) { pendingError.textContent = 'Error: ' + err.message; pendingError.classList.remove('d-none'); }
      });
  }

  if (pendingBtn) {
    pendingBtn.addEventListener('click', loadPendingList);
  }

  // Initialization: auto-select Payments on load without auto-loading analytics
  (function initDefaultSection(){
    try {
      if (sections && sections.payments) {
        hideAll();
        sections.payments.style.display = 'block';
        var paymentsBtn = document.querySelector('.segmented-btn[data-target="payments"]');
        if (paymentsBtn) {
          paymentsBtn.classList.add('active');
          paymentsBtn.setAttribute('aria-selected', 'true');
        }
        // Hide the global empty state and the grey placeholder on initial display
        if (emptyState) emptyState.style.display = 'none';
        if (paymentsPlaceholder) paymentsPlaceholder.style.display = 'none';
        // Do not auto-load analytics on page load
      }
    } catch (e) {
      // swallow initialization errors silently
    }
  })();

})();