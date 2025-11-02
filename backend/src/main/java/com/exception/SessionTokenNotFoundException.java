package com.exception;

public class SessionTokenNotFoundException extends RuntimeException {
    public SessionTokenNotFoundException(String message) {
        super(message);
    }
}
