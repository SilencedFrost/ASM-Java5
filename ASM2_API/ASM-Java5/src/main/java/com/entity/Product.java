package com.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "product")
@Getter
@Setter
@NoArgsConstructor
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long productId;

    @Column(name = "product_name", nullable = false, length = 128)
    private String productName;

    @Column(name = "Price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @Column(name = "stock_count", nullable = false)
    private int stockQuantity;

    @Column(name = "is_active")
    private Boolean active;

    @Lob
    @Column(name = "description", nullable = false, columnDefinition = "text")
    private String productDescription;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "thumbnail_extension", length = 5)
    private String thumbnailExtension;

    @Column(name = "product_size", length = 32)
    private String productSize;

    @Column(name = "variation", length = 32)
    private String variation;

    @Column(name = "view_count")
    private int viewCount;

    @Column(name = "total_sales")
    private int totalSales;

    @CreationTimestamp
    @Column(name = "date_added", updatable = false)
    private OffsetDateTime creationDate;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private OffsetDateTime updateDate;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Cart> carts = new ArrayList<>();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();

    public void setCategory(Category category) {
        if (this.category != null) {
            this.category.getProducts().remove(this);
        }

        this.category = category;

        if (category != null) {
            category.getProducts().add(this);
        }
    }
}
