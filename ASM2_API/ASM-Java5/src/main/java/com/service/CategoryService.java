package com.service;

import com.dto.category.*;
import com.entity.Category;
import com.exception.CategoryDeletionException;
import com.mapper.CategoryMapper;
import com.repository.CategoryRepository;
import jakarta.persistence.*;
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

    public CategoryResponse create(CategoryCreateRequest categoryCreateRequest) {
        Category saved = categoryRepository.save(categoryMapper.toEntity(categoryCreateRequest));
        log.info("Category created with ID {}", saved.getCategoryId());
        return categoryMapper.toDTO(saved);
    }

    public CategoryResponse update(CategoryUpdateRequest categoryUpdateRequest) {
        Category category = categoryRepository.findById(categoryUpdateRequest.categoryId()).orElseThrow(() -> new EntityNotFoundException("Category not found with id " + categoryUpdateRequest.getCategoryId()));

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
