package com.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class UpdateProductDTO extends InboundProductDTO{
    private Long productId;

    public UpdateProductDTO(Long productId, String productName, BigDecimal price, Integer stockQuantity, String ImageUrl, boolean active, String productDescription, Integer categoryId, String specifications){
        super(productName, price, stockQuantity, ImageUrl, active, productDescription, categoryId, specifications);
        this.productId = productId;
    }
}