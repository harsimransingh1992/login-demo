package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
import java.util.List;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;

@Setter
@Getter
@Entity
@Table(name = "patients")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String firstName;

    @Column(nullable = false)
    private String lastName;

    @Column(nullable = false)
    private Date dateOfBirth;

    @Column(nullable = false)
    private String gender;

    @Column(nullable = false)
    private String phoneNumber;

    @Column
    private String email;

    @Column
    private String streetAddress;

    @Column
    private String city;

    @Column
    private String state;

    @Column
    private String pincode;

    @Column
    private String medicalHistory;

    @Column(nullable = false)
    private Date registrationDate = new Date();

    @Column(unique = true)
    private String registrationCode;

    @Column(name = "checked_in")
    private Boolean checkedIn = false; // Default value is false

    @Column
    private String emergencyContactName;

    @Column
    private String emergencyContactPhoneNumber;

    @Column
    @Enumerated(EnumType.STRING)
    private Occupation occupation;

    @Column
    @Enumerated(EnumType.STRING)
    private ReferralModel referralModel;

    @Column(name = "referral_other")
    private String referralOther;

    @OneToOne
    private CheckInRecord currentCheckInRecord;

    @OneToMany(cascade = CascadeType.ALL)
    private List<CheckInRecord> patientCheckIns;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<ToothClinicalExamination> toothClinicalExaminations;

    @Column(name = "profile_picture_path")
    private String profilePicturePath;

    @ManyToOne
    @JoinColumn(name = "created_by")
    private User createdBy;

    @ManyToOne
    @JoinColumn(name = "registered_clinic")
    private ClinicModel registeredClinic;

    @Column(name = "created_at")
    private Date createdAt = new Date();

    /**
     * Calculate the age based on the dateOfBirth.
     * @return the age in years
     */
    public int getAge() {
        if (dateOfBirth == null) {
            return 0;
        }
        LocalDate birthDate = dateOfBirth.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        return Period.between(birthDate, LocalDate.now()).getYears();
    }
}