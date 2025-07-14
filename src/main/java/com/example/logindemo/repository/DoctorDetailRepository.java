package com.example.logindemo.repository;

import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;

@Component("doctorDetailRepository")
public interface DoctorDetailRepository extends JpaRepository<User, Long> {
    List<User> findByClinic_Owner_Username(String username);
    
    List<User> findByRole(UserRole role);
}
