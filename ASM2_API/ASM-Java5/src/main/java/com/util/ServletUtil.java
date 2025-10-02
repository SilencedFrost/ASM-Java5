package com.util;

import jakarta.servlet.http.HttpServletRequest;

import java.util.logging.Logger;

public class ServletUtil {
    private static final Logger logger = Logger.getLogger(ServletUtil.class.getName());

    public static String getAction(HttpServletRequest req) {
        return req.getRequestURI().substring(req.getContextPath().length() + "/api".length());
    }
}
