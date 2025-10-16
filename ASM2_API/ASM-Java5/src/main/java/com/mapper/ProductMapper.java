package com.mapper;

import com.dto.product.ProductCreateRequest;
import com.dto.product.ProductResponse;
import com.entity.Product;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ProductMapper {
    @Mapping(target = "categoryId", source = "category.categoryId")
    @Mapping(target = "parentId", source = "parentProduct.productId")
    @Mapping(target = "sellerId", source = "seller.sellerId")
    ProductResponse toDTO(Product product);

    @Mapping(target = "viewCount", ignore = true)
    @Mapping(target = "totalSales", ignore = true)
    Product toEntity(ProductCreateRequest productCreateRequest);
}
