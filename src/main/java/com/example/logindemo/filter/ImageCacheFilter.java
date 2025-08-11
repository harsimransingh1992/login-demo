package com.example.logindemo.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ImageCacheFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(ImageCacheFilter.class);
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        
        // Check if this is an image request
        if (isImageRequest(requestURI)) {
            addImageCacheHeaders(httpResponse, requestURI);
            logger.debug("Added cache headers for image: {}", requestURI);
        }
        
        chain.doFilter(request, response);
    }
    
    private boolean isImageRequest(String requestURI) {
        return requestURI != null && (
            requestURI.contains("/uploads/") ||
            requestURI.contains("/images/") ||
            requestURI.endsWith(".jpg") ||
            requestURI.endsWith(".jpeg") ||
            requestURI.endsWith(".png") ||
            requestURI.endsWith(".gif") ||
            requestURI.endsWith(".webp") ||
            requestURI.endsWith(".svg")
        );
    }
    
    private void addImageCacheHeaders(HttpServletResponse response, String requestURI) {
        // Set cache control headers for Cloudflare optimization
        response.setHeader("Cache-Control", "public, max-age=31536000, immutable");
        response.setHeader("Expires", "Thu, 31 Dec 2024 23:59:59 GMT");
        response.setHeader("ETag", generateETag(requestURI));
        response.setHeader("Last-Modified", "Thu, 01 Jan 2024 00:00:00 GMT");
        
        // Cloudflare specific headers
        response.setHeader("CF-Cache-Status", "DYNAMIC");
        
        // Add vary header for proper caching
        response.setHeader("Vary", "Accept-Encoding");
        
        // Set content type if not already set
        if (response.getContentType() == null) {
            String contentType = getContentType(requestURI);
            if (contentType != null) {
                response.setContentType(contentType);
            }
        }
    }
    
    private String generateETag(String requestURI) {
        // Simple ETag generation based on URI
        return "\"" + requestURI.hashCode() + "\"";
    }
    
    private String getContentType(String requestURI) {
        if (requestURI.endsWith(".jpg") || requestURI.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (requestURI.endsWith(".png")) {
            return "image/png";
        } else if (requestURI.endsWith(".gif")) {
            return "image/gif";
        } else if (requestURI.endsWith(".webp")) {
            return "image/webp";
        } else if (requestURI.endsWith(".svg")) {
            return "image/svg+xml";
        }
        return null;
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("ImageCacheFilter initialized");
    }
    
    @Override
    public void destroy() {
        logger.info("ImageCacheFilter destroyed");
    }
} 