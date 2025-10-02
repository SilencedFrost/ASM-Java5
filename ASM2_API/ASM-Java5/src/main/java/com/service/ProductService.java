package com.service;

import com.dto.OutboundProductDTO;
import com.dto.ProductDTO;
import com.dto.InboundProductDTO;
import com.dto.UpdateProductDTO;
import com.entity.Category;
import com.entity.Product;
import com.entity.Role;
import com.mapper.ProductMapper;
import com.util.EntityManagerUtil;
import com.util.ValidationUtil;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductService implements Service<ProductDTO, Integer> {
    private static final Logger logger = Logger.getLogger(ProductService.class.getName());

    @Override
    public List<OutboundProductDTO> findAll() {
        List<Product> productList;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            productList = em.createQuery("select p from Product p", Product.class).getResultList();
            logger.info("Fetched all products: " + productList.size() + " products found.");
            return ProductMapper.toDTOList(productList);
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error fetching products", e);
            return List.of();
        }
    }

    @Override
    public OutboundProductDTO findById(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("ID cannot be null or empty");
        }

        Product product = null;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            product = em.find(Product.class, productId);
            logger.info("Product with id " + productId + (product != null ? " found." : " not found."));
            return product != null ? ProductMapper.toDTO(product) : null;
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error finding product by ID", e);
            return null;
        }
    }

    public List<OutboundProductDTO> findByCategory(Integer categoryId) {
        List<Product> productList;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            productList = em.createQuery("SELECT p FROM Product p WHERE p.category.categoryId = :categoryId", Product.class).setParameter("categoryId", categoryId).getResultList();
            logger.info("Fetched all products: " + productList.size() + " products found.");
            return ProductMapper.toDTOList(productList);
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error fetching products", e);
            return new ArrayList<>();
        }
    }

    public List<OutboundProductDTO> findByNameLike(String keyword) {
        List<Product> productList;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            productList = em.createQuery("select p from Product p where lower(p.productName) like lower(:keyword)", Product.class).setParameter("keyword", "%" + keyword + "%").getResultList();
            logger.info("Fetched all products: " + productList.size() + " products found.");
            return ProductMapper.toDTOList(productList);
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error fetching products", e);
            return new ArrayList<>();
        }
    }

    // Manual creation method
    public boolean create(String productName, BigDecimal price, Integer stockQuantity, String ImageUrl, boolean active, String productDescription, Integer categoryId, String specifications) {
        return create(new InboundProductDTO(productName, price, stockQuantity, ImageUrl, active, productDescription, categoryId, specifications));
    }

    @Override
    public boolean create(ProductDTO productDTO) {
        if (!(productDTO instanceof InboundProductDTO)) {
            logger.warning("Create requires InboundProductDTO for security reasons");
            return false;
        }
        return create((InboundProductDTO) productDTO);
    }

    // Object creation method
    public boolean create(InboundProductDTO productDTO) {
        if(productDTO == null) {
            logger.warning("Product cannot be null");
            return false;
        }
        if(ValidationUtil.isNullOrBlank(productDTO.getProductName())) {
            logger.warning("productName cannot be null");
            return false;
        }

        try (EntityManager em = EntityManagerUtil.getEntityManager()) {

            Category category = em.find(Category.class, productDTO.getCategoryId());
            if(category == null) {
                logger.warning("Category not found");
                return false;
            }
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                Product product = ProductMapper.toEntity(productDTO, category);
                em.persist(product);
                tx.commit();
                logger.info("Product created: " + product);
                return true;
            } catch (PersistenceException e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error creating product", e);
                return false;
            }
        }
    }

    @Override
    public boolean update(ProductDTO productDTO) {
        if (!(productDTO instanceof UpdateProductDTO)) {
            logger.warning("Update requires UpdateProductDTO for security reasons");
            return false;
        }
        return update((UpdateProductDTO) productDTO);
    }

    public boolean update(UpdateProductDTO productDTO) {
        if (productDTO == null || productDTO.getProductId() == null) {
            logger.warning("Product or product ID cannot be null or empty");
            return false;
        }

        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            try {
                Product existingProduct = em.find(Product.class, productDTO.getProductId());
                if (existingProduct != null) {
                    tx.begin();
                    if (productDTO.getProductName() != null) existingProduct.setProductName(productDTO.getProductName());
                    tx.commit();
                    logger.info("Product with id " + productDTO.getProductId() + " updated successfully.");
                    return true;
                } else {
                    logger.warning("Product with id " + productDTO.getProductId() + " not found for update.");
                    return false;
                }
            } catch (Exception e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error updating product", e);
                return false;
            }
        }
    }

    @Override
    public boolean delete(Integer productId) {
        if (productId == null) {
            logger.warning("ID cannot be null");
            return false;
        }

        try(EntityManager em = EntityManagerUtil.getEntityManager()) {
            EntityTransaction tx = em.getTransaction();

            try {
                tx.begin();

                Product product = em.find(Product.class, productId);
                if (product == null) {
                    logger.warning("Product with id " + productId + " not found. Deletion skipped.");
                    tx.rollback();
                    return false;
                }

                Query countQuery = em.createQuery("select count(u) from User u where u.productId = :productId");
                countQuery.setParameter("productId", productId);
                Long userCount = (Long) countQuery.getSingleResult();

                if (userCount > 0) {
                    logger.warning("Cannot delete product " + productId + " - still assigned to " + userCount + " users");
                    tx.rollback();
                    return false;
                }

                //git  Safe to delete
                em.remove(product);
                tx.commit();
                logger.info("Product with id " + productId + " successfully deleted");
                return true;

            } catch (Exception e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error deleting product with id " + productId, e);
                return false;
            }
        }
    }

    public static Product findByProductName(EntityManager em, String productName) {
        if (ValidationUtil.isNullOrBlank(productName)) {
            return null;
        }

        try {
            TypedQuery<Product> query = em.createQuery(
                    "SELECT r FROM Product r WHERE r.productName = :productName",
                    Product.class
            );
            query.setParameter("productName", productName);

            List<Product> products = query.getResultList();
            Product product = products.isEmpty() ? null : products.getFirst();

            logger.info("Product with name '" + productName + "'" + (product != null ? " found." : " not found."));

            return product;
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error finding product by name: " + productName, e);
            return null;
        }
    }
}
