package com.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutboundRoleDTO implements RoleDTO{
    private Integer roleId;
    private String roleName;
}
