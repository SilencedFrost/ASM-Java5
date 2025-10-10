package com.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "role", schema = "public")
@Getter
@Setter
@NoArgsConstructor
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id", nullable = false)
    private int roleId;

    @Column(name = "role_name", nullable = false, length = 32)
    private String roleName;

//    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL)
//    private List<User> users = new ArrayList<>();
//
//    public Role(String roleName) {
//        this.roleName = roleName;
//    }
}
