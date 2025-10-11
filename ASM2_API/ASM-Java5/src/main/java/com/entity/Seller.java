package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Table(name = "seller", schema = "public")
public class Seller {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seller_id", nullable = false)
    private long sellerId;
//
//    @Column(name = "user_id", nullable = false, unique = true)
//    private long userId;

    @Column(name = "shop_name", length = 64)
    private String shopName;

    @Column(name = "shop_description", columnDefinition = "text")
    private String shopDescription;

    @Column(name = "rating", precision = 3, scale = 2)
    private BigDecimal rating;

    @Column(name = "total_sales")
    private long totalSales;

    @Column(name = "verification_status")
    private Boolean verificationStatus;
}