package com.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum RoleFields implements Automatable {
    ROLE_ID("roleId"),
    ROLE_NAME("roleName");

    private final String propertyKey;
}
