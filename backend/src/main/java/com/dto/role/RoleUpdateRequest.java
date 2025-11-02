package com.dto.role;

public record RoleUpdateRequest(
        Integer roleId,
        String roleName
) {
}
