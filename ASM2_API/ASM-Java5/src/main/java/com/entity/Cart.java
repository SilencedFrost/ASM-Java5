package com.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "Cart",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"UserId", "ProductId"})
        })
public class Cart {

    @Getter
    @EmbeddedId
    private CartPK id;

    @Getter
    @Setter
    @Column(name = "Quantity", nullable = false)
    private Integer quantity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserId", insertable = false, updatable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ProductId", insertable = false, updatable = false)
    private Product product;

    public void setUser(User user) {
        if (this.user != null) {
            this.user.getCarts().remove(this);
        }

        if (id == null) id = new CartPK();
        id.setUser(user);
        this.user = user;

        if (user != null) {
            user.getCarts().add(this);
        }
    }

    public void setProduct(Product product) {
        if (this.product != null) {
            this.product.getCarts().remove(this);
        }

        if (id == null) id = new CartPK();
        id.setProduct(product);
        this.product = product;

        if (product != null) {
            product.getCarts().add(this);
        }
    }

    public void setId(CartPK id) {
        if (this.id != null) {
            setUser(null);
            setProduct(null);
        }

        this.id = id;
        if (id != null) {
            setUser(id.getUser());
            setProduct(id.getProduct());
        }
    }
}