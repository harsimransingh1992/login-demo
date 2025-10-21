package com.example.logindemo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.logindemo.model.User;
import com.example.logindemo.service.UserService;

@ControllerAdvice(annotations = Controller.class)
public class GlobalModelAttributes {

    @Autowired
    private UserService userService;

    @ModelAttribute("currentUserClinicName")
    public String currentUserClinicName() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null) {
                return "";
            }
            String username = auth.getName();
            return userService.findByUsername(username)
                .map(user -> user.getClinic() != null && user.getClinic().getClinicName() != null
                        ? user.getClinic().getClinicName()
                        : "")
                .orElse("");
        } catch (Exception e) {
            return "";
        }
    }
}