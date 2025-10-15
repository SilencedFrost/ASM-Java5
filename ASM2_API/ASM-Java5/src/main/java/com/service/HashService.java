package com.service;

import at.favre.lib.crypto.bcrypt.BCrypt;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.stereotype.Service;

@Service
public final class HashService {

    /**
     * @param password plaintext password
     * @return hashed password (includes salt internally)
     */
    public String hashPassword(String password) {
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }

    /**
     * @param password plaintext password
     * @param hashed stored BCrypt hash
     * @return true if matches, false otherwise
     */
    public boolean verifyPassword(String password, String hashed) {
        return BCrypt.verifyer()
                .verify(password.toCharArray(), hashed)
                .verified;
    }

    /**
     * @param input the string to hash
     * @return SHA-256 hex string
     */
    public String hashOpaqueKey(String input) {
        return DigestUtils.sha256Hex(input);
    }

    /**
     * @param rawKey the un-hashed key (e.g. from cookie)
     * @param hashedKey the stored hash (from database)
     * @return true if they match, false otherwise
     */
    public boolean verifyOpaqueKey(String rawKey, String hashedKey) {
        return hashOpaqueKey(rawKey).equals(hashedKey);
    }
}

