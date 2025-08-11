/**
 * Service Worker for PeriDesk Application
 * Handles caching, offline functionality, and performance optimization
 */

const CACHE_NAME = 'peridesk-v1.0.0';
const STATIC_CACHE = 'peridesk-static-v1.0.0';
const DYNAMIC_CACHE = 'peridesk-dynamic-v1.0.0';

// Static assets to cache
const STATIC_ASSETS = [
    '/css/style.css',
    '/css/common/menu.css',
    '/css/patient/patientDetails.css',
    '/css/patient/list.css',
    '/css/chairside-note-component.css',
    '/css/color-code-component.css',
    '/js/imageCompression.js',
    '/js/imagePerformanceMonitor.js',
    '/js/performanceOptimizer.js',
    '/js/chairside-note-component.js',
    '/js/color-code-component.js',
    '/images/default-profile.png',
    'https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap',
    'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css',
    'https://code.jquery.com/jquery-3.6.4.min.js'
];

// Dynamic routes to cache
const DYNAMIC_ROUTES = [
    '/patients/list',
    '/patients/details/',
    '/patients/examination/',
    '/appointments/management'
];

// Install event - cache static assets
self.addEventListener('install', event => {
    console.log('Service Worker installing...');
    
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then(cache => {
                console.log('Caching static assets...');
                return cache.addAll(STATIC_ASSETS);
            })
            .then(() => {
                console.log('Static assets cached successfully');
                return self.skipWaiting();
            })
            .catch(error => {
                console.error('Failed to cache static assets:', error);
            })
    );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
    console.log('Service Worker activating...');
    
    event.waitUntil(
        caches.keys()
            .then(cacheNames => {
                return Promise.all(
                    cacheNames.map(cacheName => {
                        if (cacheName !== STATIC_CACHE && cacheName !== DYNAMIC_CACHE) {
                            console.log('Deleting old cache:', cacheName);
                            return caches.delete(cacheName);
                        }
                    })
                );
            })
            .then(() => {
                console.log('Service Worker activated');
                return self.clients.claim();
            })
    );
});

// Fetch event - serve from cache or network
self.addEventListener('fetch', event => {
    const { request } = event;
    const url = new URL(request.url);
    
    // Skip non-GET requests
    if (request.method !== 'GET') {
        return;
    }
    
    // Handle static assets
    if (isStaticAsset(request.url)) {
        event.respondWith(
            caches.match(request)
                .then(response => {
                    if (response) {
                        console.log('Serving from cache:', request.url);
                        return response;
                    }
                    
                    return fetch(request)
                        .then(response => {
                            if (response.status === 200) {
                                const responseClone = response.clone();
                                caches.open(STATIC_CACHE)
                                    .then(cache => {
                                        cache.put(request, responseClone);
                                    });
                            }
                            return response;
                        });
                })
        );
        return;
    }
    
    // Handle dynamic content (HTML pages)
    if (isDynamicRoute(request.url)) {
        event.respondWith(
            fetch(request)
                .then(response => {
                    if (response.status === 200) {
                        const responseClone = response.clone();
                        caches.open(DYNAMIC_CACHE)
                            .then(cache => {
                                cache.put(request, responseClone);
                            });
                    }
                    return response;
                })
                .catch(() => {
                    return caches.match(request)
                        .then(response => {
                            if (response) {
                                console.log('Serving offline page from cache:', request.url);
                                return response;
                            }
                            return caches.match('/offline.html');
                        });
                })
        );
        return;
    }
    
    // Handle image requests
    if (isImageRequest(request.url)) {
        event.respondWith(
            caches.match(request)
                .then(response => {
                    if (response) {
                        console.log('Serving image from cache:', request.url);
                        return response;
                    }
                    
                    return fetch(request)
                        .then(response => {
                            if (response.status === 200) {
                                const responseClone = response.clone();
                                caches.open(DYNAMIC_CACHE)
                                    .then(cache => {
                                        cache.put(request, responseClone);
                                    });
                            }
                            return response;
                        });
                })
        );
        return;
    }
    
    // Default network-first strategy for other requests
    event.respondWith(
        fetch(request)
            .catch(() => {
                return caches.match(request);
            })
    );
});

// Background sync for offline actions
self.addEventListener('sync', event => {
    if (event.tag === 'background-sync') {
        event.waitUntil(
            // Handle background sync tasks
            console.log('Background sync triggered')
        );
    }
});

// Push notifications
self.addEventListener('push', event => {
    const options = {
        body: event.data ? event.data.text() : 'New notification from PeriDesk',
        icon: '/images/default-profile.png',
        badge: '/images/default-profile.png',
        vibrate: [100, 50, 100],
        data: {
            dateOfArrival: Date.now(),
            primaryKey: 1
        },
        actions: [
            {
                action: 'explore',
                title: 'View Details',
                icon: '/images/default-profile.png'
            },
            {
                action: 'close',
                title: 'Close',
                icon: '/images/default-profile.png'
            }
        ]
    };
    
    event.waitUntil(
        self.registration.showNotification('PeriDesk Notification', options)
    );
});

// Helper functions
function isStaticAsset(url) {
    return STATIC_ASSETS.some(asset => url.includes(asset)) ||
           url.includes('/css/') ||
           url.includes('/js/') ||
           url.includes('/images/') ||
           url.includes('fonts.googleapis.com') ||
           url.includes('cdnjs.cloudflare.com') ||
           url.includes('code.jquery.com');
}

function isDynamicRoute(url) {
    return DYNAMIC_ROUTES.some(route => url.includes(route)) ||
           url.endsWith('.jsp') ||
           url.includes('/patients/') ||
           url.includes('/appointments/');
}

function isImageRequest(url) {
    return url.match(/\.(jpg|jpeg|png|gif|webp|svg)$/i) ||
           url.includes('/uploads/');
}

// Cache management functions
function clearOldCaches() {
    return caches.keys()
        .then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName);
                    }
                })
            );
        });
}

function updateCache() {
    return caches.open(CACHE_NAME)
        .then(cache => {
            return cache.addAll(STATIC_ASSETS);
        });
}

// Message handling for cache management
self.addEventListener('message', event => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        self.skipWaiting();
    }
    
    if (event.data && event.data.type === 'CLEAR_CACHE') {
        event.waitUntil(clearOldCaches());
    }
    
    if (event.data && event.data.type === 'UPDATE_CACHE') {
        event.waitUntil(updateCache());
    }
}); 