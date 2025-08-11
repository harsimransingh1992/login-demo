# Cloudflare + Tomcat Image Optimization Guide

## 1. Cloudflare Page Rules Configuration

### Create Page Rules for Image Caching:
```
URL Pattern: yourdomain.com/uploads/*
Settings:
- Cache Level: Cache Everything
- Edge Cache TTL: 1 year
- Browser Cache TTL: 1 year
- Always Online: On
- Auto Minify: CSS, JavaScript, HTML
- Rocket Loader: On
- Security Level: Medium
```

### Create Page Rules for Static Assets:
```
URL Pattern: yourdomain.com/images/*
Settings:
- Cache Level: Cache Everything
- Edge Cache TTL: 1 year
- Browser Cache TTL: 1 year
- Always Online: On
```

## 2. Cloudflare Workers (Optional - Advanced)

### Image Optimization Worker:
```javascript
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const url = new URL(request.url)
  
  // Check if it's an image request
  if (url.pathname.includes('/uploads/') && 
      (url.pathname.endsWith('.jpg') || url.pathname.endsWith('.jpeg') || 
       url.pathname.endsWith('.png') || url.pathname.endsWith('.gif'))) {
    
    // Add Cloudflare image optimization
    const imageRequest = new Request(request.url, {
      cf: {
        image: {
          format: 'auto',
          quality: 85,
          width: 1200,
          fit: 'scale-down'
        }
      }
    })
    
    return fetch(imageRequest)
  }
  
  return fetch(request)
}
```

## 3. Tomcat Configuration Updates

### Update web.xml for Image Caching:
```xml
<servlet-mapping>
    <servlet-name>default</servlet-name>
    <url-pattern>/uploads/*</url-pattern>
</servlet-mapping>

<servlet>
    <servlet-name>ImageCacheFilter</servlet-name>
    <servlet-class>com.example.logindemo.filter.ImageCacheFilter</servlet-class>
</servlet>

<filter-mapping>
    <filter-name>ImageCacheFilter</filter-name>
    <url-pattern>/uploads/*</url-pattern>
</filter-mapping>
```

## 4. Cloudflare Settings Checklist

### Speed Tab:
- ✅ **Auto Minify**: CSS, JavaScript, HTML
- ✅ **Rocket Loader**: On
- ✅ **Brotli**: On
- ✅ **Early Hints**: On
- ✅ **HTTP/3**: On
- ✅ **0-RTT**: On

### Caching Tab:
- ✅ **Always Online**: On
- ✅ **Development Mode**: Off (for production)
- ✅ **Purge Cache**: Use when deploying updates

### Network Tab:
- ✅ **HTTP/2**: On
- ✅ **HTTP/3**: On
- ✅ **0-RTT**: On
- ✅ **WebSockets**: On

## 5. Performance Monitoring

### Cloudflare Analytics:
- Monitor cache hit rates
- Track image loading performance
- Analyze bandwidth usage
- Monitor response times

### Custom Headers for Monitoring:
```java
// Add to your image serving controller
response.setHeader("CF-Cache-Status", "HIT"); // or "MISS"
response.setHeader("CF-Ray", request.getHeader("CF-Ray"));
```

## 6. Expected Performance Improvements

With Cloudflare + Tomcat optimization:
- **50-80% faster image loading** due to CDN caching
- **90%+ cache hit rate** for static images
- **Reduced server load** by serving cached content
- **Global distribution** for faster access worldwide
- **Automatic compression** and optimization 