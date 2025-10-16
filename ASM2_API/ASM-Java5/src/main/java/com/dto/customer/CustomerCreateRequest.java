package com.dto.customer;

import com.dto.user.UserCreateRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

public record CustomerCreateRequest(
        @NotNull(message = "User object is null")
        @Valid
        UserCreateRequest user
) {
}
