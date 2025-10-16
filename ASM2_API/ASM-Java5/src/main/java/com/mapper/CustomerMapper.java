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
    CustomerResponse toDTO(Customer customer);

    @Mapping(target = "user", ignore = true)
    Customer toEntity(CustomerCreateRequest customerCreateRequest);
}