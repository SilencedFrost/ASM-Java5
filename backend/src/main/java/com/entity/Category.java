package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Getter
@Entity
@Table(name = "category", schema = "public")
@NoArgsConstructor
@NamedEntityGraph(
        name = "category-with-products-and-details",
        attributeNodes = {
                @NamedAttributeNode(value = "products", subgraph = "product-subgraph")
        },
        subgraphs = {
                @NamedSubgraph(
                        name = "product-subgraph",
                        attributeNodes = {
                                @NamedAttributeNode("seller"),
                                @NamedAttributeNode("variations")
                        }
                )
        }
)
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private int categoryId;

    @Setter
    @Column(name = "category_name", length = 64, nullable = false, unique = true)
    private String categoryName;

    @Setter
    @Column(name = "description", length = 256, nullable = false)
    private String description;

    @Setter
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @OneToMany(mappedBy = "category", orphanRemoval = true)
    private final Set<Product> products = new HashSet<>();
}

