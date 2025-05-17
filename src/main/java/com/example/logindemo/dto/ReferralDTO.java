package com.example.logindemo.dto;

import com.example.logindemo.model.ReferralModel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReferralDTO {
    private String name;
    private String displayName;

    public static ReferralDTO fromEntity(ReferralModel model) {
        ReferralDTO dto = new ReferralDTO();
        dto.setName(model.name());
        dto.setDisplayName(model.getDisplayName());
        return dto;
    }
} 