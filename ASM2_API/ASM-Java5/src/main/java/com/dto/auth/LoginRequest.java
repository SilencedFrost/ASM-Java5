package com.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record LoginRequest(
        @NotBlank(message = "Email can not be blank")
        @Email(message = "Email is of incorrect format")
        String email,

        @NotBlank(message = "Password can not be blank")
        String password
) {
}
