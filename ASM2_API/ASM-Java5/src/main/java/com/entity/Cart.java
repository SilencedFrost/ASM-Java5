package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;

@Getter
@Entity
@Table(
        name = "cart",
        schema = "public",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"user_id", "product_id"})
        })
@NoArgsConstructor
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cart_id", nullable = false)
    private Long cartId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variation_id", nullable = false)
    private Variation variation;

    @Setter
    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    @CreationTimestamp
    @Column(name = "date_added", nullable = false, columnDefinition = "timestamptz")
    private OffsetDateTime dateAdded;

    public void assignUser(User user) {
        if (this.user != null) {
            this.user.getCarts().remove(this);
        }

        this.user = user;
        if (user != null) {
            user.getCarts().add(this);
        }
    }

    public void assignProduct(Product product) {
        if (this.product != null) {
            this.product.getCarts().remove(this);
        }

        this.product = product;
        if (product != null) {
            product.getCarts().add(this);
        }
    }

    public void assignVariation(Variation variation) {
        if (this.variation != null) {
            this.variation.getCarts().remove(this);
        }

        this.variation = variation;
        if (variation != null) {
            variation.getCarts().add(this);
        }
    }
}