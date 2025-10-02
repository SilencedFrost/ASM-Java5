package com.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InboundUserDTO implements UserDTO{
    protected String username;
    protected String email;
    protected String passwordHash;
    protected String roleName;
    protected boolean active;
}
