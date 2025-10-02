package com.dto;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutboundUserDTO implements UserDTO{
    private Long userId;
    private String username;
    private String email;
    private LocalDateTime creationDate;
    private String roleName;
    private boolean active;
    private LocalDateTime lastLoginDate;
}
