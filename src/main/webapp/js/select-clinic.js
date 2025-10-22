(function() {
    const clinicDropdown = document.getElementById('clinicDropdown');
    const doctorDropdown = document.getElementById('doctorDropdown');
    const appointmentsTableContainer = document.getElementById('appointmentsTableContainer');
    const appointmentsCalendarContainer = document.getElementById('appointmentsCalendarContainer');
    const tableViewBtn = document.getElementById('tableViewBtn');
    const calendarViewBtn = document.getElementById('calendarViewBtn');
    const contextPath = document.body.dataset.contextPath || '';
    // Use the date picker within the page grid
    const datePicker = document.querySelector('.page-grid .datePicker');
    // Start with blank date; do not auto-fill today
    // datePicker && (datePicker.value = moment().format('YYYY-MM-DD'));
    let selectedDoctorId = null;
    let currentViewMode = 'table'; // 'table' or 'calendar' (show calendar only after doctor selection)
    let lastAppointments = [];

    function setViewMode(mode) {
        currentViewMode = mode;
        const isCalendar = mode === 'calendar';
        appointmentsTableContainer.style.display = isCalendar ? 'none' : 'block';
        appointmentsCalendarContainer.style.display = isCalendar ? 'block' : 'none';
        tableViewBtn.classList.toggle('btn-primary', !isCalendar);
        calendarViewBtn.classList.toggle('btn-primary', isCalendar);
        tableViewBtn.classList.toggle('btn-outline', isCalendar);
        calendarViewBtn.classList.toggle('btn-outline', !isCalendar);
        if (lastAppointments && lastAppointments.length) {
            if (isCalendar) renderAppointmentsCalendar(lastAppointments);
            else renderAppointmentsTable(lastAppointments);
        }
    }

    async function fetchClinics() {
        try {
            const res = await fetch(contextPath + '/schedules/api/clinics', { credentials: 'same-origin' });
            if (!res.ok) throw new Error('Failed to load clinics');
            const clinics = await res.json();
            if (clinicDropdown && clinicDropdown.options.length <= 1) {
                clinics.forEach(c => {
                    const opt = document.createElement('option');
                    opt.value = c.clinicId;
                    opt.textContent = (c.clinicName || '') + ' (' + (c.clinicId || '') + ')';
                    clinicDropdown.appendChild(opt);
                });
            }
        } catch (e) { console.error(e); }
    }

    async function loadDoctorsForClinic(clinicId) {
        selectedDoctorId = null;
        lastAppointments = [];
        appointmentsTableContainer.innerHTML = '<div class="empty">Select a doctor to view appointments</div>';
        const calEl = window.jQuery && jQuery('#selectClinicCalendar');
        if (calEl && calEl.fullCalendar) { try { calEl.fullCalendar('destroy'); } catch (_) {} }
        // Hide calendar until a doctor is selected
        setViewMode('table');
        // Reset doctor dropdown
        if (doctorDropdown) {
            doctorDropdown.innerHTML = '<option value="">-- Select Doctor --</option>';
        }
        const doctorHint = document.getElementById('doctorHint');
        if (!clinicId) { 
            if (doctorHint) doctorHint.textContent = 'Select a clinic to load doctors';
            return; 
        }
        try {
            const res = await fetch(contextPath + '/schedules/api/clinic-doctors?clinicId=' + encodeURIComponent(clinicId), { credentials: 'same-origin' });
            if (!res.ok) {
                const msg = res.status === 403 ? 'Not authorized for this clinic' : 'Failed to load doctors';
                if (doctorHint) doctorHint.textContent = msg;
                return;
            }
            const doctors = await res.json();
            if (!Array.isArray(doctors) || doctors.length === 0) {
                if (doctorHint) doctorHint.textContent = 'No doctors found for this clinic';
                return;
            }
            // Populate dropdown
            const frag = document.createDocumentFragment();
            doctors.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.id;
                var displayName = ((d.firstName || '') + ' ' + (d.lastName || '')).trim();
                opt.textContent = displayName || d.username || ('Doctor #' + d.id);
                frag.appendChild(opt);
            });
            doctorDropdown.appendChild(frag);
            if (doctorHint) doctorHint.textContent = 'Select a doctor to view appointments';
        } catch (e) {
            console.error(e);
            if (doctorHint) doctorHint.textContent = 'Failed to load doctors';
        }
    }

    function formatDateTime(dtStr) {
        if (!dtStr) return '-';
        try {
            const dt = new Date(dtStr);
            const datePart = dt.toLocaleDateString(undefined, { day: '2-digit', month: '2-digit', year: 'numeric' });
            const timePart = dt.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' });
            return datePart + ' ' + timePart;
        } catch (_) { return dtStr; }
    }

    function ensureCustomCalendarToolbar(calEl) {
        var container = calEl.closest('.calendar-container');
        if (!container.length) container = calEl.parent();
        if (!container.find('.calendar-toolbar').length) {
            var toolbarHtml = '\n<div class="calendar-toolbar">\n  <div class="fc-left">\n    <button type="button" class="btn btn-default btn-sm js-cal-prev">Prev</button>\n  </div>\n  <div class="fc-center">\n    <span class="cal-title">&nbsp;</span>\n    <button type="button" class="btn btn-primary btn-sm js-cal-today">Today</button>\n  </div>\n  <div class="fc-right">\n    <button type="button" class="btn btn-default btn-sm js-cal-next">Next</button>\n    </div>\n</div> <div class="btn-group">\n      <button type="button" class="btn btn-default btn-sm js-cal-view" data-view="agendaDay">Day</button>\n      <button type="button" class="btn btn-default btn-sm js-cal-view" data-view="agendaWeek">Week</button>\n      <button type="button" class="btn btn-default btn-sm js-cal-view" data-view="month">Month</button>\n    </div>\n';
            container.prepend(toolbarHtml);
        }
        function fetchAppointmentsForCurrentView() {
            const clinicId = clinicDropdown && clinicDropdown.value;
            const doctorId = selectedDoctorId;
            if (!clinicId || !doctorId) return;
            const view = calEl.fullCalendar('getView');
            let startDate, endDate, defaultDateStr;
            if (view && view.name === 'agendaDay') {
                const day = calEl.fullCalendar('getDate').format('YYYY-MM-DD');
                startDate = day; endDate = day; defaultDateStr = day;
            } else if (view) {
                const start = view.start.clone();
                const end = view.end.clone().subtract(1, 'day'); // inclusive end
                startDate = start.format('YYYY-MM-DD');
                endDate = end.format('YYYY-MM-DD');
                defaultDateStr = startDate;
            } else {
                const day = (datePicker && datePicker.value) || moment().format('YYYY-MM-DD');
                startDate = day; endDate = day; defaultDateStr = day;
            }
            loadAppointmentsForRange(clinicId, doctorId, startDate, endDate, defaultDateStr);
        }
        // Bind handlers (delegate to container to avoid duplicate binds)
        container.off('click', '.js-cal-prev');
        container.on('click', '.js-cal-prev', function() { calEl.fullCalendar('prev'); fetchAppointmentsForCurrentView(); });
        container.off('click', '.js-cal-next');
        container.on('click', '.js-cal-next', function() { calEl.fullCalendar('next'); fetchAppointmentsForCurrentView(); });
        container.off('click', '.js-cal-today');
        container.on('click', '.js-cal-today', function() { calEl.fullCalendar('today'); fetchAppointmentsForCurrentView(); });
        container.off('click', '.js-cal-view');
        container.on('click', '.js-cal-view', function() { var v = jQuery(this).data('view'); calEl.fullCalendar('changeView', v); fetchAppointmentsForCurrentView(); });
    }

    function renderAppointmentsTable(appointments) {
        if (!Array.isArray(appointments) || appointments.length === 0) {
            appointmentsTableContainer.innerHTML = '<div class="empty">No appointments found for the selected doctor and date</div>';
            return;
        }
        const table = document.createElement('table');
        table.className = 'appointments-table';
        table.innerHTML = `
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Mobile</th>
                    <th>Registration ID</th>
                    <th>Date & Time</th>
                    <th>Doctor</th>
                    <th>Status</th>
                    <th>Notes</th>
                </tr>
            </thead>
            <tbody></tbody>
        `;
        const tbody = table.querySelector('tbody');
        appointments.forEach(a => {
            const tr = document.createElement('tr');
            const isRegistered = !!a.isRegistered;
            const patientCell = document.createElement('td');
            if (isRegistered && a.patientId) {
                const link = document.createElement('a');
                link.href = contextPath + '/patients/details/' + a.patientId;
                link.className = 'patient-name-link';
                link.title = 'Click to view patient details (Registered Patient)';
                link.textContent = a.patientName || a.patientMobile || 'Unknown';
                patientCell.appendChild(link);
            } else {
                const span = document.createElement('span');
                span.textContent = a.patientName || a.patientMobile || 'Unknown';
                patientCell.appendChild(span);
            }

            const mobileCell = document.createElement('td');
            mobileCell.textContent = a.patientMobile || '-';

            const regCell = document.createElement('td');
            regCell.textContent = isRegistered && a.registrationCode ? a.registrationCode : 'N/A';

            const dtCell = document.createElement('td');
            dtCell.textContent = formatDateTime(a.appointmentDateTime);

            const docCell = document.createElement('td');
            docCell.textContent = a.doctorName || 'Unassigned';

            const statusCell = document.createElement('td');
            const status = (a.status || '').toLowerCase();
            const badge = document.createElement('span');
            badge.className = 'status-badge status-' + status.replace(/\s+/g, '_');
            badge.textContent = a.status || '-';
            statusCell.appendChild(badge);

            const notesCell = document.createElement('td');
            notesCell.textContent = (a.notes && a.notes.trim()) ? a.notes : '-';

            tr.appendChild(patientCell);
            tr.appendChild(mobileCell);
            tr.appendChild(regCell);
            tr.appendChild(dtCell);
            tr.appendChild(docCell);
            tr.appendChild(statusCell);
            tr.appendChild(notesCell);
            tbody.appendChild(tr);
        });
        appointmentsTableContainer.innerHTML = '';
        appointmentsTableContainer.appendChild(table);
    }

    function renderAppointmentsCalendar(appointments, defaultDateStr) {
        const events = (appointments || []).map(a => ({
            title: (a.patientName || a.patientMobile || 'Unknown') + (a.status ? ' • ' + a.status : ''),
            start: a.appointmentDateTime,
            allDay: false
        }));
        const calEl = jQuery('#selectClinicCalendar');
        ensureCustomCalendarToolbar(calEl);
        // Preserve current view and date before re-init so view switches (e.g., agendaWeek) stick
        let preservedViewName = 'agendaDay';
        let preservedDate = defaultDateStr || (datePicker && datePicker.value) || moment().format('YYYY-MM-DD');
        try {
            const existingView = calEl.fullCalendar('getView');
            if (existingView && existingView.name) preservedViewName = existingView.name;
            const currentDate = calEl.fullCalendar('getDate');
            if (currentDate && currentDate.format) preservedDate = currentDate.format('YYYY-MM-DD');
        } catch (_) { /* calendar might not be initialized yet */ }
        calEl.fullCalendar('destroy');
        calEl.fullCalendar({
            header: false,
            defaultView: preservedViewName,
            defaultDate: preservedDate,
            allDaySlot: false,
            timeFormat: 'h:mma',
            height: 'auto',
            contentHeight: 'auto',
            nowIndicator: true,
            events: events,
            viewRender: function(view) {
                var container = calEl.closest('.calendar-container');
                if (!container.length) container = calEl.parent();
                container.find('.calendar-toolbar .cal-title').text(view.title || '');
            }
        });
    }

    async function loadAppointmentsForRange(clinicId, doctorId, startDate, endDate, defaultDateForCalendar) {
        if (!clinicId) {
            appointmentsTableContainer.innerHTML = '<div class="empty">Select a clinic first</div>';
            return;
        }
        if (!doctorId) {
            appointmentsTableContainer.innerHTML = '<div class="empty">Select a doctor to view appointments</div>';
            return;
        }
        const url = contextPath + '/schedules/api/doctor-appointments?clinicId=' + encodeURIComponent(clinicId) + '&doctorId=' + encodeURIComponent(doctorId) + '&startDate=' + encodeURIComponent(startDate) + '&endDate=' + encodeURIComponent(endDate);
        appointmentsTableContainer.innerHTML = '<div class="empty">Loading appointments...</div>';
        try {
            const res = await fetch(url, { credentials: 'same-origin' });
            if (!res.ok) {
                const msg = res.status === 403 ? 'Not authorized to view appointments for this clinic' : 'Failed to load appointments';
                appointmentsTableContainer.innerHTML = '<div class="empty">' + msg + '</div>';
                return;
            }
            const appointments = await res.json();
            lastAppointments = appointments;
            if (currentViewMode === 'calendar') renderAppointmentsCalendar(appointments, defaultDateForCalendar);
            else renderAppointmentsTable(appointments);
        } catch (e) {
            console.error(e);
            appointmentsTableContainer.innerHTML = '<div class="empty">Failed to load appointments</div>';
        }
    }

    async function loadAppointments(clinicId, doctorId, date) {
        if (!clinicId) {
            appointmentsTableContainer.innerHTML = '<div class="empty">Select a clinic first</div>';
            return;
        }
        if (!doctorId) {
            appointmentsTableContainer.innerHTML = '<div class="empty">Select a doctor to view appointments</div>';
            return;
        }
        // Build mandatory date range (day-level) for API
        const day = date || (datePicker && datePicker.value) || moment().format('YYYY-MM-DD');
        const startDate = day; // yyyy-MM-dd
        const endDate = day;   // same day range by default
        const url = contextPath + '/schedules/api/doctor-appointments?clinicId=' + encodeURIComponent(clinicId) + '&doctorId=' + encodeURIComponent(doctorId) + '&startDate=' + encodeURIComponent(startDate) + '&endDate=' + encodeURIComponent(endDate);
        appointmentsTableContainer.innerHTML = '<div class="empty">Loading appointments...</div>';
        try {
            const res = await fetch(url, { credentials: 'same-origin' });
            if (!res.ok) {
                const msg = res.status === 403 ? 'Not authorized to view appointments for this clinic' : 'Failed to load appointments';
                appointmentsTableContainer.innerHTML = '<div class="empty">' + msg + '</div>';
                return;
            }
            const appointments = await res.json();
            lastAppointments = appointments;
            if (currentViewMode === 'calendar') renderAppointmentsCalendar(appointments, day);
            else renderAppointmentsTable(appointments);
        } catch (e) {
            console.error(e);
            appointmentsTableContainer.innerHTML = '<div class="empty">Failed to load appointments</div>';
        }
    }

    clinicDropdown && clinicDropdown.addEventListener('change', (e) => {
        loadDoctorsForClinic(e.target.value);
    });

    // Replace list click with dropdown change
    doctorDropdown && doctorDropdown.addEventListener('change', (e) => {
        selectedDoctorId = e.target.value || null;
        const clinicId = clinicDropdown.value;
        const date = datePicker && datePicker.value;
        if (selectedDoctorId && clinicId) {
            // Default to calendar view once doctor is selected
            setViewMode('calendar');
            loadAppointments(clinicId, selectedDoctorId, date);
        } else {
            setViewMode('table');
            appointmentsTableContainer.innerHTML = '<div class="empty">Select a doctor to view appointments</div>';
        }
    });

    // React to date change
    datePicker && datePicker.addEventListener('change', () => {
        const clinicId = clinicDropdown.value;
        if (selectedDoctorId && clinicId) {
            loadAppointments(clinicId, selectedDoctorId, datePicker.value);
        }
    });

    // Allow switching back to list view if needed
    tableViewBtn && tableViewBtn.addEventListener('click', () => setViewMode('table'));
    calendarViewBtn && calendarViewBtn.addEventListener('click', () => setViewMode('calendar'));

    // Remove legacy management/tracking handlers
    // openManagement && openManagement.addEventListener('click', () => { /* removed */ });
    // openTracking && openTracking.addEventListener('click', () => { /* removed */ });

    // legacy management/tracking handlers removed

    // Initialize to table view so searches/rendering default to table
    setViewMode('table');
    fetchClinics();

    // -----------------------------
    // Create Appointment Modal Logic
    // -----------------------------
    const openCreateAppointmentModalBtn = document.getElementById('openCreateAppointmentModal');
    const createModal = document.getElementById('createAppointmentModal');
    const closeCreateAppointmentModalBtn = document.getElementById('closeCreateAppointmentModal');
    const cancelCreateAppointmentBtn = document.getElementById('cancelCreateAppointmentBtn');
    const modalClinicSelect = document.getElementById('modalClinicSelect');
    const modalDoctorSelect = document.getElementById('modalDoctorSelect');
    const modalDateTimeInput = document.getElementById('modalDateTimeInput');
    const modalPatientSearch = document.getElementById('modalPatientSearch');
    const modalSearchPatientBtn = document.getElementById('modalSearchPatientBtn');
    const modalPatientResult = document.getElementById('modalPatientResult');
    const modalPatientMobileSearch = document.getElementById('modalPatientMobileSearch');
    const modalUnregisteredName = document.getElementById('modalUnregisteredName');
    const modalUnregisteredMobile = document.getElementById('modalUnregisteredMobile');

    const modalNotes = document.getElementById('modalNotes');
    const submitCreateAppointmentBtn = document.getElementById('submitCreateAppointmentBtn');
    const modalError = document.getElementById('modalError');
    let modalSelectedPatientId = null;
    let modalSelectedPatientName = null;
    let modalSelectedPatientReg = null;
    let modalSelectedPatientMobile = null;
    const notificationContainer = document.getElementById('notificationContainer');

    function showToast({ type = 'success', title = '', message = '', autoHideMs = 5000 }) {
        const container = document.getElementById('notificationContainer');
        if (!container) return;
    
        // Create the toast wrapper element (missing before)
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
    
        // Build one-line text with safe fallback
        const combinedRaw = title ? (message ? `${title}: ${message}` : title) : message;
        const combinedText = String(combinedRaw ?? '').replace(/\s+/g, ' ').trim() || (type === 'success' ? 'Success' : 'Notice');
    
        // Create content and close elements without innerHTML
        const contentEl = document.createElement('div');
        contentEl.className = 'toast-content single-line';
        contentEl.textContent = combinedText;
    
        const closeBtn = document.createElement('button');
        closeBtn.className = 'toast-close';
        closeBtn.setAttribute('aria-label', 'Close');
        closeBtn.textContent = '\u00D7';
    
        closeBtn.addEventListener('click', () => {
            toast.classList.add('closing');
            setTimeout(() => toast.remove(), 200);
        });
    
        toast.appendChild(contentEl);
        toast.appendChild(closeBtn);
        container.appendChild(toast);
    
        if (autoHideMs && autoHideMs > 0) {
            setTimeout(() => {
                if (!toast.isConnected) return;
                toast.classList.add('closing');
                setTimeout(() => toast.remove(), 200);
            }, autoHideMs);
        }
    }

    function resetCreateModal() {
        modalClinicSelect && (modalClinicSelect.value = '');
        if (modalDoctorSelect) modalDoctorSelect.innerHTML = '<option value="">-- Select Doctor --</option>';
        modalDateTimeInput && (modalDateTimeInput.value = '');
        modalPatientSearch && (modalPatientSearch.value = '');
        modalPatientMobileSearch && (modalPatientMobileSearch.value = '');
        modalUnregisteredName && (modalUnregisteredName.value = '');
        modalUnregisteredMobile && (modalUnregisteredMobile.value = '');
        if (modalPatientResult) { modalPatientResult.innerHTML = ''; modalPatientResult.textContent = ''; }
        modalSelectedPatientId = null;
        modalSelectedPatientName = null;
        modalSelectedPatientReg = null;
        modalSelectedPatientMobile = null;

        modalNotes && (modalNotes.value = '');
        modalError && (modalError.style.display = 'none');
    }

    async function loadModalClinics() {
        if (!modalClinicSelect) return;
        try {
            const res = await fetch(contextPath + '/schedules/api/clinics', { credentials: 'same-origin' });
            if (!res.ok) throw new Error('Failed to load clinics');
            const clinics = await res.json();
            // Avoid duplicating options
            if (modalClinicSelect.options.length <= 1) {
                clinics.forEach(c => {
                    const opt = document.createElement('option');
                    opt.value = c.clinicId;
                    opt.textContent = (c.clinicName || '') + ' (' + (c.clinicId || '') + ')';
                    modalClinicSelect.appendChild(opt);
                });
            }
        } catch (e) { console.error(e); }
    }

    async function loadModalDoctors(clinicId) {
        if (!modalDoctorSelect) return;
        modalDoctorSelect.innerHTML = '<option value="">-- Select Doctor --</option>';
        if (!clinicId) return;
        try {
            const res = await fetch(contextPath + '/schedules/api/clinic-doctors?clinicId=' + encodeURIComponent(clinicId), { credentials: 'same-origin' });
            if (!res.ok) return;
            const doctors = await res.json();
            const frag = document.createDocumentFragment();
            doctors.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.id;
                var displayName = ((d.firstName || '') + ' ' + (d.lastName || '')).trim();
                opt.textContent = displayName || d.username || ('Doctor #' + d.id);
                frag.appendChild(opt);
            });
            modalDoctorSelect.appendChild(frag);
        } catch (e) { console.error(e); }
    }

    function openCreateModal() {
        if (!createModal) return;
        resetCreateModal();
        // Pre-fill clinic and doctor if selected in page
        if (clinicDropdown && clinicDropdown.value) {
            // Ensure clinic options are loaded so the selected value displays proper text
            loadModalClinics().then(() => {
                modalClinicSelect.value = clinicDropdown.value;
                return loadModalDoctors(clinicDropdown.value);
            }).then(() => {
                if (selectedDoctorId) {
                    modalDoctorSelect.value = String(selectedDoctorId);
                }
            }).catch(() => {
                // Fallback: set value directly even if options failed to load
                modalClinicSelect.value = clinicDropdown.value;
            });
        } else {
            loadModalClinics();
        }
        // Pre-fill date-time if datePicker has a date
        if (datePicker && datePicker.value) {
            try {
                const day = datePicker.value;
                // Default time to now
                const now = new Date();
                const hours = String(now.getHours()).padStart(2, '0');
                const minutes = String(now.getMinutes()).padStart(2, '0');
                modalDateTimeInput.value = day + 'T' + hours + ':' + minutes;
            } catch (_) {}
        }
        createModal.style.display = 'flex';
    }

    function closeCreateModal() {
        if (!createModal) return;
        createModal.style.display = 'none';
        resetCreateModal();
    }

    openCreateAppointmentModalBtn && openCreateAppointmentModalBtn.addEventListener('click', openCreateModal);
    closeCreateAppointmentModalBtn && closeCreateAppointmentModalBtn.addEventListener('click', closeCreateModal);
    cancelCreateAppointmentBtn && cancelCreateAppointmentBtn.addEventListener('click', closeCreateModal);

    modalClinicSelect && modalClinicSelect.addEventListener('change', (e) => {
        loadModalDoctors(e.target.value);
    });

    modalSearchPatientBtn && modalSearchPatientBtn.addEventListener('click', async () => {
        const reg = (modalPatientSearch && modalPatientSearch.value || '').trim();
        const mobile = (modalPatientMobileSearch && modalPatientMobileSearch.value || '').trim();
        if (!reg && !mobile) {
            if (modalPatientResult) modalPatientResult.textContent = 'Enter a registration code or mobile to search';
            return;
        }
        if (modalPatientResult) modalPatientResult.textContent = 'Searching...';
        modalSelectedPatientId = null;
        try {
            const params = [];
            if (reg) params.push('registrationCode=' + encodeURIComponent(reg));
            if (mobile) params.push('mobile=' + encodeURIComponent(mobile));
            const url = contextPath + '/payments/search/patients?' + params.join('&');
            const res = await fetch(url, {
                credentials: 'same-origin',
                headers: { 'Accept': 'application/json' }
            });
            let data;
            const contentType = res.headers.get('content-type') || '';
            if (contentType.includes('application/json')) {
                data = await res.json();
            } else {
                const text = await res.text();
                try { data = JSON.parse(text); } catch { data = { success: false, message: 'Unexpected response format' }; }
            }

            const patients = (data && data.patients && Array.isArray(data.patients)) ? data.patients : [];
            if (!patients.length) {
                if (modalPatientResult) modalPatientResult.textContent = (data && data.message) ? data.message : 'No patients found';
                return;
            }

            const frag = document.createDocumentFragment();
            const list = document.createElement('div');
            list.className = 'patient-results-list';
            patients.forEach(p => {
                const name = (((p.firstName || '') + ' ' + (p.lastName || '')).trim()) || 'Unknown';
                const regCode = p.registrationCode || '';
                const phone = p.phoneNumber || '';
                const item = document.createElement('div');
                item.className = 'patient-result-item';
                item.innerHTML = `
                    <div class="patient-result-row">
                      <div class="patient-col">
                        <div class="patient-name">${name}</div>
                        <div class="patient-meta">
                          ${regCode ? `<span class="patient-reg">Registration Code: ${regCode}</span>` : ''}
                          ${phone ? `<span class="patient-phone">Phone Number: ${phone}</span>` : ''}
                        </div>
                      </div>
                      <div class="patient-col-actions">
                        <button type="button" class="btn btn-primary btn-sm patient-select-btn" data-id="${p.id}" data-name="${name}" data-reg="${regCode}" data-mobile="${phone}">Select</button>
                      </div>
                    </div>`;
                frag.appendChild(item);
            });
            list.appendChild(frag);
            if (modalPatientResult) {
                modalPatientResult.innerHTML = '';
                modalPatientResult.appendChild(list);
            }
        } catch (e) {
            console.error(e);
            if (modalPatientResult) modalPatientResult.textContent = 'Search failed';
        }
    });

    // Delegate selection clicks in the results list
    if (modalPatientResult) {
        modalPatientResult.addEventListener('click', (e) => {
            const btn = e.target.closest('.patient-select-btn');
            if (!btn) return;
            modalSelectedPatientId = btn.dataset.id ? Number(btn.dataset.id) : null;
            modalSelectedPatientName = btn.dataset.name || null;
            modalSelectedPatientReg = btn.dataset.reg || null;
            modalSelectedPatientMobile = btn.dataset.mobile || null;
            // Show a simple confirmation inline
            const summary = document.createElement('div');
            summary.className = 'patient-selected-summary';
            summary.textContent = `Selected: ${modalSelectedPatientName || ''}${modalSelectedPatientReg ? ' ('+modalSelectedPatientReg+')' : ''}${modalSelectedPatientMobile ? ' · '+modalSelectedPatientMobile : ''}`;
            // Clear list and show summary to reduce ambiguity
            modalPatientResult.innerHTML = '';
            modalPatientResult.appendChild(summary);
        });
    }

    async function submitCreateAppointment() {
        modalError.style.display = 'none';
        const clinicId = modalClinicSelect && modalClinicSelect.value;
        const doctorId = modalDoctorSelect && modalDoctorSelect.value;
        const dateTimeStr = modalDateTimeInput && modalDateTimeInput.value;
        if (!clinicId) { modalError.textContent = 'Please select a clinic'; modalError.style.display = 'block'; return; }
        if (!doctorId) { modalError.textContent = 'Please select a doctor'; modalError.style.display = 'block'; return; }
        if (!dateTimeStr) { modalError.textContent = 'Please select a date and time'; modalError.style.display = 'block'; return; }
        let isoDateTime;
        try { isoDateTime = dateTimeStr; } catch (_) { isoDateTime = null; }
        if (!isoDateTime) { modalError.textContent = 'Invalid date/time format'; modalError.style.display = 'block'; return; }
        const payload = {
            clinicId: clinicId,
            doctorId: Number(doctorId),
            appointmentDateTime: isoDateTime,
            notes: (modalNotes && modalNotes.value) ? modalNotes.value : null
        };
        if (modalSelectedPatientId) {
            payload.patientId = Number(modalSelectedPatientId);
        } else {
            const manualName = (modalUnregisteredName && modalUnregisteredName.value || '').trim();
            const manualMobile = (modalUnregisteredMobile && modalUnregisteredMobile.value || '').trim();
            if (!manualName || !manualMobile) {
                modalError.textContent = 'Enter patient name and mobile when no registered patient is selected';
                modalError.style.display = 'block';
                return;
            }
            const mobileOk = /^\+?[0-9][0-9\s-]{6,}$/.test(manualMobile);
            if (!mobileOk) {
                modalError.textContent = 'Please enter a valid mobile number';
                modalError.style.display = 'block';
                return;
            }
            payload.patientName = manualName;
            payload.patientMobile = manualMobile;
        }
        let created = false;
        try {
            const headers = { 'Content-Type': 'application/json' };
            const csrfEl = document.querySelector('meta[name="_csrf"]');
            if (csrfEl && csrfEl.content) headers['X-CSRF-TOKEN'] = csrfEl.content;
            const res = await fetch(contextPath + '/schedules/api/schedule-appointment', {
                method: 'POST',
                headers,
                credentials: 'same-origin',
                body: JSON.stringify(payload)
            });

            let data = null;
            const contentType = (res.headers.get('content-type') || '').toLowerCase();
            if (contentType.includes('application/json')) {
                try { data = await res.json(); } catch (_) { data = null; }
            } else {
                const text = await res.text();
                try { data = JSON.parse(text); } catch (_) { data = null; }
            }

            if (!res.ok || (data && data.success === false)) {
                const msg = (data && data.message) ? data.message : `Failed to create appointment (HTTP ${res.status})`;
                modalError.textContent = msg;
                modalError.style.display = 'block';
                return;
            }

            // Consider creation successful for any 2xx response
            created = true;
            modalError.style.display = 'none';

            const clinicText = modalClinicSelect && modalClinicSelect.options[modalClinicSelect.selectedIndex]
              ? modalClinicSelect.options[modalClinicSelect.selectedIndex].text
              : clinicId;
            const doctorText = modalDoctorSelect && modalDoctorSelect.options[modalDoctorSelect.selectedIndex]
              ? modalDoctorSelect.options[modalDoctorSelect.selectedIndex].text
              : ('Doctor ' + doctorId);
            const dtPretty = isoDateTime.replace('T',' ');
            const patientText = modalSelectedPatientName
              ? `${modalSelectedPatientName}${modalSelectedPatientReg ? ' ('+modalSelectedPatientReg+')' : ''}${modalSelectedPatientMobile ? ' · '+modalSelectedPatientMobile : ''}`
              : (payload.patientName ? `${payload.patientName}${payload.patientMobile ? ' · '+payload.patientMobile : ''}` : (modalSelectedPatientId ? `Patient ID ${modalSelectedPatientId}` : 'Unregistered patient'));
            const apptIdText = data && (data.appointmentId || data.id) ? ` · ID ${data.appointmentId || data.id}` : '';

            showToast({ type: 'success', title: 'Appointment created', message: `${clinicText} · ${doctorText} · ${dtPretty} · ${patientText}${apptIdText}` });

            // Close the modal immediately after success
            closeCreateModal();
        } catch (e) {
            console.error(e);
            if (!created) {
                modalError.textContent = 'Error creating appointment';
                modalError.style.display = 'block';
                return;
            }
        }

        // Try to refresh calendar in a separate step; do not surface as a creation error
        try {
            if (clinicDropdown && clinicDropdown.value === clinicId) {
                if (doctorDropdown && String(doctorDropdown.value || '') === String(doctorId)) {
                    const day = isoDateTime.slice(0, 10);
                    setViewMode('calendar');
                    await loadAppointments(clinicId, doctorId, day);
                }
            }
        } catch (e) {
            console.error('Appointments refresh failed', e);
            showToast({ type: 'error', title: 'Appointments refresh failed', message: 'Calendar did not update' });
        }
    }

    submitCreateAppointmentBtn && submitCreateAppointmentBtn.addEventListener('click', submitCreateAppointment);

})();