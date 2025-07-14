package com.example.logindemo.mapper;

import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ToothClinicalExaminationMapper {
    
    @Mapping(target = "paymentCollectionDate", source = "paymentCollectionDate")
    @Mapping(target = "paymentAmount", source = "procedure.price")
    @Mapping(target = "paymentMode", source = "paymentMode")
    @Mapping(target = "paymentNotes", source = "paymentNotes")
    ToothClinicalExaminationDTO toDTO(ToothClinicalExamination examination);

    @Mapping(target = "paymentCollectionDate", source = "paymentCollectionDate")
    @Mapping(target = "paymentAmount", source = "procedure.price")
    @Mapping(target = "paymentMode", source = "paymentMode")
    @Mapping(target = "paymentNotes", source = "paymentNotes")
    ToothClinicalExamination toEntity(ToothClinicalExaminationDTO dto);
} 