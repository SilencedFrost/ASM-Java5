package com.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "email", length = 254, unique = true)
    private String email;

    // TODO: Ánh xạ ManyToOne với Role
    // @ManyToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "role_id")
    // private Role role;

    @Column(name = "username", length = 64)
    private String username;

    @Column(name = "first_name", length = 32)
    private String firstName;

    @Column(name = "last_name", length = 32)
    private String lastName;

    @Column(name = "birthday")
    private LocalDate birthday;

    @Column(name = "password_hash", length = 60)
    private String passwordHash;

    @Column(name = "is_active", nullable = false)
    private boolean active;

    @Column(name = "phone_number", length = 15)
    private String phoneNumber;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "creation_date")
    private LocalDateTime creationDate;

    // TODO: Ánh xạ OneToMany với Cart
    // @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    // private List<Cart> carts = new ArrayList<>();

    // TODO: Ánh xạ OneToMany với Comment
    // @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    // private List<Comment> comments = new ArrayList<>();
}
