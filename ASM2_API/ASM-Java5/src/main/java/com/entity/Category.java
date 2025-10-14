package com.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "category", schema = "public")
@Getter
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
    @Column(name = "description", length = 256)
    private String description;

    @Setter
    @Column(name = "is_active")
    private Boolean isActive;

//    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, orphanRemoval = false)
//    private List<Product> products = new ArrayList<>();

    public Category(String categoryName) {
        this.categoryName = categoryName;
    }
}

