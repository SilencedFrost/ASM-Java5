package com.dto.user

import java.time.LocalDate

data class UserCreateRequest(
    val email: String,
    val username: String,
    val firstName: String?,
    val lastName: String?,
    val birthday: LocalDate?,
    val password: String,
    val phoneNumber: String?,
    val roleId: Int
)
