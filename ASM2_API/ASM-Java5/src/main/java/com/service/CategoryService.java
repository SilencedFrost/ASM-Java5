package com.service;

import com.dto.InboundCategoryDTO;
import com.dto.OutboundCategoryDTO;
import com.dto.UpdateCategoryDTO;
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

    public Page<OutboundCategoryDTO> findAll(Pageable pageable) {
        return categoryRepository.findAll(pageable).map(CategoryMapper::toDTO);
    }

    public List<OutboundCategoryDTO> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<OutboundCategoryDTO> findById(Integer categoryId) {
        return categoryRepository.findById(categoryId).map(CategoryMapper::toDTO);
    }

    public OutboundCategoryDTO create(InboundCategoryDTO categoryDTO) {
        Category saved = categoryRepository.save(CategoryMapper.toEntity(categoryDTO));
        log.info("Category created with ID {}", saved.getCategoryId());
        return CategoryMapper.toDTO(saved);
    }

    public OutboundCategoryDTO update(UpdateCategoryDTO categoryDTO) {
        Category category = categoryRepository.findById(categoryDTO.getCategoryId()).orElseThrow(() -> new EntityNotFoundException("Category not found with id " + categoryDTO.getCategoryId()));

        if (categoryDTO.getCategoryName() != null) category.setCategoryName(categoryDTO.getCategoryName());

        return CategoryMapper.toDTO(categoryRepository.save(category));
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
