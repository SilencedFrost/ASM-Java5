package com.mapper;

import com.dto.product.ProductCreateRequest;
import com.dto.product.ProductResponse;
import com.entity.Product;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = ProductVariationMapper.class)
public interface ProductMapper {

    @Mapping(target = "categoryId", source = "category.categoryId")
    @Mapping(target = "sellerId", source = "seller.sellerId")
    @Mapping(target = "thumbnail", expression = "java(buildThumbnailFilename(product))")
    ProductResponse toDTO(Product product);

    @Mapping(target = "viewCount", ignore = true)
    @Mapping(target = "totalSales", ignore = true)
    @Mapping(target = "thumbnailExtension", ignore = true)
    Product toEntity(ProductCreateRequest productCreateRequest);

    default String buildThumbnailFilename(Product product) {
        if (product.getThumbnailExtension() == null || product.getProductId() == null) {
            return null;
        }
        return product.getProductId() + "." + product.getThumbnailExtension();
    }
}
