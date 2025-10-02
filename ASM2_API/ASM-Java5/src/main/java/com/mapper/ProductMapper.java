package com.mapper;

import com.dto.InboundProductDTO;
import com.dto.OutboundProductDTO;
import com.dto.ProductDTO;
import com.entity.Category;
import com.entity.Product;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ProductMapper {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static OutboundProductDTO toDTO(Product product) {
        if (product == null) {
            return null;
        }

        JsonNode specsNode = null;
        try {
            if (product.getSpecifications() != null && !product.getSpecifications().isBlank()) {
                specsNode = objectMapper.readTree(product.getSpecifications());
            }
        } catch (IOException e) {
            specsNode = objectMapper.createObjectNode();
        }

        return new OutboundProductDTO(
                product.getProductId(),
                product.getProductName(),
                product.getPrice(),
                product.getStockQuantity(),
                product.getImageUrl(),
                product.isActive(),
                product.getProductDescription(),
                product.getCategory().getCategoryId(),
                specsNode,
                product.getCreationDate(),
                product.getCarts().size(),
                product.getComments().size()
        );
    }

    public static Product toEntity(InboundProductDTO productDTO, Category category) {
        if (productDTO == null) {
            return null;
        }

        return new Product(
                productDTO.getProductName(),
                productDTO.getPrice(),
                productDTO.getStockQuantity(),
                productDTO.getImageUrl(),
                productDTO.isActive(),
                productDTO.getProductDescription(),
                category,
                productDTO.getSpecifications()
        );
    }

    public static List<OutboundProductDTO> toDTOList(List<Product> entityList) {
        List<OutboundProductDTO> dtoList = new ArrayList<>();
        for (Product product : entityList) {
            dtoList.add(ProductMapper.toDTO(product));
        }
        return dtoList;
    }
}
