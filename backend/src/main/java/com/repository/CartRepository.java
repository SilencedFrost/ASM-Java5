package com.repository;

import com.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository <Cart, Long> {

    List<Cart> findByUserUserId(Long userId);

    Optional<Cart> findByUserUserIdAndVariationVariationId(Long userId, Long variationId);

    boolean existsByUserUserIdAndVariationVariationId(Long userId, Long variationId);

    void deleteByUserUserIdAndVariationVariationId(Long userId, Long variationId);

    long countByUserUserId(Long userId);
}
