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

    @Mapping(target = "user", ignore = true)
    @Mapping(target = "rating", ignore = true)
    @Mapping(target = "totalSales", ignore = true)
    Seller toEntity(SellerCreateRequest sellerCreateRequest);
}