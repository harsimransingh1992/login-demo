package com.example.logindemo.service;

import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.DoctorDetailRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
@Component("doctorDetailService")
public class DoctorDetailServiceImpl implements DoctorDetailService {

    @Resource(name="doctorDetailRepository")
    private DoctorDetailRepository doctorDetailRepository;

    @Resource(name="modelMapper")
    private ModelMapper modelMapper;

    @Override
    public List<UserDTO> findDoctorsByOnboardClinicUsername(String username) {
        final List<User> clinicDoctors = doctorDetailRepository.findByClinic_Owner_Username(username);
        return clinicDoctors.stream()
            .filter(user -> user.getRole() == UserRole.DOCTOR)
            .map(user -> modelMapper.map(user, UserDTO.class))
            .collect(Collectors.toList());
    }
    
    @Override
    public List<UserDTO> getAllDoctors() {
        final List<User> doctors = doctorDetailRepository.findByRole(UserRole.DOCTOR);
        return doctors.stream()
            .map(user -> modelMapper.map(user, UserDTO.class))
            .collect(Collectors.toList());
    }
}
