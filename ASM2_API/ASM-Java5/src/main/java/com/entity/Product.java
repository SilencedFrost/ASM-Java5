package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "product", schema = "public")
@Getter
@NoArgsConstructor
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long productId;

    @Setter
    @Column(name = "product_name", nullable = false, length = 128)
    private String productName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "seller_id")
    private Seller seller;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @CreationTimestamp
    @Column(name = "date_added", updatable = false)
    private OffsetDateTime creationDate;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private OffsetDateTime updateDate;

    @Setter
    @Column(name = "thumbnail_extension", length = 5)
    private String thumbnailExtension;

    @Setter
    @Column(name = "description", nullable = false, columnDefinition = "text")
    private String description;

    @Setter
    @Column(name = "is_active")
    private Boolean isActive;

    @Setter
    @Column(name = "view_count")
    private Integer viewCount;

    @Setter
    @Column(name = "total_sales")
    private Integer totalSales;

    @OneToMany(mappedBy = "product", orphanRemoval = true)
    private final List<ProductVariation> productVariations = new ArrayList<>();

    @OneToMany(mappedBy = "product", orphanRemoval = true)
    private final List<Cart> carts = new ArrayList<>();

    public void assignCategory(Category category) {
        if(this.category != null) {
            this.category.getProducts().remove(this);
        }

        this.category = category;
        if(category != null) {
            category.getProducts().add(this);
        }
    }

    public void assignSeller(Seller seller) {
        if(this.seller != null) {
            this.seller.getProducts().remove(this);
        }

        this.seller = seller;
        if(seller != null) {
            seller.getProducts().add(this);
        }
    }
}
