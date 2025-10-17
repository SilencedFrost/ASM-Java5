package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Getter
@Entity
@Table(name = "seller", schema = "public")
@NoArgsConstructor
public class Seller {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seller_id", nullable = false)
    private long sellerId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Setter
    @Column(name = "shop_name", length = 64)
    private String shopName;

    @Setter
    @Column(name = "shop_description", columnDefinition = "text")
    private String shopDescription;

    @Setter
    @Column(name = "rating", precision = 3, scale = 2)
    private BigDecimal rating;

    @Setter
    @Column(name = "total_sales")
    private long totalSales;

    @OneToMany(mappedBy = "seller", orphanRemoval = true)
    private final List<Product> products = new ArrayList<>();
}