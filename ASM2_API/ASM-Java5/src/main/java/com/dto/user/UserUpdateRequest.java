package com.dto.user;

import java.time.LocalDate;

public record UserUpdateRequest(
        Long userId,
        String email,
        String username,
        String firstName,
        String lastName,
        LocalDate birthday,
        String password,
        String phoneNumber,
        Integer roleId,
        Boolean isActive
) {
}
