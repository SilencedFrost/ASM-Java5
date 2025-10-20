package com.dto.user;


import jakarta.validation.constraints.NotBlank;

import java.time.LocalDate;

public record ProfileUpdateRequest (

    @NotBlank(message = "Tên không được để trống")
    String firstName,

    @NotBlank(message = "Họ không được để trống")
    String lastName,

    LocalDate birthday
){
}
