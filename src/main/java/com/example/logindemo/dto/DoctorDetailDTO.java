package com.example.logindemo.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DoctorDetailDTO {
    private Long id;
    private String doctorName;
    private UserDTO onboardClinic;
}
