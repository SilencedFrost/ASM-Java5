package com.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CartFields implements Automatable {
    USER_ID("userId"),
    PRODUCT_ID("productId"),
    QUANTITY("quantity");

    private final String propertyKey;
}
