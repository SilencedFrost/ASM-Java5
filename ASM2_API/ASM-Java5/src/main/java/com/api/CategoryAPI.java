package com.api;

import static com.util.ServletUtil.*;

import com.constants.CategoryFields;
import com.dto.CategoryDTO;
import com.dto.OutboundCategoryDTO;
import com.service.CategoryService;
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

/* Endpoints:
/api/categories -> return all categories
/api/categories/:id -> return category matching id
/api/categories/products return all categories along with products
/api/categories/:id/products return category matching id along with products
 */
@WebServlet("/api/categories/*")
public class CategoryAPI extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CategoryAPI.class.getName());
    private static final CategoryService categoryService = new CategoryService();
    private static final ProductService productService = new ProductService();
    private static final String requestUrl = "/categories";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = getAction(req);
        logger.info("Get request received");

        if(action.length() == requestUrl.length()) {
            JsonUtil.sendJsonResp(resp, categoryService.findAll(), HttpServletResponse.SC_OK);
        } else {
            List<String> actionPath = Arrays.stream(action.substring(requestUrl.length() + 1).split("/")).toList();

            switch (actionPath.size()) {
                case 1 -> {
                    if(actionPath.getFirst().equals("products")) {
                        List<OutboundCategoryDTO> categoryList = categoryService.findAll();
                        List<Map<String, Object>> dataList = new ArrayList<>();
                        for(OutboundCategoryDTO categoryDTO : categoryList) {
                            Map<String, Object> dataMap = new HashMap<>();
                            dataMap.put(CategoryFields.CATEGORY_ID.getPropertyKey(), categoryDTO.getCategoryId());
                            dataMap.put(CategoryFields.CATEGORY_NAME.getPropertyKey(), categoryDTO.getCategoryName());
                            dataMap.put(CategoryFields.PRODUCT_COUNT.getPropertyKey(), categoryDTO.getProductCount());
                            dataMap.put("products", productService.findByCategory(categoryDTO.getCategoryId()));
                            dataList.add(dataMap);
                        }
                        JsonUtil.sendJsonResp(resp, dataList, HttpServletResponse.SC_OK);
                    } else {
                        try {
                            Integer categoryId = Integer.parseInt(actionPath.getFirst());
                            CategoryDTO categoryDTO = categoryService.findById(categoryId);
                            if(categoryDTO == null) {
                                JsonUtil.sendJsonResp(resp, new OutboundCategoryDTO(), HttpServletResponse.SC_NOT_FOUND);
                            } else {
                                JsonUtil.sendJsonResp(resp, categoryDTO, HttpServletResponse.SC_OK);
                            }
                        } catch (NumberFormatException e) {
                            JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
                        }
                    }
                }
                case 2 -> {
                    if(actionPath.get(1).equals("products")) {
                        try {
                            Integer categoryId = Integer.parseInt(actionPath.getFirst());
                            OutboundCategoryDTO categoryDTO = categoryService.findById(categoryId);
                            if(categoryDTO == null) {
                                JsonUtil.sendJsonResp(resp, new OutboundCategoryDTO(), HttpServletResponse.SC_NOT_FOUND);
                            } else {
                                Map<String, Object> dataMap = new HashMap<>();
                                dataMap.put(CategoryFields.CATEGORY_ID.getPropertyKey(), categoryDTO.getCategoryId());
                                dataMap.put(CategoryFields.CATEGORY_NAME.getPropertyKey(), categoryDTO.getCategoryName());
                                dataMap.put(CategoryFields.PRODUCT_COUNT.getPropertyKey(), categoryDTO.getProductCount());
                                dataMap.put("products", productService.findByCategory(categoryDTO.getCategoryId()));
                                JsonUtil.sendJsonResp(resp, dataMap, HttpServletResponse.SC_OK);
                            }
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
