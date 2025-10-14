package com.mapper;

import com.dto.customer.CustomerCreateRequest;
import com.dto.customer.CustomerResponse;
import com.entity.Customer;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = UserMapper.class
)
public interface CustomerMapper {
    @Mapping(target = "userResponse", source = "user")
    CustomerResponse toDTO(Customer customer);

    Customer toEntity(CustomerCreateRequest customerCreateRequest);
}