package com.dto.session

import java.time.OffsetDateTime

data class SessionResponse(
    val sessionId: Long,
    val userId: Long,
    val sessionHash: String,
    val lastAccessed: OffsetDateTime,
    val createdAt: OffsetDateTime,
    val expiresAt: OffsetDateTime,
    val isActive: Boolean,
    val revokedAt: OffsetDateTime,
    val revokeReason: String,
    val userAgent: String
)
