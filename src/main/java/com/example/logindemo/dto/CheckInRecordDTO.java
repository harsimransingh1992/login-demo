package com.example.logindemo.dto;

import com.example.logindemo.model.CheckInStatus;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Getter
@Setter
public class CheckInRecordDTO {
    private Long id;

    @DateTimeFormat(pattern = "dd-MM-yyyy hh:mm:ss")
    private LocalDateTime checkInTime;

    @DateTimeFormat(pattern = "dd-MM-yyyy hh:mm:ss")
    private LocalDateTime  checkOutTime;

    private ClinicDTO clinic;

    private UserDTO assignedDoctor;

    private CheckInStatus status;
}
