package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


import java.util.ArrayList;
import java.util.List;

@Getter
@Entity
@Table(name = "category", schema = "public")
@NoArgsConstructor
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
    private boolean isActive = true;

    @OneToMany(mappedBy = "category", orphanRemoval = true)
    private final List<Product> products = new ArrayList<>();
}

