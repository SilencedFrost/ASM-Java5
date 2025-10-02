package com.dto;

import lombok.*;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InboundUserDTO implements UserDTO{
    protected String username;
    protected String email;
    protected String passwordHash;
    protected String roleName;
    protected boolean active;
}
