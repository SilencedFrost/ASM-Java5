package com.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

public class JsonUtil {
    private static final ObjectMapper mapper = new ObjectMapper().registerModule(new JavaTimeModule());

    public static void sendJsonResp(HttpServletResponse resp, Object object, int httpServletResponse) throws IOException {
        String json = mapper.writeValueAsString(object);
        resp.setContentType("application/json");
        resp.setStatus(httpServletResponse);
        resp.getWriter().write(json);
        resp.flushBuffer();
    }

    public static void sendJsonRedirect(HttpServletResponse resp, String targetUrl) throws IOException {
        resp.setContentType("application/json");
        resp.setStatus(HttpServletResponse.SC_SEE_OTHER);
        String json = mapper.writeValueAsString(Map.of("redirect", targetUrl));
        resp.getWriter().write(json);
        resp.flushBuffer();
    }

    public static String readJsonBody(HttpServletRequest request) throws IOException {
        StringBuilder json = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                json.append(line);
            }
        }

        if (json.isEmpty()) {
            return null;
        }

        String result = json.toString();
        return result.isBlank() ? null : result;
    }

    public static <T> T readJsonAs(HttpServletRequest request, Class<T> clazz) throws IOException {
        String body = readJsonBody(request);
        if (body == null) {
            return null;
        }
        return mapper.readValue(body, clazz);
    }

    public static <T> T readJsonAs(HttpServletRequest request, TypeReference<T> typeRef) throws IOException {
        String body = readJsonBody(request);
        if (body == null) {
            return null;
        }
        return mapper.readValue(body, typeRef);
    }

    public static Map<String, String> readJsonAsMap(HttpServletRequest request) throws IOException {
        Map<String, String> map = readJsonAs(request, new TypeReference<>() {});
        return map != null ? map : Map.of();
    }

}
