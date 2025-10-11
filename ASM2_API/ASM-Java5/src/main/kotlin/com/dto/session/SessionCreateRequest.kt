package com.dto.session

data class SessionCreateRequest(
    val userId: Long,
    val sessionToken: String,
    val userAgent: String
)
