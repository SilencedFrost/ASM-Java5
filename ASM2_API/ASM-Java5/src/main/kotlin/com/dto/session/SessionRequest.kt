package com.dto.session

data class CreateSessionRequest(
    val userId: Long,
    val sessionToken: String,
)
