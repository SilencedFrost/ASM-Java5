package com.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UserFields implements Automatable {
    USER_ID("userId"),
    USERNAME("username"),
    EMAIL("email"),
    PASSWORD_HASH("passwordHash"),
    CREATION_DATE("creationDate"),
    ROLE_ID("roleId"),
    LAST_LOGIN("lastLoginDate");

    private final String propertyKey;
}
