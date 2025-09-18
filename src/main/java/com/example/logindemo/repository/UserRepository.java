package com.example.logindemo.repository;

import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.model.ClinicModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    List<User> findByRole(UserRole role);
    List<User> findByRoleAndClinic_Id(UserRole role, Long clinicId);
    List<User> findByClinicAndRoleIn(ClinicModel clinic, List<UserRole> roles);
} 