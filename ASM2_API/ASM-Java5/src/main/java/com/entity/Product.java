package com.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "product", schema = "public")
@Getter
@NoArgsConstructor

<<<<<<< HEAD
=======

>>>>>>> 7b71dfe (feat: add mapper and repo cart category product #61)
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long productId;

    @Setter
    @Column(name = "product_name", nullable = false, length = 128)
    private String productName;

    @Setter
    @Column(name = "price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @Setter
    @Column(name = "stock_count", nullable = false)
    private int stockCount;

    @Setter
    @Column(name = "is_active")
    private Boolean isActive;

    @Setter
    @Column(name = "description", nullable = false, columnDefinition = "text")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Product parentProduct;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "seller_id")
    private Seller seller;

    @Setter
    @Column(name = "thumbnail_extension", length = 5)
    private String thumbnailExtension;

    @Setter
    @Column(name = "product_size", length = 32)
    private String productSize;

    @Setter
    @Column(name = "variation", length = 32)
    private String variation;

    @Setter
    @Column(name = "view_count")
    private int viewCount;

    @Setter
    @Column(name = "total_sales")
    private int totalSales;

    @CreationTimestamp
    @Column(name = "date_added", updatable = false)
    private OffsetDateTime creationDate;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private OffsetDateTime updateDate;

//    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Cart> carts = new ArrayList<>();
//
//    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Comment> comments = new ArrayList<>();

//    public void setCategory(Category category) {
//        if (this.category != null) {
//            this.category.getProducts().remove(this);
//        }
//
//        this.category = category;
//
//        if (category != null) {
//            category.getProducts().add(this);
//        }
//    }
}
