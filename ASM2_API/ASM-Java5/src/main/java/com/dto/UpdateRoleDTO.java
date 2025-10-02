package com.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
public class UpdateRoleDTO extends InboundRoleDTO{
    private Integer roleId;

    public UpdateRoleDTO(Integer roleId, String roleName) {
        super(roleName);
        this.roleId = roleId;
    }
}
