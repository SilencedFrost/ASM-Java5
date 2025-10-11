package com.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;

@Entity
@Table(
        name = "cart",
        schema = "public",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"user_id", "product_id"})
        })
@NoArgsConstructor
@AllArgsConstructor
public class Cart {

    @Id
    @Getter
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cart_id", nullable = false)
    private Long cartId;

    /*
    @Getter
    @Setter
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;
    */

    @Getter
    @Setter
    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    @Getter
    @CreationTimestamp
    @Column(name = "date_added", nullable = false, columnDefinition = "timestamptz")
    private OffsetDateTime dateAdded;
}