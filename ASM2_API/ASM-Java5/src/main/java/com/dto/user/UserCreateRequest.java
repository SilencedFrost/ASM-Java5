package com.dto.user;

import java.time.LocalDate;

public record UserCreateRequest(
        String email,
        String username,
        String firstName,
        String lastName,
        LocalDate birthday,
        String password,
        String phoneNumber,
        Integer roleId
) {
}
