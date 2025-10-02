package com.api;

import com.dto.OutboundProductDTO;
import com.service.ProductService;
import com.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;
import java.util.logging.Logger;

import static com.util.ServletUtil.getAction;

/* Endpoints:
/api/products -> return all products
/api/products/:id -> return product matching id
/api/products/search/:keyword return context-matched keyword
 */
@WebServlet("/api/products/*")
public class ProductAPI extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ProductAPI.class.getName());
    private static final ProductService productService = new ProductService();
    private static final String requestUrl = "/products";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = getAction(req);
        logger.info("Get request received");

        if(action.length() == requestUrl.length()) {
            JsonUtil.sendJsonResp(resp, productService.findAll(), HttpServletResponse.SC_OK);
        } else {
            List<String> actionPath = Arrays.stream(action.substring(requestUrl.length() + 1).split("/")).toList();

            switch (actionPath.size()) {
                case 1 -> {
                    try {
                        Integer productId = Integer.parseInt(actionPath.getFirst());
                        OutboundProductDTO productDTO = productService.findById(productId);
                        if(productDTO == null) {
                            JsonUtil.sendJsonResp(resp, Map.of("error", "Product not found"), HttpServletResponse.SC_NOT_FOUND);
                        } else {
                            JsonUtil.sendJsonResp(resp, productDTO, HttpServletResponse.SC_OK);
                        }
                    } catch (NumberFormatException e) {
                        JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
                    }
                }
                case 2 -> {
                    if(actionPath.getFirst().equals("search")) {
                        try {
                            String keyword = actionPath.get(1);
                            JsonUtil.sendJsonResp(resp, productService.findByNameLike(keyword), HttpServletResponse.SC_OK);
                        } catch (NumberFormatException e) {
                            JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
                        }
                    } else {
                        JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
                    }
                } default -> JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
}
