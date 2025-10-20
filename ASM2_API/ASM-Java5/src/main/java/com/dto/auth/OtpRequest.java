package com.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record OtpRequest (
        @NotBlank(message = "OTP is required")
        String otp
){
}
