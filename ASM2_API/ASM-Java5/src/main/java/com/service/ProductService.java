package com.service;

import com.dto.*;
import com.entity.Category;
import com.entity.Product;
import com.mapper.ProductMapper;
import com.repository.CategoryRepository;
import com.repository.ProductRepository;
import com.util.ValidationUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    public Page<OutboundProductDTO> findAll(Pageable pageable) {
        return productRepository.findAll(pageable).map(ProductMapper::toDTO);
    }

    public List<OutboundProductDTO> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<OutboundProductDTO> findById(Long productId) {
        return productRepository.findById(productId).map(ProductMapper::toDTO);
    }

    public List<OutboundProductDTO> findByCategory(Integer categoryId) {
        try {
            List<Product> productList = productRepository.findByCategoryCategoryId(categoryId);
            log.info("Fetched all products: {} products found.", productList.size());
            return productList.stream().map(ProductMapper::toDTO).collect(Collectors.toList());
        } catch (Exception e) {
            log.error("Error fetching products for category {}", categoryId, e);
            return new ArrayList<>();
        }
    }

    public List<OutboundProductDTO> findByNameLike(String keyword) {
        try {
            List<Product> productList = productRepository.searchByNameLike(keyword);
            return productList.stream().map(ProductMapper::toDTO).collect(Collectors.toList());
        } catch (Exception e) {
            log.error("Error fetching products", e);
            return new ArrayList<>();
        }
    }

    @Transactional
    public boolean create(InboundProductDTO productDTO) {
        if (productDTO == null) {
            log.warn("Product cannot be null");
            return false;
        }
        if (ValidationUtil.isNullOrBlank(productDTO.getProductName())) {
            log.warn("productName cannot be null");
            return false;
        }

        Category category = categoryRepository.findById(productDTO.getCategoryId())
                .orElse(null);

        if (category == null) {
            log.warn("Category not found");
            return false;
        }

        try {
            Product product = ProductMapper.toEntity(productDTO, category);
            productRepository.save(product);
            log.info("Product created: {}", product);
            return true;
        } catch (Exception e) {
            log.error("Error creating product", e);
            return false;
        }
    }

    @Transactional
    public boolean update(UpdateProductDTO productDTO) {
        if (productDTO == null || productDTO.getProductId() == null) {
            log.warn("Product or product ID cannot be null or empty");
            return false;
        }

        try {
            return productRepository.findById(productDTO.getProductId())
                    .map(existingProduct -> {
                        if (productDTO.getProductName() != null) {
                            existingProduct.setProductName(productDTO.getProductName());
                        }
                        productRepository.save(existingProduct);
                        log.info("Product with id {} updated successfully.", productDTO.getProductId());
                        return true;
                    })
                    .orElseGet(() -> {
                        log.warn("Product with id {} not found for update.", productDTO.getProductId());
                        return false;
                    });
        } catch (Exception e) {
            log.error("Error updating product with id {}", productDTO.getProductId(), e);
            return false;
        }
    }

    @Transactional
    public boolean delete(Long productId) {
        if (productId == null) {
            log.warn("ID cannot be null");
            return false;
        }

        try {
            return productRepository.findById(productId)
                    .map(product -> {
                        productRepository.delete(product);
                        log.info("Product with id {} successfully deleted", productId);
                        return true;
                    })
                    .orElseGet(() -> {
                        log.warn("Product with id {} not found. Deletion skipped.", productId);
                        return false;
                    });
        } catch (Exception e) {
            log.error("Error deleting product with id {}", productId, e);
            return false;
        }
    }
}
