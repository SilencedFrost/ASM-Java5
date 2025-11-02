package com.dto.cart;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record CartCreateRequest(

        @NotNull(message = "Product variation id can't be null")
        Long variationId,

        @NotNull(message = "Quantity can't be null")
        @Min(value = 1, message = ("Quantity can't be less than 1"))
        Integer quantity
) {
}
