package com.mapper;

import com.dto.product.ProductCreateRequest;
import com.dto.product.ProductResponse;
import com.entity.Product;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface ProductMapper {
     @Mapping(target = "categoryId", source = "category.categoryId")
     @Mapping(target = "parentId", source = "product.parentId")
     @Mapping(target = "sellerId", source = "seller.sellerId")
    ProductResponse toDTO(Product product);

    Product toEntity(ProductCreateRequest productCreateRequest);
}
