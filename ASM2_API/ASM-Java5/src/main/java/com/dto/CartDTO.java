package com.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartDTO {

    @NotBlank(message = "User id is required")
    private Long userId;

    @NotBlank(message = "Product id is required")
    private Long productId;

    @NotBlank(message = "Quantity is required")
    private Integer quantity;
}
