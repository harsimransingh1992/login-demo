/* Lifecycle Page JS: modal handlers + lazy loading */
(function() {
  // Expose modal handlers globally (referenced from JSP onclicks)
  window.showRescheduleNextSittingModal = function(followUpId, examinationId) {
    document.getElementById('rescheduleNextSittingId').value = followUpId;
    document.getElementById('rescheduleExaminationId').value = examinationId;
    var dateInput = document.getElementById('rescheduleDate');
    var timeInput = document.getElementById('rescheduleTime');
    var notesInput = document.getElementById('rescheduleNotes');
    if (dateInput) dateInput.value = '';
    if (timeInput) timeInput.value = '';
    if (notesInput) notesInput.value = '';
    var modal = document.getElementById('rescheduleNextSittingModal');
    if (modal) modal.style.display = 'block';
  };
  
  window.showCompleteNextSittingModal = function(followUpId, examinationId) {
    document.getElementById('completeNextSittingId').value = followUpId;
    document.getElementById('completeExaminationId').value = examinationId;
    var notesInput = document.getElementById('clinicalNotes');
    if (notesInput) notesInput.value = '';
    var modal = document.getElementById('completeNextSittingModal');
    if (modal) modal.style.display = 'block';
  };
  
  window.showCancelNextSittingModal = function(followUpId, examinationId) {
    document.getElementById('cancelNextSittingId').value = followUpId;
    document.getElementById('cancelExaminationId').value = examinationId;
    var modal = document.getElementById('cancelNextSittingModal');
    if (modal) modal.style.display = 'block';
  };

  // Lazy-load images with data-src
  function initLazyImages() {
    var images = document.querySelectorAll('img[data-src]');
    if (!('IntersectionObserver' in window)) {
      images.forEach(loadImage);
      return;
    }
    var observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          loadImage(entry.target);
          observer.unobserve(entry.target);
        }
      });
    }, { rootMargin: '200px' });
    images.forEach(function(img) {
      img.classList.add('image-loading');
      observer.observe(img);
    });
  }

  function loadImage(img) {
    var src = img.getAttribute('data-src');
    if (!src) return;
    img.onload = function() {
      img.classList.remove('image-loading');
      img.classList.add('image-loaded');
    };
    img.onerror = function() {
      img.classList.remove('image-loading');
      img.classList.add('image-error');
    };
    img.src = src;
    img.removeAttribute('data-src');
  }

  // Defer heavy flowchart init until visible
  function initDeferredFlowchart() {
    var container = document.getElementById('procedure-flowchart');
    if (!container) return;
    var initFn = window.initProcedureFlowchart;
    if (!initFn || container.dataset.initialized === 'true') return;

    if (!('IntersectionObserver' in window)) {
      initFn();
      container.dataset.initialized = 'true';
      return;
    }
    var observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          initFn();
          container.dataset.initialized = 'true';
          observer.disconnect();
        }
      });
    }, { rootMargin: '200px' });
    observer.observe(container);
  }

  document.addEventListener('DOMContentLoaded', function() {
    try { initLazyImages(); } catch (e) { /* noop */ }
    try { initDeferredFlowchart(); } catch (e) { /* noop */ }
  });
})();

/* Externalized lifecycle status updates and dropdown handlers */
(function() {
  function isCaseClosed() {
    var dot = document.querySelector('.status-dropdown .status-dot');
    if (!dot) return false;
    return dot.classList.contains('closed');
  }

  function getCsrf() {
    var tokenMeta = document.querySelector('meta[name="_csrf"]');
    var headerMeta = document.querySelector('meta[name="_csrf_header"]');
    return {
      token: tokenMeta ? tokenMeta.getAttribute('content') : null,
      header: headerMeta ? headerMeta.getAttribute('content') : null
    };
  }

  async function postUpdateStatus(examinationId, newStatus, includeCsrf) {
    var url = (window.contextPath || '') + '/patients/update-procedure-status';
    var headers = { 'Content-Type': 'application/json' };
    if (includeCsrf) {
      var csrf = getCsrf();
      if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
    }
    var resp = await fetch(url, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify({ examinationId: examinationId, status: newStatus })
    });
    var text = await resp.text();
    if (text.trim().startsWith('<!DOCTYPE')) {
      alert('Authentication error. Please refresh and try again.');
      return { ok: false };
    }
    try {
      return JSON.parse(text);
    } catch (e) {
      alert('Server returned invalid response. Please try again.');
      return { ok: false };
    }
  }

  window.updateProcedureStatusDirect = async function(newStatus) {
    var examIdEl = document.getElementById('examinationId');
    var examinationId = examIdEl ? examIdEl.value : null;
    if (!newStatus || !examinationId) return;
  
    // Refresh payment status
    try {
      var refreshResp = await fetch((window.contextPath || '') + '/patients/examination/' + examinationId + '/payment-status', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
      });
      if (refreshResp.ok) {
        var paymentData = await refreshResp.json();
        var el = document.querySelector('.payment-status');
        if (el && paymentData.paymentStatus) el.textContent = paymentData.paymentStatus;
      }
    } catch (_) {}
  
    // CSRF
    var csrf = (function(){
      var t = document.querySelector('meta[name="_csrf"]');
      var h = document.querySelector('meta[name="_csrf_header"]');
      return { token: t ? t.getAttribute('content') : null, header: h ? h.getAttribute('content') : null };
    })();
  
    try {
      var url = (window.contextPath || '') + '/patients/update-procedure-status';
      var headers = { 'Content-Type': 'application/json' };
      if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
      var resp = await fetch(url, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify({ examinationId: examinationId, status: newStatus })
      });
      var text = await resp.text();
      if (text.trim().startsWith('<!DOCTYPE')) {
        alert('Authentication error. Please refresh the page and try again.');
        return;
      }
      var result;
      try { result = JSON.parse(text); } catch (_) {
        alert('Server returned invalid response. Please try again.');
        return;
      }
      if (result.success) {
        alert('Status updated successfully!');
        window.location.reload();
      } else {
        if (result.message && result.message.toLowerCase().includes('payment') && result.message.toLowerCase().includes('pending')) {
          try { if (typeof window.showPaymentPendingModal === 'function') window.showPaymentPendingModal(); } catch (_) {}
        } else {
          alert(result.message || 'Failed to update status');
        }
      }
    } catch (e) {
      alert('Failed to update status. Please try again.');
    }
  };

  window.updateProcedureStatus = async function(newStatus) {
    var examIdEl = document.getElementById('examinationId');
    var examinationId = examIdEl ? examIdEl.value : null;
    if (!newStatus || !examinationId) return;

    if (newStatus === 'CLOSED' && !isCaseClosed() && !window.xrayUploadComplete) {
      window.pendingStatusUpdate = newStatus;
      try {
        if (typeof window.showXrayConfirmationModal === 'function') {
          window.showXrayConfirmationModal();
          return;
        }
      } catch (e) {}
      var userChoice = confirm('Do you want to upload an X-ray image before closing the case?\n\nClick "OK" to upload X-ray\nClick "Cancel" to close without X-ray');
      if (userChoice) {
        var modal = document.getElementById('xrayUploadModal');
        if (modal) modal.style.display = 'block';
        return;
      } else {
        if (typeof window.updateProcedureStatusDirect === 'function') {
          window.updateProcedureStatusDirect(newStatus);
          return;
        }
      }
    }

    var result;
    try {
      result = await postUpdateStatus(examinationId, newStatus, false);
    } catch (e) {
      alert('Failed to update status. Please try again.');
      return;
    }

    if (result && result.success) {
      var notification = document.querySelector('.status-notification');
      if (notification) {
        notification.style.display = 'block';
        setTimeout(function(){ notification.style.display = 'none'; }, 3000);
      }
      setTimeout(function(){ window.location.reload(); }, 1000);
    } else {
      alert((result && result.message) || 'Failed to update status');
    }
  };

  // Status dropdown open/close and option clicks (idempotent if JSP also sets)
  document.addEventListener('DOMContentLoaded', function() {
    var statusDropdown = document.querySelector('.status-dropdown');
    var statusDropdownContent = document.querySelector('.status-dropdown-content');
    var statusOptions = document.querySelectorAll('.status-option');
    if (!statusDropdown || !statusDropdownContent) return;

    statusDropdown.addEventListener('click', function(e) {
      e.stopPropagation();
      var btn = this.querySelector('.status-dropdown-btn');
      if (btn && !btn.classList.contains('disabled') && !btn.classList.contains('cancelled')) {
        statusDropdownContent.classList.toggle('show');
        var icon = btn.querySelector('.dropdown-icon i');
        if (icon) {
          icon.style.transform = statusDropdownContent.classList.contains('show') ? 'rotate(180deg)' : 'rotate(0deg)';
        }
      }
    });

    document.addEventListener('click', function(e) {
      if (!statusDropdown.contains(e.target) && !statusDropdownContent.contains(e.target)) {
        statusDropdownContent.classList.remove('show');
        var icon = statusDropdown.querySelector('.dropdown-icon i');
        if (icon) icon.style.transform = 'rotate(0deg)';
      }
    });

    statusOptions.forEach(function(option) {
      option.addEventListener('click', function() {
        var newStatus = this.getAttribute('data-status');
        if (newStatus) {
          window.updateProcedureStatus(newStatus);
        }
        statusDropdownContent.classList.remove('show');
        var icon = statusDropdown.querySelector('.dropdown-icon i');
        if (icon) icon.style.transform = 'rotate(0deg)';
      });
    });
  });
})();