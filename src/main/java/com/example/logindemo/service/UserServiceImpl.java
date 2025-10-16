package com.example.logindemo.service;

import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.dto.UserRegistrationDto;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.repository.ClinicRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public UserDTO createUser(UserDTO userDTO) {
        // Check if username already exists
        if (userRepository.findByUsername(userDTO.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }

        User user = modelMapper.map(userDTO, User.class);
        
        // Set default password if not provided
        String password = userDTO.getPassword();
        if (password == null || password.isEmpty()) {
            password = "changeme";  // Default password
        }
        user.setPassword(passwordEncoder.encode(password));
        
        User savedUser = userRepository.save(user);
        return modelMapper.map(savedUser, UserDTO.class);
    }

    @Override
    @Transactional
    public UserDTO updateUser(Long id, UserDTO userDTO) {
        return userRepository.findById(id)
                .map(user -> {
                    // Check if username is being changed and if it's already taken
                    if (!user.getUsername().equals(userDTO.getUsername())) {
                        if (userRepository.findByUsername(userDTO.getUsername()).isPresent()) {
                            throw new RuntimeException("Username already exists");
                        }
                        user.setUsername(userDTO.getUsername());
                    }

                    // Update user fields but preserve password
                    user.setFirstName(userDTO.getFirstName());
                    user.setLastName(userDTO.getLastName());
                    user.setEmail(userDTO.getEmail());
                    user.setPhoneNumber(userDTO.getPhoneNumber());
                    user.setRole(userDTO.getRole());
                    
                    // Update new dental professional fields
                    user.setSpecialization(userDTO.getSpecialization());
                    user.setLicenseNumber(userDTO.getLicenseNumber());
                    user.setLicenseExpiryDate(userDTO.getLicenseExpiryDate());
                    user.setQualification(userDTO.getQualification());
                    user.setDesignation(userDTO.getDesignation());
                    user.setJoiningDate(userDTO.getJoiningDate());
                    user.setEmergencyContact(userDTO.getEmergencyContact());
                    user.setAddress(userDTO.getAddress());
                    user.setBio(userDTO.getBio());
                    user.setIsActive(userDTO.getIsActive());
                    user.setCanRefund(userDTO.getCanRefund());
                    user.setCanApplyDiscount(userDTO.getCanApplyDiscount());
                    user.setCanDeleteExamination(userDTO.getCanDeleteExamination());
                    
                    // Update clinic if provided
                    if (userDTO.getClinic() != null) {
                        user.setClinic(modelMapper.map(userDTO.getClinic(), com.example.logindemo.model.ClinicModel.class));
                    }
                    
                    User updatedUser = userRepository.save(user);
                    return modelMapper.map(updatedUser, UserDTO.class);
                })
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    @Override
    @Transactional
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserDTO> getAllUsers() {
        return userRepository.findAll().stream()
                .map(user -> modelMapper.map(user, UserDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<UserDTO> getUserById(Long id) {
        return userRepository.findById(id)
                .map(user -> modelMapper.map(user, UserDTO.class));
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<UserDTO> getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .map(user -> modelMapper.map(user, UserDTO.class));
    }

    @Override
    @Transactional(readOnly = true)
    public long countUsers() {
        return userRepository.count();
    }


    
    @Override
    @Transactional
    public void registerNewUser(UserRegistrationDto registrationDto) {
        // Check if username already exists
        if (userRepository.findByUsername(registrationDto.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }
        
        // Validate password match
        if (!registrationDto.getPassword().equals(registrationDto.getConfirmPassword())) {
            throw new RuntimeException("Passwords do not match");
        }
        
        // Create new user
        User user = new User();
        user.setUsername(registrationDto.getUsername());
        user.setPassword(passwordEncoder.encode(registrationDto.getPassword()));
        
        // Set user details if provided
        user.setFirstName(registrationDto.getFirstName() != null ? registrationDto.getFirstName() : "New");
        user.setLastName(registrationDto.getLastName() != null ? registrationDto.getLastName() : "User");
        user.setEmail(registrationDto.getEmail());
        user.setPhoneNumber(registrationDto.getPhoneNumber());
        user.setRole(UserRole.STAFF); // Default role
        
        // Set new dental professional fields
        user.setSpecialization(registrationDto.getSpecialization());
        user.setLicenseNumber(registrationDto.getLicenseNumber());
        user.setLicenseExpiryDate(registrationDto.getLicenseExpiryDate());
        user.setQualification(registrationDto.getQualification());
        user.setDesignation(registrationDto.getDesignation());
        user.setJoiningDate(registrationDto.getJoiningDate());
        user.setEmergencyContact(registrationDto.getEmergencyContact());
        user.setAddress(registrationDto.getAddress());
        user.setBio(registrationDto.getBio());
        user.setIsActive(registrationDto.getIsActive() != null ? registrationDto.getIsActive() : true);
        
        // Associate with clinic if clinicId is provided
        if (registrationDto.getClinicId() != null) {
            clinicRepository.findById(registrationDto.getClinicId())
                .ifPresent(user::setClinic);
        }
        
        userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserDTO> getUsersByRole(UserRole role) {
        return userRepository.findByRole(role).stream()
            .map(user -> modelMapper.map(user, UserDTO.class))
            .collect(Collectors.toList());
    }

    @Override
    public List<UserDTO> getUsersByRoleAndClinic(UserRole role, ClinicModel clinic) {
        if (clinic == null) {
            return new java.util.ArrayList<>();
        }
        return userRepository.findByRoleAndClinic_Id(role, clinic.getId()).stream()
                .map(user -> modelMapper.map(user, UserDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}