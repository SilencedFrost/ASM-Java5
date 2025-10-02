package com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@WebFilter("/*")
public class VueFilter implements Filter {

    private ServletContext servletContext;

    @Override
    public void init(FilterConfig filterConfig) {
        this.servletContext = filterConfig.getServletContext();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 1. Skip API requests
        if (path.startsWith("/api/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Try to load requested static resource
        if (serveStatic(path, resp)) {
            return;
        }

        // 3. Otherwise, fallback to index.html (Vue Router history mode)
        serveStatic("/index.html", resp);
    }

    private boolean serveStatic(String path, HttpServletResponse resp) throws IOException {
        InputStream resource = servletContext.getResourceAsStream(path);

        if (resource == null) {
            return false;
        }

        // Guess MIME type
        String mime = servletContext.getMimeType(path);
        if (mime != null) {
            resp.setContentType(mime);
        }

        try (OutputStream out = resp.getOutputStream()) {
            resource.transferTo(out);
        }

        return true;
    }
}
