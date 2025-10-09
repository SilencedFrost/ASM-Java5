-- Drops

DROP TABLE IF EXISTS public.cart;
DROP TABLE IF EXISTS public.product;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.seller;
DROP TABLE IF EXISTS public.address;
DROP TABLE IF EXISTS public.admin;
DROP TABLE IF EXISTS public.customer;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.role;

-- Table: role

CREATE TABLE IF NOT EXISTS public.role
(
	role_id int NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    role_name varchar(32) NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (role_id)
);

ALTER TABLE IF EXISTS public.role
    OWNER to postgres;

INSERT INTO public.role (role_name) VALUES ('guest');
INSERT INTO public.role (role_name) VALUES ('customer');
INSERT INTO public.role (role_name) VALUES ('seller');
INSERT INTO public.role (role_name) VALUES ('admin');

-- Table: users

CREATE TABLE IF NOT EXISTS public.users
(
    user_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    email varchar(254) COMPRESSION lz4 COLLATE pg_catalog."default" UNIQUE,
	role_id int,
	username varchar(64),
	birthday date,
	password_hash varchar(64),
	is_active bit NOT NULL,
    creation_date timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_pk PRIMARY KEY (user_id),
	CONSTRAINT user_fk_role FOREIGN KEY (role_id) 
		REFERENCES public.role (role_id)
);

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;

-- Table: customer

CREATE TABLE IF NOT EXISTS public.customer
(
	customer_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    user_id bigint NOT NULL UNIQUE,
    CONSTRAINT customer_pk PRIMARY KEY (customer_id),
    CONSTRAINT customer_fk_user FOREIGN KEY (user_id)
        REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.customer
    OWNER to postgres;

-- Table: admin

CREATE TABLE IF NOT EXISTS public.admin
(
	admin_id int NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    user_id bigint NOT NULL UNIQUE,
    CONSTRAINT admin_pk PRIMARY KEY (admin_id),
    CONSTRAINT admin_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.admin
    OWNER to postgres;

-- Table: seller

CREATE TABLE IF NOT EXISTS public.seller
(
	seller_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    user_id bigint NOT NULL UNIQUE,
    CONSTRAINT seller_pk PRIMARY KEY (seller_id),
    CONSTRAINT seller_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.seller
    OWNER to postgres;

-- Table: address

CREATE TABLE IF NOT EXISTS public.address
(
	address_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    user_id bigint NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (address_id),
	CONSTRAINT address_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.address
    OWNER to postgres;

-- Table: category

CREATE TABLE IF NOT EXISTS public.category
(
	category_id int NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    category_name varchar(64) NOT NULL UNIQUE,
    CONSTRAINT category_pk PRIMARY KEY (category_id)
);

ALTER TABLE IF EXISTS public.category
    OWNER to postgres;

-- Table: product

CREATE TABLE IF NOT EXISTS public.product
(
	product_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    product_name character varying(128),
	parent_id bigint,
	seller_id bigint NOT NULL,
	category_id int NOT NULL,
	date_added timestamp DEFAULT CURRENT_TIMESTAMP,
	stock_count integer NOT NULL,
	product_size varchar(32),
	variation varchar(32),
	description text NOT NULL,
	price numeric(12,2) NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (product_id),
    CONSTRAINT product_fk_seller FOREIGN KEY (seller_id) 
        REFERENCES public.seller (seller_id),
	CONSTRAINT product_fk_category FOREIGN KEY (category_id) 
        REFERENCES public.category (category_id),
	CONSTRAINT product_parent_id FOREIGN KEY (parent_id)
		REFERENCES public.product (product_id)
);

ALTER TABLE IF EXISTS public.product
    OWNER to postgres;

-- Table: cart

CREATE TABLE IF NOT EXISTS public.cart
(
	user_id bigint NOT NULL,
	product_id bigint NOT NULL,
    quantity int NOT NULL,
	date_added timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cart_pk PRIMARY KEY (user_id, product_id),
    CONSTRAINT cart_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id),
	CONSTRAINT cart_fk_product FOREIGN KEY (product_id) 
        REFERENCES public.product (product_id),
	CONSTRAINT cart_quantity_positive CHECK (quantity > 0)
);

ALTER TABLE IF EXISTS public.cart
    OWNER to postgres;