package com.dto.address;

public record AddressResponse(
        Long addressId,
        Long userId,
        String addressLine1,
        String addressLine2,
        Integer cityId,
        Boolean isDefault
) {
}
