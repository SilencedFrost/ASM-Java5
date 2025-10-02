package com.dto;

import java.math.BigDecimal;

public interface ProductDTO {
    public String getProductName();
    public BigDecimal getPrice();
    public Integer getStockQuantity();
    public String getImageUrl();
    public boolean isActive();
    public String getProductDescription();
    public Integer getCategoryId();
}
