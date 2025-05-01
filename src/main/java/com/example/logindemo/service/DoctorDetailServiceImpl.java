package com.example.logindemo.service;

import com.example.logindemo.dto.DoctorDetailDTO;
import com.example.logindemo.model.DoctorDetail;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.repository.DoctorDetailRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@Component("doctorDetailService")
public class DoctorDetailServiceImpl implements DoctorDetailService{

    @Resource(name="doctorDetailRepository")
    private DoctorDetailRepository doctorDetailRepository;

    @Resource(name="modelMapper")
    private ModelMapper modelMapper;

    @Override
    public List<DoctorDetailDTO> findDoctorsByOnboardClinicUsername(String clinicId) {
            final List<DoctorDetail> clinicDoctors=doctorDetailRepository.findDoctorsByOnboardClinic_Username(clinicId);
            List<DoctorDetailDTO> clinicDoctorDTOs=new ArrayList<>();
            clinicDoctors.forEach(doctorDetail->{
                clinicDoctorDTOs.add(modelMapper.map(doctorDetail, DoctorDetailDTO.class));
            });
            return clinicDoctorDTOs;
    }
}
