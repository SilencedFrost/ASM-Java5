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
    SellerResponse toDTO(Seller seller);

    Seller toEntity(SellerCreateRequest sellerCreateRequest);
}