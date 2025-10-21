package com.dto.auth;

public record VerificationTokenRequest(
    String token,
    Long userId
) {
}
