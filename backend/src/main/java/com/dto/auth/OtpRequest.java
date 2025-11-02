package com.dto.auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record OtpRequest (
        @NotBlank(message = "OTP can't be blank")
        @Pattern(regexp = "\\d{6}", message = "Invalid OTP format")
        String otp
){
}
