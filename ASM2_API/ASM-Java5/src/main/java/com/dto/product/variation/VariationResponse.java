package com.dto.product.variation;

import java.math.BigDecimal;

public record VariationResponse(
        Long variationId,
        Long productId,
        String image,
        String productSize,
        String variation,
        BigDecimal price
) {
}
