-- Drops

DROP TABLE IF EXISTS public.order_item;
DROP TABLE IF EXISTS public.order;
DROP TABLE IF EXISTS public.order_status;

DROP TABLE IF EXISTS public.verification_token;

DROP TABLE IF EXISTS public.cart;

DROP TABLE IF EXISTS public.product_variation;
DROP TABLE IF EXISTS public.product;
DROP TABLE IF EXISTS public.category;

DROP TABLE IF EXISTS public.address;
DROP TABLE IF EXISTS public.city;

DROP TABLE IF EXISTS public.customer;
DROP TABLE IF EXISTS public.seller;
DROP TABLE IF EXISTS public.admin;

DROP TABLE IF EXISTS public.session;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.role;

-- Table: role

CREATE TABLE IF NOT EXISTS public.role
(
	role_id int,
    role_name varchar(32) NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (role_id)
);

ALTER TABLE IF EXISTS public.role
    OWNER to postgres;

-- Table: users

CREATE TABLE IF NOT EXISTS public.users
(
    user_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    email varchar(254) NOT NULL UNIQUE,
	role_id int,
	username varchar(64),
	first_name varchar(32),
	last_name varchar(32),
	birthday date,
	password_hash char(60) NOT NULL,
	is_active boolean NOT NULL,
	phone_number varchar(15),
	updated_at timestamptz,
    creation_date timestamptz NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (user_id),
	CONSTRAINT user_fk_role FOREIGN KEY (role_id) 
		REFERENCES public.role (role_id)
);

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;

-- Table: session

CREATE TABLE IF NOT EXISTS public.session
(
    session_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    user_id bigint NOT NULL,
	session_hash char(64) NOT NULL,
	last_accessed timestamptz NOT NULL,
	created_at timestamptz NOT NULL,
	expires_at timestamptz NOT NULL,
	is_active boolean NOT NULL,
	revoked_at timestamptz,
	revoke_reason varchar(128),
	user_agent text NOT NULL,
    CONSTRAINT session_pk PRIMARY KEY (session_id),
	CONSTRAINT session_fk_user FOREIGN KEY (user_id) 
		REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.session
    OWNER to postgres;

-- Table: admin

CREATE TABLE IF NOT EXISTS public.admin
(
	admin_id int GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
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
	seller_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    user_id bigint NOT NULL UNIQUE,
	shop_name varchar(64) NOT NULL,
	shop_description text,
	rating decimal(3,2) CHECK (rating >= 0 AND rating <= 5),
	total_sales bigint,
    CONSTRAINT seller_pk PRIMARY KEY (seller_id),
    CONSTRAINT seller_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.seller
    OWNER to postgres;

-- Table: customer

CREATE TABLE IF NOT EXISTS public.customer
(
	customer_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    user_id bigint NOT NULL UNIQUE,
    CONSTRAINT customer_pk PRIMARY KEY (customer_id),
    CONSTRAINT customer_fk_user FOREIGN KEY (user_id)
        REFERENCES public.users (user_id)
);

ALTER TABLE IF EXISTS public.customer
    OWNER to postgres;

-- Table: city

CREATE TABLE IF NOT EXISTS public.city
(
	city_id int GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    city_name varchar(64) NOT NULL,
    CONSTRAINT city_pk PRIMARY KEY (city_id)
);

ALTER TABLE IF EXISTS public.city
    OWNER to postgres;

-- Table: address

CREATE TABLE IF NOT EXISTS public.address
(
	address_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    user_id bigint NOT NULL,
	address_line1 varchar(64),
	address_line2 varchar(64),
	city_id int NOT NULL,
	is_default boolean NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (address_id),
	CONSTRAINT address_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id),
	CONSTRAINT address_fk_city FOREIGN KEY (city_id) 
        REFERENCES public.city (city_id)
);

ALTER TABLE IF EXISTS public.address
    OWNER to postgres;

-- Table: category

CREATE TABLE IF NOT EXISTS public.category
(
	category_id int GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    category_name varchar(64) NOT NULL UNIQUE,
	description varchar(256),
	is_active boolean,
    CONSTRAINT category_pk PRIMARY KEY (category_id)
);

ALTER TABLE IF EXISTS public.category
    OWNER to postgres;

-- Table: product

CREATE TABLE IF NOT EXISTS public.product
(
	product_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 CACHE 1 ),
    product_name varchar(128) NOT NULL,
	seller_id bigint NOT NULL,
	category_id int NOT NULL,
	date_added timestamptz NOT NULL,
	updated_at timestamptz,
	thumbnail_extension varchar(5),
	description text NOT NULL,
	is_active boolean NOT NULL,
	rating decimal(3, 2),
	total_sales int,
    CONSTRAINT product_pk PRIMARY KEY (product_id),
    CONSTRAINT product_fk_seller FOREIGN KEY (seller_id) 
        REFERENCES public.seller (seller_id),
	CONSTRAINT product_fk_category FOREIGN KEY (category_id) 
        REFERENCES public.category (category_id)
);

ALTER TABLE IF EXISTS public.product
    OWNER to postgres;

-- Table: product_variation

CREATE TABLE IF NOT EXISTS public.product_variation
(
    variation_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    product_id bigint NOT NULL,
    date_added timestamptz NOT NULL,
    updated_at timestamptz,
    image_extension varchar(5),
    product_size varchar(32) NOT NULL,
    variation varchar(32) NOT NULL,
    price numeric(15,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT variation_pk PRIMARY KEY (variation_id),
    CONSTRAINT variation_fk_product FOREIGN KEY (product_id)
        REFERENCES public.product (product_id) ON DELETE CASCADE,
    UNIQUE (product_id, product_size, variation)
);

ALTER TABLE IF EXISTS public.product_variation
    OWNER to postgres;

-- Table: cart

CREATE TABLE IF NOT EXISTS public.cart
(
	cart_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
	user_id bigint NOT NULL,
	product_id bigint NOT NULL,
	variation_id bigint NOT NULL,
    quantity int NOT NULL CHECK (quantity > 0),
	date_added timestamptz NOT NULL,
    CONSTRAINT cart_pk PRIMARY KEY (cart_id),
    CONSTRAINT cart_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id),
	CONSTRAINT cart_fk_product FOREIGN KEY (product_id) 
        REFERENCES public.product (product_id),
	CONSTRAINT cart_fk_variation FOREIGN KEY (variation_id) 
	REFERENCES public.product_variation (variation_id),
	UNIQUE (user_id, variation_id)
);

ALTER TABLE IF EXISTS public.cart
    OWNER to postgres;

-- Table: order_status

CREATE TABLE IF NOT EXISTS public.order_status
(
    status_id int GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    status_name varchar(50) NOT NULL UNIQUE,
    description text,
    created_at timestamptz NOT NULL,
    CONSTRAINT order_status_pk PRIMARY KEY (status_id)
);

ALTER TABLE IF EXISTS public.order_status OWNER TO postgres;

-- Table: order

CREATE TABLE IF NOT EXISTS public.order
(
    order_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    user_id bigint NOT NULL,
    delivery_address text NOT NULL,
    total_amount NUMERIC(15,2) NOT NULL CHECK (total_amount >= 0),
    payment_method varchar(50) NOT NULL,
    status_id int NOT NULL,
    order_date timestamptz NOT NULL,
    updated_at timestamptz,
    notes text,
    CONSTRAINT order_pk PRIMARY KEY (order_id),
    CONSTRAINT order_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users(user_id) ON DELETE CASCADE,
    CONSTRAINT order_fk_status FOREIGN KEY (status_id) 
        REFERENCES public.order_status(status_id) ON DELETE RESTRICT,
    CONSTRAINT order_chk_payment CHECK (payment_method IN ('cash_on_delivery', 'bank_transfer', 'e_wallet', 'credit_card'))
);

ALTER TABLE IF EXISTS public.order OWNER TO postgres;

-- Table: order_item

CREATE TABLE IF NOT EXISTS public.order_item
(
    order_item_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    variation_id bigint NOT NULL,
    product_name varchar(128) NOT NULL,
    product_size varchar(32) NOT NULL,
    variation varchar(32) NOT NULL,
    quantity int NOT NULL CHECK (quantity > 0),
    price numeric(15,2) NOT NULL CHECK (price >= 0),
    subtotal numeric(15,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT order_item_pk PRIMARY KEY (order_item_id),
    CONSTRAINT order_item_fk_order FOREIGN KEY (order_id) 
        REFERENCES public.order(order_id) ON DELETE CASCADE,
    CONSTRAINT order_item_fk_product FOREIGN KEY (product_id) 
        REFERENCES public.product(product_id) ON DELETE RESTRICT,
    CONSTRAINT order_item_fk_variation FOREIGN KEY (variation_id) 
        REFERENCES public.product_variation(variation_id) ON DELETE RESTRICT
);

ALTER TABLE IF EXISTS public.order_item OWNER TO postgres;

-- Table: verification_token

CREATE TABLE IF NOT EXISTS public.verification_token (
	verification_token_id bigint GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
    verification_token_hash char(64) NOT NULL,
    creation_date timestamptz NOT NULL,
    user_id bigint NOT NULL,
    CONSTRAINT fk_user_token FOREIGN KEY(user_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

ALTER TABLE IF EXISTS public.verification_token
    OWNER to postgres;

-- users
CREATE INDEX idx_users_role_id ON public.users(role_id);
CREATE INDEX idx_users_is_active ON public.users(is_active);

-- session
CREATE UNIQUE INDEX idx_session_hash ON public.session(session_hash);
CREATE INDEX idx_session_user_id ON public.session(user_id);

-- product
CREATE INDEX idx_product_seller_id ON public.product(seller_id);
CREATE INDEX idx_product_category_id ON public.product(category_id);
CREATE INDEX idx_product_is_active ON public.product(is_active);
CREATE INDEX idx_product_date_added ON public.product(date_added);

-- product variation

CREATE INDEX IF NOT EXISTS idx_variation_product ON product_variation(product_id);

-- category
CREATE INDEX idx_category_is_active ON public.category(is_active);

-- cart
CREATE INDEX idx_cart_product_id ON public.cart(product_id);

-- address
CREATE INDEX idx_address_user_id ON public.address(user_id);
CREATE INDEX idx_address_city_id ON public.address(city_id);
CREATE INDEX idx_address_is_default ON public.address(is_default);

-- order
CREATE INDEX idx_order_user_id ON public.order(user_id);
CREATE INDEX idx_order_status_id ON public.order(status_id);
CREATE INDEX idx_order_order_date ON public.order(order_date);

-- order_item
CREATE INDEX idx_order_item_order_id ON public.order_item(order_id);
CREATE INDEX idx_order_item_product_id ON public.order_item(product_id);
CREATE INDEX idx_order_item_variation_id ON public.order_item(variation_id);