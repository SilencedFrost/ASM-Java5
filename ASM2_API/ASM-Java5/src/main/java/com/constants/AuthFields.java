package com.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum AuthFields implements Automatable {
    USERNAME_OR_EMAIL("usernameOrEmail"),
    USERNAME("username"),
    EMAIL("email"),
    PASSWORD("password");

    private final String propertyKey;
}
