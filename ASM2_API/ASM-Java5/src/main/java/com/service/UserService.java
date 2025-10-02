package com.service;

import com.dto.InboundUserDTO;
import com.dto.OutboundUserDTO;
import com.dto.UpdateUserDTO;
import com.dto.UserDTO;
import com.entity.Role;
import com.entity.User;
import com.mapper.UserMapper;
import com.security.PasswordHasher;
import com.util.EntityManagerUtil;
import com.util.ValidationUtil;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService implements Service<UserDTO, Long>{
    private static final Logger logger = Logger.getLogger(UserService.class.getName());

    @Override
    public List<UserDTO> findAll() {
        List<User> userList;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            userList = em.createQuery("SELECT u FROM User u", User.class).getResultList();
            logger.info("Fetched all users: " + userList.size() + " users found.");
            return UserMapper.toDTOList(userList);
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error fetching users", e);
            return List.of();
        }
    }

    @Override
    public UserDTO findById(Long userId) {
        if (userId == null) {
            logger.warning("userId cannot be null");
            return null;
        }
        User user;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            user = em.find(User.class, userId);
            logger.info("User with id " + userId + (user != null ? " found." : " not found."));
            return user != null ? UserMapper.toDTO(user) : null;
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error finding user by ID", e);
            return null;
        }
    }

    public UserDTO findByEmail(String email) {
        if (ValidationUtil.isNullOrBlank(email)) {
            throw new IllegalArgumentException("email cannot be null or empty");
        }

        User user;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            user = em.createQuery("SELECT u FROM User u WHERE LOWER(u.email) = LOWER(:email)", User.class).setParameter("email", email).getSingleResult();
            logger.info("User with email " + email + (user != null ? " found." : " not found."));
            return user != null ? UserMapper.toDTO(user) : null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error finding user by email", e);
            return null;
        }
    }

    public UserDTO findByUsername(String username) {
        if (ValidationUtil.isNullOrBlank(username)) {
            throw new IllegalArgumentException("username cannot be null or empty");
        }

        User user;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            user = em.createQuery("SELECT u FROM User u WHERE LOWER(u.username) = LOWER(:username)", User.class).setParameter("username", username).getSingleResult();
            logger.info("User with username " + username + (user != null ? " found." : " not found."));
            return user != null ? UserMapper.toDTO(user) : null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error finding user by username", e);
            return null;
        }
    }

    public OutboundUserDTO findByUsernameOrEmail(String usernameOrEmail) {
        if(ValidationUtil.isNullOrBlank(usernameOrEmail)) {
            logger.warning("Username or Email is null, aborting search");
            return null;
        }
        User user;
        try(EntityManager em = EntityManagerUtil.getEntityManager()) {
            user = em.createQuery("SELECT u FROM User u WHERE LOWER(u.username) = LOWER(:value) OR LOWER(u.email) = LOWER(:value)", User.class).setParameter("value", usernameOrEmail).getSingleResult();
            return UserMapper.toDTO(user);
        } catch (PersistenceException e) {
            logger.log(Level.SEVERE, "Error fetching users", e);
            return null;
        }
    }

    public boolean validateUser(String password, Long userId) {
        if(ValidationUtil.isNullOrBlank(password)) {
            logger.warning("Warning is null, aborting validation");
            return false;
        }
        if (userId == null) {
            logger.warning("ID is null, aborting validation");
            return false;
        }

        User user = null;
        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            user = em.find(User.class, userId);
            logger.info("User with id " + userId + (user != null ? " found." : " not found."));
        } catch (NoResultException e) {
            logger.log(Level.SEVERE, "Error finding user by ID", e);
        }
        if(user != null) {
            return PasswordHasher.verify(password, user.getPasswordHash());
        } else {
            return false;
        }
    }

    // Manual creation method
    public boolean create(String username, String email, String passwordHash, String roleName, boolean active) {
        return create(new InboundUserDTO(username, email, passwordHash, roleName, active));
    }

    @Override
    public boolean create(UserDTO userDTO) {
        if (!(userDTO instanceof InboundUserDTO)) {
            logger.warning("Create requires InboundUserDTO for security reasons");
            return false;
        }
        return create((InboundUserDTO) userDTO);
    }

    // Object creation method
    public boolean create(InboundUserDTO userDTO) {
        if (userDTO == null) {
            throw new IllegalArgumentException("User cannot be null");
        }

        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            Role role = RoleService.findByRoleName(em, userDTO.getRoleName());
            if(role == null) {
                logger.warning("Role not found");
                return false;
            }
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                User user = UserMapper.toEntity(userDTO, role);
                user.setRole(role);
                em.persist(user);
                tx.commit();
                logger.info("User created: " + user);
                return true;
            } catch (PersistenceException e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error creating user", e);
                return false;
            }
        }
    }

    @Override
    public boolean update(UserDTO userDTO) {
        if (!(userDTO instanceof UpdateUserDTO)) {
            logger.warning("Update requires UpdateUserDTO for security reasons");
            return false;
        }
        return update((UpdateUserDTO) userDTO);
    }

    public boolean update(Long userId, String username, String email, String passwordHash, String roleName, boolean active) {
        return update(new UpdateUserDTO(userId, username, email, passwordHash, roleName, active));
    }

    public boolean updateLoginDate(Long userId) {
        if(userId == null) {
            logger.warning("User Id is null, aborting update");
            return false;
        }

        try(EntityManager em = EntityManagerUtil.getEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            try{

                tx.begin();
                User user = em.find(User.class, userId);
                if(user != null) {
                    logger.info("updating last login date for user " + user.getUserId());
                    user.setLastLoginDate(LocalDateTime.now());
                }
                tx.commit();
                return true;
            } catch (PersistenceException e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error updating user login date", e);
                return false;
            }
        }
    }

    // Object update method
    public boolean update(UpdateUserDTO userDTO) {
        if (userDTO == null || userDTO.getUserId() == null) {
            logger.warning("User or User ID cannot be null or empty");
            return false;
        }

        try (EntityManager em = EntityManagerUtil.getEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            try {
                User existingUser = em.find(User.class, userDTO.getUserId());
                if (existingUser != null) {
                    tx.begin();
                    if(!ValidationUtil.isNullOrBlank(userDTO.getUsername())) existingUser.setUsername(userDTO.getUsername());
                    if(!ValidationUtil.isNullOrBlank(userDTO.getPasswordHash())) existingUser.setPasswordHash(userDTO.getPasswordHash());
                    if(!ValidationUtil.isNullOrBlank(userDTO.getEmail()) || ValidationUtil.isValidEmail(userDTO.getEmail())) existingUser.setEmail(userDTO.getEmail());
                    if(!ValidationUtil.isNullOrBlank(userDTO.getRoleName())) {
                        Role role = RoleService.findByRoleName(em, userDTO.getRoleName());
                        if (role == null) role = em.find(Role.class, 1);
                        existingUser.setRole(role);
                    }
                    tx.commit();
                    logger.info("User with id " + userDTO.getUserId() + " updated successfully.");
                    return true;
                } else {
                    logger.warning("User with id " + userDTO.getUserId() + " not found for update.");
                    return false;
                }
            } catch (Exception e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error updating user", e);
                return false;
            }
        }
    }

    //Manual delete method
    @Override
    public boolean delete(Long userId) {
        if (userId == null) {
            logger.warning("ID cannot be null");
            return false;
        }
        try(EntityManager em = EntityManagerUtil.getEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            User user = em.find(User.class, userId);
            if (user == null) {
                logger.warning("User with id " + userId + " not found. Deletion skipped.");
                return false;
            }

            try {
                tx.begin();
                em.remove(user);
                user.setRole(null);
                tx.commit();
                return true;
            } catch (Exception e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                logger.log(Level.SEVERE, "Error deleting user with id " + userId, e);
                return false;
            }
        }
    }
}
