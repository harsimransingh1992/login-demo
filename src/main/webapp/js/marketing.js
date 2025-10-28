// Minimal analytics and performance helpers for the marketing page
(function () {
  // Analytics: replace with real provider keys as needed
  var ANALYTICS_PROVIDER = 'gtag'; // or 'plausible'
  var GA_MEASUREMENT_ID = window.GA_MEASUREMENT_ID || null; // e.g., 'G-XXXXXXX'

  function trackPageView() {
    try {
      if (ANALYTICS_PROVIDER === 'gtag' && window.gtag && GA_MEASUREMENT_ID) {
        window.gtag('js', new Date());
        window.gtag('config', GA_MEASUREMENT_ID, { page_path: window.location.pathname });
      } else if (ANALYTICS_PROVIDER === 'plausible' && window.plausible) {
        window.plausible('pageview');
      } else {
        // no-op; provider not configured
      }
    } catch (e) { /* swallow */ }
  }

  // Lazy image optimization: ensure native lazy works and fade-in
  function enhanceLazyImages() {
    var images = document.querySelectorAll('img[loading="lazy"]');
    images.forEach(function (img) {
      img.style.opacity = '0';
      img.style.transition = 'opacity 300ms ease';
      function onLoad() { img.style.opacity = '1'; }
      if (img.complete) { onLoad(); } else { img.addEventListener('load', onLoad, { once: true }); }
    });
  }

  // Header skip link support for accessibility
  function addSkipLink() {
    var skip = document.createElement('a');
    skip.href = '#main';
    skip.className = 'visually-hidden-focusable';
    skip.textContent = 'Skip to main content';
    skip.style.position = 'absolute';
    skip.style.left = '8px';
    skip.style.top = '8px';
    skip.style.background = '#fff';
    skip.style.padding = '6px 10px';
    skip.style.borderRadius = '6px';
    skip.style.boxShadow = '0 2px 8px rgba(0,0,0,0.08)';
    skip.style.transform = 'translateY(-200%)';
    skip.style.transition = 'transform 160ms ease';
    skip.addEventListener('focus', function () { skip.style.transform = 'translateY(0)'; });
    skip.addEventListener('blur', function () { skip.style.transform = 'translateY(-200%)'; });
    document.body.prepend(skip);
  }

  document.addEventListener('DOMContentLoaded', function () {
    trackPageView();
    enhanceLazyImages();
    addSkipLink();
  });
})();