package com.dto.city;

public record CityUpdateRequest(
        Integer cityId,
        String cityName
) {
}
