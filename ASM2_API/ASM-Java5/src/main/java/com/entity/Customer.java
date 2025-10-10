package com.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "customer")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "customer_id")
    private Long customerId;

    // TODO: Ánh xạ OneToOne với User
    // @OneToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "user_id", nullable = false, unique = true)
    // private User user;
}
