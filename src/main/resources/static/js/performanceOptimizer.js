/**
 * Frontend Performance Optimizer
 * Handles resource optimization, lazy loading, and performance monitoring
 */

const PerformanceOptimizer = {
    /**
     * Initialize performance optimizations
     */
    init() {
        this.preloadCriticalResources();
        this.setupLazyLoading();
        this.optimizeImages();
        this.setupIntersectionObserver();
        this.monitorPerformance();
        this.optimizeFonts();
        this.setupServiceWorker();
    },

    /**
     * Preload critical resources
     */
    preloadCriticalResources() {
        // Preload critical CSS and JS
        const criticalResources = [
            '/css/style.css',
            '/css/common/menu.css',
            '/js/imageCompression.js'
        ];

        criticalResources.forEach(resource => {
            const link = document.createElement('link');
            link.rel = 'preload';
            link.href = resource;
            link.as = resource.endsWith('.css') ? 'style' : 'script';
            document.head.appendChild(link);
        });

        // Preload critical fonts
        const fontLink = document.createElement('link');
        fontLink.rel = 'preload';
        fontLink.href = 'https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap';
        fontLink.as = 'style';
        document.head.appendChild(fontLink);
    },

    /**
     * Setup lazy loading for images and components
     */
    setupLazyLoading() {
        // Lazy load images
        const images = document.querySelectorAll('img[data-src]');
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    observer.unobserve(img);
                }
            });
        });

        images.forEach(img => imageObserver.observe(img));

        // Lazy load components
        const components = document.querySelectorAll('[data-lazy-component]');
        const componentObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    this.loadComponent(entry.target);
                    observer.unobserve(entry.target);
                }
            });
        });

        components.forEach(component => componentObserver.observe(component));
    },

    /**
     * Optimize images for better performance
     */
    optimizeImages() {
        // Add loading="lazy" to all images
        const images = document.querySelectorAll('img:not([loading])');
        images.forEach(img => {
            img.loading = 'lazy';
            img.decoding = 'async';
        });

        // Add error handling for images
        images.forEach(img => {
            img.addEventListener('error', () => {
                img.style.display = 'none';
                console.warn(`Failed to load image: ${img.src}`);
            });
        });
    },

    /**
     * Setup intersection observer for performance monitoring
     */
    setupIntersectionObserver() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    // Track component visibility
                    this.trackComponentVisibility(entry.target);
                }
            });
        }, {
            threshold: 0.1
        });

        // Observe all major components
        const components = document.querySelectorAll('.container, .modal, .form-section');
        components.forEach(component => observer.observe(component));
    },

    /**
     * Monitor application performance
     */
    monitorPerformance() {
        // Monitor Core Web Vitals
        if ('PerformanceObserver' in window) {
            // Largest Contentful Paint (LCP)
            const lcpObserver = new PerformanceObserver((list) => {
                const entries = list.getEntries();
                const lastEntry = entries[entries.length - 1];
                console.log('LCP:', lastEntry.startTime);
                
                if (lastEntry.startTime > 2500) {
                    console.warn('LCP is too slow:', lastEntry.startTime);
                }
            });
            lcpObserver.observe({ entryTypes: ['largest-contentful-paint'] });

            // First Input Delay (FID)
            const fidObserver = new PerformanceObserver((list) => {
                const entries = list.getEntries();
                entries.forEach(entry => {
                    console.log('FID:', entry.processingStart - entry.startTime);
                    
                    if (entry.processingStart - entry.startTime > 100) {
                        console.warn('FID is too slow:', entry.processingStart - entry.startTime);
                    }
                });
            });
            fidObserver.observe({ entryTypes: ['first-input'] });

            // Cumulative Layout Shift (CLS)
            const clsObserver = new PerformanceObserver((list) => {
                let clsValue = 0;
                const entries = list.getEntries();
                entries.forEach(entry => {
                    if (!entry.hadRecentInput) {
                        clsValue += entry.value;
                    }
                });
                console.log('CLS:', clsValue);
                
                if (clsValue > 0.1) {
                    console.warn('CLS is too high:', clsValue);
                }
            });
            clsObserver.observe({ entryTypes: ['layout-shift'] });
        }

        // Monitor memory usage
        if ('memory' in performance) {
            setInterval(() => {
                const memory = performance.memory;
                const usedMB = Math.round(memory.usedJSHeapSize / 1048576);
                const totalMB = Math.round(memory.totalJSHeapSize / 1048576);
                
                if (usedMB > 100) {
                    console.warn('High memory usage:', usedMB + 'MB / ' + totalMB + 'MB');
                }
            }, 30000);
        }
    },

    /**
     * Optimize font loading
     */
    optimizeFonts() {
        // Font display swap for better performance
        const fontLinks = document.querySelectorAll('link[href*="fonts.googleapis.com"]');
        fontLinks.forEach(link => {
            if (!link.href.includes('display=swap')) {
                link.href += '&display=swap';
            }
        });

        // Preload critical fonts
        const criticalFonts = [
            'https://fonts.gstatic.com/s/poppins/v20/pxiEyp8kv8JHgFVrJJfecg.woff2',
            'https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLGT9Z1xlFQ.woff2'
        ];

        criticalFonts.forEach(font => {
            const link = document.createElement('link');
            link.rel = 'preload';
            link.href = font;
            link.as = 'font';
            link.type = 'font/woff2';
            link.crossOrigin = 'anonymous';
            document.head.appendChild(link);
        });
    },

    /**
     * Setup service worker for caching
     */
    setupServiceWorker() {
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('/sw.js')
                .then(registration => {
                    console.log('Service Worker registered:', registration);
                })
                .catch(error => {
                    console.log('Service Worker registration failed:', error);
                });
        }
    },

    /**
     * Load component dynamically
     */
    loadComponent(element) {
        const componentType = element.dataset.lazyComponent;
        const componentUrl = element.dataset.componentUrl;
        
        if (componentUrl) {
            fetch(componentUrl)
                .then(response => response.text())
                .then(html => {
                    element.innerHTML = html;
                    element.classList.add('loaded');
                })
                .catch(error => {
                    console.error('Failed to load component:', error);
                });
        }
    },

    /**
     * Track component visibility for analytics
     */
    trackComponentVisibility(element) {
        const componentName = element.className || element.id || 'unknown';
        console.log('Component visible:', componentName);
        
        // Send analytics data if needed
        if (window.gtag) {
            gtag('event', 'component_view', {
                'component_name': componentName,
                'page_location': window.location.href
            });
        }
    },

    /**
     * Optimize DOM operations
     */
    optimizeDOM() {
        // Use DocumentFragment for bulk DOM operations
        const fragment = document.createDocumentFragment();
        
        // Batch DOM updates
        requestAnimationFrame(() => {
            // Perform DOM updates here
        });
    },

    /**
     * Debounce function calls
     */
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    /**
     * Throttle function calls
     */
    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }
};

// Initialize performance optimizations when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    PerformanceOptimizer.init();
});

// Export for use in other modules
window.PerformanceOptimizer = PerformanceOptimizer; 