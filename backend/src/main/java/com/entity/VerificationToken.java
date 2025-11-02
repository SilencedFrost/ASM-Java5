package com.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;

@Getter
@Entity
@NoArgsConstructor
@Table(name = "verification_token")
public class VerificationToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "verification_token_id")
    private Long verificationTokenId;

    @Setter
    @Column(name= "verification_token_hash", nullable = false, unique = true)
    private String tokenHash;

    @Setter
    @OneToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, name = "user_id")
    private User user;

    @CreationTimestamp
    @Column(nullable = false, name = "creation_date")
    private OffsetDateTime creationDate;
}
