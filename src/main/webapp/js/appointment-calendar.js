/**
 * Initializes the appointment calendar
 * @param {Array} appointmentEvents - Array of appointment events
 */
function initializeCalendar(appointmentEvents) {
    var calendarEl = document.getElementById('calendar');
    
    if (!calendarEl) {
        console.error('Calendar element not found');
        return;
    }
    
    // Debug appointment data
    console.log('Appointment Events:', appointmentEvents);
    
    // Process appointment dates if needed
    appointmentEvents.forEach(function(event) {
        // Ensure date is in correct format for FullCalendar
        if (event.start && typeof event.start === 'string') {
            // If date is already in ISO format, FullCalendar can handle it
            // If not, we might need to convert it
            console.log('Original date format:', event.start);
            
            // If date doesn't have 'T' separator (ISO format), add it
            if (event.start.indexOf('T') === -1) {
                event.start = event.start.replace(' ', 'T');
            }
            
            console.log('Processed date:', event.start);
        }
    });
    
    // Determine screen size
    var isMobile = window.innerWidth < 768;
    var isSmall = window.innerWidth < 576;
    
    // Set calendar options based on screen size
    var calendarOptions = {
        initialView: 'timeGridDay',
        headerToolbar: {
            left: isMobile ? 'prev,next' : 'prev,next today',
            center: 'title',
            right: isMobile ? 'today' : 'timeGridDay,timeGridWeek'
        },
        slotMinTime: '08:00:00',
        slotMaxTime: '20:00:00',
        slotDuration: '00:30:00',
        allDaySlot: false,
        height: 'auto',
        expandRows: true,
        stickyHeaderDates: true,
        nowIndicator: true,
        timeZone: 'local',
        now: new Date(),
        scrollTime: new Date().getHours() + ':00:00',
        slotEventOverlap: false,
        forceEventDuration: true,
        defaultTimedEventDuration: '00:30:00',
        businessHours: {
            daysOfWeek: [0, 1, 2, 3, 4, 5, 6],
            startTime: '08:00',
            endTime: '20:00'
        },
        eventBackgroundColor: '#e8f4fc',
        eventBorderColor: '#3498db',
        eventTextColor: '#2c3e50',
        events: appointmentEvents,
        eventClick: function(info) {
            info.jsEvent.preventDefault();
            window.location.href = info.event.url;
        },
        eventTimeFormat: {
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        eventContent: function(arg) {
            var doctor = arg.event.extendedProps.doctor || '';
            var phone = arg.event.extendedProps.phone || '';
            
            // Simplified content for very small screens
            if (isSmall) {
                return {
                    html: 
                        '<div class="fc-event-main-frame">' +
                        '<div class="fc-event-title-container">' +
                        '<div class="fc-event-title fc-sticky">' + arg.event.title + '</div>' +
                        '</div>' +
                        '<div class="fc-event-doctor">Dr. ' + doctor + '</div>' +
                        '</div>'
                };
            }
            
            return {
                html: 
                    '<div class="fc-event-main-frame">' +
                    '<div class="fc-event-title-container">' +
                    '<div class="fc-event-title fc-sticky">' + arg.event.title + '</div>' +
                    '</div>' +
                    '<div class="fc-event-doctor">Dr. ' + doctor + '</div>' +
                    (isMobile ? '' : '<div class="fc-event-phone">' + phone + '</div>') +
                    '</div>'
            };
        },
        loading: function(isLoading) {
            if (!isLoading) {
                setTimeout(function() {
                    var scrollContainer = document.querySelector('.fc-timegrid-body');
                    if (scrollContainer) {
                        var now = new Date();
                        var currentHour = now.getHours();
                        var currentMinute = now.getMinutes();
                        
                        // Adjust hour height based on screen size
                        var hourHeight = isSmall ? 30 : (isMobile ? 35 : 45);
                        var scrollPosition = ((currentHour - 8) * hourHeight) + ((currentMinute / 60) * hourHeight);
                        
                        if (scrollPosition >= 0) {
                            scrollContainer.scrollTop = scrollPosition;
                        }
                    }
                }, 100);
            }
        },
        // Add responsive handling
        windowResize: function(view) {
            var newIsMobile = window.innerWidth < 768;
            var newIsSmall = window.innerWidth < 576;
            
            if (newIsMobile !== isMobile || newIsSmall !== isSmall) {
                isMobile = newIsMobile;
                isSmall = newIsSmall;
                
                // Update toolbar configuration
                calendar.setOption('headerToolbar', {
                    left: isMobile ? 'prev,next' : 'prev,next today',
                    center: 'title',
                    right: isMobile ? 'today' : 'timeGridDay,timeGridWeek'
                });
                
                // Force redraw
                calendar.updateSize();
            }
        },
        // Customize view rendering
        viewDidMount: function(view) {
            // Apply custom styles after view is mounted
            setTimeout(function() {
                adjustCalendarSize();
            }, 0);
        }
    };
    
    var calendar = new FullCalendar.Calendar(calendarEl, calendarOptions);
    calendar.render();
    
    // Function to adjust calendar size
    function adjustCalendarSize() {
        var calendarContainer = document.querySelector('.calendar-container');
        var calendarHeader = document.querySelector('.fc-header-toolbar');
        var calendarBody = document.querySelector('.fc-view-harness');
        
        if (calendarContainer && calendarHeader && calendarBody) {
            // Calculate available height
            var containerHeight = calendarContainer.offsetHeight;
            var headerHeight = calendarHeader.offsetHeight;
            var availableHeight = containerHeight - headerHeight - 20; // 20px for padding
            
            // Set the height of the calendar body
            if (availableHeight > 200) { // Minimum height
                calendarBody.style.height = availableHeight + 'px';
            }
        }
    }
    
    // Add window resize listener for responsive adjustments
    window.addEventListener('resize', function() {
        if (calendarEl) {
            // Allow calendar to adjust to new container size
            calendar.updateSize();
            adjustCalendarSize();
        }
    });
    
    // Initial size adjustment
    adjustCalendarSize();
} 