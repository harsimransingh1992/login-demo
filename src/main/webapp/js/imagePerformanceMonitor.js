/**
 * Image Performance Monitor
 * Tracks image loading performance and provides optimization insights
 */

const ImagePerformanceMonitor = {
    imageLoadTimes: [],
    failedImages: [],
    
    /**
     * Initialize the performance monitor
     */
    init() {
        this.observeImageLoading();
        this.setupPerformanceReporting();
    },
    
    /**
     * Observe image loading performance
     */
    observeImageLoading() {
        const images = document.querySelectorAll('img');
        
        images.forEach(img => {
            const startTime = performance.now();
            
            if (img.complete) {
                // Image already loaded (cached)
                const cachedLoadTime = 0.1; // Small time for cached images
                this.recordImageLoad(img.src, cachedLoadTime, true, true);
            } else {
                // Image still loading
                img.addEventListener('load', () => {
                    const loadTime = performance.now() - startTime;
                    // Ensure minimum time for very fast loads
                    const adjustedLoadTime = Math.max(loadTime, 0.1);
                    this.recordImageLoad(img.src, adjustedLoadTime, true, false);
                });
                
                img.addEventListener('error', () => {
                    const loadTime = performance.now() - startTime;
                    const adjustedLoadTime = Math.max(loadTime, 0.1);
                    this.recordImageLoad(img.src, adjustedLoadTime, false, false);
                });
            }
        });
    },
    
    /**
     * Record image load performance
     */
    recordImageLoad(src, loadTime, success, isCached = false) {
        const imageData = {
            src: src,
            loadTime: loadTime,
            success: success,
            isCached: isCached,
            timestamp: new Date().toISOString(),
            size: this.getImageSize(src)
        };
        
        this.imageLoadTimes.push(imageData);
        
        if (!success) {
            this.failedImages.push(imageData);
        }
        
        // Log slow images (over 2 seconds) and cache status
        if (loadTime > 2000) {
            console.warn(`Slow image load detected: ${src} took ${loadTime.toFixed(2)}ms`);
        } else if (isCached) {
            console.log(`Cached image loaded: ${src} (${loadTime.toFixed(2)}ms)`);
        } else if (loadTime < 10) {
            console.log(`Very fast image load: ${src} (${loadTime.toFixed(2)}ms) - likely cached`);
        } else {
            console.log(`Image loaded: ${src} took ${loadTime.toFixed(2)}ms`);
        }
    },
    
    /**
     * Get image size from URL (approximate)
     */
    getImageSize(src) {
        // This is a placeholder - in a real implementation, you'd get actual file size
        return 'unknown';
    },
    
    /**
     * Setup performance reporting
     */
    setupPerformanceReporting() {
        // Report performance after page load
        window.addEventListener('load', () => {
            setTimeout(() => {
                this.generatePerformanceReport();
            }, 1000);
        });
    },
    
    /**
     * Generate performance report
     */
    generatePerformanceReport() {
        const totalImages = this.imageLoadTimes.length;
        const successfulImages = this.imageLoadTimes.filter(img => img.success).length;
        const failedImages = this.failedImages.length;
        const cachedImages = this.imageLoadTimes.filter(img => img.isCached).length;
        const freshImages = this.imageLoadTimes.filter(img => !img.isCached && img.success).length;
        
        const loadTimes = this.imageLoadTimes
            .filter(img => img.success)
            .map(img => img.loadTime);
        
        const freshLoadTimes = this.imageLoadTimes
            .filter(img => !img.isCached && img.success)
            .map(img => img.loadTime);
        
        const avgLoadTime = loadTimes.length > 0 ? 
            loadTimes.reduce((a, b) => a + b, 0) / loadTimes.length : 0;
        
        const avgFreshLoadTime = freshLoadTimes.length > 0 ? 
            freshLoadTimes.reduce((a, b) => a + b, 0) / freshLoadTimes.length : 0;
        
        const maxLoadTime = loadTimes.length > 0 ? Math.max(...loadTimes) : 0;
        const minLoadTime = loadTimes.length > 0 ? Math.min(...loadTimes) : 0;
        
        const report = {
            totalImages,
            successfulImages,
            failedImages,
            cachedImages,
            freshImages,
            averageLoadTime: avgLoadTime.toFixed(2) + 'ms',
            averageFreshLoadTime: avgFreshLoadTime.toFixed(2) + 'ms',
            maxLoadTime: maxLoadTime.toFixed(2) + 'ms',
            minLoadTime: minLoadTime.toFixed(2) + 'ms',
            slowImages: this.imageLoadTimes.filter(img => img.loadTime > 2000),
            cacheHitRate: totalImages > 0 ? ((cachedImages / totalImages) * 100).toFixed(1) + '%' : '0%'
        };
        
        console.log('=== Image Performance Report ===');
        console.log('Total Images:', report.totalImages);
        console.log('Successful Loads:', report.successfulImages);
        console.log('Failed Loads:', report.failedImages);
        console.log('Cached Images:', report.cachedImages);
        console.log('Fresh Loads:', report.freshImages);
        console.log('Cache Hit Rate:', report.cacheHitRate);
        console.log('Average Load Time (All):', report.averageLoadTime);
        console.log('Average Load Time (Fresh):', report.averageFreshLoadTime);
        console.log('Max Load Time:', report.maxLoadTime);
        console.log('Min Load Time:', report.minLoadTime);
        
        if (report.slowImages.length > 0) {
            console.warn('Slow Images (>2s):', report.slowImages.map(img => ({
                src: img.src,
                loadTime: img.loadTime.toFixed(2) + 'ms',
                isCached: img.isCached
            })));
        }
        
        // Performance insights
        if (report.cacheHitRate === '100%') {
            console.log('🎉 Excellent! All images loaded from cache');
        } else if (parseFloat(report.cacheHitRate) > 80) {
            console.log('✅ Good cache performance');
        } else if (parseFloat(report.cacheHitRate) > 50) {
            console.log('⚠️ Moderate cache performance - consider optimizing');
        } else {
            console.log('❌ Low cache performance - images loading fresh');
        }
        
        // Performance report generated - no server reporting needed
    },
    

    
    /**
     * Get performance summary
     */
    getPerformanceSummary() {
        return {
            totalImages: this.imageLoadTimes.length,
            successfulImages: this.imageLoadTimes.filter(img => img.success).length,
            failedImages: this.failedImages.length,
            averageLoadTime: this.imageLoadTimes
                .filter(img => img.success)
                .reduce((sum, img) => sum + img.loadTime, 0) / 
                this.imageLoadTimes.filter(img => img.success).length || 0
        };
    }
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    ImagePerformanceMonitor.init();
});

// Export for global access
window.ImagePerformanceMonitor = ImagePerformanceMonitor; 