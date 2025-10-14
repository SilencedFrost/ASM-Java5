package com.mapper;

import com.dto.city.CityCreateRequest;
import com.dto.city.CityResponse;
import com.entity.City;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface CityMapper {
    CityResponse toDTO(City city);

    City toEntity(CityCreateRequest cityCreateRequest);
}
