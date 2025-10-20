package com.service;

import com.dto.product.ProductCreateRequest;
import com.dto.product.ProductResponse;
import com.dto.product.ProductSummaryResponse;
import com.dto.product.ProductUpdateRequest;
import com.entity.Category;
import com.entity.Product;
import com.exception.CategoryNotFoundException;
import com.mapper.ProductMapper;
import com.repository.CategoryRepository;
import com.repository.ProductRepository;
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
    private final ProductMapper productMapper;

    public Page<ProductResponse> findAll(Pageable pageable) {
        return productRepository.findAll(pageable).map(productMapper::toDTO);
    }

    public List<ProductResponse> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Page<ProductSummaryResponse> findAllSummary(Pageable pageable) {
        return productRepository.findAll(pageable).map(productMapper::toSummaryDTO);
    }

    public List<ProductSummaryResponse> findAllSummary() {
        return findAllSummary(PageRequest.of(0, 50)).getContent();
    }

    public Optional<ProductResponse> findById(Long productId) {
        return productRepository.findById(productId).map(productMapper::toDTO);
    }

    public List<ProductResponse> findByCategory(Integer categoryId) {
        try {
            List<Product> productList = productRepository.findByCategoryCategoryId(categoryId);
            log.info("Fetched all products: {} products found.", productList.size());
            return productList.stream().map(productMapper::toDTO).collect(Collectors.toList());
        } catch (Exception e) {
            log.error("Error fetching products for category {}", categoryId, e);
            return new ArrayList<>();
        }
    }

    public List<ProductSummaryResponse> findByNameLike(String keyword) {
            List<Product> productList = productRepository.findByProductNameContainsIgnoreCase(keyword);
            return productList.stream().map(productMapper::toSummaryDTO).collect(Collectors.toList());
    }

    public List<ProductSummaryResponse> findTop5Latest() {
        List<Product> productList = productRepository.findTop5ByOrderByCreationDateDesc();
        return productList.stream().map(productMapper::toSummaryDTO).collect(Collectors.toList());
    }

    public List<ProductSummaryResponse> findTop5BestSelling() {
        List<Product> productList = productRepository.findTop5ByOrderByTotalSalesDesc();
        return productList.stream().map(productMapper::toSummaryDTO).collect(Collectors.toList());
    }

    @Transactional
    public boolean create(ProductCreateRequest productCreateRequest) {
        Category category = categoryRepository.findById(productCreateRequest.categoryId())
                .orElseThrow(() -> new CategoryNotFoundException("Category not found"));

        try {
            Product product = productMapper.toEntity(productCreateRequest);
            product.assignCategory(category);
            productRepository.save(product);
            log.info("Product created: {}", product);
            return true;
        } catch (Exception e) {
            log.error("Error creating product", e);
            return false;
        }
    }

    @Transactional
    public boolean update(ProductUpdateRequest productUpdateRequest) {
        if (productUpdateRequest == null || productUpdateRequest.productId() == null) {
            log.warn("Product or product ID cannot be null or empty");
            return false;
        }

        try {
            return productRepository.findById(productUpdateRequest.productId())
                    .map(existingProduct -> {
                        if (productUpdateRequest.productName() != null) {
                            existingProduct.setProductName(productUpdateRequest.productName());
                        }
                        productRepository.save(existingProduct);
                        log.info("Product with id {} updated successfully.", productUpdateRequest.productId());
                        return true;
                    })
                    .orElseGet(() -> {
                        log.warn("Product with id {} not found for update.", productUpdateRequest.productId());
                        return false;
                    });
        } catch (Exception e) {
            log.error("Error updating product with id {}", productUpdateRequest.productId(), e);
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
