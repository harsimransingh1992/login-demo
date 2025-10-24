(function() {
  const contextPath = (document.body && document.body.dataset && document.body.dataset.contextPath) || '';

  function getCsrf() {
    const tokenEl = document.querySelector('meta[name="_csrf"]');
    const headerEl = document.querySelector('meta[name="_csrf_header"]');
    return {
      token: tokenEl ? tokenEl.getAttribute('content') : '',
      header: headerEl ? headerEl.getAttribute('content') : 'X-CSRF-TOKEN',
    };
  }

  async function postUpdateStatus(examinationId, status) {
    const { token, header } = getCsrf();
    const res = await fetch(`${contextPath}/patients/update-procedure-status`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        [header]: token,
      },
      body: JSON.stringify({ examinationId, status }),
      credentials: 'same-origin',
    });

    let data = null;
    try {
      data = await res.json();
    } catch (e) {
      // Fallthrough to generic error handling
    }

    if (!res.ok) {
      const msg = (data && data.message) || `Request failed (${res.status})`;
      throw new Error(msg);
    }

    // Expect { success: true } or { success: false, errorCode, message }
    if (!data || typeof data.success !== 'boolean') {
      throw new Error('Invalid server response');
    }

    if (!data.success) {
      const err = new Error(data.message || 'Status update failed');
      err.code = data.errorCode;
      throw err;
    }

    return data;
  }

  function showStatusNotification() {
    const el = document.querySelector('.status-notification');
    if (!el) return;
    el.classList.add('show');
    setTimeout(() => {
      el.classList.remove('show');
    }, 2500);
  }

  function showPaymentPendingModal() {
    const modal = document.getElementById('paymentPendingModal');
    if (!modal) return;
    modal.style.display = 'block';
  }

  function closePaymentPendingModal() {
    const modal = document.getElementById('paymentPendingModal');
    if (!modal) return;
    modal.style.display = 'none';
  }

  function getExaminationId() {
    const input = document.getElementById('examinationId');
    if (!input) return null;
    const val = input.value || input.getAttribute('value');
    return val || null;
  }

  // Public: Direct status update without pre-checks (used by admin or controlled flows)
  window.updateProcedureStatusDirect = async function(status) {
    const examinationId = getExaminationId();
    if (!examinationId) {
      alert('Missing examination id');
      return;
    }

    try {
      await postUpdateStatus(examinationId, status);
      // Either show notification or reload to reflect latest server-side state
      showStatusNotification();
      setTimeout(() => window.location.reload(), 600);
    } catch (err) {
      if (err && err.code === 'PAYMENT_PENDING') {
        showPaymentPendingModal();
        return;
      }
      if (/401|403|authentication/i.test(err.message)) {
        alert('You are not authenticated or authorized to perform this action.');
        return;
      }
      alert(err.message || 'Failed to update status');
    }
  };

  // Public: Standard update with X-ray precondition handling
  window.updateProcedureStatus = async function(status) {
    const examinationId = getExaminationId();
    if (!examinationId) {
      alert('Missing examination id');
      return;
    }

    // If closing, ensure x-ray upload requirement is satisfied
    const isClosing = String(status).toUpperCase() === 'CLOSED';
    const requiresXray = window.requiresXray === true; // may be set in JSP
    const xrayDone = window.xrayUploadComplete === true;

    if (isClosing && requiresXray && !xrayDone) {
      const modal = document.getElementById('xrayConfirmationModal');
      if (modal) {
        modal.style.display = 'block';
        return; // wait for user confirmation in modal
      }
    }

    try {
      await postUpdateStatus(examinationId, status);
      showStatusNotification();
      setTimeout(() => window.location.reload(), 600);
    } catch (err) {
      if (err && err.code === 'PAYMENT_PENDING') {
        showPaymentPendingModal();
        return;
      }
      alert(err.message || 'Failed to update status');
    }
  };

  // Status dropdown interactions
  function setupStatusDropdown() {
    const dropdown = document.querySelector('.status-dropdown');
    const btn = document.getElementById('statusDropdownBtn');
    const content = dropdown ? dropdown.querySelector('.status-dropdown-content') : null;
    if (!dropdown || !btn || !content) return;

    function toggle(open) {
      if (open === true) content.classList.add('show');
      else if (open === false) content.classList.remove('show');
      else content.classList.toggle('show');
    }

    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      // allow opening even if visually disabled, to show info/options
      toggle();
    });

    document.addEventListener('click', (e) => {
      if (!content.classList.contains('show')) return;
      if (!dropdown.contains(e.target)) {
        toggle(false);
      }
    });

    content.querySelectorAll('.status-option').forEach((opt) => {
      opt.addEventListener('click', async (e) => {
        e.stopPropagation();
        const status = opt.dataset.status;
        const current = btn.dataset.currentStatus || '';
        if (!status) return;
        toggle(false);
        if (current && current.toUpperCase() === status.toUpperCase()) {
          showStatusNotification();
          return;
        }
        await window.updateProcedureStatus(status);
      });
      opt.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          opt.click();
        }
      });
    });
  }

  // Init on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setupStatusDropdown);
  } else {
    setupStatusDropdown();
  }
})();