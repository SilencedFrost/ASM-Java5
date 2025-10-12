package com.entity;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Entity
@Table(name = "address", schema = "public")
@NoArgsConstructor
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private long addressId;

    /*
    @Setter
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    */

    @Setter
    @Column(name = "address_line1", length = 64)
    private String addressLine1;

    @Setter
    @Column(name = "address_line2", length = 64)
    private String addressLine2;

    @Setter
    @Column(name = "city_id")
    private int cityId;

    @Setter
    @Column(name = "is_default")
    private boolean isDefault;
}