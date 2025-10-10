package com.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "address", schema = "public")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private long addressId;

    @Column(name = "user_id", nullable = false)
    private long userId;

    @Column(name = "address_line1", length = 64)
    private String addressLine1;

    @Column(name = "address_line2", length = 64)
    private String addressLine2;

    @Column(name = "city_id")
    private Integer cityId;

    @Column(name = "is_default")
    private Boolean isDefault;
}