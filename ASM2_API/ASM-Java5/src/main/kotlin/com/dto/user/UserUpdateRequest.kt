package com.dto.user

import java.time.LocalDate

data class UserUpdateRequest(
    val userId: Long,  // Required to identify which user to update
    val email: String? = null,
    val username: String? = null,
    val firstName: String? = null,
    val lastName: String? = null,
    val birthday: LocalDate? = null,
    val password: String? = null,  // Optional password change
    val phoneNumber: String? = null,
    val roleId: Int? = null,
    val isActive: Boolean? = null
)
