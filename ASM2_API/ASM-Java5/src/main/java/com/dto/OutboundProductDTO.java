package com.dto;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutboundProductDTO implements ProductDTO{
    private Long productId;
    private String productName;
    private BigDecimal price;
    private Integer stockQuantity;
    private String ImageUrl;
    private boolean active;
    private String productDescription;
    private Integer categoryId;
    private JsonNode specifications;
    private LocalDateTime creationDate;
    private Integer cartCount;
    private Integer commentCount;
}