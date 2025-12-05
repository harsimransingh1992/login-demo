package com.example.logindemo.dto;

import com.example.logindemo.model.ReferralModel;
import com.example.logindemo.model.MembershipPlan;
import com.example.logindemo.model.PatientColorCode;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Getter
@Setter
public class PatientDTO {

    private String id;

    private String firstName;

    private String lastName;

    private String registrationCode;

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

    private ReferralDTO referralModel;

    private Boolean checkedIn;

    private CheckInRecordDTO currentCheckInRecord;

    private List<CheckInRecordDTO> patientCheckIns;
    
    private String profilePicturePath;
    
    // This field is not persisted but used for file upload
    private transient org.springframework.web.multipart.MultipartFile profilePicture;

    private Integer age;
    
    private String referralOther;
    
    // Audit fields
    private String createdBy;
    private String registeredClinic;
    private Date createdAt;
    
    private PatientColorCode colorCode;

    private String chairsideNote;

    // Transient field for pending payments calculation
    private Double pendingPayments = 0.0;

    private MembershipPlan membershipPlan;
    private String membershipNumber;

    public Integer getAge() {
        if (dateOfBirth == null) {
            return null;
        }
        LocalDate birthDate = dateOfBirth.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate currentDate = LocalDate.now();
        return Period.between(birthDate, currentDate).getYears();
    }

}
