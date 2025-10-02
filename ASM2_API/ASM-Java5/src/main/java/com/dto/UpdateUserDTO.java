package com.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UpdateUserDTO extends InboundUserDTO{
    private Long userId;

    public UpdateUserDTO(Long userId, String username, String email, String passwordHash, String roleName, boolean active){
        super(username, email, passwordHash, roleName, active);
        this.userId = userId;
    }
}
