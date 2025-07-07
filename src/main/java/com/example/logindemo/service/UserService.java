package com.example.logindemo.service;

import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.dto.UserRegistrationDto;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.model.User;
import com.example.logindemo.model.ClinicModel;

import java.util.List;
import java.util.Optional;

public interface UserService {
    List<UserDTO> getAllUsers();
    Optional<UserDTO> getUserById(Long id);
    Optional<UserDTO> getUserByUsername(String username);
    UserDTO createUser(UserDTO userDTO);
    UserDTO updateUser(Long id, UserDTO userDTO);
    void deleteUser(Long id);
    List<UserDTO> getUsersByRole(UserRole role);
    List<UserDTO> getUsersByRoleAndClinic(UserRole role, ClinicModel clinic);
    long countUsers();
    void registerNewUser(UserRegistrationDto registrationDto);
    Optional<User> findByUsername(String username);
}
