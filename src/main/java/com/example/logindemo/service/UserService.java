package com.example.logindemo.service;

import com.example.logindemo.model.User;
import com.example.logindemo.dto.UserRegistrationDto;

public interface UserService {
    User registerNewUser(UserRegistrationDto registrationDto) throws Exception;
    boolean usernameExists(String username);
} 