package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.ArrayList;
import java.util.List;

@Getter
@Entity
@Table(name = "role", schema = "public")
@NoArgsConstructor
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id", nullable = false)
    private int roleId;

    @Setter
    @Column(name = "role_name", nullable = false, length = 32)
    private String roleName;

    @Setter
    @OneToMany(mappedBy = "role")
    private List<User> users = new ArrayList<>();
}