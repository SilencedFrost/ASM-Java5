package com.dto.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

import java.time.LocalDate;

public record UserCreateRequest(

        @NotBlank(message = "Email can not be blank")
        @Email(message = "Email is of incorrect format")
        String email,

        String username,
        String firstName,
        String lastName,
        LocalDate birthday,

        @NotBlank(message = "Password can not be blank")
        @Pattern(message = "Password must contain one: lowercase letter, uppercase letter, special char (!@#$%^&*_-), and be 8-32 chars long", regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*_-]).{8,32}$")
        String password,

        String phoneNumber,
        Integer roleId
) {
}
