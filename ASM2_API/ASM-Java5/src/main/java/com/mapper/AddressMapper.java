package com.mapper;

import com.dto.address.AddressCreateRequest;
import com.dto.address.AddressResponse;
import com.entity.Address;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface AddressMapper {

    @Mapping(target = "userId", source = "user.userId")
    AddressResponse toDTO(Address address);

    Address toEntity(AddressCreateRequest addressCreateRequest);
}

