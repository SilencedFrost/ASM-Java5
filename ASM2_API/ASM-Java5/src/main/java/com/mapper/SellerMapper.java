package com.mapper;

import com.dto.seller.SellerCreateRequest;
import com.dto.seller.SellerResponse;
import com.entity.Seller;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = UserMapper.class
)

public interface SellerMapper {
    @Mapping(target = "userResponse" ,source = "user")
    SellerResponse toDTO(Seller seller);

    Seller toEntity(SellerCreateRequest sellerCreateRequest);
}