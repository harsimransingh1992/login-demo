package com.example.logindemo.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

@Controller
@Slf4j
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        // Get error status code
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        
        // Log the error
        if (status != null) {
            Integer statusCode = Integer.valueOf(status.toString());
            
            log.error("Error with status code: {} occurred. URI: {}", statusCode, request.getRequestURI());
            
            // Return specific page for 404 errors
            if (statusCode == HttpStatus.NOT_FOUND.value()) {
                return "404";
            }
            
            // Add status code to model
            model.addAttribute("status", statusCode);
            
            // Add specific error messages based on status code
            if (statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
                model.addAttribute("error", "Internal Server Error");
                model.addAttribute("message", "Something went wrong on our server.");
            } else if (statusCode == HttpStatus.FORBIDDEN.value()) {
                model.addAttribute("error", "Access Denied");
                model.addAttribute("message", "You don't have permission to access this resource.");
            } else {
                model.addAttribute("error", "Error");
                model.addAttribute("message", "An error occurred. Please try again later.");
            }
        } else {
            model.addAttribute("status", "Unknown");
            model.addAttribute("error", "Unknown Error");
            model.addAttribute("message", "An unexpected error occurred.");
        }
        
        // Get error message if available
        Object exception = request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
        if (exception != null) {
            String errorMessage = ((Throwable) exception).getMessage();
            model.addAttribute("exception", errorMessage);
            log.error("Exception: {}", errorMessage);
        }
        
        // In development mode, you may want to show the full stack trace
        Object trace = request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
        if (trace != null && trace instanceof Throwable) {
            model.addAttribute("trace", ((Throwable) trace).getMessage());
        }
        
        return "error";
    }
} 