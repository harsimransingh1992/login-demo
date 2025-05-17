package com.example.logindemo.dto;

import com.example.logindemo.model.ReferralModel;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

@Getter
@Setter
public class PatientDTO {

    private String id;

    private String firstName;

    private String lastName;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date dateOfBirth;

    private String gender;

    private String phoneNumber;

    private String email;

    private String streetAddress;
    
    private String city;
    
    private String state;
    
    private String pincode;

    private Date registrationDate;

    private String medicalHistory;

    private String emergencyContactName;

    private String emergencyContactPhoneNumber;

    private OccupationDTO occupation;

    private ReferralDTO referral;

    private Boolean checkedIn;

    private CheckInRecordDTO currentCheckInRecord;

    private List<CheckInRecordDTO> patientCheckIns;
    
    private String profilePicturePath;
    
    // This field is not persisted but used for file upload
    private transient org.springframework.web.multipart.MultipartFile profilePicture;

}