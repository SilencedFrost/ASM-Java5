package com.repository;

import com.entity.Category;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository <Category, Integer> {

    List<Category> findByProductsIsNotEmpty();

    @EntityGraph(
            value = "category-with-products-and-details",
            type = EntityGraph.EntityGraphType.LOAD
    )
    @Query("SELECT c FROM Category c WHERE c.id = :id")
    Optional<Category> findByIdWithProductDetail(Integer id);

    @EntityGraph(
            value = "category-with-products-and-details",
            type = EntityGraph.EntityGraphType.LOAD
    )
    @Query("SELECT c FROM Category c WHERE SIZE(c.products) > 0")
    List<Category> findNonEmptyWithProductDetails();
}
