package com.entity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.OffsetDateTime;

    @Getter
    @Setter
    @Entity
    @Table(name = "session", schema = "public")
    public class Session {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
//        @Column(name = "session_id", nullable = false)
//        private long sessionId;
//
//        @Column(name = "user_id", nullable = false)
//           private long userId;  // Tham chiếu tới role(role_id) theo script (không chỉnh)

        @Column(name = "session_hash", length = 64)
        private String sessionHash;

        @Column(name = "last_login", nullable = false)
        private OffsetDateTime lastLogin;
    }


