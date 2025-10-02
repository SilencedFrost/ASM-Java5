package com.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ProductFields implements Automatable {
    PRODUCT_ID("productId"),
    PRODUCT_NAME("productName"),
    PRICE("price"),
    STOCK_QUANTITY("stockQuantity"),
    IMAGE_URL("imageUrl"),
    IS_ACTIVE("active"),
    PRODUCT_DESCRIPTION("productDescription"),
    CATEGORY_ID("categoryId"),
    SPECIFICATIONS("specifications"),
    CREATION_DATE("creationDate");

    private final String propertyKey;
}
