package com.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Users")
@Getter
@Setter
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserId")
    private Long userId;

    @Column(name = "Username", nullable = false, length = 32, unique = true)
    private String username;

    @Column(name = "Email", nullable = false, length = 254, unique = true)
    private String email;

    @Column(name = "PasswordHash", nullable = false, length = 64)
    private String passwordHash;

    @Column(name = "CreationDate", nullable = false)
    private LocalDateTime creationDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RoleId", nullable = false)
    private Role role;

    @Column(name = "IsActive", nullable = false)
    private boolean active;

    @Column(name = "LastLoginDate")
    private LocalDateTime lastLoginDate;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Cart> carts = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();

    public void setRole(Role role) {
        if (this.role != null) {
            this.role.getUsers().remove(this);
        }

        this.role = role;

        if (role != null) {
            role.getUsers().add(this);
        }
    }

    @PrePersist
    protected void onCreate() {
        this.creationDate = LocalDateTime.now();
    }

    public User(String username, String email, String passwordHash, Role role, boolean active) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        setRole(role);
        this.active = active;
    }
}
