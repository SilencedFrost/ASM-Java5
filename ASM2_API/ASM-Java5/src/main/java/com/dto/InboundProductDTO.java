package com.dto;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InboundProductDTO implements ProductDTO{
    protected String productName;
    protected BigDecimal price;
    protected Integer stockQuantity;
    protected String ImageUrl;
    protected boolean active;
    protected String productDescription;
    protected Integer categoryId;
    protected String specifications;
}