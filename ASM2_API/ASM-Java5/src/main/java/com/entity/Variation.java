package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
        name = "product_variation",
        schema = "public",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "unique_product_size_variation",
                        columnNames = {"product_id", "product_size", "variation"}
                )
        }
)
@Getter
@NoArgsConstructor
public class Variation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "variation_id")
    private Long variationId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @CreationTimestamp
    @Column(name = "date_added", nullable = false, updatable = false)
    private OffsetDateTime dateAdded;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;

    @Setter
    @Column(name = "image_extension", length = 5)
    private String imageExtension;

    @Setter
    @Column(name = "product_size", length = 32, nullable = false)
    private String productSize;

    @Setter
    @Column(name = "variation", length = 32, nullable = false)
    private String variation;

    @Setter
    @Column(name = "price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @OneToMany(mappedBy = "variation", orphanRemoval = true)
    private final List<Cart> carts = new ArrayList<>();

    public void assignProduct(Product product) {
        if (this.product != null) {
            this.product.getVariations().remove(this);
        }

        this.product = product;
        if (product != null) {
            product.getVariations().add(this);
        }
    }
}
