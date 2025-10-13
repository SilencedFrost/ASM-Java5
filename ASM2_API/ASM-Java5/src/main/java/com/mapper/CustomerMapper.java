package com.mapper;

import com.dto.customer.CustomerCreateRequest;
import com.dto.customer.CustomerResponse;
import com.entity.Customer;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring", uses = UserMapper.class,
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface CustomerMapper {
    @Mapping(source = "user", target = "userResponse")
    CustomerResponse toDTO(Customer customer);

    @Mapping(source = "userId", target = "user.userId")
    Customer toEntity(CustomerCreateRequest customerCreateRequest);
}
