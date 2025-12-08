package com.service;

import com.dto.category.CategoryCreateRequest;
import com.dto.category.CategoryResponse;
import com.dto.category.CategoryUpdateRequest;
import com.dto.category.CategoryWithProductResponse;
import com.entity.Category;
import com.exception.CategoryDeletionException;
import com.mapper.CategoryMapper;
import com.repository.CategoryRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class CategoryService {
    private final CategoryRepository categoryRepository;
    private final CategoryMapper categoryMapper;

    public Page<CategoryResponse> findAll(Pageable pageable) {
        return categoryRepository.findAll(pageable).map(categoryMapper::toDTO);
    }

    public List<CategoryResponse> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<CategoryResponse> findById(Integer categoryId) {
        return categoryRepository.findById(categoryId).map(categoryMapper::toDTO);
    }

    // Core methods that return entities/DTOs
    public List<CategoryWithProductResponse> findAllWithProduct() {
        return categoryRepository.findNonEmptyWithProductDetails()
                .stream()
                .map(categoryMapper::toDTOWithProduct)
                .toList();
    }

    public List<CategoryResponse> findNotEmpty() {
        return categoryRepository.findByProductsIsNotEmpty()
                .stream()
                .map(categoryMapper::toDTO)
                .toList();
    }

    public Optional<CategoryWithProductResponse> findByIdWithProduct(Integer categoryId) {
        return categoryRepository.findByIdWithProductDetail(categoryId)
                .map(categoryMapper::toDTOWithProduct);
    }

    // Filtered variations use helper methods
    public List<CategoryWithProductResponse> findAllWithActiveProduct() {
        return this.findAllWithProduct().stream()
                .map(this::filterToActiveProducts)
                .filter(this::hasProducts)
                .toList();
    }

    public Optional<CategoryWithProductResponse> findByIdWithActiveProduct(Integer categoryId) {
        return this.findByIdWithProduct(categoryId)
                .map(this::filterToActiveProducts)
                .filter(this::hasProducts);
    }

    private CategoryWithProductResponse filterToActiveProducts(CategoryWithProductResponse dto) {
        dto.productSummaryResponses().removeIf(product -> !product.isActive());
        return dto;
    }

    private boolean hasProducts(CategoryWithProductResponse dto) {
        return !dto.productSummaryResponses().isEmpty();
    }

    public CategoryResponse create(CategoryCreateRequest categoryCreateRequest) {
        Category saved = categoryRepository.save(categoryMapper.toEntity(categoryCreateRequest));
        log.info("Category created with ID {}", saved.getCategoryId());
        return categoryMapper.toDTO(saved);
    }

    public CategoryResponse update(CategoryUpdateRequest categoryUpdateRequest) {
        Category category = categoryRepository.findById(categoryUpdateRequest.categoryId()).orElseThrow(() -> new EntityNotFoundException("Category not found with id " + categoryUpdateRequest.categoryId()));

        if (categoryUpdateRequest.categoryName() != null) category.setCategoryName(categoryUpdateRequest.categoryName());

        return categoryMapper.toDTO(categoryRepository.save(category));
    }

    public void delete(Integer categoryId) {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() -> new EntityNotFoundException("Category not found with id " + categoryId));

        if(category.getProducts().isEmpty()) {
            categoryRepository.delete(category);
        }
        else {
            throw new CategoryDeletionException("Cannot delete category " + categoryId + " because it's still assigned to products");
        }
    }
}
