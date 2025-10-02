package com.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InboundRoleDTO implements RoleDTO{
    private String roleName;
}
