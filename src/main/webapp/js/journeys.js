(function(){
  function qs(id){ return document.getElementById(id); }
  function formatDateTime(dt){
    try { return new Date(dt).toLocaleString(undefined, { year:'numeric', month:'short', day:'2-digit', hour:'2-digit', minute:'2-digit' }); }
    catch(e){ return dt; }
  }
  function titleForEvent(type){
    switch(type){
      case 'registration': return 'Patient registered';
      case 'clinic_checkin': return 'Clinic check-in';
      case 'clinic_checkout': return 'Clinic check-out';
      case 'appointment_booked': return 'Appointment booked';
      case 'examination_added': return 'Examination added';
      case 'status_changed': return 'Status changed';
      case 'payment_transaction': return 'Payment transaction';
      case 'interaction': return 'Interaction logged';
      default: return type || 'Event';
    }
  }
  function selectedEventTypesCsv(){
    const sel = qs('filterEventTypes');
    if (!sel) return '';
    const vals = Array.from(sel.selectedOptions).map(o => o.value).filter(Boolean);
    return vals.join(',');
  }
  function buildQuery(){
    const params = new URLSearchParams();
    const patientId = qs('filterPatientId').value.trim();
    const eventTypesCsv = selectedEventTypesCsv();
    const fromDate = qs('filterFrom').value;
    const toDate = qs('filterTo').value;
    const searchText = qs('filterSearch').value.trim();
    if (patientId) params.set('patientId', patientId);
    if (eventTypesCsv) params.set('eventTypes', eventTypesCsv);
    if (searchText) params.set('searchText', searchText);
    if (fromDate) params.set('from', new Date(fromDate + 'T00:00:00').toISOString());
    if (toDate) params.set('to', new Date(toDate + 'T23:59:59').toISOString());
    return params.toString();
  }
  function maskSensitive(key, val){
    if (!val || typeof val !== 'string') return val;
    const k = key.toLowerCase();
    if (k.includes('phone')) return val.replace(/\d(?=\d{2})/g, '•');
    if (k.includes('email')) return val.replace(/(^.).+(@.+$)/, '$1••••$2');
    return val;
  }
  function parseMetadata(metadataJson){
    if (!metadataJson) return {};
    try { return JSON.parse(metadataJson); } catch(e){ return { raw: metadataJson }; }
  }
  function renderSummary(events){
    const el = qs('summaryContainer');
    if (!el) return;
    if (!events || events.length === 0){ el.innerHTML = ''; return; }
    const counts = events.reduce((acc, e) => { const t = e.eventType || 'interaction'; acc[t] = (acc[t]||0)+1; return acc; }, {});
    const items = Object.keys(counts).sort().map(t => `<span class="badge ${t}">${t}: ${counts[t]}</span>`).join(' ');
    el.innerHTML = `<div class="summary-row">${items}</div>`;
  }
  function renderEvents(events){
    const container = qs('timelineContainer');
    if (!events || events.length === 0){
      container.innerHTML = '<div class="empty">No events found for the selected filters</div>';
      renderSummary(events);
      return;
    }
    events.sort((a,b) => new Date(a.createdAt) - new Date(b.createdAt));
    let lastDay = '';
    const html = events.map(ev => {
      const time = formatDateTime(ev.createdAt);
      const type = ev.eventType;
      const title = titleForEvent(type);
      const meta = parseMetadata(ev.metadataJson);
      const safeText = (k,v) => typeof v === 'string' ? maskSensitive(k, v.replace(/[\n\r]+/g, ' ')) : JSON.stringify(v);
      const metaList = Object.keys(meta).map(k => `<div><strong>${k}:</strong> ${safeText(k, meta[k])}</div>`).join('');
      const pid = ev.patientId || '';
      const recordLink = pid ? `<a class="link" href="/patients?patientId=${pid}" target="_blank">View record</a>` : '';
      const dayKey = new Date(ev.createdAt).toDateString();
      const dayHeader = dayKey !== lastDay ? `<div class="day-sep">${dayKey}</div>` : '';
      lastDay = dayKey;
      return `
        ${dayHeader}
        <div class="timeline-item">
          <div class="time">${time}</div>
          <div class="content">
            <div class="title">${title}</div>
            <div class="details">${metaList}</div>
            <div class="event-badges">
              <span class="badge ${type || 'interaction'}">${type || 'interaction'}</span>
              ${recordLink}
            </div>
          </div>
        </div>
      `;
    }).join('');
    container.innerHTML = html;
    renderSummary(events);
  }
  async function loadEvents(){
    const query = buildQuery();
    const resp = await fetch(`/journeys/api/events?${query}`);
    if (!resp.ok){
      qs('timelineContainer').innerHTML = '<div class="empty">Failed to load events</div>';
      qs('summaryContainer').innerHTML = '';
      return;
    }
    const data = await resp.json();
    renderEvents(data.events || []);
  }

  function setPreset(days){
    const today = new Date();
    const from = new Date();
    from.setDate(today.getDate() - (days - 1));
    const fmt = (d) => d.toISOString().slice(0,10);
    qs('filterFrom').value = fmt(from);
    qs('filterTo').value = fmt(today);
  }
  function clearFilters(){
    qs('filterEventTypes').selectedIndex = -1;
    qs('filterFrom').value = '';
    qs('filterTo').value = '';
    qs('filterSearch').value = '';
  }
  async function exportCsv(){
    try {
      const query = buildQuery();
      const url = `/journeys/api/events/export?${query}`;
      window.open(url, '_blank');
    } catch (e) {
      alert('Export failed. Please try again.');
    }
  }

  document.addEventListener('DOMContentLoaded', function(){
    const applyBtn = qs('applyFiltersBtn');
    const printBtn = qs('printSummaryBtn');
    const exportBtn = qs('exportCsvBtn');
    const pToday = qs('presetToday');
    const p7 = qs('preset7d');
    const p30 = qs('preset30d');
    const clearBtn = qs('clearFilters');
    if (applyBtn) applyBtn.addEventListener('click', loadEvents);
    if (printBtn) printBtn.addEventListener('click', function(){ window.print(); });
    if (exportBtn) exportBtn.addEventListener('click', exportCsv);
    if (pToday) pToday.addEventListener('click', function(){ setPreset(1); loadEvents(); });
    if (p7) p7.addEventListener('click', function(){ setPreset(7); loadEvents(); });
    if (p30) p30.addEventListener('click', function(){ setPreset(30); loadEvents(); });
    if (clearBtn) clearBtn.addEventListener('click', function(){ clearFilters(); loadEvents(); });

    // Auto-load if patientId present on page
    const initialPid = qs('filterPatientId').value;
    if (initialPid) loadEvents();
  });
})();