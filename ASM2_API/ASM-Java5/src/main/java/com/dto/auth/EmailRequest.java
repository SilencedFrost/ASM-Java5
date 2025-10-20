package com.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record EmailRequest (
        @NotBlank(message = "Email can't be blank")
        @Email(message = "Invalid email format")
        String email
){
}
