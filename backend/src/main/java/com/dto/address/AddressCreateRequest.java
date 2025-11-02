package com.dto.address;

public record AddressCreateRequest(
        Long userId,
        String addressLine1,
        String addressLine2,
        Integer cityId,
        Boolean isDefault
) {
}
