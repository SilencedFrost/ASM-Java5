package com.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
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
