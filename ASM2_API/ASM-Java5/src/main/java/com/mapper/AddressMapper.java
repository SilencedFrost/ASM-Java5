package com.mapper;

import com.dto.address.AddressCreateRequest;
import com.dto.address.AddressResponse;
import com.entity.Address;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface AddressMapper {
    AddressResponse toDTO(Address address);

    Address toEntity(AddressCreateRequest addressCreateRequest);
}

