package com.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "admin")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Admin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "admin_id")
    private Integer adminId;

    // TODO: Ánh xạ OneToOne với User
    // @OneToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "user_id", nullable = false, unique = true)
    // private User user;
}
