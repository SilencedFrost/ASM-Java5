package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;

@Getter
@Entity
@Table(name = "session", schema = "public")
@NoArgsConstructor
public class Session {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "session_id")
    private long sessionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Setter
    @Column(name = "session_hash", nullable = false, length = 64, columnDefinition = "char(64)")
    private String sessionHash;

    @Setter
    @Column(name = "last_accessed", nullable = false)
    private OffsetDateTime lastAccessed;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    @Setter
    @Column(name = "expires_at", nullable = false)
    private OffsetDateTime expiresAt;

    @Setter
    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;

    @Setter
    @Column(name = "revoked_at")
    private OffsetDateTime revokedAt;

    @Setter
    @Column(name = "revoke_reason", length = 128)
    private String revokeReason;

    @Setter
    @Column(name = "user_agent", nullable = false, columnDefinition = "text")
    private String userAgent;
}