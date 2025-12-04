package com.mapper;

import com.dto.product.ProductCreateRequest;
import com.dto.product.ProductResponse;
import com.dto.product.ProductSummaryResponse;
import com.entity.Product;
import com.entity.Variation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.math.BigDecimal;
import java.util.Set;

@Mapper(
        componentModel = "spring",
        uses = VariationMapper.class)
public interface ProductMapper {

    @Mapping(target = "categoryId", source = "category.categoryId")
    @Mapping(target = "sellerId", source = "seller.sellerId")
    @Mapping(target = "sellerName", source = "seller.shopName")
    @Mapping(target = "thumbnail", expression = "java(buildThumbnailFilename(product))")
    ProductResponse toDTO(Product product);

    @Mapping(target = "categoryId", source = "category.categoryId")
    @Mapping(target = "sellerId", source = "seller.sellerId")
    @Mapping(target = "sellerName", source = "seller.shopName")
    @Mapping(target = "thumbnail", expression = "java(buildThumbnailFilename(product))")
    @Mapping(target = "price", expression = "java(aggregatePrice(product.getVariations()))")
    ProductSummaryResponse toSummaryDTO(Product product);

    @Mapping(target = "rating", ignore = true)
    @Mapping(target = "totalSales", ignore = true)
    @Mapping(target = "thumbnailExtension", ignore = true)
    @Mapping(target = "carts", ignore = true)
    @Mapping(target = "variations", ignore = true)
    Product toEntity(ProductCreateRequest productCreateRequest);

    default String buildThumbnailFilename(Product product) {
        if (product.getThumbnailExtension() == null || product.getProductId() == null) {
            return null;
        }
        return product.getProductId() + "." + product.getThumbnailExtension();
    }

    default BigDecimal aggregatePrice(Set<Variation> variations) {
        return variations.stream().map(Variation::getPrice).min(BigDecimal::compareTo).orElse(BigDecimal.ZERO);
    }
}
