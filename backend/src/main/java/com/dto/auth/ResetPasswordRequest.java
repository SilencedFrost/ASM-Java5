package com.dto.auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record ResetPasswordRequest(
    @NotBlank(message = "Password can't be blank")
    @Pattern(message = "Password must contain one: lowercase letter, uppercase letter, special char (!@#$%^&*_-), and be 8-32 chars long", regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*_-]).{8,32}$")
    String newPassword
) {
}
