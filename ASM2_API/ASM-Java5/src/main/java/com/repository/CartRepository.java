package com.repository;

import com.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository <Cart, Long> {

    List<Cart> findByUserUserId(Long userId);

    Optional<Cart> findByUserUserIdAndProductProductId(Long userId, Long productId);

    boolean existsByUserUserIdAndProductProductId(Long userId, Long productId);

    void deleteByUserUserIdAndProductProductId(Long userId, Long productId);

    long countByUserUserId(Long userId);
}
