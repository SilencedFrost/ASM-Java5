package com.dto.session

import java.time.OffsetDateTime

data class SessionUpdateRequest(
    val sessionId: Long,
    val lastAccessed: OffsetDateTime,
    val expiresAt: OffsetDateTime,
    val isActive: Boolean,
    val revokedAt: OffsetDateTime,
    val revokeReason: String,
    val userAgent: String
)
