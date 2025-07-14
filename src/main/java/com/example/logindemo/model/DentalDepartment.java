package com.example.logindemo.model;


import lombok.Getter;

@Getter
public enum DentalDepartment {

    ORTHODONTICS("Orthodontics"),
    PERIODONTICS("Periodontics"),
    PEDODONTICS("Pedodontics"),
    PROSTHODONTICS("Prosthodontics"),
    IMPLANTOLOGY("Implantology"),
    DIAGNOSIS_ORAL_MEDICINE_RADIOLOGY("Diagnosis, Oral Medicine & Radiology"),
    ENDODONTICS_CONSERVATIVE_DENTISTRY("Department of Endodontics & Conservative Dentistry"),
    ORAL_MAXILLOFACIAL_SURGERY("Department of Oral & Maxillofacial Surgery");


    private final String displayName;

    DentalDepartment(String displayName) {
        this.displayName = displayName;
    }
}
