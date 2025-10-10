package com.dto.user

import java.time.LocalDate
import java.time.OffsetDateTime

data class UserResponse(
    val userId: Long,
    val email: String,
    val username: String,
    val firstName: String?,
    val lastName: String?,
    val birthday: LocalDate?,
    val phoneNumber: String?,
    val roleId: Int,
    val isActive: Boolean,
    val creationDate: OffsetDateTime,
    val updatedAt: OffsetDateTime?
)
