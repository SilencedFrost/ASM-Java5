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

-- Roles
INSERT INTO public.role (role_id, role_name) VALUES (1, 'customer');
INSERT INTO public.role (role_id, role_name) VALUES (2, 'seller');
INSERT INTO public.role (role_id, role_name) VALUES (3, 'admin');

-- User
-- Admin user (role_id = 3)
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) 
VALUES ('thnrgbefv0987@gmail.com', 3, 'admin_master', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-02-15 10:30:00+00');

-- Seller user (role_id = 2)
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) 
VALUES ('minhnqts00553@fpt.edu.vn', 2, 'Minh', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-05-22 14:45:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller2@gmail.com', 2, 'alex_m', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-03-10 08:20:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller3@gmail.com', 2, 'jamie_c', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-06-18 16:55:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller4@gmail.com', 2, 'taylor_s', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-08-05 11:30:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller5@gmail.com', 2, 'morgan_l', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-09-12 09:15:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller6@gmail.com', 2, 'casey_w', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-10-28 13:40:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller7@gmail.com', 2, 'jordan_b', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-01-15 10:25:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller8@gmail.com', 2, 'riley_p', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-03-22 15:50:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller9@gmail.com', 2, 'avery_k', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-05-07 12:05:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller10@gmail.com', 2, 'blake_r', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-07-19 08:35:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date)
VALUES ('seller11@email.com', 2, 'sage_t', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-10-22 15:38:00+00');

-- Customer users (role_id = 1)
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('morgan.lee@email.com', 1, 'morgan_l', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-09-12 09:15:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('jordan.patel@email.com', 1, 'jordan_p', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-11-28 13:40:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('casey.williams@email.com', 1, 'casey_w', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-01-14 15:22:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('riley.nguyen@email.com', 1, 'riley_n', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-02-20 10:05:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('avery.garcia@email.com', 1, 'avery_g', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-03-17 12:50:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('dakota.jones@email.com', 1, 'dakota_j', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-04-08 08:33:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('skylar.martin@email.com', 1, 'skylar_m', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-05-25 14:18:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('quinn.rodriguez@email.com', 1, 'quinn_r', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-06-11 16:42:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('peyton.kim@email.com', 1, 'peyton_k', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-07-03 09:27:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('charlie.davis@email.com', 1, 'charlie_d', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-08-19 11:55:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('reese.wilson@email.com', 1, 'reese_w', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-09-07 13:12:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('sage.thompson@email.com', 1, 'sage_t', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-10-22 15:38:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('cameron.brown@email.com', 1, 'cameron_b', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2024-11-30 10:44:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('river.lopez@email.com', 1, 'river_l', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2025-01-18 08:59:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('phoenix.anderson@email.com', 1, 'phoenix_a', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2025-03-09 14:25:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('hunter.white@email.com', 1, 'hunter_w', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', false, '2025-09-28 16:10:00+00');

-- Admin
INSERT INTO public.admin (user_id) VALUES (100000);

-- Seller
INSERT INTO public.seller (user_id, shop_name) VALUES (100001, 'Shop1');
INSERT INTO public.seller (user_id, shop_name) VALUES (100002, 'Shop2');
INSERT INTO public.seller (user_id, shop_name) VALUES (100003, 'Shop3');
INSERT INTO public.seller (user_id, shop_name) VALUES (100004, 'Shop4');
INSERT INTO public.seller (user_id, shop_name) VALUES (100005, 'Shop5');
INSERT INTO public.seller (user_id, shop_name) VALUES (100006, 'Shop6');
INSERT INTO public.seller (user_id, shop_name) VALUES (100007, 'Shop7');
INSERT INTO public.seller (user_id, shop_name) VALUES (100008, 'Shop8');
INSERT INTO public.seller (user_id, shop_name) VALUES (100009, 'Shop9');
INSERT INTO public.seller (user_id, shop_name) VALUES (100010, 'Shop10');
INSERT INTO public.seller (user_id, shop_name) VALUES (100011, 'Shop11');


-- Customer
INSERT INTO public.customer (user_id) VALUES (100012);
INSERT INTO public.customer (user_id) VALUES (100013);
INSERT INTO public.customer (user_id) VALUES (100014);
INSERT INTO public.customer (user_id) VALUES (100015);
INSERT INTO public.customer (user_id) VALUES (100016);
INSERT INTO public.customer (user_id) VALUES (100017);
INSERT INTO public.customer (user_id) VALUES (100018);
INSERT INTO public.customer (user_id) VALUES (100019);
INSERT INTO public.customer (user_id) VALUES (100020);
INSERT INTO public.customer (user_id) VALUES (100021);
INSERT INTO public.customer (user_id) VALUES (100022);
INSERT INTO public.customer (user_id) VALUES (100023);
INSERT INTO public.customer (user_id) VALUES (100024);
INSERT INTO public.customer (user_id) VALUES (100025);
INSERT INTO public.customer (user_id) VALUES (100026);

-- City
INSERT INTO public.city (city_name) VALUES ('Hồ Chí Minh');
INSERT INTO public.city (city_name) VALUES ('Hà Nội');
INSERT INTO public.city (city_name) VALUES ('Đà Nẵng');
INSERT INTO public.city (city_name) VALUES ('Hải Phòng');
INSERT INTO public.city (city_name) VALUES ('Cần Thơ');
INSERT INTO public.city (city_name) VALUES ('Huế');

-- Category
-- Vietnamese dishes
INSERT INTO public.category (category_name, is_active) values ('Hủ tiếu', true);
INSERT INTO public.category (category_name, is_active) values ('Bún', true);
INSERT INTO public.category (category_name, is_active) values ('Phở', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Cơm tấm', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Bánh mì', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Cháo', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Bánh xèo', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Gỏi cuốn', true);

-- Snacks & Street food
INSERT INTO public.category (category_name, is_active) VALUES ('Bánh tráng nướng', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Xôi', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Nem nướng', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Chè', true);

-- Korean dishes
INSERT INTO public.category (category_name, is_active) values ('Tteokbokki', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Kimchi', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Kimbap', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Bibimbap', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Samgyeopsal', true);

-- Japanese dishes
INSERT INTO public.category (category_name, is_active) values ('Takoyaki', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Sushi', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Ramen', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Udon', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Katsudon', true);

-- Drinks
INSERT INTO public.category (category_name, is_active) values ('Trà sữa', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Cà phê sữa đá', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Trà đào cam sả', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Trà chanh', true);
INSERT INTO public.category (category_name, is_active) VALUES ('Soda chanh', true);

-- Product
-- Seller 100000: Categories 1 (Hủ tiếu), 2 (Bún), 3 (Phở) - 18 products
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, rating, total_sales) VALUES 
('Hủ tiếu Nam Vang', 100000, 1, '2023-03-15 08:30:00+07', '2024-05-20 10:15:00+07', 'jpg', 'Hủ tiếu Nam Vang đậm đà với tôm tươi, thịt băm, gan lợn và nước dùng ngọt thanh', true, 4.75, 3245),
('Hủ tiếu Mỹ Tho', 100000, 1, '2023-04-10 09:00:00+07', '2024-08-12 14:30:00+07', 'jpg', 'Hủ tiếu Mỹ Tho truyền thống với tôm khô, thịt heo, giá đỗ và nước dùng trong vắt', true, 4.60, 2890),
('Hủ tiếu xào hải sản', 100000, 1, '2023-06-20 11:45:00+07', '2025-01-15 16:20:00+07', 'jpg', 'Hủ tiếu xào thập cẩm với tôm, mực, cua và rau củ tươi ngon', true, 4.50, 1876),
('Hủ tiếu khô', 100000, 1, '2023-07-05 07:20:00+07', '2024-11-10 09:40:00+07', 'jpg', 'Hủ tiếu khô trộn với tôm thịt, hành phi và nước mắm ngọt đậm đà', true, 4.65, 2345),
('Hủ tiếu bò kho', 100000, 1, '2024-01-12 13:15:00+07', '2025-03-08 11:25:00+07', 'jpg', 'Hủ tiếu bò kho với thịt bò ninh mềm, nước dùng đậm đà thơm ngon', true, 4.80, 4123),
('Hủ tiếu gà', 100000, 1, '2024-03-22 10:30:00+07', '2025-06-14 15:10:00+07', 'jpg', 'Hủ tiếu gà với thịt gà luộc, nước dùng ngọt từ xương gà', false, 4.40, 1234),
('Bún bò Huế', 100000, 2, '2023-05-08 08:00:00+07', '2024-09-20 12:30:00+07', 'jpg', 'Bún bò Huế cay nồng với chả, giò heo, nước dùng ninh từ xương ống', true, 4.85, 5678),
('Bún riêu cua', 100000, 2, '2023-08-14 09:30:00+07', '2025-02-18 14:45:00+07', 'jpg', 'Bún riêu cua đồng với cà chua, đậu hũ chiên và nước dùng chua chua thanh mát', true, 4.70, 3890),
('Bún thịt nướng', 100000, 2, '2023-09-25 11:00:00+07', '2024-12-05 10:20:00+07', 'jpg', 'Bún thịt nướng thơm lừng với thịt heo nướng than hoa, rau sống và nước mắm chua ngọt', true, 4.55, 2567),
('Bún chả Hà Nội', 100000, 2, '2024-02-10 12:45:00+07', '2025-04-22 16:30:00+07', 'jpg', 'Bún chả Hà Nội truyền thống với chả nướng, thịt ba rọi và nước mắm pha', true, 4.90, 6234),
('Bún măng vịt', 100000, 2, '2024-05-18 08:15:00+07', '2025-07-10 09:50:00+07', 'jpg', 'Bún măng vịt với thịt vịt nấu măng, nước dùng đậm đà thơm ngon', true, 4.45, 1890),
('Bún mắm', 100000, 2, '2024-07-03 10:20:00+07', '2025-09-15 13:40:00+07', 'jpg', 'Bún mắm miền Tây với cá lóc, tôm, thịt heo và nước mắm đặc trưng', false, 4.35, 1456),
('Phở bò tái', 100000, 3, '2023-03-20 07:30:00+07', '2024-06-15 11:20:00+07', 'jpg', 'Phở bò tái với thịt bò tươi ngon, bánh phở mềm và nước dùng trong vắt thom ngát', true, 4.80, 4567),
('Phở bò chín', 100000, 3, '2023-06-12 09:45:00+07', '2024-10-08 14:30:00+07', 'jpg', 'Phở bò chín với thịt bò ninh mềm, nước dùng ngọt thanh', true, 4.70, 3890),
('Phở bò viên', 100000, 3, '2023-09-18 11:00:00+07', '2025-01-20 15:45:00+07', 'jpg', 'Phở bò viên với viên bò dai giòn, nước dùng đậm đà', true, 4.65, 3234),
('Phở gà', 100000, 3, '2024-01-05 08:30:00+07', '2025-03-12 10:15:00+07', 'jpg', 'Phở gà với thịt gà luộc mềm, nước dùng ngọt từ xương gà', true, 4.60, 2890),
('Phở tái nạm gân', 100000, 3, '2024-04-15 12:00:00+07', '2025-06-20 16:30:00+07', 'jpg', 'Phở tái nạm gân đầy đủ với nhiều loại thịt bò, nước dùng đậm vị', true, 4.85, 5123),
('Phở đặc biệt', 100000, 3, '2024-08-22 10:45:00+07', '2025-10-05 13:20:00+07', 'jpg', 'Phở đặc biệt thập cẩm với tất cả các loại thịt bò, bò viên và sườn', true, 4.95, 7890),

-- Seller 100001: Categories 4 (Cơm tấm), 5 (Bánh mì) - 18 products
('Cơm tấm sườn bì chả', 100001, 4, '2023-04-08 08:00:00+07', '2024-07-15 11:30:00+07', 'jpg', 'Cơm tấm sườn nướng, bì, chả trứng đầy đủ với nước mắm chua ngọt', true, 4.75, 4234),
('Cơm tấm sườn nướng', 100001, 4, '2023-05-20 09:30:00+07', '2024-09-10 14:20:00+07', 'jpg', 'Cơm tấm sườn nướng than hoa thơm lừng, ăn kèm dưa leo và đồ chua', true, 4.70, 3890),
('Cơm tấm bì', 100001, 4, '2023-07-15 11:15:00+07', '2025-02-08 15:40:00+07', 'jpg', 'Cơm tấm bì mỏng giòn rụm, trộn với dầu hành phi thơm ngon', true, 4.50, 2345),
('Cơm tấm gà nướng', 100001, 4, '2023-10-03 12:45:00+07', '2025-04-18 10:30:00+07', 'jpg', 'Cơm tấm gà nướng sa tế cay nồng, thịt gà mềm ngon đậm vị', true, 4.65, 3456),
('Cơm tấm sườn bì', 100001, 4, '2024-01-18 08:20:00+07', '2025-05-22 12:15:00+07', 'jpg', 'Cơm tấm sườn bì truyền thống miền Nam, nước mắm pha đậm đà', true, 4.80, 5123),
('Cơm tấm chả trứng', 100001, 4, '2024-03-25 10:00:00+07', '2025-07-12 14:50:00+07', 'jpg', 'Cơm tấm chả trứng hấp mềm xốp, thơm mùi thịt heo băm', false, 4.40, 1890),
('Cơm tấm tứ quý', 100001, 4, '2024-06-10 11:30:00+07', '2025-08-20 16:10:00+07', 'jpg', 'Cơm tấm tứ quý đầy đủ sườn bì chả và trứng ốp la', true, 4.85, 6789),
('Cơm tấm sườn cây', 100001, 4, '2024-09-05 09:15:00+07', '2025-10-10 13:45:00+07', 'jpg', 'Cơm tấm sườn cây nướng nguyên miếng, đậm vị thơm ngon', true, 4.90, 5890),
('Cơm tấm gà xối mỡ', 100001, 4, '2024-11-12 12:00:00+07', NULL, 'jpg', 'Cơm tấm gà xối mỡ Hải Nam, gạo thơm cơm dẻo thịt gà mềm', true, 4.55, 2678),
('Bánh mì thịt', 100001, 5, '2023-03-25 07:45:00+07', '2024-08-15 10:30:00+07', 'jpg', 'Bánh mì thịt nguội, pate, dưa leo, ngò rau thơm ngon giòn tan', true, 4.70, 4567),
('Bánh mì xíu mại', 100001, 5, '2023-06-18 09:00:00+07', '2024-11-20 13:15:00+07', 'jpg', 'Bánh mì xíu mại sốt cà chua đậm đà, thịt viên mềm ngon', true, 4.65, 3890),
('Bánh mì pate', 100001, 5, '2023-08-22 10:30:00+07', '2025-01-10 14:45:00+07', 'jpg', 'Bánh mì pate truyền thống, chà bông và nước tương ngọt', true, 4.50, 2456),
('Bánh mì trứng ốp la', 100001, 5, '2023-11-05 11:45:00+07', '2025-03-25 16:20:00+07', 'jpg', 'Bánh mì trứng ốp la nóng giòn, trứng gà béo ngậy', true, 4.60, 3234),
('Bánh mì gà', 100001, 5, '2024-02-14 08:15:00+07', '2025-06-05 11:40:00+07', 'jpg', 'Bánh mì gà xé phay hoặc gà nướng thơm lừng đậm vị', true, 4.75, 4890),
('Bánh mì chả cá', 100001, 5, '2024-05-20 10:00:00+07', '2025-08-15 13:30:00+07', 'jpg', 'Bánh mì chả cá Nha Trang, chả cá chiên giòn ăn kèm rau thơm', false, 4.45, 2123),
('Bánh mì thập cẩm', 100001, 5, '2024-07-28 12:30:00+07', '2025-09-20 15:50:00+07', 'jpg', 'Bánh mì thập cẩm đầy đủ với nhiều loại nhân thịt nguội', true, 4.80, 5678),
('Bánh mì bò kho', 100001, 5, '2024-10-15 09:45:00+07', '2025-10-18 12:20:00+07', 'jpg', 'Bánh mì bò kho với thịt bò ninh mềm, nước sốt đậm đà', true, 4.85, 6234),
('Bánh mì ốp let', 100001, 5, '2025-01-08 11:00:00+07', NULL, 'jpg', 'Bánh mì ốp let với trứng, xúc xích và pate thơm béo', true, 4.55, 1890),

-- Seller 100002: Categories 6 (Cháo), 8 (Gỏi cuốn) - 18 products
('Cháo lòng', 100002, 6, '2023-04-12 08:30:00+07', '2024-09-05 11:45:00+07', 'jpg', 'Cháo lòng heo với lòng tươi, tiết canh và đậu phộng rang', true, 4.60, 2890),
('Cháo gà', 100002, 6, '2023-06-25 09:15:00+07', '2024-12-10 14:30:00+07', 'jpg', 'Cháo gà nấu với gạo nếp và thịt gà xé mềm thơm ngon', true, 4.70, 3456),
('Cháo vịt', 100002, 6, '2023-09-08 10:45:00+07', '2025-02-15 16:20:00+07', 'jpg', 'Cháo vịt nấu với gừng, hành và thịt vịt đậm vị', true, 4.55, 2345),
('Cháo hải sản', 100002, 6, '2023-12-20 12:00:00+07', '2025-04-28 10:15:00+07', 'jpg', 'Cháo hải sản với tôm, mực, cua và rau thơm tươi ngon', true, 4.75, 4123),
('Cháo cá lóc', 100002, 6, '2024-03-10 08:45:00+07', '2025-06-18 13:40:00+07', 'jpg', 'Cháo cá lóc với thịt cá tươi, nấu mềm nhuyễn thơm ngon', true, 4.50, 1890),
('Cháo sườn', 100002, 6, '2024-05-22 11:30:00+07', '2025-08-10 15:20:00+07', 'jpg', 'Cháo sườn heo ninh mềm, nước cháo sánh mịn đậm đà', false, 4.40, 1567),
('Cháo tim gà', 100002, 6, '2024-08-05 09:00:00+07', '2025-09-25 12:30:00+07', 'jpg', 'Cháo tim gà với tim gà non mềm ngon, nước cháo sánh', true, 4.65, 2678),
('Cháo trứng', 100002, 6, '2024-10-18 10:15:00+07', '2025-10-12 14:45:00+07', 'jpg', 'Cháo trứng đơn giản nhưng bổ dưỡng, thích hợp cho trẻ em', true, 4.35, 1234),
('Cháo bò', 100002, 6, '2025-02-08 12:45:00+07', NULL, 'jpg', 'Cháo bò với thịt bò băm mềm, hành phi thơm lừng', true, 4.80, 3890),
('Gỏi cuốn tôm thịt', 100002, 8, '2023-05-15 08:00:00+07', '2024-10-20 11:30:00+07', 'jpg', 'Gỏi cuốn tôm thịt truyền thống với bánh tráng tươi, rau sống và tương đen', true, 4.75, 4567),
('Gỏi cuốn chay', 100002, 8, '2023-07-28 09:30:00+07', '2025-01-15 14:20:00+07', 'jpg', 'Gỏi cuốn chay với rau củ tươi ngon, đậu hũ chiên giòn', true, 4.50, 2345),
('Gỏi cuốn tôm', 100002, 8, '2023-10-12 11:00:00+07', '2025-03-22 15:45:00+07', 'jpg', 'Gỏi cuốn tôm tươi với bánh tráng mỏng, rau thơm và bún', true, 4.70, 3678),
('Gỏi cuốn thịt', 100002, 8, '2024-01-25 12:30:00+07', '2025-05-10 16:50:00+07', 'jpg', 'Gỏi cuốn thịt heo luộc mềm, cuốn với rau sống và bún tươi', true, 4.60, 2890),
('Gỏi cuốn bì', 100002, 8, '2024-04-08 08:45:00+07', '2025-07-20 13:15:00+07', 'jpg', 'Gỏi cuốn bì giòn rụm, cuốn cùng rau thơm và tương đen', false, 4.45, 1789),
('Gỏi cuốn bò nướng', 100002, 8, '2024-06-20 10:15:00+07', '2025-08-28 14:40:00+07', 'jpg', 'Gỏi cuốn bò nướng lá lốt thơm ngon, ăn kèm tương đậu phộng', true, 4.80, 5234),
('Gỏi cuốn gà', 100002, 8, '2024-09-05 11:45:00+07', '2025-10-08 16:20:00+07', 'jpg', 'Gỏi cuốn gà xé với rau sống tươi mát, tương chua ngọt', true, 4.55, 2567),
('Gỏi cuốn hải sản', 100002, 8, '2024-11-18 09:30:00+07', NULL, 'jpg', 'Gỏi cuốn hải sản với tôm, mực và rau thơm tươi ngon', true, 4.85, 6123),
('Gỏi cuốn nem nướng', 100002, 8, '2025-02-15 12:00:00+07', NULL, 'jpg', 'Gỏi cuốn nem nướng Ninh Hòa thơm lừng, ăn kèm tương đậm đà', true, 4.75, 4234),

-- Seller 100003: Categories 7 (Bánh xèo), 9 (Bánh tráng nướng) - 18 products
('Bánh xèo miền Tây', 100003, 7, '2023-04-20 08:15:00+07', '2024-08-25 11:40:00+07', 'jpg', 'Bánh xèo miền Tây giòn rụm với tôm, thịt, giá đỗ ăn kèm rau sống', true, 4.80, 5234),
('Bánh xèo tôm thịt', 100003, 7, '2023-07-05 09:45:00+07', '2024-11-15 14:30:00+07', 'jpg', 'Bánh xèo tôm thịt truyền thống với nước mắm chua ngọt', true, 4.70, 3890),
('Bánh xèo hải sản', 100003, 7, '2023-09-18 11:15:00+07', '2025-01-20 15:50:00+07', 'jpg', 'Bánh xèo hải sản đầy đủ tôm mực cua và rau thơm', true, 4.75, 4567),
('Bánh xèo chay', 100003, 7, '2023-12-03 12:45:00+07', '2025-04-08 10:25:00+07', 'jpg', 'Bánh xèo chay với nấm, đậu hũ và rau củ tươi ngon', true, 4.50, 2345),
('Bánh xèo mini', 100003, 7, '2024-02-15 08:30:00+07', '2025-06-22 13:15:00+07', 'jpg', 'Bánh xèo mini nhỏ xinh, giòn tan thơm ngon dễ ăn', true, 4.60, 3123),
('Bánh xèo tôm nhảy', 100003, 7, '2024-05-28 10:00:00+07', '2025-08-10 14:45:00+07', 'jpg', 'Bánh xèo tôm nhảy đặc sản với tôm tươi nguyên con', false, 4.85, 6789),
('Bánh xèo miền Trung', 100003, 7, '2024-08-12 11:30:00+07', '2025-09-28 16:20:00+07', 'jpg', 'Bánh xèo miền Trung nhỏ gọn, cuốn với rau sống và tương đậm đà', true, 4.65, 2890),
('Bánh xèo nấm', 100003, 7, '2024-10-25 09:15:00+07', '2025-10-15 12:40:00+07', 'jpg', 'Bánh xèo nấm với nhiều loại nấm tươi, thơm ngon bổ dưỡng', true, 4.55, 2456),
('Bánh xèo đặc biệt', 100003, 7, '2025-01-10 12:00:00+07', NULL, 'jpg', 'Bánh xèo đặc biệt thập cẩm với đầy đủ nhân hải sản và thịt', true, 4.90, 7123),
('Bánh tráng nướng trứng', 100003, 9, '2023-05-08 08:00:00+07', '2024-09-15 11:30:00+07', 'jpg', 'Bánh tráng nướng trứng cút thơm béo, rắc hành phi và ruốc', true, 4.75, 4890),
('Bánh tráng nướng bơ', 100003, 9, '2023-07-20 09:30:00+07', '2024-12-05 14:20:00+07', 'jpg', 'Bánh tráng nướng bơ thơm ngon với trứng và pate', true, 4.65, 3567),
('Bánh tráng nướng phô mai', 100003, 9, '2023-10-05 11:00:00+07', '2025-02-18 15:45:00+07', 'jpg', 'Bánh tráng nướng phô mai béo ngậy, rắc khô bò và hành', true, 4.80, 5678),
('Bánh tráng nướng sate', 100003, 9, '2024-01-12 12:30:00+07', '2025-04-25 16:50:00+07', 'jpg', 'Bánh tráng nướng sate cay nồng với trứng và ruốc', true, 4.70, 4123),
('Bánh tráng nướng chay', 100003, 9, '2024-03-28 08:45:00+07', '2025-07-10 13:15:00+07', 'jpg', 'Bánh tráng nướng chay với rau củ và nấm, không trứng', false, 4.40, 1890),
('Bánh tráng nướng mỡ hành', 100003, 9, '2024-06-15 10:15:00+07', '2025-08-22 14:40:00+07', 'jpg', 'Bánh tráng nướng mỡ hành truyền thống giòn tan thơm lừng', true, 4.85, 6234),
('Bánh tráng nướng khô bò', 100003, 9, '2024-09-08 11:45:00+07', '2025-10-05 16:20:00+07', 'jpg', 'Bánh tráng nướng khô bò với trứng và hành phi', true, 4.60, 3234),
('Bánh tráng nướng Đà Lạt', 100003, 9, '2024-11-20 09:30:00+07', NULL, 'jpg', 'Bánh tráng nướng Đà Lạt đặc sản với nhiều topping', true, 4.90, 7890),
('Bánh tráng nướng tôm', 100003, 9, '2025-02-05 12:00:00+07', NULL, 'jpg', 'Bánh tráng nướng tôm khô thơm ngon, giòn rụm hấp dẫn', true, 4.55, 2678),

-- Seller 100004: Categories 10 (Xôi), 12 (Chè) - 18 products
('Xôi gà', 100004, 10, '2023-04-15 07:30:00+07', '2024-08-20 10:45:00+07', 'jpg', 'Xôi gà với thịt gà xé, hành phi và nước mắm gừng thơm ngon', true, 4.70, 3890),
('Xôi xéo', 100004, 10, '2023-06-28 09:00:00+07', '2024-11-10 13:30:00+07', 'jpg', 'Xôi xéo với đậu xanh nghiền mịn, rắc hành phi và vừng rang', true, 4.75, 4567),
('Xôi lạc', 100004, 10, '2023-09-10 10:30:00+07', '2025-01-25 15:20:00+07', 'jpg', 'Xôi lạc với đậu phộng rang giòn, xôi dẻo thơm ngon', true, 4.50, 2345),
('Xôi thịt kho', 100004, 10, '2023-11-22 12:00:00+07', '2025-03-15 16:40:00+07', 'jpg', 'Xôi thịt kho trứng với thịt ba rọi kho đậm đà', true, 4.80, 5234),
('Xôi chay', 100004, 10, '2024-02-08 08:15:00+07', '2025-05-20 11:50:00+07', 'jpg', 'Xôi chay với nấm, đậu phộng và rau củ bổ dưỡng', true, 4.45, 1890),
('Xôi vò', 100004, 10, '2024-04-25 10:45:00+07', '2025-07-08 14:30:00+07', 'jpg', 'Xôi vò với đậu xanh bọc ngoài, xôi dẻo thơm mềm', false, 4.60, 2678),
('Xôi sườn', 100004, 10, '2024-07-12 11:30:00+07', '2025-09-18 15:45:00+07', 'jpg', 'Xôi sườn nướng thơm lừng với sườn heo nướng than hoa', true, 4.85, 6123),
('Xôi đậu đen', 100004, 10, '2024-09-28 09:00:00+07', '2025-10-12 12:20:00+07', 'jpg', 'Xôi đậu đen với đậu đen nấu mềm, xôi dẻo ngọt thanh', true, 4.55, 2456),
('Xôi ngũ sắc', 100004, 10, '2024-12-10 12:45:00+07', NULL, 'jpg', 'Xôi ngũ sắc nhiều màu sắc đẹp mắt, thơm ngon bổ dưỡng', true, 4.65, 3234),
('Chè ba màu', 100004, 12, '2023-05-18 08:30:00+07', '2024-09-25 11:45:00+07', 'jpg', 'Chè ba màu truyền thống với đậu đỏ, đậu xanh, thạch và nước cốt dừa', true, 4.70, 3890),
('Chè bưởi', 100004, 12, '2023-07-30 10:00:00+07', '2024-12-15 14:30:00+07', 'jpg', 'Chè bưởi với múi bưởi tươi, nước dừa ngọt mát', true, 4.65, 3456),
('Chè thập cẩm', 100004, 12, '2023-10-15 11:30:00+07', '2025-02-20 15:50:00+07', 'jpg', 'Chè thập cẩm đầy đủ với nhiều loại đậu, hạt sen và trân châu', true, 4.75, 4567),
('Chè đậu xanh', 100004, 12, '2024-01-05 12:45:00+07', '2025-04-18 16:20:00+07', 'jpg', 'Chè đậu xanh nấu mềm ngọt thanh, ăn nóng hoặc lạnh đều ngon', true, 4.50, 2345),
('Chè khúc bạch', 100004, 12, '2024-03-20 08:15:00+07', '2025-06-25 13:40:00+07', 'jpg', 'Chè khúc bạch mát lạnh với thạch trắng mềm và nước đường', false, 4.60, 2890),
('Chè đậu đen', 100004, 12, '2024-06-08 10:45:00+07', '2025-08-15 14:50:00+07', 'jpg', 'Chè đậu đen bổ dưỡng với đậu đen nấu mềm và nước cốt dừa', true, 4.55, 2567),
('Chè hạt sen', 100004, 12, '2024-08-22 11:15:00+07', '2025-09-30 15:30:00+07', 'jpg', 'Chè hạt sen với hạt sen tươi nấu mềm, nước ngọt thanh', true, 4.80, 5123),
('Chè bắp', 100004, 12, '2024-11-05 09:30:00+07', '2025-10-18 12:45:00+07', 'jpg', 'Chè bắp với ngô ngọt, nước cốt dừa béo ngậy thơm ngon', true, 4.45, 1890),
('Chè thái', 100004, 12, '2025-01-18 12:00:00+07', NULL, 'jpg', 'Chè thái với trái cây nhiệt đới, nước cốt dừa và đá bào mát lạnh', true, 4.85, 6234),

-- Seller 100005: Categories 4 (Cơm tấm), 11 (Nem nướng) - 18 products
('Cơm tấm sườn non', 100005, 4, '2023-05-10 08:00:00+07', '2024-09-20 11:30:00+07', 'jpg', 'Cơm tấm sườn non nướng mềm ngon, ăn kèm dưa leo và đồ chua', true, 4.75, 4234),
('Cơm tấm opla', 100005, 4, '2023-07-25 09:30:00+07', '2024-12-10 14:20:00+07', 'jpg', 'Cơm tấm trứng ốp la đơn giản nhưng ngon miệng', true, 4.50, 2345),
('Cơm tấm đặc biệt', 100005, 4, '2023-10-08 11:00:00+07', '2025-02-15 15:45:00+07', 'jpg', 'Cơm tấm đặc biệt với sườn bì chả trứng đầy đủ topping', true, 4.90, 7890),
('Cơm tấm sườn trứng', 100005, 4, '2024-01-22 12:30:00+07', '2025-04-28 16:50:00+07', 'jpg', 'Cơm tấm sườn nướng và trứng ốp la thơm ngon đậm vị', true, 4.70, 3890),
('Cơm tấm chả cá', 100005, 4, '2024-04-15 08:45:00+07', '2025-07-05 13:15:00+07', 'jpg', 'Cơm tấm chả cá Nha Trang, chả cá chiên giòn thơm ngon', true, 4.60, 2678),
('Cơm tấm sườn mỡ', 100005, 4, '2024-06-28 10:15:00+07', '2025-08-20 14:40:00+07', 'jpg', 'Cơm tấm sườn mỡ nướng nguyên miếng, béo ngậy đậm đà', false, 4.80, 5234),
('Cơm tấm tôm', 100005, 4, '2024-09-12 11:45:00+07', '2025-10-08 16:20:00+07', 'jpg', 'Cơm tấm tôm nướng mỡ hành, tôm tươi ngon thơm lừng', true, 4.85, 6123),
('Cơm tấm bò nướng', 100005, 4, '2024-11-25 09:30:00+07', NULL, 'jpg', 'Cơm tấm bò nướng sả ớt cay nồng, thịt bò mềm ngon', true, 4.65, 3456),
('Cơm tấm ba rọi', 100005, 4, '2025-02-08 12:00:00+07', NULL, 'jpg', 'Cơm tấm ba rọi nướng than hoa, thịt ba rọi béo ngậy', true, 4.55, 2567),
('Nem nướng Ninh Hòa', 100005, 11, '2023-05-22 08:15:00+07', '2024-10-05 11:40:00+07', 'jpg', 'Nem nướng Ninh Hòa truyền thống, ăn kèm bánh tráng và rau sống', true, 4.85, 6789),
('Nem nướng cuốn', 100005, 11, '2023-08-10 09:45:00+07', '2025-01-15 14:30:00+07', 'jpg', 'Nem nướng cuốn bánh tráng với rau thơm và tương đậm đà', true, 4.75, 5123),
('Nem nướng xiên', 100005, 11, '2023-11-18 11:15:00+07', '2025-03-25 15:50:00+07', 'jpg', 'Nem nướng xiên nướng than hoa, ăn nóng giòn thơm', true, 4.70, 4234),
('Nem nướng lụi', 100005, 11, '2024-02-05 12:45:00+07', '2025-05-20 16:20:00+07', 'jpg', 'Nem lụi cuốn bánh tráng với rau sống tươi mát', true, 4.65, 3678),
('Nem nướng chả ram', 100005, 11, '2024-04-28 08:30:00+07', '2025-07-15 13:40:00+07', 'jpg', 'Nem nướng chả ram đặc sản miền Trung thơm ngon', false, 4.60, 2890),
('Nem nướng sa tế', 100005, 11, '2024-07-15 10:00:00+07', '2025-09-05 14:50:00+07', 'jpg', 'Nem nướng sa tế cay nồng thơm lừng hấp dẫn', true, 4.80, 5678),
('Nem nướng bánh hỏi', 100005, 11, '2024-10-02 11:30:00+07', '2025-10-15 15:30:00+07', 'jpg', 'Nem nướng ăn với bánh hỏi, rau sống và nước mắm pha', true, 4.55, 2456),
('Nem nướng mỡ hành', 100005, 11, '2024-12-18 09:15:00+07', NULL, 'jpg', 'Nem nướng mỡ hành thơm béo, nướng than hoa giòn rụm', true, 4.90, 7234),
('Nem nướng đặc biệt', 100005, 11, '2025-02-22 12:00:00+07', NULL, 'jpg', 'Nem nướng đặc biệt với nhiều topping hấp dẫn', true, 4.70, 3890),

-- Seller 100006: Category 13 (Tteokbokki) - 18 products
('Tteokbokki cay', 100006, 13, '2023-04-18 08:30:00+07', '2024-08-25 11:45:00+07', 'jpg', 'Tteokbokki cay truyền thống Hàn Quốc với bánh gạo mềm và sốt gochujang đậm đà', true, 4.80, 5234),
('Tteokbokki phô mai', 100006, 13, '2023-06-30 10:00:00+07', '2024-11-15 14:30:00+07', 'jpg', 'Tteokbokki phô mai béo ngậy với phô mai mozzarella tan chảy', true, 4.85, 6789),
('Tteokbokki hải sản', 100006, 13, '2023-09-15 11:30:00+07', '2025-01-20 15:50:00+07', 'jpg', 'Tteokbokki hải sản với tôm, mực, cua và rau củ tươi ngon', true, 4.75, 4567),
('Tteokbokki jjajang', 100006, 13, '2023-12-05 12:45:00+07', '2025-04-10 16:20:00+07', 'jpg', 'Tteokbokki jjajang với sốt đậu đen thơm ngon đặc trưng', true, 4.60, 2890),
('Tteokbokki carbonara', 100006, 13, '2024-02-20 08:15:00+07', '2025-06-25 13:40:00+07', 'jpg', 'Tteokbokki carbonara kem béo ngậy với phô mai và sữa tươi', true, 4.70, 3678),
('Tteokbokki sốt kem', 100006, 13, '2024-05-10 10:45:00+07', '2025-08-18 14:50:00+07', 'jpg', 'Tteokbokki sốt kem mềm mịn với hương vị ngọt ngào', false, 4.55, 2456),
('Tteokbokki cay vừa', 100006, 13, '2024-07-28 11:15:00+07', '2025-09-30 15:30:00+07', 'jpg', 'Tteokbokki cay vừa phù hợp với người không ăn cay nhiều', true, 4.65, 3234),
('Tteokbokki xúc xích', 100006, 13, '2024-10-15 09:30:00+07', '2025-10-12 12:45:00+07', 'jpg', 'Tteokbokki xúc xích với xúc xích Hàn Quốc thơm ngon', true, 4.80, 5678),
('Tteokbokki trứng', 100006, 13, '2025-01-08 12:00:00+07', NULL, 'jpg', 'Tteokbokki trứng với trứng lòng đào béo ngậy hấp dẫn', true, 4.75, 4890),
('Tteokbokki siêu cay', 100006, 13, '2023-05-25 08:00:00+07', '2024-10-10 11:30:00+07', 'jpg', 'Tteokbokki siêu cay dành cho người thích ăn cay cấp độ cao', true, 4.70, 3890),
('Tteokbokki ramyeon', 100006, 13, '2023-08-12 09:30:00+07', '2024-12-20 14:20:00+07', 'jpg', 'Tteokbokki ramyeon kết hợp với mì Hàn Quốc thơm ngon', true, 4.85, 6234),
('Tteokbokki búp bê', 100006, 13, '2023-11-05 11:00:00+07', '2025-02-15 15:45:00+07', 'jpg', 'Tteokbokki búp bê với bánh gạo mini dễ thương', true, 4.50, 2345),
('Tteokbokki bơ', 100006, 13, '2024-01-28 12:30:00+07', '2025-04-22 16:50:00+07', 'jpg', 'Tteokbokki bơ thơm béo với bơ tươi và rong biển', true, 4.60, 2678),
('Tteokbokki nguyên bản', 100006, 13, '2024-04-15 08:45:00+07', '2025-07-08 13:15:00+07', 'jpg', 'Tteokbokki nguyên bản truyền thống với sốt gochujang chuẩn vị', false, 4.75, 4567),
('Tteokbokki thập cẩm', 100006, 13, '2024-07-02 10:15:00+07', '2025-08-25 14:40:00+07', 'jpg', 'Tteokbokki thập cẩm với nhiều topping hấp dẫn', true, 4.90, 7890),
('Tteokbokki mozzarella', 100006, 13, '2024-09-20 11:45:00+07', '2025-10-18 16:20:00+07', 'jpg', 'Tteokbokki mozzarella với phô mai kéo sợi thơm ngon', true, 4.85, 6789),
('Tteokbokki odeng', 100006, 13, '2024-12-08 09:30:00+07', NULL, 'jpg', 'Tteokbokki odeng với chả cá Hàn Quốc thơm ngon', true, 4.65, 3456),
('Tteokbokki sốt đen', 100006, 13, '2025-02-18 12:00:00+07', NULL, 'jpg', 'Tteokbokki sốt đen jjajang với hương vị độc đáo', true, 4.70, 3890),

-- Seller 100007: Categories 14 (Kimchi), 15 (Kimbap), 16 (Bibimbap), 17 (Samgyeopsal) - 19 products
('Kimchi truyền thống', 100007, 14, '2023-05-12 08:15:00+07', '2024-09-25 11:40:00+07', 'jpg', 'Kimchi truyền thống Hàn Quốc chua cay đậm đà, lên men tự nhiên', true, 4.75, 4567),
('Kimchi cải thảo', 100007, 14, '2023-07-28 09:45:00+07', '2024-12-15 14:30:00+07', 'jpg', 'Kimchi cải thảo tươi ngon với ớt bột Hàn Quốc chính hiệu', true, 4.70, 3890),
('Kimchi củ cải', 100007, 14, '2023-10-15 11:15:00+07', '2025-02-20 15:50:00+07', 'jpg', 'Kimchi củ cải giòn giòn chua chua thơm ngon', true, 4.60, 2678),
('Kimchi dưa chuột', 100007, 14, '2024-01-10 12:45:00+07', '2025-04-28 16:20:00+07', 'jpg', 'Kimchi dưa chuột tươi mát, lên men vừa phải dễ ăn', true, 4.55, 2345),
('Kimbap bò', 100007, 15, '2023-06-05 08:30:00+07', '2024-10-20 11:45:00+07', 'jpg', 'Kimbap bò với thịt bò xào, rau củ và trứng cuộn trong rong biển', true, 4.80, 5234),
('Kimbap tham thịt', 100007, 15, '2023-08-20 10:00:00+07', '2025-01-10 14:30:00+07', 'jpg', 'Kimbap thịt thập cẩm với nhiều loại nhân thịt và rau', true, 4.75, 4678),
('Kimbap kimchi', 100007, 15, '2023-11-08 11:30:00+07', '2025-03-25 15:50:00+07', 'jpg', 'Kimbap kimchi chua cay đặc trưng Hàn Quốc', true, 4.65, 3234),
('Kimbap cá ngừ', 100007, 15, '2024-02-22 12:45:00+07', '2025-06-15 16:20:00+07', 'jpg', 'Kimbap cá ngừ với cá ngừ đóng hộp và sốt mayo', false, 4.70, 3890),
('Kimbap rong biển', 100007, 15, '2024-05-18 08:15:00+07', '2025-08-10 13:40:00+07', 'jpg', 'Kimbap rong biển cuốn với rau củ tươi ngon bổ dưỡng', true, 4.50, 2456),
('Bibimbap thịt bò', 100007, 16, '2023-06-20 09:00:00+07', '2024-11-05 12:30:00+07', 'jpg', 'Bibimbap thịt bò với rau củ đầy màu sắc, trứng và sốt gochujang', true, 4.85, 6789),
('Bibimbap hải sản', 100007, 16, '2023-09-10 10:30:00+07', '2025-01-25 14:50:00+07', 'jpg', 'Bibimbap hải sản với tôm, mực và các loại rau củ tươi', true, 4.80, 5678),
('Bibimbap chay', 100007, 16, '2023-12-18 11:45:00+07', '2025-04-10 15:30:00+07', 'jpg', 'Bibimbap chay với rau củ và đậu hũ, không thịt', true, 4.60, 2890),
('Bibimbap gà', 100007, 16, '2024-03-08 12:30:00+07', '2025-06-22 16:15:00+07', 'jpg', 'Bibimbap gà với thịt gà xào và rau củ thơm ngon', true, 4.70, 3678),
('Samgyeopsal nướng', 100007, 17, '2023-07-05 08:00:00+07', '2024-11-20 11:30:00+07', 'jpg', 'Samgyeopsal ba rọi heo Hàn Quốc nướng than hoa thơm lừng', true, 4.90, 7890),
('Samgyeopsal cuộn rau', 100007, 17, '2023-10-22 09:30:00+07', '2025-02-15 14:20:00+07', 'jpg', 'Samgyeopsal cuộn rau xà lách, tỏi và sốt ssamjang', true, 4.85, 6234),
('Samgyeopsal phô mai', 100007, 17, '2024-01-15 11:00:00+07', '2025-04-28 15:45:00+07', 'jpg', 'Samgyeopsal phô mai béo ngậy với phô mai tan chảy', false, 4.75, 4567),
('Samgyeopsal sốt cay', 100007, 17, '2024-04-30 12:30:00+07', '2025-07-18 16:50:00+07', 'jpg', 'Samgyeopsal sốt cay nồng với gochujang đậm đà', true, 4.80, 5678),
('Samgyeopsal marinaded', 100007, 17, '2024-08-15 09:15:00+07', '2025-09-28 13:40:00+07', 'jpg', 'Samgyeopsal ướp gia vị Hàn Quốc thơm ngon đậm vị', true, 4.70, 3890),
('Samgyeopsal combo', 100007, 17, '2024-11-28 12:00:00+07', NULL, 'jpg', 'Samgyeopsal combo với đầy đủ rau sống và sốt Hàn Quốc', true, 4.95, 8234),

-- Seller 100008: Categories 20 (Ramen), 21 (Udon), 22 (Katsudon) - 20 products
('Ramen tonkotsu', 100008, 20, '2023-05-20 08:30:00+07', '2024-09-30 11:45:00+07', 'jpg', 'Ramen tonkotsu với nước dùng xương heo ninh đặc sệt, thơm béo', true, 4.85, 6789),
('Ramen miso', 100008, 20, '2023-08-08 10:00:00+07', '2024-12-20 14:30:00+07', 'jpg', 'Ramen miso với nước dùng miso đậm đà, thịt heo chả sú', true, 4.80, 5678),
('Ramen shoyu', 100008, 20, '2023-11-15 11:30:00+07', '2025-02-25 15:50:00+07', 'jpg', 'Ramen shoyu với nước dùng xì dầu trong vắt, mì dai ngon', true, 4.75, 4567),
('Ramen cay', 100008, 20, '2024-02-05 12:45:00+07', '2025-05-15 16:20:00+07', 'jpg', 'Ramen cay Nhật Bản với ớt đỏ, nước dùng cay nồng', true, 4.70, 3890),
('Ramen hải sản', 100008, 20, '2024-05-22 08:15:00+07', '2025-07-28 13:40:00+07', 'jpg', 'Ramen hải sản với tôm, mực, nghêu và rau củ tươi', true, 4.90, 7890),
('Ramen tsukemen', 100008, 20, '2024-08-10 10:45:00+07', '2025-09-25 14:50:00+07', 'jpg', 'Ramen tsukemen với mì chấm nước dùng đặc sánh đậm đà', false, 4.65, 3234),
('Ramen trứng', 100008, 20, '2024-11-05 11:15:00+07', '2025-10-18 15:30:00+07', 'jpg', 'Ramen trứng với trứng lòng đào ướp tương, mì dai thơm', true, 4.75, 4678),
('Udon nước', 100008, 21, '2023-06-10 08:00:00+07', '2024-10-25 11:30:00+07', 'jpg', 'Udon nước với sợi mì udon dai, nước dùng trong vắt thanh mát', true, 4.70, 3890),
('Udon xào', 100008, 21, '2023-09-22 09:30:00+07', '2025-01-15 14:20:00+07', 'jpg', 'Udon xào với thịt và rau củ, sốt đậm đà thơm ngon', true, 4.75, 4567),
('Udon curry', 100008, 21, '2023-12-10 11:00:00+07', '2025-03-28 15:45:00+07', 'jpg', 'Udon curry Nhật Bản với nước curry đặc sệt thơm lừng', true, 4.80, 5234),
('Udon tempura', 100008, 21, '2024-03-18 12:30:00+07', '2025-06-10 16:50:00+07', 'jpg', 'Udon tempura với tôm tempura giòn rụm, nước dùng ngọt thanh', true, 4.85, 6234),
('Udon nóng', 100008, 21, '2024-06-25 08:45:00+07', '2025-08-20 13:15:00+07', 'jpg', 'Udon nóng với nước dùng sôi, ăn trong mùa đông ấm áp', true, 4.60, 2678),
('Udon lạnh', 100008, 21, '2024-09-15 10:15:00+07', '2025-10-08 14:40:00+07', 'jpg', 'Udon lạnh với mì udon mát lạnh, chấm nước tương thanh mát', false, 4.55, 2456),
('Udon bò', 100008, 21, '2024-12-02 11:45:00+07', NULL, 'jpg', 'Udon bò với thịt bò xào mềm ngon, nước dùng đậm đà', true, 4.70, 3890),
('Katsudon thịt heo', 100008, 22, '2023-06-28 08:15:00+07', '2024-11-10 11:40:00+07', 'jpg', 'Katsudon thịt heo với thịt heo chiên giòn, trứng và nước tương ngọt', true, 4.85, 6789),
('Katsudon gà', 100008, 22, '2023-10-05 09:45:00+07', '2025-02-18 14:30:00+07', 'jpg', 'Katsudon gà với thịt gà chiên giòn, cơm nóng và trứng', true, 4.80, 5678),
('Katsudon bò', 100008, 22, '2024-01-20 11:15:00+07', '2025-04-30 15:50:00+07', 'jpg', 'Katsudon bò với thịt bò chiên giòn, sốt teriyaki đậm đà', true, 4.75, 4567),
('Katsudon cá', 100008, 22, '2024-04-10 12:45:00+07', '2025-07-22 16:20:00+07', 'jpg', 'Katsudon cá với phi lê cá chiên giòn, cơm Nhật mềm dẻo', true, 4.70, 3890),
('Katsudon trứng', 100008, 22, '2024-07-18 08:30:00+07', '2025-09-10 13:40:00+07', 'jpg', 'Katsudon trứng với nhiều trứng, sốt ngọt béo ngậy', false, 4.65, 3234),
('Katsudon đặc biệt', 100008, 22, '2024-10-28 10:00:00+07', '2025-10-20 14:50:00+07', 'jpg', 'Katsudon đặc biệt với thịt heo và nhiều topping hấp dẫn', true, 4.90, 7890),

-- Seller 100009: Category 18 (Takoyaki) - 18 products
('Takoyaki bạch tuộc', 100009, 18, '2023-05-15 08:00:00+07', '2024-09-25 11:30:00+07', 'jpg', 'Takoyaki bạch tuộc Nhật Bản với miếng bạch tuộc tươi, sốt takoyaki đậm đà', true, 4.80, 5678),
('Takoyaki phô mai', 100009, 18, '2023-07-30 09:30:00+07', '2024-12-15 14:20:00+07', 'jpg', 'Takoyaki phô mai với phô mai tan chảy bên trong, béo ngậy thơm ngon', true, 4.85, 6789),
('Takoyaki tôm', 100009, 18, '2023-10-18 11:00:00+07', '2025-02-20 15:45:00+07', 'jpg', 'Takoyaki tôm tươi với tôm tươi ngon, rắc rong biển và bột cá ngừ', true, 4.70, 3890),
('Takoyaki mực', 100009, 18, '2024-01-08 12:30:00+07', '2025-04-25 16:50:00+07', 'jpg', 'Takoyaki mực với mực tươi dai giòn, sốt mayo và sốt takoyaki', true, 4.75, 4567),
('Takoyaki hải sản', 100009, 18, '2024-03-25 08:45:00+07', '2025-07-10 13:15:00+07', 'jpg', 'Takoyaki hải sản với tôm, mực, bạch tuộc đầy đủ', true, 4.90, 7890),
('Takoyaki cay', 100009, 18, '2024-06-12 10:15:00+07', '2025-08-28 14:40:00+07', 'jpg', 'Takoyaki cay với sốt cay nồng, rắc ớt bột đỏ', false, 4.60, 2678),
('Takoyaki truyền thống', 100009, 18, '2024-09-05 11:45:00+07', '2025-10-15 16:20:00+07', 'jpg', 'Takoyaki truyền thống Nhật Bản với công thức gốc', true, 4.85, 6234),
('Takoyaki sốt teriyaki', 100009, 18, '2024-11-22 09:30:00+07', NULL, 'jpg', 'Takoyaki sốt teriyaki ngọt ngào đậm đà thơm lừng', true, 4.65, 3234),
('Takoyaki mini', 100009, 18, '2025-02-10 12:00:00+07', NULL, 'jpg', 'Takoyaki mini size nhỏ xinh, dễ ăn cho trẻ em', true, 4.55, 2456),
('Takoyaki phô mai mozzarella', 100009, 18, '2023-06-20 08:15:00+07', '2024-10-30 11:40:00+07', 'jpg', 'Takoyaki phô mai mozzarella kéo sợi hấp dẫn', true, 4.90, 7234),
('Takoyaki sốt đen', 100009, 18, '2023-09-12 09:45:00+07', '2025-01-25 14:30:00+07', 'jpg', 'Takoyaki sốt đen độc đáo với hương vị đặc biệt', true, 4.70, 3890),
('Takoyaki tương ớt', 100009, 18, '2023-12-05 11:15:00+07', '2025-03-30 15:50:00+07', 'jpg', 'Takoyaki tương ớt cay ngọt đậm đà Nhật Bản', true, 4.65, 3234),
('Takoyaki rong biển', 100009, 18, '2024-02-28 12:45:00+07', '2025-06-18 16:20:00+07', 'jpg', 'Takoyaki rong biển với nhiều rong biển thơm ngon', false, 4.60, 2890),
('Takoyaki cua', 100009, 18, '2024-05-20 08:30:00+07', '2025-08-15 13:40:00+07', 'jpg', 'Takoyaki cua với thịt cua tươi ngon béo ngậy', true, 4.80, 5678),
('Takoyaki bơ', 100009, 18, '2024-08-08 10:00:00+07', '2025-09-28 14:50:00+07', 'jpg', 'Takoyaki bơ thơm béo với bơ tươi tan chảy', true, 4.75, 4567),
('Takoyaki xúc xích', 100009, 18, '2024-10-25 11:30:00+07', '2025-10-18 15:30:00+07', 'jpg', 'Takoyaki xúc xích với xúc xích Nhật thơm ngon', true, 4.70, 3890),
('Takoyaki thập cẩm', 100009, 18, '2025-01-15 09:15:00+07', NULL, 'jpg', 'Takoyaki thập cẩm với nhiều nhân hấp dẫn đa dạng', true, 4.95, 8234),
('Takoyaki trứng', 100009, 18, '2025-03-05 12:00:00+07', NULL, 'jpg', 'Takoyaki trứng với trứng cút bên trong mềm ngon', true, 4.55, 2678),

-- Seller 100010: Categories 23 (Trà sữa), 24 (Cà phê sữa đá), 25 (Trà đào cam sả), 26 (Trà chanh), 27 (Soda chanh) - 29 products
('Trà sữa truyền thống', 100010, 23, '2023-04-25 08:00:00+07', '2024-09-10 11:30:00+07', 'jpg', 'Trà sữa truyền thống với trân châu đen dai ngon, vị ngọt vừa phải', true, 4.75, 4890),
('Trà sữa trân châu đường đen', 100010, 23, '2023-07-10 09:30:00+07', '2024-12-05 14:20:00+07', 'jpg', 'Trà sữa trân châu đường đen thơm ngọt, trân châu mềm dẻo', true, 4.85, 6789),
('Trà sữa matcha', 100010, 23, '2023-10-05 11:00:00+07', '2025-02-18 15:45:00+07', 'jpg', 'Trà sữa matcha Nhật Bản với vị trà xanh đậm đà', true, 4.70, 3890),
('Trà sữa socola', 100010, 23, '2024-01-15 12:30:00+07', '2025-04-30 16:50:00+07', 'jpg', 'Trà sữa socola ngọt ngào béo ngậy thơm lừng', true, 4.80, 5678),
('Trà sữa khoai môn', 100010, 23, '2024-04-05 08:45:00+07', '2025-07-20 13:15:00+07', 'jpg', 'Trà sữa khoai môn với vị khoai môn tím thơm ngon', true, 4.65, 3234),
('Trà sữa dâu', 100010, 23, '2024-06-22 10:15:00+07', '2025-08-30 14:40:00+07', 'jpg', 'Trà sữa dâu tươi mát với trái dâu tây thật', false, 4.60, 2678),
('Cà phê sữa đá', 100010, 24, '2023-05-18 08:15:00+07', '2024-10-25 11:40:00+07', 'jpg', 'Cà phê sữa đá truyền thống Việt Nam đậm đà thơm ngon', true, 4.80, 5678),
('Cà phê đen đá', 100010, 24, '2023-08-12 09:45:00+07', '2025-01-15 14:30:00+07', 'jpg', 'Cà phê đen đá đậm đà nguyên chất, không pha sữa', true, 4.70, 3890),
('Cà phê bạc xỉu', 100010, 24, '2023-11-08 11:15:00+07', '2025-03-28 15:50:00+07', 'jpg', 'Cà phê bạc xỉu ngọt ngào với nhiều sữa ít cà phê', true, 4.75, 4567),
('Cà phê nóng', 100010, 24, '2024-02-20 12:45:00+07', '2025-06-10 16:20:00+07', 'jpg', 'Cà phê nóng thơm nồng đậm đà cho buổi sáng', true, 4.65, 3234),
('Cà phê cốt dừa', 100010, 24, '2024-05-10 08:30:00+07', '2025-08-22 13:40:00+07', 'jpg', 'Cà phê cốt dừa béo ngậy thơm mát độc đáo', true, 4.85, 6234),
('Trà đào cam sả', 100010, 25, '2023-06-08 09:00:00+07', '2024-11-20 12:30:00+07', 'jpg', 'Trà đào cam sả tươi mát với đào, cam và sả thơm ngon', true, 4.90, 7890),
('Trà đào', 100010, 25, '2023-09-15 10:30:00+07', '2025-02-05 14:50:00+07', 'jpg', 'Trà đào ngọt mát với đào tươi ngon cắt múi', true, 4.75, 4678),
('Trà cam sả', 100010, 25, '2023-12-22 11:45:00+07', '2025-04-18 15:30:00+07', 'jpg', 'Trà cam sả thơm mát với cam tươi và sả thơm', true, 4.70, 3890),
('Trà đào chanh sả', 100010, 25, '2024-03-12 12:30:00+07', '2025-06-28 16:15:00+07', 'jpg', 'Trà đào chanh sả tươi mát chua ngọt hài hòa', false, 4.80, 5678),
('Trà đào vải', 100010, 25, '2024-06-05 08:45:00+07', '2025-08-18 13:20:00+07', 'jpg', 'Trà đào vải ngọt mát với đào và vải tươi', true, 4.65, 3234),
('Trà chanh', 100010, 26, '2023-05-25 08:00:00+07', '2024-10-10 11:30:00+07', 'jpg', 'Trà chanh tươi mát chua ngọt giải khát tuyệt vời', true, 4.70, 3890),
('Trà chanh dây', 100010, 26, '2023-08-20 09:30:00+07', '2025-01-05 14:20:00+07', 'jpg', 'Trà chanh dây thơm ngon với chanh dây chua chua', true, 4.75, 4567),
('Trà chanh giã tay', 100010, 26, '2023-11-15 11:00:00+07', '2025-03-20 15:45:00+07', 'jpg', 'Trà chanh giã tay truyền thống với chanh và đường', true, 4.65, 3234),
('Trà chanh muối', 100010, 26, '2024-02-08 12:30:00+07', '2025-05-28 16:50:00+07', 'jpg', 'Trà chanh muối độc đáo với chanh ngâm muối', true, 4.60, 2678),
('Trà chanh bạc hà', 100010, 26, '2024-05-18 08:45:00+07', '2025-08-10 13:15:00+07', 'jpg', 'Trà chanh bạc hà mát lạnh thơm ngon giải nhiệt', false, 4.80, 5678),
('Trà chanh vàng', 100010, 26, '2024-08-25 10:15:00+07', '2025-09-30 14:40:00+07', 'jpg', 'Trà chanh vàng tươi với chanh vàng ngọt thơm', true, 4.55, 2456),
('Soda chanh', 100010, 27, '2023-06-15 08:15:00+07', '2024-11-05 11:40:00+07', 'jpg', 'Soda chanh sảng khoái với chanh tươi và soda', true, 4.75, 4567),
('Soda chanh dây', 100010, 27, '2023-09-28 09:45:00+07', '2025-02-10 14:30:00+07', 'jpg', 'Soda chanh dây thơm mát với chanh dây chua ngọt', true, 4.70, 3890),
('Soda bạc hà chanh', 100010, 27, '2024-01-05 11:15:00+07', '2025-04-22 15:50:00+07', 'jpg', 'Soda bạc hà chanh mát lạnh sảng khoái tuyệt vời', true, 4.80, 5678),
('Soda blue curacao', 100010, 27, '2024-03-28 12:45:00+07', '2025-07-15 16:20:00+07', 'jpg', 'Soda blue curacao màu xanh đẹp mắt ngọt mát', true, 4.65, 3234),
('Soda việt quất', 100010, 27, '2024-06-18 08:30:00+07', '2025-08-28 13:40:00+07', 'jpg', 'Soda việt quất tím đẹp với vị việt quất thơm ngon', false, 4.85, 6234),
('Soda dâu', 100010, 27, '2024-09-10 10:00:00+07', '2025-10-15 14:50:00+07', 'jpg', 'Soda dâu ngọt mát với dâu tây tươi ngon', true, 4.60, 2890),
('Soda cam', 100010, 27, '2024-12-05 11:30:00+07', NULL, 'jpg', 'Soda cam tươi mát với nước cam vắt tươi', true, 4.75, 4678);

-- Product variation
-- 100000: Hủ tiếu Nam Vang (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100000, '2023-03-15 09:00:00+07', '2023-05-20 14:30:00+07', 'jpg', 'nhỏ', 'thường', 35000.00),
(100000, '2023-03-15 09:00:00+07', '2023-06-10 11:20:00+07', 'jpg', 'nhỏ', 'đặc biệt', 45000.00),
(100000, '2023-03-15 09:00:00+07', '2023-07-15 16:45:00+07', 'jpg', 'vừa', 'thường', 45000.00),
(100000, '2023-03-15 09:00:00+07', '2023-08-22 10:15:00+07', 'jpg', 'vừa', 'đặc biệt', 55000.00),
(100000, '2023-03-15 09:00:00+07', '2024-01-18 13:30:00+07', 'jpg', 'lớn', 'thường', 55000.00),
(100000, '2023-03-15 09:00:00+07', '2024-03-25 09:40:00+07', 'jpg', 'lớn', 'đặc biệt', 65000.00);

-- 100001: Hủ tiếu Mỹ Tho (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100001, '2023-04-10 10:15:00+07', '2023-06-05 15:20:00+07', 'jpg', 'nhỏ', 'khô', 35000.00),
(100001, '2023-04-10 10:15:00+07', '2023-07-12 11:30:00+07', 'jpg', 'nhỏ', 'nước', 35000.00),
(100001, '2023-04-10 10:15:00+07', '2023-09-08 14:45:00+07', 'jpg', 'vừa', 'khô', 45000.00),
(100001, '2023-04-10 10:15:00+07', '2023-11-20 10:00:00+07', 'jpg', 'vừa', 'nước', 45000.00),
(100001, '2023-04-10 10:15:00+07', '2024-02-14 16:30:00+07', 'jpg', 'lớn', 'khô', 55000.00),
(100001, '2023-04-10 10:15:00+07', '2024-05-22 12:15:00+07', 'jpg', 'lớn', 'nước', 55000.00);

-- 100002: Hủ tiếu xào hải sản (2 sizes × 3 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100002, '2023-06-20 12:30:00+07', '2023-08-15 14:20:00+07', 'jpg', 'vừa', 'cay vừa', 55000.00),
(100002, '2023-06-20 12:30:00+07', '2023-09-10 11:45:00+07', 'jpg', 'vừa', 'cay nhiều', 55000.00),
(100002, '2023-06-20 12:30:00+07', '2023-10-22 15:30:00+07', 'jpg', 'vừa', 'không cay', 55000.00),
(100002, '2023-06-20 12:30:00+07', '2024-01-08 13:20:00+07', 'jpg', 'lớn', 'cay vừa', 70000.00),
(100002, '2023-06-20 12:30:00+07', '2024-03-19 10:40:00+07', 'jpg', 'lớn', 'cay nhiều', 70000.00),
(100002, '2023-06-20 12:30:00+07', '2024-06-11 14:55:00+07', 'jpg', 'lớn', 'không cay', 70000.00);

-- 100003: Hủ tiếu khô (3 sizes × 1 variation = 3 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100003, '2023-07-05 08:00:00+07', '2023-09-14 11:30:00+07', 'jpg', 'nhỏ', 'default', 30000.00),
(100003, '2023-07-05 08:00:00+07', '2023-11-22 15:45:00+07', 'jpg', 'vừa', 'default', 40000.00),
(100003, '2023-07-05 08:00:00+07', '2024-02-28 13:20:00+07', 'jpg', 'lớn', 'default', 50000.00);

-- 100004: Hủ tiếu bò kho (2 sizes × 2 variations = 4 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100004, '2024-01-12 14:00:00+07', '2024-03-15 10:30:00+07', 'jpg', 'vừa', 'ít cay', 50000.00),
(100004, '2024-01-12 14:00:00+07', '2024-05-08 14:45:00+07', 'jpg', 'vừa', 'cay thơm', 50000.00),
(100004, '2024-01-12 14:00:00+07', '2024-07-20 11:20:00+07', 'jpg', 'lớn', 'ít cay', 65000.00),
(100004, '2024-01-12 14:00:00+07', '2024-09-12 16:10:00+07', 'jpg', 'lớn', 'cay thơm', 65000.00);

-- 100005: Hủ tiếu gà (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100005, '2024-03-22 11:15:00+07', '2024-05-10 13:40:00+07', 'jpg', 'nhỏ', 'gà luộc', 35000.00),
(100005, '2024-03-22 11:15:00+07', '2024-06-18 10:25:00+07', 'jpg', 'nhỏ', 'gà xé', 38000.00),
(100005, '2024-03-22 11:15:00+07', '2024-07-25 15:30:00+07', 'jpg', 'vừa', 'gà luộc', 45000.00),
(100005, '2024-03-22 11:15:00+07', '2024-08-14 12:15:00+07', 'jpg', 'vừa', 'gà xé', 48000.00),
(100005, '2024-03-22 11:15:00+07', '2024-09-22 14:50:00+07', 'jpg', 'lớn', 'gà luộc', 55000.00),
(100005, '2024-03-22 11:15:00+07', '2024-10-05 11:35:00+07', 'jpg', 'lớn', 'gà xé', 58000.00);

-- 100006: Bún bò Huế (3 sizes × 3 variations = 9 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100006, '2023-05-08 08:45:00+07', '2023-07-16 13:20:00+07', 'jpg', 'nhỏ', 'ít cay', 40000.00),
(100006, '2023-05-08 08:45:00+07', '2023-08-22 10:35:00+07', 'jpg', 'nhỏ', 'cay vừa', 40000.00),
(100006, '2023-05-08 08:45:00+07', '2023-10-11 15:45:00+07', 'jpg', 'nhỏ', 'cay nhiều', 40000.00),
(100006, '2023-05-08 08:45:00+07', '2023-12-05 11:50:00+07', 'jpg', 'vừa', 'ít cay', 50000.00),
(100006, '2023-05-08 08:45:00+07', '2024-02-14 14:25:00+07', 'jpg', 'vừa', 'cay vừa', 50000.00),
(100006, '2023-05-08 08:45:00+07', '2024-04-20 10:40:00+07', 'jpg', 'vừa', 'cay nhiều', 50000.00),
(100006, '2023-05-08 08:45:00+07', '2024-06-12 16:15:00+07', 'jpg', 'lớn', 'ít cay', 60000.00),
(100006, '2023-05-08 08:45:00+07', '2024-08-08 13:30:00+07', 'jpg', 'lớn', 'cay vừa', 60000.00),
(100006, '2023-05-08 08:45:00+07', '2024-09-25 11:55:00+07', 'jpg', 'lớn', 'cay nhiều', 60000.00);

-- 100007: Bún riêu cua (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100007, '2023-08-14 10:00:00+07', '2023-10-18 14:30:00+07', 'jpg', 'nhỏ', 'riêu thường', 35000.00),
(100007, '2023-08-14 10:00:00+07', '2023-11-25 11:45:00+07', 'jpg', 'nhỏ', 'riêu đặc biệt', 45000.00),
(100007, '2023-08-14 10:00:00+07', '2024-01-16 15:20:00+07', 'jpg', 'vừa', 'riêu thường', 45000.00),
(100007, '2023-08-14 10:00:00+07', '2024-03-22 13:35:00+07', 'jpg', 'vừa', 'riêu đặc biệt', 55000.00),
(100007, '2023-08-14 10:00:00+07', '2024-06-10 10:50:00+07', 'jpg', 'lớn', 'riêu thường', 55000.00),
(100007, '2023-08-14 10:00:00+07', '2024-08-20 14:15:00+07', 'jpg', 'lớn', 'riêu đặc biệt', 65000.00);

-- 100008: Bún thịt nướng (2 sizes × 2 variations = 4 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100008, '2023-09-25 11:30:00+07', '2023-11-14 15:40:00+07', 'jpg', 'vừa', 'không chả giò', 45000.00),
(100008, '2023-09-25 11:30:00+07', '2024-01-08 13:25:00+07', 'jpg', 'vừa', 'kèm chả giò', 55000.00),
(100008, '2023-09-25 11:30:00+07', '2024-03-19 10:55:00+07', 'jpg', 'lớn', 'không chả giò', 60000.00),
(100008, '2023-09-25 11:30:00+07', '2024-06-05 14:20:00+07', 'jpg', 'lớn', 'kèm chả giò', 70000.00);

-- 100009: Bún chả Hà Nội (1 size × 3 variations = 3 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100009, '2024-02-10 13:30:00+07', '2024-04-15 11:40:00+07', 'jpg', 'default', 'chả viên', 50000.00),
(100009, '2024-02-10 13:30:00+07', '2024-06-20 15:25:00+07', 'jpg', 'default', 'chả miếng', 50000.00),
(100009, '2024-02-10 13:30:00+07', '2024-08-12 13:50:00+07', 'jpg', 'default', 'chả hỗn hợp', 55000.00);

-- 100010: Bún măng vịt (3 sizes × 1 variation = 3 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100010, '2024-05-18 09:00:00+07', '2024-07-10 14:30:00+07', 'jpg', 'nhỏ', 'default', 45000.00),
(100010, '2024-05-18 09:00:00+07', '2024-08-22 11:45:00+07', 'jpg', 'vừa', 'default', 60000.00),
(100010, '2024-05-18 09:00:00+07', '2024-09-30 15:20:00+07', 'jpg', 'lớn', 'default', 75000.00);

-- 100011: Bún mắm (2 sizes × 2 variations = 4 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100011, '2024-07-03 10:45:00+07', '2024-08-18 13:30:00+07', 'jpg', 'vừa', 'ít mắm', 50000.00),
(100011, '2024-07-03 10:45:00+07', '2024-09-12 15:45:00+07', 'jpg', 'vừa', 'đậm đà', 50000.00),
(100011, '2024-07-03 10:45:00+07', '2024-10-08 11:20:00+07', 'jpg', 'lớn', 'ít mắm', 65000.00),
(100011, '2024-07-03 10:45:00+07', '2024-10-15 14:35:00+07', 'jpg', 'lớn', 'đậm đà', 65000.00);

-- 100012: Phở bò tái (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100012, '2023-03-20 08:15:00+07', '2023-05-22 13:40:00+07', 'jpg', 'nhỏ', 'nước lèo thường', 40000.00),
(100012, '2023-03-20 08:15:00+07', '2023-07-10 10:55:00+07', 'jpg', 'nhỏ', 'nước lèo đặc', 42000.00),
(100012, '2023-03-20 08:15:00+07', '2023-09-15 14:20:00+07', 'jpg', 'vừa', 'nước lèo thường', 50000.00),
(100012, '2023-03-20 08:15:00+07', '2023-11-28 11:35:00+07', 'jpg', 'vừa', 'nước lèo đặc', 52000.00),
(100012, '2023-03-20 08:15:00+07', '2024-02-14 15:50:00+07', 'jpg', 'lớn', 'nước lèo thường', 60000.00),
(100012, '2023-03-20 08:15:00+07', '2024-04-22 13:25:00+07', 'jpg', 'lớn', 'nước lèo đặc', 62000.00);

-- 100013: Phở bò chín (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100013, '2023-06-12 10:30:00+07', '2023-08-16 14:45:00+07', 'jpg', 'nhỏ', 'bò nạc', 40000.00),
(100013, '2023-06-12 10:30:00+07', '2023-10-05 11:20:00+07', 'jpg', 'nhỏ', 'bò gân', 42000.00),
(100013, '2023-06-12 10:30:00+07', '2023-12-12 15:35:00+07', 'jpg', 'vừa', 'bò nạc', 50000.00),
(100013, '2023-06-12 10:30:00+07', '2024-02-20 13:50:00+07', 'jpg', 'vừa', 'bò gân', 52000.00),
(100013, '2023-06-12 10:30:00+07', '2024-05-08 10:40:00+07', 'jpg', 'lớn', 'bò nạc', 60000.00),
(100013, '2023-06-12 10:30:00+07', '2024-07-18 14:15:00+07', 'jpg', 'lớn', 'bò gân', 62000.00);

-- 100014: Phở bò viên (3 sizes × 1 variation = 3 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100014, '2023-09-18 11:45:00+07', '2023-11-22 15:30:00+07', 'jpg', 'nhỏ', 'default', 38000.00),
(100014, '2023-09-18 11:45:00+07', '2024-01-16 13:45:00+07', 'jpg', 'vừa', 'default', 48000.00),
(100014, '2023-09-18 11:45:00+07', '2024-04-10 11:20:00+07', 'jpg', 'lớn', 'default', 58000.00);

-- 100015: Phở gà (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100015, '2024-01-05 09:15:00+07', '2024-03-12 14:30:00+07', 'jpg', 'nhỏ', 'gà ta', 42000.00),
(100015, '2024-01-05 09:15:00+07', '2024-05-08 11:45:00+07', 'jpg', 'nhỏ', 'gà công nghiệp', 38000.00),
(100015, '2024-01-05 09:15:00+07', '2024-06-20 15:20:00+07', 'jpg', 'vừa', 'gà ta', 52000.00),
(100015, '2024-01-05 09:15:00+07', '2024-07-25 13:35:00+07', 'jpg', 'vừa', 'gà công nghiệp', 48000.00),
(100015, '2024-01-05 09:15:00+07', '2024-09-10 10:50:00+07', 'jpg', 'lớn', 'gà ta', 62000.00),
(100015, '2024-01-05 09:15:00+07', '2024-10-02 14:40:00+07', 'jpg', 'lớn', 'gà công nghiệp', 58000.00);

-- 100016: Phở tái nạm gân (3 sizes × 2 variations = 6 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100016, '2024-04-15 12:45:00+07', '2024-06-10 15:30:00+07', 'jpg', 'nhỏ', 'nhiều tái', 48000.00),
(100016, '2024-04-15 12:45:00+07', '2024-07-18 13:45:00+07', 'jpg', 'nhỏ', 'nhiều gân', 48000.00),
(100016, '2024-04-15 12:45:00+07', '2024-08-22 11:20:00+07', 'jpg', 'vừa', 'nhiều tái', 58000.00),
(100016, '2024-04-15 12:45:00+07', '2024-09-15 14:35:00+07', 'jpg', 'vừa', 'nhiều gân', 58000.00),
(100016, '2024-04-15 12:45:00+07', '2024-10-05 10:50:00+07', 'jpg', 'lớn', 'nhiều tái', 68000.00),
(100016, '2024-04-15 12:45:00+07', '2024-10-12 15:15:00+07', 'jpg', 'lớn', 'nhiều gân', 68000.00);

-- 100017: Phở đặc biệt (3 sizes × 3 variations = 9 records)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100017, '2024-08-22 11:30:00+07', '2024-09-10 14:45:00+07', 'jpg', 'nhỏ', 'không hành', 55000.00),
(100017, '2024-08-22 11:30:00+07', '2024-09-18 11:20:00+07', 'jpg', 'nhỏ', 'hành lá', 55000.00),
(100017, '2024-08-22 11:30:00+07', '2024-09-25 15:35:00+07', 'jpg', 'nhỏ', 'hành nấm', 58000.00),
(100017, '2024-08-22 11:30:00+07', '2024-10-02 13:50:00+07', 'jpg', 'vừa', 'không hành', 65000.00),
(100017, '2024-08-22 11:30:00+07', '2024-10-08 10:40:00+07', 'jpg', 'vừa', 'hành lá', 65000.00),
(100017, '2024-08-22 11:30:00+07', '2024-10-12 14:25:00+07', 'jpg', 'vừa', 'hành nấm', 68000.00),
(100017, '2024-08-22 11:30:00+07', '2024-10-15 11:55:00+07', 'jpg', 'lớn', 'không hành', 75000.00),
(100017, '2024-08-22 11:30:00+07', '2024-10-18 15:10:00+07', 'jpg', 'lớn', 'hành lá', 75000.00),
(100017, '2024-08-22 11:30:00+07', '2024-10-20 13:30:00+07', 'jpg', 'lớn', 'hành nấm', 78000.00);

-- 100018: Cơm tấm sườn bì chả (Broken rice with pork chop, shredded pork skin, and pork cake)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100018, '2023-04-08 10:30:00+07', '2023-06-15 14:20:00+07', 'jpg', 'nhỏ', 'không nước ngọt', 35000.00),
(100018, '2023-04-08 10:30:00+07', '2023-07-22 16:45:00+07', 'jpg', 'nhỏ', 'combo nước ngọt', 42000.00),
(100018, '2023-04-08 10:30:00+07', '2023-08-10 11:30:00+07', 'jpg', 'vừa', 'không nước ngọt', 45000.00),
(100018, '2023-04-08 10:30:00+07', '2023-09-05 15:10:00+07', 'jpg', 'vừa', 'combo nước ngọt', 52000.00),
(100018, '2023-04-08 10:30:00+07', '2024-01-20 13:25:00+07', 'jpg', 'lớn', 'không nước ngọt', 55000.00),
(100018, '2023-04-08 10:30:00+07', '2024-03-18 10:40:00+07', 'jpg', 'lớn', 'combo nước ngọt', 62000.00);

-- 100019: Cơm tấm sườn nướng (Broken rice with grilled pork chop)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100019, '2023-05-20 11:15:00+07', '2023-07-08 14:30:00+07', 'jpg', 'nhỏ', 'không nước ngọt', 32000.00),
(100019, '2023-05-20 11:15:00+07', '2023-08-14 16:20:00+07', 'jpg', 'nhỏ', 'combo nước ngọt', 39000.00),
(100019, '2023-05-20 11:15:00+07', '2023-10-25 12:45:00+07', 'jpg', 'vừa', 'không nước ngọt', 42000.00),
(100019, '2023-05-20 11:15:00+07', '2024-02-10 15:30:00+07', 'jpg', 'vừa', 'combo nước ngọt', 49000.00),
(100019, '2023-05-20 11:15:00+07', '2024-05-22 11:10:00+07', 'jpg', 'lớn', 'không nước ngọt', 52000.00),
(100019, '2023-05-20 11:15:00+07', '2024-08-15 14:55:00+07', 'jpg', 'lớn', 'combo nước ngọt', 59000.00);

-- 100020: Cơm tấm bì (Broken rice with shredded pork skin)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100020, '2023-07-15 13:00:00+07', '2023-09-20 15:40:00+07', 'jpg', 'default', 'không nước ngọt', 28000.00),
(100020, '2023-07-15 13:00:00+07', '2023-11-12 10:25:00+07', 'jpg', 'default', 'combo nước ngọt', 35000.00);

-- 100021: Cơm tấm gà nướng (Broken rice with grilled chicken)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100021, '2023-10-03 14:30:00+07', '2023-11-28 16:15:00+07', 'jpg', 'nhỏ', 'không nước ngọt', 35000.00),
(100021, '2023-10-03 14:30:00+07', '2024-01-05 12:40:00+07', 'jpg', 'nhỏ', 'combo nước ngọt', 42000.00),
(100021, '2023-10-03 14:30:00+07', '2024-03-22 14:20:00+07', 'jpg', 'vừa', 'không nước ngọt', 45000.00),
(100021, '2023-10-03 14:30:00+07', '2024-06-18 11:50:00+07', 'jpg', 'vừa', 'combo nước ngọt', 52000.00);

-- 100022: Cơm tấm sườn bì (Broken rice with pork chop and shredded pork skin)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100022, '2024-01-18 10:00:00+07', '2024-03-25 15:30:00+07', 'jpg', 'nhỏ', 'không nước ngọt', 33000.00),
(100022, '2024-01-18 10:00:00+07', '2024-05-14 13:20:00+07', 'jpg', 'nhỏ', 'combo nước ngọt', 40000.00),
(100022, '2024-01-18 10:00:00+07', '2024-07-20 16:45:00+07', 'jpg', 'vừa', 'không nước ngọt', 43000.00),
(100022, '2024-01-18 10:00:00+07', '2024-09-10 11:15:00+07', 'jpg', 'vừa', 'combo nước ngọt', 50000.00);

-- 100023: Cơm tấm chả trứng (Broken rice with egg meatloaf)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100023, '2024-03-25 11:45:00+07', '2024-05-18 14:30:00+07', 'jpg', 'default', 'không nước ngọt', 30000.00),
(100023, '2024-03-25 11:45:00+07', '2024-07-08 16:20:00+07', 'jpg', 'default', 'combo nước ngọt', 37000.00);

-- 100024: Cơm tấm tứ quý (Broken rice with four treasures - premium combination)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100024, '2024-06-10 13:15:00+07', '2024-08-05 15:40:00+07', 'jpg', 'nhỏ', 'không nước ngọt', 42000.00),
(100024, '2024-06-10 13:15:00+07', '2024-09-22 12:25:00+07', 'jpg', 'nhỏ', 'combo nước ngọt', 49000.00),
(100024, '2024-06-10 13:15:00+07', '2025-01-15 14:10:00+07', 'jpg', 'vừa', 'không nước ngọt', 52000.00),
(100024, '2024-06-10 13:15:00+07', '2025-03-10 16:35:00+07', 'jpg', 'vừa', 'combo nước ngọt', 59000.00),
(100024, '2024-06-10 13:15:00+07', '2025-05-20 11:50:00+07', 'jpg', 'lớn', 'không nước ngọt', 62000.00),
(100024, '2024-06-10 13:15:00+07', '2025-07-28 13:45:00+07', 'jpg', 'lớn', 'combo nước ngọt', 69000.00);

-- 100025: Cơm tấm sườn cây (Broken rice with rib on stick)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100025, '2024-09-05 11:00:00+07', '2024-10-22 14:20:00+07', 'jpg', 'nhỏ', 'không nước ngọt', 38000.00),
(100025, '2024-09-05 11:00:00+07', '2025-01-08 16:10:00+07', 'jpg', 'nhỏ', 'combo nước ngọt', 45000.00),
(100025, '2024-09-05 11:00:00+07', '2025-03-18 12:35:00+07', 'jpg', 'vừa', 'không nước ngọt', 48000.00),
(100025, '2024-09-05 11:00:00+07', '2025-06-05 15:50:00+07', 'jpg', 'vừa', 'combo nước ngọt', 55000.00);

-- 100026: Cơm tấm gà xối mỡ (Broken rice with poached chicken)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100026, '2024-11-12 13:30:00+07', '2025-01-20 15:45:00+07', 'jpg', 'default', 'không nước ngọt', 36000.00),
(100026, '2024-11-12 13:30:00+07', '2025-03-15 12:20:00+07', 'jpg', 'default', 'combo nước ngọt', 43000.00);

-- 100027: Bánh mì thịt (Vietnamese sandwich with pork)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100027, '2023-03-25 09:20:00+07', '2023-05-10 14:35:00+07', 'jpg', 'default', 'đầy đủ rau', 20000.00),
(100027, '2023-03-25 09:20:00+07', '2023-07-18 16:40:00+07', 'jpg', 'default', 'ít rau', 20000.00),
(100027, '2023-03-25 09:20:00+07', '2023-09-22 11:25:00+07', 'jpg', 'default', 'không rau', 20000.00);

-- 100028: Bánh mì xíu mại (Vietnamese sandwich with meatballs)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100028, '2023-06-18 10:45:00+07', '2023-08-05 15:20:00+07', 'jpg', 'default', 'đầy đủ rau', 22000.00),
(100028, '2023-06-18 10:45:00+07', '2023-10-12 13:40:00+07', 'jpg', 'default', 'ít rau', 22000.00),
(100028, '2023-06-18 10:45:00+07', '2024-01-08 16:15:00+07', 'jpg', 'default', 'không rau', 22000.00);

-- 100029: Bánh mì pate (Vietnamese sandwich with pate)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100029, '2023-08-22 12:15:00+07', '2023-10-18 14:50:00+07', 'jpg', 'default', 'đầy đủ rau', 18000.00),
(100029, '2023-08-22 12:15:00+07', '2024-01-05 11:30:00+07', 'jpg', 'default', 'ít rau', 18000.00),
(100029, '2023-08-22 12:15:00+07', '2024-03-22 15:45:00+07', 'jpg', 'default', 'không rau', 18000.00);

-- 100030: Bánh mì trứng ốp la (Vietnamese sandwich with fried egg)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100030, '2023-11-05 13:20:00+07', '2024-01-15 16:35:00+07', 'jpg', 'default', 'đầy đủ rau', 19000.00),
(100030, '2023-11-05 13:20:00+07', '2024-03-08 12:10:00+07', 'jpg', 'default', 'ít rau', 19000.00),
(100030, '2023-11-05 13:20:00+07', '2024-05-20 14:25:00+07', 'jpg', 'default', 'không rau', 19000.00);

-- 100031: Bánh mì gà (Vietnamese sandwich with chicken)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100031, '2024-02-14 10:00:00+07', '2024-04-10 15:40:00+07', 'jpg', 'default', 'đầy đủ rau', 23000.00),
(100031, '2024-02-14 10:00:00+07', '2024-06-18 13:20:00+07', 'jpg', 'default', 'ít rau', 23000.00),
(100031, '2024-02-14 10:00:00+07', '2024-08-25 16:50:00+07', 'jpg', 'default', 'không rau', 23000.00);

-- 100032: Bánh mì chả cá (Vietnamese sandwich with fish cake)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100032, '2024-05-20 11:30:00+07', '2024-07-15 14:45:00+07', 'jpg', 'default', 'đầy đủ rau', 25000.00),
(100032, '2024-05-20 11:30:00+07', '2024-09-08 12:15:00+07', 'jpg', 'default', 'ít rau', 25000.00),
(100032, '2024-05-20 11:30:00+07', '2025-01-20 15:30:00+07', 'jpg', 'default', 'không rau', 25000.00);

-- 100033: Bánh mì thập cẩm (Vietnamese sandwich with mixed ingredients)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100033, '2024-07-28 14:00:00+07', '2024-09-22 16:20:00+07', 'jpg', 'default', 'đầy đủ rau', 28000.00),
(100033, '2024-07-28 14:00:00+07', '2024-11-15 13:45:00+07', 'jpg', 'default', 'ít rau', 28000.00),
(100033, '2024-07-28 14:00:00+07', '2025-02-08 11:10:00+07', 'jpg', 'default', 'không rau', 28000.00);

-- 100034: Bánh mì bò kho (Vietnamese sandwich with beef stew)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100034, '2024-10-15 11:20:00+07', '2024-12-10 15:35:00+07', 'jpg', 'default', 'đầy đủ rau', 30000.00),
(100034, '2024-10-15 11:20:00+07', '2025-02-18 13:50:00+07', 'jpg', 'default', 'ít rau', 30000.00),
(100034, '2024-10-15 11:20:00+07', '2025-04-25 16:15:00+07', 'jpg', 'default', 'không rau', 30000.00);

-- 100035: Bánh mì ốp let (Vietnamese sandwich with omelet)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100035, '2025-01-08 12:45:00+07', '2025-03-15 15:20:00+07', 'jpg', 'default', 'đầy đủ rau', 21000.00),
(100035, '2025-01-08 12:45:00+07', '2025-05-22 14:10:00+07', 'jpg', 'default', 'ít rau', 21000.00),
(100035, '2025-01-08 12:45:00+07', '2025-08-10 11:35:00+07', 'jpg', 'default', 'không rau', 21000.00);

-- Product 100036: Cháo lòng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100036, '2023-04-12 10:00:00+07', '2023-05-20 14:30:00+07', 'jpg', 'nhỏ', 'không trứng', 25000.00),
(100036, '2023-04-12 10:00:00+07', '2023-06-15 09:45:00+07', 'jpg', 'nhỏ', 'có trứng', 30000.00),
(100036, '2023-04-12 10:00:00+07', '2023-07-10 11:20:00+07', 'jpg', 'vừa', 'không trứng', 35000.00),
(100036, '2023-04-12 10:00:00+07', '2023-08-05 16:00:00+07', 'jpg', 'vừa', 'có trứng', 40000.00),
(100036, '2023-04-12 10:00:00+07', '2023-09-12 10:30:00+07', 'jpg', 'lớn', 'không trứng', 45000.00),
(100036, '2023-04-12 10:00:00+07', '2023-10-01 13:15:00+07', 'jpg', 'lớn', 'có trứng', 50000.00);

-- Product 100037: Cháo gà
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100037, '2023-06-25 11:00:00+07', '2023-07-30 15:20:00+07', 'jpg', 'nhỏ', 'gà xé', 28000.00),
(100037, '2023-06-25 11:00:00+07', '2023-08-15 10:45:00+07', 'jpg', 'nhỏ', 'gà nguyên miếng', 32000.00),
(100037, '2023-06-25 11:00:00+07', '2023-09-20 14:00:00+07', 'jpg', 'vừa', 'gà xé', 38000.00),
(100037, '2023-06-25 11:00:00+07', '2023-10-05 09:30:00+07', 'jpg', 'vừa', 'gà nguyên miếng', 42000.00),
(100037, '2023-06-25 11:00:00+07', '2023-11-10 16:45:00+07', 'jpg', 'lớn', 'gà xé', 48000.00),
(100037, '2023-06-25 11:00:00+07', '2023-12-01 11:20:00+07', 'jpg', 'lớn', 'gà nguyên miếng', 52000.00);

-- Product 100038: Cháo vịt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100038, '2023-09-08 12:30:00+07', '2023-10-15 13:40:00+07', 'jpg', 'nhỏ', 'default', 30000.00),
(100038, '2023-09-08 12:30:00+07', '2023-11-20 10:15:00+07', 'jpg', 'vừa', 'default', 40000.00),
(100038, '2023-09-08 12:30:00+07', '2023-12-05 14:50:00+07', 'jpg', 'lớn', 'default', 50000.00);

-- Product 100039: Cháo hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100039, '2023-12-20 14:00:00+07', '2024-01-15 11:30:00+07', 'jpg', 'nhỏ', 'tôm mực', 35000.00),
(100039, '2023-12-20 14:00:00+07', '2024-02-10 15:20:00+07', 'jpg', 'nhỏ', 'đầy đủ hải sản', 45000.00),
(100039, '2023-12-20 14:00:00+07', '2024-03-05 09:45:00+07', 'jpg', 'vừa', 'tôm mực', 45000.00),
(100039, '2023-12-20 14:00:00+07', '2024-04-01 13:10:00+07', 'jpg', 'vừa', 'đầy đủ hải sản', 55000.00),
(100039, '2023-12-20 14:00:00+07', '2024-05-10 16:30:00+07', 'jpg', 'lớn', 'tôm mực', 55000.00),
(100039, '2023-12-20 14:00:00+07', '2024-06-15 10:00:00+07', 'jpg', 'lớn', 'đầy đủ hải sản', 65000.00);

-- Product 100040: Cháo cá lóc
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100040, '2024-03-10 10:15:00+07', '2024-04-20 14:25:00+07', 'jpg', 'nhỏ', 'default', 32000.00),
(100040, '2024-03-10 10:15:00+07', '2024-05-15 11:40:00+07', 'jpg', 'vừa', 'default', 42000.00),
(100040, '2024-03-10 10:15:00+07', '2024-06-10 09:50:00+07', 'jpg', 'lớn', 'default', 52000.00);

-- Product 100041: Cháo sườn
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100041, '2024-05-22 13:00:00+07', '2024-06-25 15:30:00+07', 'jpg', 'nhỏ', 'sườn non', 35000.00),
(100041, '2024-05-22 13:00:00+07', '2024-07-15 10:20:00+07', 'jpg', 'nhỏ', 'sườn già', 38000.00),
(100041, '2024-05-22 13:00:00+07', '2024-08-10 14:45:00+07', 'jpg', 'vừa', 'sườn non', 45000.00),
(100041, '2024-05-22 13:00:00+07', '2024-09-05 11:15:00+07', 'jpg', 'vừa', 'sườn già', 48000.00),
(100041, '2024-05-22 13:00:00+07', '2024-10-01 16:00:00+07', 'jpg', 'lớn', 'sườn non', 55000.00),
(100041, '2024-05-22 13:00:00+07', '2024-10-15 09:30:00+07', 'jpg', 'lớn', 'sườn già', 58000.00);

-- Product 100042: Cháo tim gà
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100042, '2024-08-05 10:30:00+07', '2024-09-10 13:20:00+07', 'jpg', 'nhỏ', 'default', 25000.00),
(100042, '2024-08-05 10:30:00+07', '2024-10-05 15:40:00+07', 'jpg', 'vừa', 'default', 35000.00);

-- Product 100043: Cháo trứng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100043, '2024-10-18 11:45:00+07', '2024-10-22 10:30:00+07', 'jpg', 'default', 'default', 20000.00);

-- Product 100044: Cháo bò
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100044, '2025-02-08 14:15:00+07', '2025-03-10 12:20:00+07', 'jpg', 'nhỏ', 'bò băm', 30000.00),
(100044, '2025-02-08 14:15:00+07', '2025-04-05 15:30:00+07', 'jpg', 'nhỏ', 'bò thái lát', 35000.00),
(100044, '2025-02-08 14:15:00+07', '2025-05-15 10:45:00+07', 'jpg', 'vừa', 'bò băm', 40000.00),
(100044, '2025-02-08 14:15:00+07', '2025-06-20 14:00:00+07', 'jpg', 'vừa', 'bò thái lát', 45000.00),
(100044, '2025-02-08 14:15:00+07', '2025-07-25 11:30:00+07', 'jpg', 'lớn', 'bò băm', 50000.00),
(100044, '2025-02-08 14:15:00+07', '2025-08-30 16:15:00+07', 'jpg', 'lớn', 'bò thái lát', 55000.00);

-- Product 100045: Gỏi cuốn tôm thịt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100045, '2023-05-15 09:30:00+07', '2023-06-20 14:15:00+07', 'jpg', '3 cuốn', 'default', 35000.00),
(100045, '2023-05-15 09:30:00+07', '2023-07-15 11:30:00+07', 'jpg', '5 cuốn', 'default', 55000.00),
(100045, '2023-05-15 09:30:00+07', '2023-08-10 16:45:00+07', 'jpg', '8 cuốn', 'default', 85000.00);

-- Product 100046: Gỏi cuốn chay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100046, '2023-07-28 11:00:00+07', '2023-08-25 13:30:00+07', 'jpg', '3 cuốn', 'nấm', 25000.00),
(100046, '2023-07-28 11:00:00+07', '2023-09-15 10:45:00+07', 'jpg', '3 cuốn', 'đậu hũ', 28000.00),
(100046, '2023-07-28 11:00:00+07', '2023-10-10 15:20:00+07', 'jpg', '5 cuốn', 'nấm', 40000.00),
(100046, '2023-07-28 11:00:00+07', '2023-11-05 09:30:00+07', 'jpg', '5 cuốn', 'đậu hũ', 45000.00);

-- Product 100047: Gỏi cuốn tôm
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100047, '2023-10-12 12:30:00+07', '2023-11-15 14:40:00+07', 'jpg', '3 cuốn', 'default', 30000.00),
(100047, '2023-10-12 12:30:00+07', '2023-12-10 11:15:00+07', 'jpg', '5 cuốn', 'default', 48000.00);

-- Product 100048: Gỏi cuốn thịt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100048, '2024-01-25 14:00:00+07', '2024-02-20 15:30:00+07', 'jpg', '3 cuốn', 'default', 28000.00),
(100048, '2024-01-25 14:00:00+07', '2024-03-15 10:45:00+07', 'jpg', '5 cuốn', 'default', 45000.00);

-- Product 100049: Gỏi cuốn bì
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100049, '2024-04-08 10:15:00+07', '2024-05-10 13:25:00+07', 'jpg', '3 cuốn', 'default', 32000.00),
(100049, '2024-04-08 10:15:00+07', '2024-06-05 16:40:00+07', 'jpg', '5 cuốn', 'default', 50000.00),
(100049, '2024-04-08 10:15:00+07', '2024-07-01 11:20:00+07', 'jpg', '8 cuốn', 'default', 78000.00);

-- Product 100050: Gỏi cuốn bò nướng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100050, '2024-06-20 11:45:00+07', '2024-07-25 14:30:00+07', 'jpg', '3 cuốn', 'sốt me', 38000.00),
(100050, '2024-06-20 11:45:00+07', '2024-08-15 10:15:00+07', 'jpg', '3 cuốn', 'mắm nêm', 38000.00),
(100050, '2024-06-20 11:45:00+07', '2024-09-10 15:50:00+07', 'jpg', '5 cuốn', 'sốt me', 60000.00),
(100050, '2024-06-20 11:45:00+07', '2024-10-05 12:20:00+07', 'jpg', '5 cuốn', 'mắm nêm', 60000.00);

-- Product 100051: Gỏi cuốn gà
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100051, '2024-09-05 13:15:00+07', '2024-10-08 15:40:00+07', 'jpg', '3 cuốn', 'default', 30000.00),
(100051, '2024-09-05 13:15:00+07', '2024-10-18 11:25:00+07', 'jpg', '5 cuốn', 'default', 48000.00);

-- Product 100052: Gỏi cuốn hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100052, '2024-11-18 11:00:00+07', '2024-12-15 14:20:00+07', 'jpg', '3 cuốn', 'tôm mực', 40000.00),
(100052, '2024-11-18 11:00:00+07', '2025-01-10 10:45:00+07', 'jpg', '3 cuốn', 'tôm cua', 45000.00),
(100052, '2024-11-18 11:00:00+07', '2025-02-05 15:30:00+07', 'jpg', '5 cuốn', 'tôm mực', 65000.00),
(100052, '2024-11-18 11:00:00+07', '2025-03-01 12:15:00+07', 'jpg', '5 cuốn', 'tôm cua', 70000.00);

-- Product 100053: Gỏi cuốn nem nướng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100053, '2025-02-15 13:30:00+07', '2025-03-20 15:45:00+07', 'jpg', '3 cuốn', 'default', 35000.00),
(100053, '2025-02-15 13:30:00+07', '2025-04-15 11:20:00+07', 'jpg', '5 cuốn', 'default', 55000.00),
(100053, '2025-02-15 13:30:00+07', '2025-05-20 14:30:00+07', 'jpg', '8 cuốn', 'default', 85000.00);

-- Product 100054: Bánh xèo miền Tây
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100054, '2023-04-20 10:30:00+07', '2023-05-15 14:20:00+07', 'jpg', '15cm', 'Nguyên bản', 45000.00),
(100054, '2023-04-20 10:30:00+07', '2023-06-22 09:45:00+07', 'jpg', '15cm', 'Thêm tôm', 55000.00),
(100054, '2023-04-20 10:30:00+07', '2023-07-10 16:30:00+07', 'jpg', '22cm', 'Nguyên bản', 65000.00),
(100054, '2023-04-20 10:30:00+07', '2023-08-05 11:15:00+07', 'jpg', '22cm', 'Thêm tôm', 75000.00);

-- Product 100055: Bánh xèo tôm thịt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100055, '2023-07-05 11:20:00+07', '2023-08-12 10:30:00+07', 'jpg', '18cm', 'Không rau sống', 50000.00),
(100055, '2023-07-05 11:20:00+07', '2023-09-20 15:45:00+07', 'jpg', '18cm', 'Đầy đủ rau sống', 52000.00),
(100055, '2023-07-05 11:20:00+07', '2023-10-05 09:00:00+07', 'jpg', '25cm', 'Không rau sống', 70000.00),
(100055, '2023-07-05 11:20:00+07', '2023-10-18 14:20:00+07', 'jpg', '25cm', 'Đầy đủ rau sống', 72000.00);

-- Product 100056: Bánh xèo hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100056, '2023-09-18 13:45:00+07', '2023-10-25 11:30:00+07', 'jpg', '20cm', 'Nước mắm truyền thống', 75000.00),
(100056, '2023-09-18 13:45:00+07', '2023-11-30 16:15:00+07', 'jpg', '20cm', 'Nước mắm me', 77000.00),
(100056, '2023-09-18 13:45:00+07', '2024-01-08 10:00:00+07', 'jpg', '28cm', 'Nước mắm truyền thống', 95000.00),
(100056, '2023-09-18 13:45:00+07', '2024-02-14 13:45:00+07', 'jpg', '28cm', 'Nước mắm me', 97000.00);

-- Product 100057: Bánh xèo chay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100057, '2023-12-03 14:20:00+07', '2024-01-15 09:30:00+07', 'jpg', '16cm', 'Nước chấm chay', 40000.00),
(100057, '2023-12-03 14:20:00+07', '2024-02-20 11:45:00+07', 'jpg', '16cm', 'Nước chấm đậu phộng', 42000.00),
(100057, '2023-12-03 14:20:00+07', '2024-03-10 15:00:00+07', 'jpg', '23cm', 'Nước chấm chay', 58000.00),
(100057, '2023-12-03 14:20:00+07', '2024-04-18 10:20:00+07', 'jpg', '23cm', 'Nước chấm đậu phộng', 60000.00);

-- Product 100058: Bánh xèo mini
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100058, '2024-02-15 10:00:00+07', '2024-03-22 14:30:00+07', 'jpg', '6 chiếc', 'Chấm nước mắm', 35000.00),
(100058, '2024-02-15 10:00:00+07', '2024-04-10 09:15:00+07', 'jpg', '6 chiếc', 'Chấm tương ớt', 35000.00),
(100058, '2024-02-15 10:00:00+07', '2024-05-05 11:40:00+07', 'jpg', '10 chiếc', 'Chấm nước mắm', 55000.00),
(100058, '2024-02-15 10:00:00+07', '2024-06-12 16:20:00+07', 'jpg', '10 chiếc', 'Chấm tương ớt', 55000.00);

-- Product 100059: Bánh xèo tôm nhảy
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100059, '2024-05-28 11:30:00+07', '2024-06-20 10:45:00+07', 'jpg', '19cm', 'Tôm tươi', 85000.00),
(100059, '2024-05-28 11:30:00+07', '2024-07-15 14:00:00+07', 'jpg', '19cm', 'Tôm + mực', 95000.00),
(100059, '2024-05-28 11:30:00+07', '2024-08-25 09:30:00+07', 'jpg', '26cm', 'Tôm tươi', 110000.00),
(100059, '2024-05-28 11:30:00+07', '2024-09-18 15:20:00+07', 'jpg', '26cm', 'Tôm + mực', 120000.00);

-- Product 100060: Bánh xèo miền Trung
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100060, '2024-08-12 13:00:00+07', '2024-09-10 11:15:00+07', 'jpg', '17cm', 'Ít cay', 48000.00),
(100060, '2024-08-12 13:00:00+07', '2024-10-05 14:45:00+07', 'jpg', '17cm', 'Cay vừa', 48000.00),
(100060, '2024-08-12 13:00:00+07', '2024-10-15 09:20:00+07', 'jpg', '17cm', 'Cay nhiều', 48000.00),
(100060, '2024-08-12 13:00:00+07', '2024-10-20 16:30:00+07', 'jpg', '24cm', 'Ít cay', 68000.00),
(100060, '2024-08-12 13:00:00+07', '2024-10-21 10:00:00+07', 'jpg', '24cm', 'Cay vừa', 68000.00),
(100060, '2024-08-12 13:00:00+07', '2024-10-21 15:45:00+07', 'jpg', '24cm', 'Cay nhiều', 68000.00);

-- Product 100061: Bánh xèo nấm
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100061, '2024-10-25 10:45:00+07', '2024-10-26 14:20:00+07', 'jpg', 'default', 'Nấm thường', 42000.00),
(100061, '2024-10-25 10:45:00+07', '2024-10-27 09:30:00+07', 'jpg', 'default', 'Nấm cao cấp', 52000.00);

-- Product 100062: Bánh xèo đặc biệt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100062, '2025-01-10 14:30:00+07', '2025-01-25 11:00:00+07', 'jpg', '21cm', 'Nguyên liệu thường', 78000.00),
(100062, '2025-01-10 14:30:00+07', '2025-02-10 15:30:00+07', 'jpg', '21cm', 'Nguyên liệu cao cấp', 95000.00),
(100062, '2025-01-10 14:30:00+07', '2025-03-05 10:15:00+07', 'jpg', '30cm', 'Nguyên liệu thường', 105000.00),
(100062, '2025-01-10 14:30:00+07', '2025-04-08 14:45:00+07', 'jpg', '30cm', 'Nguyên liệu cao cấp', 125000.00);

-- Product 100063: Bánh tráng nướng trứng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100063, '2023-05-08 09:30:00+07', '2023-06-15 11:20:00+07', 'jpg', 'default', '1 trứng', 15000.00),
(100063, '2023-05-08 09:30:00+07', '2023-07-10 14:40:00+07', 'jpg', 'default', '2 trứng', 20000.00);

-- Product 100064: Bánh tráng nướng bơ
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100064, '2023-07-20 11:00:00+07', '2023-08-18 10:30:00+07', 'jpg', 'default', 'Bơ ít', 18000.00),
(100064, '2023-07-20 11:00:00+07', '2023-09-05 15:15:00+07', 'jpg', 'default', 'Bơ nhiều', 22000.00);

-- Product 100065: Bánh tráng nướng phô mai
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100065, '2023-10-05 12:30:00+07', '2023-11-12 09:45:00+07', 'jpg', 'default', 'Phô mai thường', 25000.00),
(100065, '2023-10-05 12:30:00+07', '2023-12-08 14:20:00+07', 'jpg', 'default', 'Phô mai Hàn Quốc', 32000.00);

-- Product 100066: Bánh tráng nướng sate
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100066, '2024-01-12 14:00:00+07', '2024-02-05 10:30:00+07', 'jpg', 'default', 'Ít cay', 20000.00),
(100066, '2024-01-12 14:00:00+07', '2024-03-10 15:45:00+07', 'jpg', 'default', 'Cay vừa', 20000.00),
(100066, '2024-01-12 14:00:00+07', '2024-04-15 11:20:00+07', 'jpg', 'default', 'Cay nhiều', 20000.00);

-- Product 100067: Bánh tráng nướng chay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100067, '2024-03-28 10:15:00+07', '2024-04-20 14:30:00+07', 'jpg', 'default', 'Rau thập cẩm', 18000.00),
(100067, '2024-03-28 10:15:00+07', '2024-05-25 09:45:00+07', 'jpg', 'default', 'Nấm và rau', 22000.00);

-- Product 100068: Bánh tráng nướng mỡ hành
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100068, '2024-06-15 11:45:00+07', '2024-07-10 10:20:00+07', 'jpg', 'default', 'Không trứng', 17000.00),
(100068, '2024-06-15 11:45:00+07', '2024-08-05 15:30:00+07', 'jpg', 'default', 'Có trứng', 22000.00);

-- Product 100069: Bánh tráng nướng khô bò
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100069, '2024-09-08 13:15:00+07', '2024-09-25 11:40:00+07', 'jpg', 'default', 'Khô bò vụn', 28000.00),
(100069, '2024-09-08 13:15:00+07', '2024-10-12 14:50:00+07', 'jpg', 'default', 'Khô bò miếng', 35000.00);

-- Product 100070: Bánh tráng nướng Đà Lạt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100070, '2024-11-20 11:00:00+07', '2024-11-28 10:15:00+07', 'jpg', 'default', 'Trứng cút', 25000.00),
(100070, '2024-11-20 11:00:00+07', '2024-12-05 14:30:00+07', 'jpg', 'default', 'Trứng gà', 22000.00),
(100070, '2024-11-20 11:00:00+07', '2025-01-08 09:45:00+07', 'jpg', 'default', 'Không trứng', 18000.00);

-- Product 100071: Bánh tráng nướng tôm
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100071, '2025-02-05 13:30:00+07', '2025-02-20 11:20:00+07', 'jpg', 'default', 'Tôm khô', 30000.00),
(100071, '2025-02-05 13:30:00+07', '2025-03-15 15:45:00+07', 'jpg', 'default', 'Tôm tươi', 38000.00);

-- Product 100072: Xôi gà (Chicken sticky rice)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100072, '2023-04-15 08:00:00+07', '2023-05-20 10:30:00+07', 'jpg', 'nhỏ', 'gà luộc', 25000.00),
(100072, '2023-04-15 08:00:00+07', '2023-06-15 14:20:00+07', 'jpg', 'nhỏ', 'gà xé', 28000.00),
(100072, '2023-04-15 08:00:00+07', '2023-07-10 09:45:00+07', 'jpg', 'vừa', 'gà luộc', 35000.00),
(100072, '2023-04-15 08:00:00+07', '2023-08-22 11:15:00+07', 'jpg', 'vừa', 'gà xé', 38000.00),
(100072, '2023-04-15 08:00:00+07', '2023-09-05 16:30:00+07', 'jpg', 'lớn', 'gà luộc', 45000.00),
(100072, '2023-04-15 08:00:00+07', '2023-10-12 13:20:00+07', 'jpg', 'lớn', 'gà xé', 48000.00);

-- Product 100073: Xôi xéo (Sticky rice with mung bean and fried shallots)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100073, '2023-06-28 09:30:00+07', '2023-08-15 10:20:00+07', 'jpg', 'nhỏ', 'không trứng', 20000.00),
(100073, '2023-06-28 09:30:00+07', '2023-09-20 14:45:00+07', 'jpg', 'nhỏ', 'thêm trứng', 25000.00),
(100073, '2023-06-28 09:30:00+07', '2023-10-18 11:30:00+07', 'jpg', 'vừa', 'không trứng', 28000.00),
(100073, '2023-06-28 09:30:00+07', '2023-11-22 09:15:00+07', 'jpg', 'vừa', 'thêm trứng', 33000.00),
(100073, '2023-06-28 09:30:00+07', '2024-01-10 15:40:00+07', 'jpg', 'lớn', 'không trứng', 38000.00),
(100073, '2023-06-28 09:30:00+07', '2024-02-14 12:25:00+07', 'jpg', 'lớn', 'thêm trứng', 43000.00);

-- Product 100074: Xôi lạc (Sticky rice with peanuts)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100074, '2023-09-10 11:00:00+07', '2023-10-25 13:30:00+07', 'jpg', 'nhỏ', 'default', 18000.00),
(100074, '2023-09-10 11:00:00+07', '2023-11-30 10:15:00+07', 'jpg', 'vừa', 'default', 25000.00),
(100074, '2023-09-10 11:00:00+07', '2024-01-08 14:50:00+07', 'jpg', 'lớn', 'default', 35000.00);

-- Product 100075: Xôi thịt kho (Sticky rice with braised pork)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100075, '2023-11-22 12:30:00+07', '2024-01-15 09:20:00+07', 'jpg', 'nhỏ', 'thịt ba chỉ', 30000.00),
(100075, '2023-11-22 12:30:00+07', '2024-02-20 11:45:00+07', 'jpg', 'nhỏ', 'thịt nạc', 32000.00),
(100075, '2023-11-22 12:30:00+07', '2024-03-18 15:10:00+07', 'jpg', 'vừa', 'thịt ba chỉ', 40000.00),
(100075, '2023-11-22 12:30:00+07', '2024-04-22 13:30:00+07', 'jpg', 'vừa', 'thịt nạc', 42000.00);

-- Product 100076: Xôi chay (Vegetarian sticky rice)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100076, '2024-02-08 08:45:00+07', '2024-03-25 10:20:00+07', 'jpg', 'nhỏ', 'nấm rơm', 22000.00),
(100076, '2024-02-08 08:45:00+07', '2024-04-30 14:35:00+07', 'jpg', 'nhỏ', 'nấm hương', 25000.00),
(100076, '2024-02-08 08:45:00+07', '2024-05-20 11:50:00+07', 'jpg', 'vừa', 'nấm rơm', 30000.00),
(100076, '2024-02-08 08:45:00+07', '2024-06-15 09:40:00+07', 'jpg', 'vừa', 'nấm hương', 33000.00),
(100076, '2024-02-08 08:45:00+07', '2024-07-22 13:25:00+07', 'jpg', 'lớn', 'nấm rơm', 40000.00),
(100076, '2024-02-08 08:45:00+07', '2024-08-18 15:10:00+07', 'jpg', 'lớn', 'nấm hương', 43000.00);

-- Product 100077: Xôi vò (Sticky rice with hand-torn chicken)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100077, '2024-04-25 11:15:00+07', '2024-06-10 09:30:00+07', 'jpg', 'nhỏ', 'default', 28000.00),
(100077, '2024-04-25 11:15:00+07', '2024-07-20 14:45:00+07', 'jpg', 'vừa', 'default', 38000.00);

-- Product 100078: Xôi sườn (Sticky rice with pork ribs)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100078, '2024-07-12 12:00:00+07', '2024-08-25 10:15:00+07', 'jpg', 'nhỏ', 'sườn nướng', 35000.00),
(100078, '2024-07-12 12:00:00+07', '2024-09-15 13:40:00+07', 'jpg', 'nhỏ', 'sườn rim', 33000.00),
(100078, '2024-07-12 12:00:00+07', '2024-10-08 11:25:00+07', 'jpg', 'vừa', 'sườn nướng', 45000.00),
(100078, '2024-07-12 12:00:00+07', '2024-10-20 15:50:00+07', 'jpg', 'vừa', 'sườn rim', 43000.00);

-- Product 100079: Xôi đậu đen (Sticky rice with black beans)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100079, '2024-09-28 09:30:00+07', '2024-10-15 14:20:00+07', 'jpg', 'default', 'default', 20000.00);

-- Product 100080: Xôi ngũ sắc (Five-color sticky rice)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100080, '2024-12-10 13:15:00+07', '2025-01-20 10:30:00+07', 'jpg', 'nhỏ', 'không nhân', 25000.00),
(100080, '2024-12-10 13:15:00+07', '2025-02-15 14:45:00+07', 'jpg', 'nhỏ', 'có nhân đậu xanh', 30000.00),
(100080, '2024-12-10 13:15:00+07', '2025-03-10 11:20:00+07', 'jpg', 'vừa', 'không nhân', 35000.00),
(100080, '2024-12-10 13:15:00+07', '2025-04-05 09:55:00+07', 'jpg', 'vừa', 'có nhân đậu xanh', 40000.00);

-- Product 100081: Chè ba màu (Three-color dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100081, '2023-05-18 09:00:00+07', '2023-07-10 13:25:00+07', 'jpg', 'nhỏ', 'nước cốt dừa', 20000.00),
(100081, '2023-05-18 09:00:00+07', '2023-08-22 10:40:00+07', 'jpg', 'nhỏ', 'sữa tươi', 22000.00),
(100081, '2023-05-18 09:00:00+07', '2023-09-15 15:15:00+07', 'jpg', 'vừa', 'nước cốt dừa', 28000.00),
(100081, '2023-05-18 09:00:00+07', '2023-10-20 11:50:00+07', 'jpg', 'vừa', 'sữa tươi', 30000.00),
(100081, '2023-05-18 09:00:00+07', '2023-11-25 14:30:00+07', 'jpg', 'lớn', 'nước cốt dừa', 35000.00),
(100081, '2023-05-18 09:00:00+07', '2024-01-08 09:45:00+07', 'jpg', 'lớn', 'sữa tươi', 37000.00);

-- Product 100082: Chè bưởi (Pomelo dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100082, '2023-07-30 10:30:00+07', '2023-09-12 13:20:00+07', 'jpg', 'nhỏ', 'default', 22000.00),
(100082, '2023-07-30 10:30:00+07', '2023-10-18 15:45:00+07', 'jpg', 'lớn', 'default', 32000.00);

-- Product 100083: Chè thập cẩm (Mixed dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100083, '2023-10-15 12:00:00+07', '2023-11-28 10:15:00+07', 'jpg', 'nhỏ', 'nước đá', 25000.00),
(100083, '2023-10-15 12:00:00+07', '2023-12-20 14:30:00+07', 'jpg', 'nhỏ', 'nóng', 23000.00),
(100083, '2023-10-15 12:00:00+07', '2024-01-15 11:45:00+07', 'jpg', 'vừa', 'nước đá', 33000.00),
(100083, '2023-10-15 12:00:00+07', '2024-02-10 09:20:00+07', 'jpg', 'vừa', 'nóng', 31000.00),
(100083, '2023-10-15 12:00:00+07', '2024-03-18 15:55:00+07', 'jpg', 'lớn', 'nước đá', 40000.00),
(100083, '2023-10-15 12:00:00+07', '2024-04-22 13:10:00+07', 'jpg', 'lớn', 'nóng', 38000.00);

-- Product 100084: Chè đậu xanh (Mung bean dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100084, '2024-01-05 13:15:00+07', '2024-02-20 10:30:00+07', 'jpg', 'nhỏ', 'nước cốt dừa', 18000.00),
(100084, '2024-01-05 13:15:00+07', '2024-03-15 14:45:00+07', 'jpg', 'nhỏ', 'sữa đặc', 20000.00),
(100084, '2024-01-05 13:15:00+07', '2024-04-10 11:20:00+07', 'jpg', 'vừa', 'nước cốt dừa', 25000.00),
(100084, '2024-01-05 13:15:00+07', '2024-05-08 09:35:00+07', 'jpg', 'vừa', 'sữa đặc', 27000.00);

-- Product 100085: Chè khúc bạch (White jelly dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100085, '2024-03-20 08:45:00+07', '2024-05-05 13:20:00+07', 'jpg', 'nhỏ', 'thạch rau câu', 22000.00),
(100085, '2024-03-20 08:45:00+07', '2024-06-12 10:55:00+07', 'jpg', 'nhỏ', 'thạch gelatin', 24000.00),
(100085, '2024-03-20 08:45:00+07', '2024-07-18 15:10:00+07', 'jpg', 'lớn', 'thạch rau câu', 32000.00),
(100085, '2024-03-20 08:45:00+07', '2024-08-25 11:40:00+07', 'jpg', 'lớn', 'thạch gelatin', 34000.00);

-- Product 100086: Chè đậu đen (Black bean dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100086, '2024-06-08 11:15:00+07', '2024-07-22 09:30:00+07', 'jpg', 'default', 'nước cốt dừa', 20000.00);

-- Product 100087: Chè hạt sen (Lotus seed dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100087, '2024-08-22 11:45:00+07', '2024-09-30 14:20:00+07', 'jpg', 'nhỏ', 'long nhãn', 25000.00),
(100087, '2024-08-22 11:45:00+07', '2024-10-15 10:35:00+07', 'jpg', 'nhỏ', 'không long nhãn', 22000.00),
(100087, '2024-08-22 11:45:00+07', '2024-10-22 13:50:00+07', 'jpg', 'vừa', 'long nhãn', 33000.00),
(100087, '2024-08-22 11:45:00+07', '2025-01-10 11:15:00+07', 'jpg', 'vừa', 'không long nhãn', 30000.00);

-- Product 100088: Chè bắp (Corn dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100088, '2024-11-05 10:00:00+07', '2024-12-18 13:25:00+07', 'jpg', 'nhỏ', 'sữa dừa', 18000.00),
(100088, '2024-11-05 10:00:00+07', '2025-01-22 10:40:00+07', 'jpg', 'nhỏ', 'sữa tươi', 20000.00),
(100088, '2024-11-05 10:00:00+07', '2025-02-15 14:55:00+07', 'jpg', 'vừa', 'sữa dừa', 25000.00),
(100088, '2024-11-05 10:00:00+07', '2025-03-10 11:20:00+07', 'jpg', 'vừa', 'sữa tươi', 27000.00),
(100088, '2024-11-05 10:00:00+07', '2025-04-08 09:35:00+07', 'jpg', 'lớn', 'sữa dừa', 32000.00),
(100088, '2024-11-05 10:00:00+07', '2025-05-12 15:10:00+07', 'jpg', 'lớn', 'sữa tươi', 34000.00);

-- Product 100089: Chè thái (Thai-style dessert)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100089, '2025-01-18 12:30:00+07', '2025-02-25 10:15:00+07', 'jpg', 'nhỏ', 'nước đá bào', 28000.00),
(100089, '2025-01-18 12:30:00+07', '2025-03-20 14:40:00+07', 'jpg', 'nhỏ', 'thạch trái cây', 30000.00),
(100089, '2025-01-18 12:30:00+07', '2025-04-15 11:55:00+07', 'jpg', 'lớn', 'nước đá bào', 38000.00),
(100089, '2025-01-18 12:30:00+07', '2025-05-10 09:20:00+07', 'jpg', 'lớn', 'thạch trái cây', 40000.00);

-- Product 100090: Cơm tấm sườn non
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100090, '2023-05-10 10:30:00+07', '2023-06-15 14:20:00+07', 'jpg', 'nhỏ', 'default', 35000.00),
(100090, '2023-05-10 10:30:00+07', '2023-06-15 14:20:00+07', 'jpg', 'vừa', 'default', 45000.00),
(100090, '2023-05-10 10:30:00+07', '2023-06-15 14:20:00+07', 'jpg', 'lớn', 'default', 55000.00);

-- Product 100091: Cơm tấm opla
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100091, '2023-07-25 11:00:00+07', '2023-08-20 09:45:00+07', 'jpg', 'nhỏ', 'thêm trứng', 30000.00),
(100091, '2023-07-25 11:00:00+07', '2023-08-20 09:45:00+07', 'jpg', 'nhỏ', 'không thêm', 25000.00),
(100091, '2023-07-25 11:00:00+07', '2023-08-20 09:45:00+07', 'jpg', 'vừa', 'thêm trứng', 40000.00),
(100091, '2023-07-25 11:00:00+07', '2023-08-20 09:45:00+07', 'jpg', 'vừa', 'không thêm', 35000.00);

-- Product 100092: Cơm tấm đặc biệt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'nhỏ', 'thêm chả', 45000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'nhỏ', 'thêm bì', 48000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'nhỏ', 'full topping', 52000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'vừa', 'thêm chả', 55000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'vừa', 'thêm bì', 58000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'vừa', 'full topping', 62000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'lớn', 'thêm chả', 65000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'lớn', 'thêm bì', 68000.00),
(100092, '2023-10-08 13:15:00+07', '2023-11-10 16:30:00+07', 'jpg', 'lớn', 'full topping', 72000.00);

-- Product 100093: Cơm tấm sườn trứng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100093, '2024-01-22 14:00:00+07', '2024-02-28 11:15:00+07', 'jpg', 'nhỏ', 'default', 38000.00),
(100093, '2024-01-22 14:00:00+07', '2024-02-28 11:15:00+07', 'jpg', 'vừa', 'default', 48000.00),
(100093, '2024-01-22 14:00:00+07', '2024-02-28 11:15:00+07', 'jpg', 'lớn', 'default', 58000.00);

-- Product 100094: Cơm tấm chả cá
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100094, '2024-04-15 10:30:00+07', '2024-05-20 13:45:00+07', 'jpg', 'nhỏ', 'nước mắm pha', 40000.00),
(100094, '2024-04-15 10:30:00+07', '2024-05-20 13:45:00+07', 'jpg', 'nhỏ', 'mắm nêm', 42000.00),
(100094, '2024-04-15 10:30:00+07', '2024-05-20 13:45:00+07', 'jpg', 'vừa', 'nước mắm pha', 50000.00),
(100094, '2024-04-15 10:30:00+07', '2024-05-20 13:45:00+07', 'jpg', 'vừa', 'mắm nêm', 52000.00);

-- Product 100095: Cơm tấm sườn mỡ
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100095, '2024-06-28 12:00:00+07', '2024-07-30 15:20:00+07', 'jpg', 'default', 'default', 42000.00);

-- Product 100096: Cơm tấm tôm
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100096, '2024-09-12 13:30:00+07', '2024-10-05 10:15:00+07', 'jpg', 'nhỏ', '3 con', 45000.00),
(100096, '2024-09-12 13:30:00+07', '2024-10-05 10:15:00+07', 'jpg', 'nhỏ', '5 con', 52000.00),
(100096, '2024-09-12 13:30:00+07', '2024-10-05 10:15:00+07', 'jpg', 'vừa', '3 con', 55000.00),
(100096, '2024-09-12 13:30:00+07', '2024-10-05 10:15:00+07', 'jpg', 'vừa', '5 con', 62000.00),
(100096, '2024-09-12 13:30:00+07', '2024-10-05 10:15:00+07', 'jpg', 'lớn', '3 con', 65000.00),
(100096, '2024-09-12 13:30:00+07', '2024-10-05 10:15:00+07', 'jpg', 'lớn', '5 con', 72000.00);

-- Product 100097: Cơm tấm bò nướng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100097, '2024-11-25 11:15:00+07', NULL, 'jpg', 'nhỏ', 'ớt xanh', 48000.00),
(100097, '2024-11-25 11:15:00+07', NULL, 'jpg', 'nhỏ', 'hành tây', 48000.00),
(100097, '2024-11-25 11:15:00+07', NULL, 'jpg', 'vừa', 'ớt xanh', 58000.00),
(100097, '2024-11-25 11:15:00+07', NULL, 'jpg', 'vừa', 'hành tây', 58000.00);

-- Product 100098: Cơm tấm ba rọi
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100098, '2025-02-08 14:00:00+07', '2025-03-15 10:30:00+07', 'jpg', 'nhỏ', 'default', 40000.00),
(100098, '2025-02-08 14:00:00+07', '2025-03-15 10:30:00+07', 'jpg', 'vừa', 'default', 50000.00),
(100098, '2025-02-08 14:00:00+07', '2025-03-15 10:30:00+07', 'jpg', 'lớn', 'default', 60000.00);

-- Product 100099: Nem nướng Ninh Hòa
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100099, '2023-05-22 10:00:00+07', '2023-06-28 14:45:00+07', 'jpg', '6 xiên', 'nước mắm me', 35000.00),
(100099, '2023-05-22 10:00:00+07', '2023-06-28 14:45:00+07', 'jpg', '6 xiên', 'tương đen', 35000.00),
(100099, '2023-05-22 10:00:00+07', '2023-06-28 14:45:00+07', 'jpg', '10 xiên', 'nước mắm me', 55000.00),
(100099, '2023-05-22 10:00:00+07', '2023-06-28 14:45:00+07', 'jpg', '10 xiên', 'tương đen', 55000.00);

-- Product 100100: Nem nướng cuốn
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100100, '2023-08-10 11:30:00+07', '2023-09-18 09:20:00+07', 'jpg', '4 cuốn', 'bánh tráng mỏng', 28000.00),
(100100, '2023-08-10 11:30:00+07', '2023-09-18 09:20:00+07', 'jpg', '4 cuốn', 'bánh tráng dày', 30000.00),
(100100, '2023-08-10 11:30:00+07', '2023-09-18 09:20:00+07', 'jpg', '7 cuốn', 'bánh tráng mỏng', 45000.00),
(100100, '2023-08-10 11:30:00+07', '2023-09-18 09:20:00+07', 'jpg', '7 cuốn', 'bánh tráng dày', 47000.00);

-- Product 100101: Nem nướng xiên
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100101, '2023-11-18 13:00:00+07', '2023-12-22 11:40:00+07', 'jpg', '5 xiên', 'default', 30000.00),
(100101, '2023-11-18 13:00:00+07', '2023-12-22 11:40:00+07', 'jpg', '8 xiên', 'default', 45000.00);

-- Product 100102: Nem nướng lụi
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100102, '2024-02-05 14:30:00+07', '2024-03-12 16:15:00+07', 'jpg', '100g', 'rau sống', 40000.00),
(100102, '2024-02-05 14:30:00+07', '2024-03-12 16:15:00+07', 'jpg', '100g', 'dưa leo', 42000.00),
(100102, '2024-02-05 14:30:00+07', '2024-03-12 16:15:00+07', 'jpg', '150g', 'rau sống', 55000.00),
(100102, '2024-02-05 14:30:00+07', '2024-03-12 16:15:00+07', 'jpg', '150g', 'dưa leo', 57000.00);

-- Product 100103: Nem nướng chả ram
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100103, '2024-04-28 10:15:00+07', '2024-05-30 13:50:00+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100104: Nem nướng sa tế
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100104, '2024-07-15 12:00:00+07', '2024-08-20 10:25:00+07', 'jpg', '6 xiên', 'sa tế vừa', 38000.00),
(100104, '2024-07-15 12:00:00+07', '2024-08-20 10:25:00+07', 'jpg', '6 xiên', 'sa tế cay', 40000.00),
(100104, '2024-07-15 12:00:00+07', '2024-08-20 10:25:00+07', 'jpg', '9 xiên', 'sa tế vừa', 55000.00),
(100104, '2024-07-15 12:00:00+07', '2024-08-20 10:25:00+07', 'jpg', '9 xiên', 'sa tế cay', 57000.00);

-- Product 100105: Nem nướng bánh hỏi
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100105, '2024-10-02 13:15:00+07', '2024-10-18 15:30:00+07', 'jpg', 'nhỏ', 'thêm mỡ hành', 35000.00),
(100105, '2024-10-02 13:15:00+07', '2024-10-18 15:30:00+07', 'jpg', 'nhỏ', 'không mỡ hành', 32000.00),
(100105, '2024-10-02 13:15:00+07', '2024-10-18 15:30:00+07', 'jpg', 'vừa', 'thêm mỡ hành', 45000.00),
(100105, '2024-10-02 13:15:00+07', '2024-10-18 15:30:00+07', 'jpg', 'vừa', 'không mỡ hành', 42000.00),
(100105, '2024-10-02 13:15:00+07', '2024-10-18 15:30:00+07', 'jpg', 'lớn', 'thêm mỡ hành', 55000.00),
(100105, '2024-10-02 13:15:00+07', '2024-10-18 15:30:00+07', 'jpg', 'lớn', 'không mỡ hành', 52000.00);

-- Product 100106: Nem nướng mỡ hành
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100106, '2024-12-18 11:00:00+07', NULL, 'jpg', '6 xiên', 'default', 42000.00),
(100106, '2024-12-18 11:00:00+07', NULL, 'jpg', '10 xiên', 'default', 65000.00);

-- Product 100107: Nem nướng đặc biệt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100107, '2025-02-22 14:00:00+07', '2025-04-10 12:30:00+07', 'jpg', 'combo nhỏ', 'thêm chả ram', 50000.00),
(100107, '2025-02-22 14:00:00+07', '2025-04-10 12:30:00+07', 'jpg', 'combo nhỏ', 'thêm bì', 52000.00),
(100107, '2025-02-22 14:00:00+07', '2025-04-10 12:30:00+07', 'jpg', 'combo nhỏ', 'full topping', 55000.00),
(100107, '2025-02-22 14:00:00+07', '2025-04-10 12:30:00+07', 'jpg', 'combo lớn', 'thêm chả ram', 70000.00),
(100107, '2025-02-22 14:00:00+07', '2025-04-10 12:30:00+07', 'jpg', 'combo lớn', 'thêm bì', 72000.00),
(100107, '2025-02-22 14:00:00+07', '2025-04-10 12:30:00+07', 'jpg', 'combo lớn', 'full topping', 75000.00);

-- Product 100108: Tteokbokki cay (Spicy tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100108, '2023-04-19 09:15:00+07', '2023-06-22 14:30:00+07', 'jpg', 'nhỏ', 'không phô mai', 35000),
(100108, '2023-04-19 09:15:00+07', '2023-06-22 14:30:00+07', 'jpg', 'nhỏ', 'thêm phô mai', 45000),
(100108, '2023-04-19 09:15:00+07', '2023-07-10 10:20:00+07', 'jpg', 'vừa', 'không phô mai', 50000),
(100108, '2023-04-19 09:15:00+07', '2023-07-10 10:20:00+07', 'jpg', 'vừa', 'thêm phô mai', 60000),
(100108, '2023-04-19 09:15:00+07', '2023-08-15 11:45:00+07', 'jpg', 'lớn', 'không phô mai', 65000),
(100108, '2023-04-19 09:15:00+07', '2023-08-15 11:45:00+07', 'jpg', 'lớn', 'thêm phô mai', 75000);

-- Product 100109: Tteokbokki phô mai (Cheese tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100109, '2023-07-01 14:30:00+07', '2023-09-05 16:20:00+07', 'jpg', 'nhỏ', 'default', 45000),
(100109, '2023-07-01 14:30:00+07', '2023-09-05 16:20:00+07', 'jpg', 'vừa', 'default', 60000),
(100109, '2023-07-01 14:30:00+07', '2023-10-12 15:10:00+07', 'jpg', 'lớn', 'default', 75000);

-- Product 100110: Tteokbokki hải sản (Seafood tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100110, '2023-09-16 08:45:00+07', '2023-11-20 09:30:00+07', 'jpg', 'nhỏ', 'hải sản thường', 55000),
(100110, '2023-09-16 08:45:00+07', '2023-11-20 09:30:00+07', 'jpg', 'nhỏ', 'hải sản cao cấp', 75000),
(100110, '2023-09-16 08:45:00+07', '2023-12-08 10:15:00+07', 'jpg', 'vừa', 'hải sản thường', 70000),
(100110, '2023-09-16 08:45:00+07', '2023-12-08 10:15:00+07', 'jpg', 'vừa', 'hải sản cao cấp', 95000),
(100110, '2023-09-16 08:45:00+07', '2024-01-15 11:00:00+07', 'jpg', 'lớn', 'hải sản thường', 85000),
(100110, '2023-09-16 08:45:00+07', '2024-01-15 11:00:00+07', 'jpg', 'lớn', 'hải sản cao cấp', 110000);

-- Product 100111: Tteokbokki jjajang (Black bean sauce tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100111, '2023-12-06 13:20:00+07', '2024-02-14 14:45:00+07', 'jpg', 'nhỏ', 'sốt ít', 40000),
(100111, '2023-12-06 13:20:00+07', '2024-02-14 14:45:00+07', 'jpg', 'nhỏ', 'sốt nhiều', 42000),
(100111, '2023-12-06 13:20:00+07', '2024-03-10 15:30:00+07', 'jpg', 'vừa', 'sốt ít', 55000),
(100111, '2023-12-06 13:20:00+07', '2024-03-10 15:30:00+07', 'jpg', 'vừa', 'sốt nhiều', 58000);

-- Product 100112: Tteokbokki carbonara
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100112, '2024-02-21 09:00:00+07', '2024-04-18 10:30:00+07', 'jpg', 'nhỏ', 'thêm bacon', 50000),
(100112, '2024-02-21 09:00:00+07', '2024-04-18 10:30:00+07', 'jpg', 'nhỏ', 'không bacon', 40000),
(100112, '2024-02-21 09:00:00+07', '2024-05-22 11:15:00+07', 'jpg', 'lớn', 'thêm bacon', 70000),
(100112, '2024-02-21 09:00:00+07', '2024-05-22 11:15:00+07', 'jpg', 'lớn', 'không bacon', 58000);

-- Product 100113: Tteokbokki sốt kem (Cream sauce tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100113, '2024-05-11 11:30:00+07', '2024-07-05 13:20:00+07', 'jpg', 'default', 'default', 52000);

-- Product 100114: Tteokbokki cay vừa (Medium spicy tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100114, '2024-07-29 12:00:00+07', '2024-09-10 14:30:00+07', 'jpg', 'nhỏ', 'thêm trứng', 42000),
(100114, '2024-07-29 12:00:00+07', '2024-09-10 14:30:00+07', 'jpg', 'nhỏ', 'thêm xúc xích', 45000),
(100114, '2024-07-29 12:00:00+07', '2024-09-10 14:30:00+07', 'jpg', 'nhỏ', 'không topping', 35000),
(100114, '2024-07-29 12:00:00+07', '2024-09-25 15:10:00+07', 'jpg', 'vừa', 'thêm trứng', 57000),
(100114, '2024-07-29 12:00:00+07', '2024-09-25 15:10:00+07', 'jpg', 'vừa', 'thêm xúc xích', 60000),
(100114, '2024-07-29 12:00:00+07', '2024-09-25 15:10:00+07', 'jpg', 'vừa', 'không topping', 48000);

-- Product 100115: Tteokbokki xúc xích (Sausage tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100115, '2024-10-16 10:15:00+07', '2024-10-20 11:45:00+07', 'jpg', 'nhỏ', 'default', 45000),
(100115, '2024-10-16 10:15:00+07', '2024-10-20 11:45:00+07', 'jpg', 'lớn', 'default', 65000);

-- Product 100116: Tteokbokki trứng (Egg tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100116, '2025-01-09 13:30:00+07', '2025-02-15 14:20:00+07', 'jpg', 'nhỏ', '1 trứng', 40000),
(100116, '2025-01-09 13:30:00+07', '2025-02-15 14:20:00+07', 'jpg', 'nhỏ', '2 trứng', 48000),
(100116, '2025-01-09 13:30:00+07', '2025-03-10 15:00:00+07', 'jpg', 'vừa', '1 trứng', 55000),
(100116, '2025-01-09 13:30:00+07', '2025-03-10 15:00:00+07', 'jpg', 'vừa', '2 trứng', 65000),
(100116, '2025-01-09 13:30:00+07', '2025-04-08 16:15:00+07', 'jpg', 'lớn', '1 trứng', 68000),
(100116, '2025-01-09 13:30:00+07', '2025-04-08 16:15:00+07', 'jpg', 'lớn', '2 trứng', 80000);

-- Product 100117: Tteokbokki siêu cay (Super spicy tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100117, '2023-05-26 09:00:00+07', '2023-07-15 10:30:00+07', 'jpg', 'nhỏ', 'default', 38000),
(100117, '2023-05-26 09:00:00+07', '2023-08-20 11:45:00+07', 'jpg', 'vừa', 'default', 52000),
(100117, '2023-05-26 09:00:00+07', '2023-09-18 12:30:00+07', 'jpg', 'lớn', 'default', 68000);

-- Product 100118: Tteokbokki ramyeon (Ramyeon tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100118, '2023-08-13 10:15:00+07', '2023-10-05 11:30:00+07', 'jpg', 'nhỏ', 'nước ít', 42000),
(100118, '2023-08-13 10:15:00+07', '2023-10-05 11:30:00+07', 'jpg', 'nhỏ', 'nước nhiều', 42000),
(100118, '2023-08-13 10:15:00+07', '2023-11-12 13:00:00+07', 'jpg', 'vừa', 'nước ít', 58000),
(100118, '2023-08-13 10:15:00+07', '2023-11-12 13:00:00+07', 'jpg', 'vừa', 'nước nhiều', 58000);

-- Product 100119: Tteokbokki búp bê (Doll tteokbokki - mini rice cakes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100119, '2023-11-06 12:00:00+07', '2024-01-08 13:30:00+07', 'jpg', 'default', 'sốt cay', 48000),
(100119, '2023-11-06 12:00:00+07', '2024-01-08 13:30:00+07', 'jpg', 'default', 'sốt ngọt', 48000);

-- Product 100120: Tteokbokki bơ (Butter tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100120, '2024-01-29 13:15:00+07', '2024-03-15 14:45:00+07', 'jpg', 'nhỏ', 'default', 45000),
(100120, '2024-01-29 13:15:00+07', '2024-04-20 15:30:00+07', 'jpg', 'lớn', 'default', 62000);

-- Product 100121: Tteokbokki nguyên bản (Original tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100121, '2024-04-16 09:30:00+07', '2024-06-10 10:45:00+07', 'jpg', 'nhỏ', 'default', 32000),
(100121, '2024-04-16 09:30:00+07', '2024-07-05 11:30:00+07', 'jpg', 'vừa', 'default', 45000),
(100121, '2024-04-16 09:30:00+07', '2024-08-12 12:15:00+07', 'jpg', 'lớn', 'default', 58000);

-- Product 100122: Tteokbokki thập cẩm (Mixed tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100122, '2024-07-03 11:00:00+07', '2024-08-18 12:30:00+07', 'jpg', 'nhỏ', 'topping cơ bản', 48000),
(100122, '2024-07-03 11:00:00+07', '2024-08-18 12:30:00+07', 'jpg', 'nhỏ', 'topping đặc biệt', 58000),
(100122, '2024-07-03 11:00:00+07', '2024-09-10 13:45:00+07', 'jpg', 'vừa', 'topping cơ bản', 65000),
(100122, '2024-07-03 11:00:00+07', '2024-09-10 13:45:00+07', 'jpg', 'vừa', 'topping đặc biệt', 78000);

-- Product 100123: Tteokbokki mozzarella
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100123, '2024-09-21 12:30:00+07', '2024-10-15 14:00:00+07', 'jpg', 'default', 'phô mai thường', 55000),
(100123, '2024-09-21 12:30:00+07', '2024-10-15 14:00:00+07', 'jpg', 'default', 'phô mai extra', 65000);

-- Product 100124: Tteokbokki odeng (Fish cake tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100124, '2024-12-09 10:00:00+07', '2025-01-20 11:30:00+07', 'jpg', 'nhỏ', 'default', 42000),
(100124, '2024-12-09 10:00:00+07', '2025-02-10 12:15:00+07', 'jpg', 'vừa', 'default', 58000),
(100124, '2024-12-09 10:00:00+07', '2025-03-05 13:00:00+07', 'jpg', 'lớn', 'default', 72000);

-- Product 100125: Tteokbokki sốt đen (Black sauce tteokbokki)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES
(100125, '2025-02-19 13:00:00+07', '2025-04-10 14:30:00+07', 'jpg', 'nhỏ', 'sốt vừa', 45000),
(100125, '2025-02-19 13:00:00+07', '2025-04-10 14:30:00+07', 'jpg', 'nhỏ', 'sốt đậm', 48000),
(100125, '2025-02-19 13:00:00+07', '2025-05-15 15:45:00+07', 'jpg', 'lớn', 'sốt vừa', 62000),
(100125, '2025-02-19 13:00:00+07', '2025-05-15 15:45:00+07', 'jpg', 'lớn', 'sốt đậm', 68000);

-- Product 100126: Kimchi truyền thống
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100126, '2023-05-12 10:30:00+07', '2023-08-15 14:20:00+07', 'jpg', '250g', 'Cay vừa', 45000.00),
(100126, '2023-05-12 10:30:00+07', '2023-09-20 09:15:00+07', 'jpg', '250g', 'Cay nồng', 45000.00),
(100126, '2023-05-12 10:30:00+07', '2024-01-10 11:00:00+07', 'jpg', '500g', 'Cay vừa', 85000.00),
(100126, '2023-05-12 10:30:00+07', '2024-03-22 16:30:00+07', 'jpg', '500g', 'Cay nồng', 85000.00);

-- Product 100127: Kimchi cải thảo
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100127, '2023-07-28 11:00:00+07', '2023-10-05 13:45:00+07', 'jpg', '300g', 'Truyền thống', 50000.00),
(100127, '2023-07-28 11:00:00+07', '2024-02-14 10:20:00+07', 'jpg', '300g', 'Ít cay', 50000.00),
(100127, '2023-07-28 11:00:00+07', '2024-05-18 15:00:00+07', 'jpg', '600g', 'Truyền thống', 95000.00),
(100127, '2023-07-28 11:00:00+07', '2024-08-25 09:30:00+07', 'jpg', '600g', 'Ít cay', 95000.00);

-- Product 100128: Kimchi củ cải
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100128, '2023-10-15 13:30:00+07', '2024-01-20 11:15:00+07', 'jpg', '200g', 'Cắt lát', 40000.00),
(100128, '2023-10-15 13:30:00+07', '2024-04-10 14:40:00+07', 'jpg', '200g', 'Cắt vuông', 40000.00),
(100128, '2023-10-15 13:30:00+07', '2024-07-05 10:00:00+07', 'jpg', '500g', 'Cắt lát', 90000.00),
(100128, '2023-10-15 13:30:00+07', '2024-09-12 16:20:00+07', 'jpg', '500g', 'Cắt vuông', 90000.00);

-- Product 100129: Kimchi dưa chuột
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100129, '2024-01-10 14:00:00+07', '2024-03-25 11:30:00+07', 'jpg', '250g', 'Nguyên trái', 42000.00),
(100129, '2024-01-10 14:00:00+07', '2024-06-18 15:45:00+07', 'jpg', '250g', 'Cắt khoanh', 42000.00),
(100129, '2024-01-10 14:00:00+07', '2024-09-20 10:15:00+07', 'jpg', '500g', 'Nguyên trái', 80000.00),
(100129, '2024-01-10 14:00:00+07', '2024-10-15 14:00:00+07', 'jpg', '500g', 'Cắt khoanh', 80000.00);

-- Product 100130: Kimbap bò
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100130, '2023-06-05 10:15:00+07', '2023-09-10 13:20:00+07', 'jpg', '6 miếng', 'Không sốt', 55000.00),
(100130, '2023-06-05 10:15:00+07', '2023-12-05 11:40:00+07', 'jpg', '6 miếng', 'Có sốt', 58000.00),
(100130, '2023-06-05 10:15:00+07', '2024-03-15 15:10:00+07', 'jpg', '10 miếng', 'Không sốt', 85000.00),
(100130, '2023-06-05 10:15:00+07', '2024-07-20 09:50:00+07', 'jpg', '10 miếng', 'Có sốt', 90000.00);

-- Product 100131: Kimbap tham thịt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100131, '2023-08-20 11:30:00+07', '2023-11-15 14:00:00+07', 'jpg', '6 miếng', 'Cơ bản', 50000.00),
(100131, '2023-08-20 11:30:00+07', '2024-02-20 10:30:00+07', 'jpg', '6 miếng', 'Combo nước ngọt', 65000.00),
(100131, '2023-08-20 11:30:00+07', '2024-05-28 16:15:00+07', 'jpg', '10 miếng', 'Cơ bản', 80000.00),
(100131, '2023-08-20 11:30:00+07', '2024-08-30 12:45:00+07', 'jpg', '10 miếng', 'Combo nước ngọt', 95000.00);

-- Product 100132: Kimbap kimchi
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100132, '2023-11-08 13:00:00+07', '2024-01-22 15:30:00+07', 'jpg', '6 miếng', 'Kimchi ít cay', 52000.00),
(100132, '2023-11-08 13:00:00+07', '2024-04-18 11:20:00+07', 'jpg', '6 miếng', 'Kimchi cay nồng', 52000.00),
(100132, '2023-11-08 13:00:00+07', '2024-07-12 14:50:00+07', 'jpg', '10 miếng', 'Kimchi ít cay', 82000.00),
(100132, '2023-11-08 13:00:00+07', '2024-09-25 10:00:00+07', 'jpg', '10 miếng', 'Kimchi cay nồng', 82000.00);

-- Product 100133: Kimbap cá ngừ
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100133, '2024-02-22 14:15:00+07', '2024-05-10 16:00:00+07', 'jpg', '6 miếng', 'Cá ngừ thường', 60000.00),
(100133, '2024-02-22 14:15:00+07', '2024-08-05 12:30:00+07', 'jpg', '6 miếng', 'Cá ngừ cao cấp', 70000.00),
(100133, '2024-02-22 14:15:00+07', '2024-10-08 15:20:00+07', 'jpg', '10 miếng', 'Cá ngừ thường', 95000.00),
(100133, '2024-02-22 14:15:00+07', '2024-10-18 11:45:00+07', 'jpg', '10 miếng', 'Cá ngừ cao cấp', 110000.00);

-- Product 100134: Kimbap rong biển
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100134, '2024-05-18 10:00:00+07', '2024-07-25 14:30:00+07', 'jpg', '6 miếng', 'Rong biển xanh', 48000.00),
(100134, '2024-05-18 10:00:00+07', '2024-09-15 11:00:00+07', 'jpg', '6 miếng', 'Rong biển đỏ', 48000.00),
(100134, '2024-05-18 10:00:00+07', '2024-10-10 16:40:00+07', 'jpg', '10 miếng', 'Rong biển xanh', 75000.00),
(100134, '2024-05-18 10:00:00+07', '2024-10-19 13:20:00+07', 'jpg', '10 miếng', 'Rong biển đỏ', 75000.00);

-- Product 100135: Bibimbap thịt bò
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100135, '2023-06-20 10:30:00+07', '2023-09-18 15:00:00+07', 'jpg', 'Nhỏ', 'Không trứng', 65000.00),
(100135, '2023-06-20 10:30:00+07', '2023-12-22 11:30:00+07', 'jpg', 'Nhỏ', 'Có trứng', 72000.00),
(100135, '2023-06-20 10:30:00+07', '2024-03-10 14:20:00+07', 'jpg', 'Lớn', 'Không trứng', 95000.00),
(100135, '2023-06-20 10:30:00+07', '2024-06-28 16:10:00+07', 'jpg', 'Lớn', 'Có trứng', 105000.00);

-- Product 100136: Bibimbap hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100136, '2023-09-10 12:00:00+07', '2023-12-05 10:45:00+07', 'jpg', 'Nhỏ', 'Hải sản tươi', 75000.00),
(100136, '2023-09-10 12:00:00+07', '2024-02-28 15:30:00+07', 'jpg', 'Nhỏ', 'Hải sản đặc biệt', 85000.00),
(100136, '2023-09-10 12:00:00+07', '2024-06-15 11:20:00+07', 'jpg', 'Lớn', 'Hải sản tươi', 110000.00),
(100136, '2023-09-10 12:00:00+07', '2024-09-08 14:00:00+07', 'jpg', 'Lớn', 'Hải sản đặc biệt', 125000.00);

-- Product 100137: Bibimbap chay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100137, '2023-12-18 13:15:00+07', '2024-03-05 16:20:00+07', 'jpg', 'Nhỏ', 'Rau thường', 55000.00),
(100137, '2023-12-18 13:15:00+07', '2024-06-20 10:50:00+07', 'jpg', 'Nhỏ', 'Rau hữu cơ', 65000.00),
(100137, '2023-12-18 13:15:00+07', '2024-08-18 14:30:00+07', 'jpg', 'Lớn', 'Rau thường', 85000.00),
(100137, '2023-12-18 13:15:00+07', '2024-10-12 11:15:00+07', 'jpg', 'Lớn', 'Rau hữu cơ', 98000.00);

-- Product 100138: Bibimbap gà
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100138, '2024-03-08 14:00:00+07', '2024-05-22 12:40:00+07', 'jpg', 'Nhỏ', 'Gà nướng', 62000.00),
(100138, '2024-03-08 14:00:00+07', '2024-08-10 15:50:00+07', 'jpg', 'Nhỏ', 'Gà chiên', 62000.00),
(100138, '2024-03-08 14:00:00+07', '2024-10-05 10:30:00+07', 'jpg', 'Lớn', 'Gà nướng', 92000.00),
(100138, '2024-03-08 14:00:00+07', '2024-10-17 13:55:00+07', 'jpg', 'Lớn', 'Gà chiên', 92000.00);

-- Product 100139: Samgyeopsal nướng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100139, '2023-07-05 09:30:00+07', '2023-10-12 14:20:00+07', 'jpg', '200g', 'Không ướp', 85000.00),
(100139, '2023-07-05 09:30:00+07', '2024-01-18 11:45:00+07', 'jpg', '200g', 'Ướp sẵn', 90000.00),
(100139, '2023-07-05 09:30:00+07', '2024-04-25 16:00:00+07', 'jpg', '200g', 'Combo rau', 105000.00),
(100139, '2023-07-05 09:30:00+07', '2024-08-08 10:15:00+07', 'jpg', '350g', 'Không ướp', 145000.00),
(100139, '2023-07-05 09:30:00+07', '2024-10-02 15:30:00+07', 'jpg', '350g', 'Ướp sẵn', 152000.00),
(100139, '2023-07-05 09:30:00+07', '2024-10-20 12:00:00+07', 'jpg', '350g', 'Combo rau', 175000.00);

-- Product 100140: Samgyeopsal cuộn rau
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100140, '2023-10-22 11:00:00+07', '2024-01-08 13:40:00+07', 'jpg', '6 cuộn', 'Rau tươi', 78000.00),
(100140, '2023-10-22 11:00:00+07', '2024-04-15 10:20:00+07', 'jpg', '6 cuộn', 'Rau kimchi', 82000.00),
(100140, '2023-10-22 11:00:00+07', '2024-07-30 16:50:00+07', 'jpg', '10 cuộn', 'Rau tươi', 125000.00),
(100140, '2023-10-22 11:00:00+07', '2024-10-11 14:10:00+07', 'jpg', '10 cuộn', 'Rau kimchi', 132000.00);

-- Product 100141: Samgyeopsal phô mai
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100141, '2024-01-15 12:30:00+07', '2024-04-02 15:15:00+07', 'jpg', '200g', 'Phô mai Mozzarella', 95000.00),
(100141, '2024-01-15 12:30:00+07', '2024-07-08 11:00:00+07', 'jpg', '200g', 'Phô mai Cheddar', 95000.00),
(100141, '2024-01-15 12:30:00+07', '2024-09-22 16:30:00+07', 'jpg', '350g', 'Phô mai Mozzarella', 165000.00),
(100141, '2024-01-15 12:30:00+07', '2024-10-16 13:45:00+07', 'jpg', '350g', 'Phô mai Cheddar', 165000.00);

-- Product 100142: Samgyeopsal sốt cay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100142, '2024-04-30 14:00:00+07', '2024-07-15 10:30:00+07', 'jpg', '200g', 'Cay vừa', 88000.00),
(100142, '2024-04-30 14:00:00+07', '2024-09-05 15:20:00+07', 'jpg', '200g', 'Cay nồng', 88000.00),
(100142, '2024-04-30 14:00:00+07', '2024-10-14 11:50:00+07', 'jpg', '200g', 'Siêu cay', 88000.00),
(100142, '2024-04-30 14:00:00+07', '2024-10-21 14:25:00+07', 'jpg', '350g', 'Cay vừa', 152000.00),
(100142, '2024-04-30 14:00:00+07', '2024-10-21 15:00:00+07', 'jpg', '350g', 'Cay nồng', 152000.00),
(100142, '2024-04-30 14:00:00+07', '2024-10-21 16:10:00+07', 'jpg', '350g', 'Siêu cay', 152000.00);

-- Product 100143: Samgyeopsal marinaded
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100143, '2024-08-15 11:00:00+07', '2024-09-28 13:30:00+07', 'jpg', '250g', 'Ướp tỏi', 92000.00),
(100143, '2024-08-15 11:00:00+07', '2024-10-10 16:15:00+07', 'jpg', '250g', 'Ướp mật ong', 95000.00),
(100143, '2024-08-15 11:00:00+07', '2024-10-18 14:40:00+07', 'jpg', '400g', 'Ướp tỏi', 158000.00),
(100143, '2024-08-15 11:00:00+07', '2024-10-20 11:20:00+07', 'jpg', '400g', 'Ướp mật ong', 165000.00);

-- Product 100144: Samgyeopsal combo
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100144, '2024-11-28 13:30:00+07', '2024-12-05 15:00:00+07', 'jpg', 'Combo 2 người', 'Cơ bản', 285000.00),
(100144, '2024-11-28 13:30:00+07', '2024-12-08 11:45:00+07', 'jpg', 'Combo 2 người', 'Đặc biệt', 325000.00),
(100144, '2024-11-28 13:30:00+07', '2024-12-12 14:20:00+07', 'jpg', 'Combo 4 người', 'Cơ bản', 540000.00),
(100144, '2024-11-28 13:30:00+07', '2024-12-15 16:30:00+07', 'jpg', 'Combo 4 người', 'Đặc biệt', 620000.00);

-- Product 100145: Ramen tonkotsu
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100145, '2023-05-20 09:00:00+07', '2023-07-15 14:30:00+07', 'jpg', 'nhỏ', 'thường', 65000.00),
(100145, '2023-05-20 09:00:00+07', '2023-08-22 10:15:00+07', 'jpg', 'nhỏ', 'thêm trứng', 75000.00),
(100145, '2023-05-20 09:00:00+07', '2023-09-10 16:45:00+07', 'jpg', 'nhỏ', 'thêm thịt xá xíu', 85000.00),
(100145, '2023-05-20 09:00:00+07', '2023-06-18 11:20:00+07', 'jpg', 'lớn', 'thường', 85000.00),
(100145, '2023-05-20 09:00:00+07', '2023-10-05 13:50:00+07', 'jpg', 'lớn', 'thêm trứng', 95000.00),
(100145, '2023-05-20 09:00:00+07', '2024-01-12 09:30:00+07', 'jpg', 'lớn', 'thêm thịt xá xíu', 105000.00);

-- Product 100146: Ramen miso
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100146, '2023-08-08 11:00:00+07', '2023-09-20 15:00:00+07', 'jpg', 'nhỏ', 'thường', 68000.00),
(100146, '2023-08-08 11:00:00+07', '2023-11-05 12:30:00+07', 'jpg', 'nhỏ', 'thêm rong biển', 78000.00),
(100146, '2023-08-08 11:00:00+07', '2024-02-14 10:45:00+07', 'jpg', 'lớn', 'thường', 88000.00),
(100146, '2023-08-08 11:00:00+07', '2024-03-22 14:20:00+07', 'jpg', 'lớn', 'thêm rong biển', 98000.00);

-- Product 100147: Ramen shoyu
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100147, '2023-11-15 12:00:00+07', '2023-12-28 16:15:00+07', 'jpg', 'nhỏ', 'thường', 62000.00),
(100147, '2023-11-15 12:00:00+07', '2024-01-30 11:40:00+07', 'jpg', 'nhỏ', 'thêm măng', 72000.00),
(100147, '2023-11-15 12:00:00+07', '2024-04-18 09:55:00+07', 'jpg', 'nhỏ', 'thêm thịt gà', 82000.00),
(100147, '2023-11-15 12:00:00+07', '2024-02-20 13:25:00+07', 'jpg', 'vừa', 'thường', 75000.00),
(100147, '2023-11-15 12:00:00+07', '2024-05-10 10:30:00+07', 'jpg', 'vừa', 'thêm măng', 85000.00),
(100147, '2023-11-15 12:00:00+07', '2024-06-25 14:50:00+07', 'jpg', 'vừa', 'thêm thịt gà', 95000.00),
(100147, '2023-11-15 12:00:00+07', '2024-03-15 15:10:00+07', 'jpg', 'lớn', 'thường', 88000.00),
(100147, '2023-11-15 12:00:00+07', '2024-07-08 11:45:00+07', 'jpg', 'lớn', 'thêm măng', 98000.00),
(100147, '2023-11-15 12:00:00+07', '2024-08-19 13:20:00+07', 'jpg', 'lớn', 'thêm thịt gà', 108000.00);

-- Product 100148: Ramen cay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100148, '2024-02-05 13:15:00+07', '2024-03-18 10:30:00+07', 'jpg', 'nhỏ', 'cay vừa', 70000.00),
(100148, '2024-02-05 13:15:00+07', '2024-04-22 14:45:00+07', 'jpg', 'nhỏ', 'cay nhiều', 70000.00),
(100148, '2024-02-05 13:15:00+07', '2024-05-30 09:20:00+07', 'jpg', 'lớn', 'cay vừa', 90000.00),
(100148, '2024-02-05 13:15:00+07', '2024-07-12 15:55:00+07', 'jpg', 'lớn', 'cay nhiều', 90000.00);

-- Product 100149: Ramen hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100149, '2024-05-22 09:00:00+07', '2024-06-15 11:30:00+07', 'jpg', 'nhỏ', 'thường', 85000.00),
(100149, '2024-05-22 09:00:00+07', '2024-07-20 13:45:00+07', 'jpg', 'nhỏ', 'thêm tôm', 105000.00),
(100149, '2024-05-22 09:00:00+07', '2024-08-25 10:15:00+07', 'jpg', 'lớn', 'thường', 110000.00),
(100149, '2024-05-22 09:00:00+07', '2024-09-30 14:50:00+07', 'jpg', 'lớn', 'thêm tôm', 130000.00);

-- Product 100150: Ramen tsukemen
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100150, '2024-08-10 11:30:00+07', '2024-09-05 15:20:00+07', 'jpg', 'default', 'nước sốt đậm đà', 95000.00),
(100150, '2024-08-10 11:30:00+07', '2024-10-10 12:40:00+07', 'jpg', 'default', 'nước sốt nhẹ', 95000.00);

-- Product 100151: Ramen trứng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100151, '2024-11-05 12:00:00+07', '2024-11-20 10:30:00+07', 'jpg', 'nhỏ', '1 trứng', 65000.00),
(100151, '2024-11-05 12:00:00+07', '2024-12-08 14:15:00+07', 'jpg', 'nhỏ', '2 trứng', 80000.00),
(100151, '2024-11-05 12:00:00+07', '2024-11-28 11:45:00+07', 'jpg', 'lớn', '1 trứng', 85000.00),
(100151, '2024-11-05 12:00:00+07', '2025-01-05 09:50:00+07', 'jpg', 'lớn', '2 trứng', 100000.00);

-- Product 100152: Udon nước
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100152, '2023-06-10 08:30:00+07', '2023-07-22 13:20:00+07', 'jpg', 'nhỏ', 'thường', 55000.00),
(100152, '2023-06-10 08:30:00+07', '2023-09-14 10:45:00+07', 'jpg', 'nhỏ', 'thêm chả cá', 68000.00),
(100152, '2023-06-10 08:30:00+07', '2023-10-28 15:30:00+07', 'jpg', 'vừa', 'thường', 68000.00),
(100152, '2023-06-10 08:30:00+07', '2023-12-05 11:20:00+07', 'jpg', 'vừa', 'thêm chả cá', 81000.00),
(100152, '2023-06-10 08:30:00+07', '2024-01-18 14:00:00+07', 'jpg', 'lớn', 'thường', 81000.00),
(100152, '2023-06-10 08:30:00+07', '2024-03-25 09:40:00+07', 'jpg', 'lớn', 'thêm chả cá', 94000.00);

-- Product 100153: Udon xào
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100153, '2023-09-22 10:00:00+07', '2023-10-30 12:45:00+07', 'jpg', 'default', 'rau củ', 60000.00),
(100153, '2023-09-22 10:00:00+07', '2023-11-20 15:20:00+07', 'jpg', 'default', 'thịt bò', 75000.00),
(100153, '2023-09-22 10:00:00+07', '2024-01-08 10:30:00+07', 'jpg', 'default', 'hải sản', 85000.00);

-- Product 100154: Udon curry
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100154, '2023-12-10 11:30:00+07', '2024-01-15 14:50:00+07', 'jpg', 'nhỏ', 'thường', 70000.00),
(100154, '2023-12-10 11:30:00+07', '2024-02-28 10:15:00+07', 'jpg', 'nhỏ', 'thêm thịt gà', 85000.00),
(100154, '2023-12-10 11:30:00+07', '2024-04-10 13:40:00+07', 'jpg', 'lớn', 'thường', 90000.00),
(100154, '2023-12-10 11:30:00+07', '2024-05-22 11:25:00+07', 'jpg', 'lớn', 'thêm thịt gà', 105000.00);

-- Product 100155: Udon tempura
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100155, '2024-03-18 13:00:00+07', '2024-04-25 15:30:00+07', 'jpg', 'nhỏ', 'tempura rau', 75000.00),
(100155, '2024-03-18 13:00:00+07', '2024-06-08 12:45:00+07', 'jpg', 'nhỏ', 'tempura tôm', 95000.00),
(100155, '2024-03-18 13:00:00+07', '2024-07-15 10:20:00+07', 'jpg', 'lớn', 'tempura rau', 95000.00),
(100155, '2024-03-18 13:00:00+07', '2024-08-30 14:55:00+07', 'jpg', 'lớn', 'tempura tôm', 115000.00);

-- Product 100156: Udon nóng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100156, '2024-06-25 09:15:00+07', '2024-07-18 11:40:00+07', 'jpg', 'nhỏ', 'thường', 58000.00),
(100156, '2024-06-25 09:15:00+07', '2024-08-22 13:25:00+07', 'jpg', 'nhỏ', 'thêm hành tươi', 63000.00),
(100156, '2024-06-25 09:15:00+07', '2024-09-10 15:50:00+07', 'jpg', 'lớn', 'thường', 78000.00),
(100156, '2024-06-25 09:15:00+07', '2024-10-05 10:30:00+07', 'jpg', 'lớn', 'thêm hành tươi', 83000.00);

-- Product 100157: Udon lạnh
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100157, '2024-09-15 10:45:00+07', '2024-10-08 14:20:00+07', 'jpg', 'default', 'nước chấm gừng', 65000.00),
(100157, '2024-09-15 10:45:00+07', '2024-11-12 11:35:00+07', 'jpg', 'default', 'nước chấm mè', 65000.00);

-- Product 100158: Udon bò
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100158, '2024-12-02 12:15:00+07', '2024-12-20 10:40:00+07', 'jpg', 'nhỏ', 'thường', 72000.00),
(100158, '2024-12-02 12:15:00+07', '2025-01-10 14:25:00+07', 'jpg', 'nhỏ', 'thêm nấm', 82000.00),
(100158, '2024-12-02 12:15:00+07', '2024-12-28 16:10:00+07', 'jpg', 'lớn', 'thường', 95000.00),
(100158, '2024-12-02 12:15:00+07', '2025-02-05 12:50:00+07', 'jpg', 'lớn', 'thêm nấm', 105000.00);

-- Product 100159: Katsudon thịt heo
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100159, '2023-06-28 08:45:00+07', '2023-08-05 13:30:00+07', 'jpg', 'default', 'trứng lòng đào', 78000.00),
(100159, '2023-06-28 08:45:00+07', '2023-09-20 10:15:00+07', 'jpg', 'default', 'trứng chín kỹ', 78000.00);

-- Product 100160: Katsudon gà
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100160, '2023-10-05 10:15:00+07', '2023-11-18 14:40:00+07', 'jpg', 'default', 'sốt katsu', 75000.00),
(100160, '2023-10-05 10:15:00+07', '2024-01-05 11:25:00+07', 'jpg', 'default', 'sốt teriyaki', 75000.00);

-- Product 100161: Katsudon bò
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100161, '2024-01-20 11:45:00+07', '2024-02-28 15:20:00+07', 'jpg', 'default', 'thường', 88000.00),
(100161, '2024-01-20 11:45:00+07', '2024-04-10 13:50:00+07', 'jpg', 'default', 'thêm phô mai', 98000.00);

-- Product 100162: Katsudon cá
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100162, '2024-04-10 13:15:00+07', '2024-05-22 10:30:00+07', 'jpg', 'default', 'sốt tartar', 82000.00),
(100162, '2024-04-10 13:15:00+07', '2024-06-30 14:45:00+07', 'jpg', 'default', 'sốt ponzu', 82000.00);

-- Product 100163: Katsudon trứng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100163, '2024-07-18 09:00:00+07', '2024-08-12 11:40:00+07', 'jpg', 'default', '2 trứng', 65000.00),
(100163, '2024-07-18 09:00:00+07', '2024-09-25 15:15:00+07', 'jpg', 'default', '3 trứng', 75000.00);

-- Product 100164: Katsudon đặc biệt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100164, '2024-10-28 10:30:00+07', '2024-11-15 13:20:00+07', 'jpg', 'default', 'thường', 110000.00),
(100164, '2024-10-28 10:30:00+07', '2024-12-05 11:45:00+07', 'jpg', 'default', 'thêm topping đặc biệt', 135000.00),
(100164, '2024-10-28 10:30:00+07', '2025-01-18 14:30:00+07', 'jpg', 'default', 'combo với nước', 145000.00);

-- Product 100165: Takoyaki bạch tuộc
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100165, '2023-05-15 10:30:00+07', '2023-06-20 14:15:00+07', 'jpg', '6 viên', 'Sốt mayonnaise', 35000.00),
(100165, '2023-05-15 10:30:00+07', '2023-07-10 16:20:00+07', 'jpg', '6 viên', 'Sốt teriyaki', 38000.00),
(100165, '2023-05-15 10:30:00+07', '2023-08-05 11:30:00+07', 'jpg', '8 viên', 'Sốt mayonnaise', 45000.00),
(100165, '2023-05-15 10:30:00+07', '2023-08-25 13:45:00+07', 'jpg', '8 viên', 'Sốt teriyaki', 48000.00);

-- Product 100166: Takoyaki phô mai
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100166, '2023-07-30 11:00:00+07', '2023-09-12 10:20:00+07', 'jpg', '6 viên', 'Phô mai cheddar', 42000.00),
(100166, '2023-07-30 11:00:00+07', '2023-10-05 15:30:00+07', 'jpg', '6 viên', 'Phô mai mozzarella', 45000.00),
(100166, '2023-07-30 11:00:00+07', '2023-11-18 09:45:00+07', 'jpg', '8 viên', 'Phô mai cheddar', 55000.00),
(100166, '2023-07-30 11:00:00+07', '2024-01-22 14:10:00+07', 'jpg', '8 viên', 'Phô mai mozzarella', 58000.00);

-- Product 100167: Takoyaki tôm
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100167, '2023-10-18 13:15:00+07', '2023-12-08 11:25:00+07', 'jpg', '6 viên', 'Tôm nguyên con', 48000.00),
(100167, '2023-10-18 13:15:00+07', '2024-02-15 16:40:00+07', 'jpg', '6 viên', 'Tôm băm', 45000.00),
(100167, '2023-10-18 13:15:00+07', '2024-03-20 10:15:00+07', 'jpg', '10 viên', 'Tôm nguyên con', 75000.00),
(100167, '2023-10-18 13:15:00+07', '2024-05-10 14:30:00+07', 'jpg', '10 viên', 'Tôm băm', 70000.00);

-- Product 100168: Takoyaki mực
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100168, '2024-01-08 14:00:00+07', '2024-02-20 09:30:00+07', 'jpg', '6 viên', 'Mực tươi', 40000.00),
(100168, '2024-01-08 14:00:00+07', '2024-04-15 13:50:00+07', 'jpg', '6 viên', 'Mực khô', 38000.00),
(100168, '2024-01-08 14:00:00+07', '2024-06-08 11:20:00+07', 'jpg', '8 viên', 'Mực tươi', 52000.00),
(100168, '2024-01-08 14:00:00+07', '2024-07-22 15:10:00+07', 'jpg', '8 viên', 'Mực khô', 50000.00);

-- Product 100169: Takoyaki hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100169, '2024-03-25 10:30:00+07', '2024-05-10 14:20:00+07', 'jpg', '6 viên', 'Hải sản thập cẩm', 52000.00),
(100169, '2024-03-25 10:30:00+07', '2024-06-18 09:45:00+07', 'jpg', '6 viên', 'Hải sản cao cấp', 58000.00),
(100169, '2024-03-25 10:30:00+07', '2024-07-25 16:30:00+07', 'jpg', '10 viên', 'Hải sản thập cẩm', 82000.00),
(100169, '2024-03-25 10:30:00+07', '2024-09-05 11:15:00+07', 'jpg', '10 viên', 'Hải sản cao cấp', 92000.00);

-- Product 100170: Takoyaki cay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100170, '2024-06-12 12:00:00+07', '2024-07-20 10:30:00+07', 'jpg', '6 viên', 'Cay vừa', 38000.00),
(100170, '2024-06-12 12:00:00+07', '2024-08-15 14:45:00+07', 'jpg', '6 viên', 'Cay nồng', 40000.00),
(100170, '2024-06-12 12:00:00+07', '2024-09-22 09:20:00+07', 'jpg', '8 viên', 'Cay vừa', 50000.00),
(100170, '2024-06-12 12:00:00+07', '2024-10-12 16:10:00+07', 'jpg', '8 viên', 'Cay nồng', 52000.00);

-- Product 100171: Takoyaki truyền thống
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100171, '2024-09-05 13:30:00+07', '2024-10-10 11:45:00+07', 'jpg', '6 viên', 'Không topping', 35000.00),
(100171, '2024-09-05 13:30:00+07', '2024-10-18 15:20:00+07', 'jpg', '6 viên', 'Rắc bột cá ngừ', 38000.00),
(100171, '2024-09-05 13:30:00+07', NULL, 'jpg', '8 viên', 'Không topping', 45000.00),
(100171, '2024-09-05 13:30:00+07', NULL, 'jpg', '8 viên', 'Rắc bột cá ngừ', 48000.00);

-- Product 100172: Takoyaki sốt teriyaki
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100172, '2024-11-22 11:15:00+07', NULL, 'jpg', '6 viên', 'Sốt teriyaki ngọt', 40000.00),
(100172, '2024-11-22 11:15:00+07', NULL, 'jpg', '6 viên', 'Sốt teriyaki mặn', 40000.00),
(100172, '2024-11-22 11:15:00+07', NULL, 'jpg', '10 viên', 'Sốt teriyaki ngọt', 65000.00),
(100172, '2024-11-22 11:15:00+07', NULL, 'jpg', '10 viên', 'Sốt teriyaki mặn', 65000.00);

-- Product 100173: Takoyaki mini
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100173, '2025-02-10 14:00:00+07', '2025-03-15 10:20:00+07', 'jpg', '12 viên', 'Sốt mayonnaise', 45000.00),
(100173, '2025-02-10 14:00:00+07', '2025-04-08 15:45:00+07', 'jpg', '12 viên', 'Sốt BBQ', 48000.00),
(100173, '2025-02-10 14:00:00+07', '2025-05-20 09:30:00+07', 'jpg', '20 viên', 'Sốt mayonnaise', 70000.00),
(100173, '2025-02-10 14:00:00+07', '2025-06-25 14:10:00+07', 'jpg', '20 viên', 'Sốt BBQ', 75000.00);

-- Product 100174: Takoyaki phô mai mozzarella
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100174, '2023-06-20 10:00:00+07', '2023-08-05 11:30:00+07', 'jpg', '6 viên', 'Mozzarella tan chảy', 48000.00),
(100174, '2023-06-20 10:00:00+07', '2023-09-18 14:20:00+07', 'jpg', '6 viên', 'Mozzarella giòn', 45000.00),
(100174, '2023-06-20 10:00:00+07', '2023-11-22 16:40:00+07', 'jpg', '8 viên', 'Mozzarella tan chảy', 62000.00),
(100174, '2023-06-20 10:00:00+07', '2024-01-10 10:15:00+07', 'jpg', '8 viên', 'Mozzarella giòn', 58000.00);

-- Product 100175: Takoyaki sốt đen
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100175, '2023-09-12 11:30:00+07', '2023-11-05 13:20:00+07', 'jpg', '6 viên', 'Sốt mực đen', 42000.00),
(100175, '2023-09-12 11:30:00+07', '2024-01-18 15:45:00+07', 'jpg', '6 viên', 'Sốt nấm đen', 40000.00),
(100175, '2023-09-12 11:30:00+07', '2024-03-22 09:30:00+07', 'jpg', '10 viên', 'Sốt mực đen', 68000.00),
(100175, '2023-09-12 11:30:00+07', '2024-05-15 14:10:00+07', 'jpg', '10 viên', 'Sốt nấm đen', 65000.00);

-- Product 100176: Takoyaki tương ớt
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100176, '2023-12-05 13:00:00+07', '2024-02-08 11:25:00+07', 'jpg', '6 viên', 'Tương ớt Hàn Quốc', 38000.00),
(100176, '2023-12-05 13:00:00+07', '2024-04-12 16:30:00+07', 'jpg', '6 viên', 'Tương ớt Thái Lan', 40000.00),
(100176, '2023-12-05 13:00:00+07', '2024-06-20 10:15:00+07', 'jpg', '8 viên', 'Tương ớt Hàn Quốc', 50000.00),
(100176, '2023-12-05 13:00:00+07', '2024-08-05 14:45:00+07', 'jpg', '8 viên', 'Tương ớt Thái Lan', 52000.00);

-- Product 100177: Takoyaki rong biển
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100177, '2024-02-28 14:30:00+07', '2024-04-15 09:40:00+07', 'jpg', '6 viên', 'Rong biển giòn', 40000.00),
(100177, '2024-02-28 14:30:00+07', '2024-06-10 13:20:00+07', 'jpg', '6 viên', 'Rong biển tươi', 42000.00),
(100177, '2024-02-28 14:30:00+07', '2024-08-18 16:10:00+07', 'jpg', '10 viên', 'Rong biển giòn', 65000.00),
(100177, '2024-02-28 14:30:00+07', '2024-09-25 11:30:00+07', 'jpg', '10 viên', 'Rong biển tươi', 68000.00);

-- Product 100178: Takoyaki cua
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100178, '2024-05-20 10:15:00+07', '2024-07-08 14:30:00+07', 'jpg', '6 viên', 'Cua thịt', 55000.00),
(100178, '2024-05-20 10:15:00+07', '2024-08-22 09:45:00+07', 'jpg', '6 viên', 'Cua gạch', 58000.00),
(100178, '2024-05-20 10:15:00+07', '2024-09-30 16:20:00+07', 'jpg', '8 viên', 'Cua thịt', 72000.00),
(100178, '2024-05-20 10:15:00+07', '2024-10-15 11:10:00+07', 'jpg', '8 viên', 'Cua gạch', 75000.00);

-- Product 100179: Takoyaki bơ
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100179, '2024-08-08 11:45:00+07', '2024-09-20 10:30:00+07', 'jpg', '6 viên', 'Bơ tỏi', 45000.00),
(100179, '2024-08-08 11:45:00+07', '2024-10-10 15:20:00+07', 'jpg', '6 viên', 'Bơ thảo mộc', 48000.00),
(100179, '2024-08-08 11:45:00+07', NULL, 'jpg', '10 viên', 'Bơ tỏi', 72000.00),
(100179, '2024-08-08 11:45:00+07', NULL, 'jpg', '10 viên', 'Bơ thảo mộc', 75000.00);

-- Product 100180: Takoyaki xúc xích
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100180, '2024-10-25 13:15:00+07', NULL, 'jpg', '6 viên', 'Xúc xích gà', 40000.00),
(100180, '2024-10-25 13:15:00+07', NULL, 'jpg', '6 viên', 'Xúc xích heo', 42000.00),
(100180, '2024-10-25 13:15:00+07', NULL, 'jpg', '8 viên', 'Xúc xích gà', 52000.00),
(100180, '2024-10-25 13:15:00+07', NULL, 'jpg', '8 viên', 'Xúc xích heo', 55000.00);

-- Product 100181: Takoyaki thập cẩm
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100181, '2025-01-15 11:00:00+07', '2025-02-28 14:20:00+07', 'jpg', '6 viên', 'Thập cẩm đặc biệt', 52000.00),
(100181, '2025-01-15 11:00:00+07', '2025-04-10 09:35:00+07', 'jpg', '6 viên', 'Thập cẩm cao cấp', 58000.00),
(100181, '2025-01-15 11:00:00+07', '2025-06-05 16:15:00+07', 'jpg', '10 viên', 'Thập cẩm đặc biệt', 85000.00),
(100181, '2025-01-15 11:00:00+07', '2025-08-18 11:40:00+07', 'jpg', '10 viên', 'Thập cẩm cao cấp', 95000.00);

-- Product 100182: Takoyaki trứng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100182, '2025-03-05 14:00:00+07', '2025-04-22 10:25:00+07', 'jpg', '6 viên', 'Trứng gà', 38000.00),
(100182, '2025-03-05 14:00:00+07', '2025-06-15 15:40:00+07', 'jpg', '6 viên', 'Trứng cút', 40000.00),
(100182, '2025-03-05 14:00:00+07', '2025-08-08 09:20:00+07', 'jpg', '8 viên', 'Trứng gà', 50000.00),
(100182, '2025-03-05 14:00:00+07', '2025-09-25 14:50:00+07', 'jpg', '8 viên', 'Trứng cút', 52000.00);

-- Product 100183: Trà sữa truyền thống
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100183, '2023-04-26 09:30:00+07', '2023-06-15 10:00:00+07', 'jpg', 'M', 'Trân châu trắng', 35000.00),
(100183, '2023-04-26 09:30:00+07', '2023-06-15 10:00:00+07', 'jpg', 'M', 'Trân châu đen', 35000.00),
(100183, '2023-04-26 09:30:00+07', '2023-07-20 14:30:00+07', 'jpg', 'M', 'Pudding', 38000.00),
(100183, '2023-04-26 09:30:00+07', '2023-05-10 11:00:00+07', 'jpg', 'L', 'Trân châu trắng', 42000.00),
(100183, '2023-04-26 09:30:00+07', '2023-05-10 11:00:00+07', 'jpg', 'L', 'Trân châu đen', 42000.00),
(100183, '2023-04-26 09:30:00+07', '2023-07-20 14:30:00+07', 'jpg', 'L', 'Pudding', 45000.00);

-- Product 100184: Trà sữa trân châu đường đen
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100184, '2023-07-11 10:00:00+07', '2023-08-25 15:00:00+07', 'jpg', 'M', 'Đường đen thường', 38000.00),
(100184, '2023-07-11 10:00:00+07', '2023-09-10 11:30:00+07', 'jpg', 'M', 'Thạch dừa', 40000.00),
(100184, '2023-07-11 10:00:00+07', '2023-08-25 15:00:00+07', 'jpg', 'L', 'Đường đen thường', 45000.00),
(100184, '2023-07-11 10:00:00+07', '2023-09-10 11:30:00+07', 'jpg', 'L', 'Thạch dừa', 47000.00);

-- Product 100185: Trà sữa matcha
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100185, '2023-10-06 11:30:00+07', '2023-11-20 09:00:00+07', 'jpg', 'S', 'Không topping', 32000.00),
(100185, '2023-10-06 11:30:00+07', '2023-12-05 14:00:00+07', 'jpg', 'S', 'Trân châu trắng', 35000.00),
(100185, '2023-10-06 11:30:00+07', '2023-12-05 14:00:00+07', 'jpg', 'S', 'Thạch rau câu', 35000.00),
(100185, '2023-10-06 11:30:00+07', '2023-11-20 09:00:00+07', 'jpg', 'M', 'Không topping', 38000.00),
(100185, '2023-10-06 11:30:00+07', '2023-12-05 14:00:00+07', 'jpg', 'M', 'Trân châu trắng', 41000.00),
(100185, '2023-10-06 11:30:00+07', '2023-12-05 14:00:00+07', 'jpg', 'M', 'Thạch rau câu', 41000.00),
(100185, '2023-10-06 11:30:00+07', '2023-11-20 09:00:00+07', 'jpg', 'L', 'Không topping', 45000.00),
(100185, '2023-10-06 11:30:00+07', '2023-12-05 14:00:00+07', 'jpg', 'L', 'Trân châu trắng', 48000.00),
(100185, '2023-10-06 11:30:00+07', '2023-12-05 14:00:00+07', 'jpg', 'L', 'Thạch rau câu', 48000.00);

-- Product 100186: Trà sữa socola
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100186, '2024-01-16 13:00:00+07', '2024-03-10 10:30:00+07', 'jpg', 'M', 'Thạch socola', 40000.00),
(100186, '2024-01-16 13:00:00+07', '2024-02-28 16:00:00+07', 'jpg', 'M', 'Kem socola', 42000.00),
(100186, '2024-01-16 13:00:00+07', '2024-03-10 10:30:00+07', 'jpg', 'L', 'Thạch socola', 47000.00),
(100186, '2024-01-16 13:00:00+07', '2024-02-28 16:00:00+07', 'jpg', 'L', 'Kem socola', 49000.00);

-- Product 100187: Trà sữa khoai môn
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100187, '2024-04-06 09:15:00+07', '2024-05-20 11:00:00+07', 'jpg', 'M', 'Khoai môn nghiền', 40000.00),
(100187, '2024-04-06 09:15:00+07', '2024-06-10 14:30:00+07', 'jpg', 'M', 'Trân châu khoai môn', 42000.00),
(100187, '2024-04-06 09:15:00+07', '2024-05-20 11:00:00+07', 'jpg', 'L', 'Khoai môn nghiền', 47000.00),
(100187, '2024-04-06 09:15:00+07', '2024-06-10 14:30:00+07', 'jpg', 'L', 'Trân châu khoai môn', 49000.00);

-- Product 100188: Trà sữa dâu
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100188, '2024-06-23 10:45:00+07', '2024-07-30 09:00:00+07', 'jpg', 'S', 'Thạch dâu', 33000.00),
(100188, '2024-06-23 10:45:00+07', '2024-08-15 13:30:00+07', 'jpg', 'S', 'Dâu tươi', 38000.00),
(100188, '2024-06-23 10:45:00+07', '2024-07-30 09:00:00+07', 'jpg', 'M', 'Thạch dâu', 39000.00),
(100188, '2024-06-23 10:45:00+07', '2024-08-15 13:30:00+07', 'jpg', 'M', 'Dâu tươi', 44000.00),
(100188, '2024-06-23 10:45:00+07', '2024-07-30 09:00:00+07', 'jpg', 'L', 'Thạch dâu', 46000.00),
(100188, '2024-06-23 10:45:00+07', '2024-08-15 13:30:00+07', 'jpg', 'L', 'Dâu tươi', 51000.00);

-- Product 100189: Cà phê sữa đá
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100189, '2023-05-19 08:45:00+07', '2023-07-05 10:00:00+07', 'jpg', 'Nhỏ', 'Đường thường', 22000.00),
(100189, '2023-05-19 08:45:00+07', '2023-08-12 14:30:00+07', 'jpg', 'Nhỏ', 'Ít đường', 22000.00),
(100189, '2023-05-19 08:45:00+07', '2023-07-05 10:00:00+07', 'jpg', 'Vừa', 'Đường thường', 27000.00),
(100189, '2023-05-19 08:45:00+07', '2023-08-12 14:30:00+07', 'jpg', 'Vừa', 'Ít đường', 27000.00),
(100189, '2023-05-19 08:45:00+07', '2023-07-05 10:00:00+07', 'jpg', 'Lớn', 'Đường thường', 32000.00),
(100189, '2023-05-19 08:45:00+07', '2023-08-12 14:30:00+07', 'jpg', 'Lớn', 'Ít đường', 32000.00);

-- Product 100190: Cà phê đen đá
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100190, '2023-08-13 10:15:00+07', '2023-09-20 11:30:00+07', 'jpg', 'Nhỏ', 'Đường thường', 18000.00),
(100190, '2023-08-13 10:15:00+07', '2023-10-05 15:00:00+07', 'jpg', 'Nhỏ', 'Không đường', 18000.00),
(100190, '2023-08-13 10:15:00+07', '2023-09-20 11:30:00+07', 'jpg', 'Vừa', 'Đường thường', 23000.00),
(100190, '2023-08-13 10:15:00+07', '2023-10-05 15:00:00+07', 'jpg', 'Vừa', 'Không đường', 23000.00),
(100190, '2023-08-13 10:15:00+07', '2023-09-20 11:30:00+07', 'jpg', 'Lớn', 'Đường thường', 28000.00),
(100190, '2023-08-13 10:15:00+07', '2023-10-05 15:00:00+07', 'jpg', 'Lớn', 'Không đường', 28000.00);

-- Product 100191: Cà phê bạc xỉu
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100191, '2023-11-09 11:45:00+07', '2023-12-20 09:30:00+07', 'jpg', 'Nhỏ', 'Nóng', 25000.00),
(100191, '2023-11-09 11:45:00+07', '2023-12-20 09:30:00+07', 'jpg', 'Nhỏ', 'Đá', 25000.00),
(100191, '2023-11-09 11:45:00+07', '2024-01-15 14:00:00+07', 'jpg', 'Vừa', 'Nóng', 30000.00),
(100191, '2023-11-09 11:45:00+07', '2024-01-15 14:00:00+07', 'jpg', 'Vừa', 'Đá', 30000.00);

-- Product 100192: Cà phê nóng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100192, '2024-02-21 13:15:00+07', '2024-04-10 10:00:00+07', 'jpg', '150ml', 'Đen', 20000.00),
(100192, '2024-02-21 13:15:00+07', '2024-04-10 10:00:00+07', 'jpg', '150ml', 'Sữa', 23000.00),
(100192, '2024-02-21 13:15:00+07', '2024-04-10 10:00:00+07', 'jpg', '250ml', 'Đen', 28000.00),
(100192, '2024-02-21 13:15:00+07', '2024-04-10 10:00:00+07', 'jpg', '250ml', 'Sữa', 31000.00);

-- Product 100193: Cà phê cốt dừa
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100193, '2024-05-11 09:00:00+07', '2024-06-25 11:30:00+07', 'jpg', 'M', 'Cốt dừa tươi', 35000.00),
(100193, '2024-05-11 09:00:00+07', '2024-07-15 14:00:00+07', 'jpg', 'M', 'Thạch dừa', 37000.00),
(100193, '2024-05-11 09:00:00+07', '2024-06-25 11:30:00+07', 'jpg', 'L', 'Cốt dừa tươi', 42000.00),
(100193, '2024-05-11 09:00:00+07', '2024-07-15 14:00:00+07', 'jpg', 'L', 'Thạch dừa', 44000.00);

-- Product 100194: Trà đào cam sả
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100194, '2023-06-09 09:30:00+07', '2023-07-22 10:45:00+07', 'jpg', 'M', 'Ít đá', 32000.00),
(100194, '2023-06-09 09:30:00+07', '2023-08-10 15:30:00+07', 'jpg', 'M', 'Nhiều đá', 32000.00),
(100194, '2023-06-09 09:30:00+07', '2023-09-05 11:00:00+07', 'jpg', 'M', 'Thạch đào', 35000.00),
(100194, '2023-06-09 09:30:00+07', '2023-07-22 10:45:00+07', 'jpg', 'L', 'Ít đá', 38000.00),
(100194, '2023-06-09 09:30:00+07', '2023-08-10 15:30:00+07', 'jpg', 'L', 'Nhiều đá', 38000.00),
(100194, '2023-06-09 09:30:00+07', '2023-09-05 11:00:00+07', 'jpg', 'L', 'Thạch đào', 41000.00);

-- Product 100195: Trà đào
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100195, '2023-09-16 11:00:00+07', '2023-10-28 09:30:00+07', 'jpg', 'M', 'Đào tươi', 30000.00),
(100195, '2023-09-16 11:00:00+07', '2023-11-15 14:00:00+07', 'jpg', 'M', 'Đào ngâm', 28000.00),
(100195, '2023-09-16 11:00:00+07', '2023-10-28 09:30:00+07', 'jpg', 'L', 'Đào tươi', 36000.00),
(100195, '2023-09-16 11:00:00+07', '2023-11-15 14:00:00+07', 'jpg', 'L', 'Đào ngâm', 34000.00);

-- Product 100196: Trà cam sả
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100196, '2023-12-23 12:15:00+07', '2024-02-05 10:00:00+07', 'jpg', 'S', 'Ít đường', 25000.00),
(100196, '2023-12-23 12:15:00+07', '2024-02-05 10:00:00+07', 'jpg', 'S', 'Đường thường', 25000.00),
(100196, '2023-12-23 12:15:00+07', '2024-02-05 10:00:00+07', 'jpg', 'M', 'Ít đường', 30000.00),
(100196, '2023-12-23 12:15:00+07', '2024-02-05 10:00:00+07', 'jpg', 'M', 'Đường thường', 30000.00),
(100196, '2023-12-23 12:15:00+07', '2024-02-05 10:00:00+07', 'jpg', 'L', 'Ít đường', 35000.00),
(100196, '2023-12-23 12:15:00+07', '2024-02-05 10:00:00+07', 'jpg', 'L', 'Đường thường', 35000.00);

-- Product 100197: Trà đào chanh sả
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100197, '2024-03-13 13:00:00+07', '2024-04-25 11:30:00+07', 'jpg', 'M', 'Đào tươi', 33000.00),
(100197, '2024-03-13 13:00:00+07', '2024-05-18 15:00:00+07', 'jpg', 'M', 'Thạch đào', 35000.00),
(100197, '2024-03-13 13:00:00+07', '2024-04-25 11:30:00+07', 'jpg', 'L', 'Đào tươi', 39000.00),
(100197, '2024-03-13 13:00:00+07', '2024-05-18 15:00:00+07', 'jpg', 'L', 'Thạch đào', 41000.00);

-- Product 100198: Trà đào vải
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100198, '2024-06-06 09:15:00+07', '2024-07-20 10:30:00+07', 'jpg', 'M', 'Vải tươi', 34000.00),
(100198, '2024-06-06 09:15:00+07', '2024-08-10 14:45:00+07', 'jpg', 'M', 'Vải đông lạnh', 32000.00),
(100198, '2024-06-06 09:15:00+07', '2024-07-20 10:30:00+07', 'jpg', 'L', 'Vải tươi', 40000.00),
(100198, '2024-06-06 09:15:00+07', '2024-08-10 14:45:00+07', 'jpg', 'L', 'Vải đông lạnh', 38000.00);

-- Product 100199: Trà chanh
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100199, '2023-05-26 08:30:00+07', '2023-07-10 09:45:00+07', 'jpg', 'S', 'Đường thường', 20000.00),
(100199, '2023-05-26 08:30:00+07', '2023-08-05 13:30:00+07', 'jpg', 'S', 'Mật ong', 23000.00),
(100199, '2023-05-26 08:30:00+07', '2023-07-10 09:45:00+07', 'jpg', 'M', 'Đường thường', 25000.00),
(100199, '2023-05-26 08:30:00+07', '2023-08-05 13:30:00+07', 'jpg', 'M', 'Mật ong', 28000.00),
(100199, '2023-05-26 08:30:00+07', '2023-07-10 09:45:00+07', 'jpg', 'L', 'Đường thường', 30000.00),
(100199, '2023-05-26 08:30:00+07', '2023-08-05 13:30:00+07', 'jpg', 'L', 'Mật ong', 33000.00);

-- Product 100200: Trà chanh dây
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100200, '2023-08-21 10:00:00+07', '2023-10-05 11:15:00+07', 'jpg', 'M', 'Hạt chanh dây', 28000.00),
(100200, '2023-08-21 10:00:00+07', '2023-11-12 14:30:00+07', 'jpg', 'M', 'Không hạt', 28000.00),
(100200, '2023-08-21 10:00:00+07', '2023-10-05 11:15:00+07', 'jpg', 'L', 'Hạt chanh dây', 33000.00),
(100200, '2023-08-21 10:00:00+07', '2023-11-12 14:30:00+07', 'jpg', 'L', 'Không hạt', 33000.00);

-- Product 100201: Trà chanh giã tay
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100201, '2023-11-16 11:30:00+07', '2024-01-08 10:00:00+07', 'jpg', 'M', 'Ít cay', 30000.00),
(100201, '2023-11-16 11:30:00+07', '2024-02-20 14:15:00+07', 'jpg', 'M', 'Vừa cay', 30000.00),
(100201, '2023-11-16 11:30:00+07', '2024-01-08 10:00:00+07', 'jpg', 'L', 'Ít cay', 35000.00),
(100201, '2023-11-16 11:30:00+07', '2024-02-20 14:15:00+07', 'jpg', 'L', 'Vừa cay', 35000.00);

-- Product 100202: Trà chanh muối
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100202, '2024-02-09 13:00:00+07', '2024-03-25 09:30:00+07', 'jpg', 'M', 'Muối vừa', 27000.00),
(100202, '2024-02-09 13:00:00+07', '2024-04-18 11:45:00+07', 'jpg', 'M', 'Muối nhiều', 27000.00),
(100202, '2024-02-09 13:00:00+07', '2024-03-25 09:30:00+07', 'jpg', 'L', 'Muối vừa', 32000.00),
(100202, '2024-02-09 13:00:00+07', '2024-04-18 11:45:00+07', 'jpg', 'L', 'Muối nhiều', 32000.00);

-- Product 100203: Trà chanh bạc hà
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100203, '2024-05-19 09:15:00+07', '2024-06-30 10:30:00+07', 'jpg', 'S', 'Bạc hà tươi', 26000.00),
(100203, '2024-05-19 09:15:00+07', '2024-07-22 14:00:00+07', 'jpg', 'S', 'Syrup bạc hà', 24000.00),
(100203, '2024-05-19 09:15:00+07', '2024-06-30 10:30:00+07', 'jpg', 'M', 'Bạc hà tươi', 31000.00),
(100203, '2024-05-19 09:15:00+07', '2024-07-22 14:00:00+07', 'jpg', 'M', 'Syrup bạc hà', 29000.00),
(100203, '2024-05-19 09:15:00+07', '2024-06-30 10:30:00+07', 'jpg', 'L', 'Bạc hà tươi', 36000.00),
(100203, '2024-05-19 09:15:00+07', '2024-07-22 14:00:00+07', 'jpg', 'L', 'Syrup bạc hà', 34000.00);

-- Product 100204: Trà chanh vàng
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100204, '2024-08-26 10:45:00+07', '2024-09-15 11:30:00+07', 'jpg', 'M', 'Chanh vàng tươi', 32000.00),
(100204, '2024-08-26 10:45:00+07', '2024-10-08 15:00:00+07', 'jpg', 'M', 'Mật ong chanh', 35000.00),
(100204, '2024-08-26 10:45:00+07', '2024-09-15 11:30:00+07', 'jpg', 'L', 'Chanh vàng tươi', 38000.00),
(100204, '2024-08-26 10:45:00+07', '2024-10-08 15:00:00+07', 'jpg', 'L', 'Mật ong chanh', 41000.00);

-- Product 100205: Soda chanh
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100205, '2023-06-16 08:45:00+07', '2023-07-28 10:00:00+07', 'jpg', 'M', 'Chanh xanh', 25000.00),
(100205, '2023-06-16 08:45:00+07', '2023-08-20 13:30:00+07', 'jpg', 'M', 'Chanh vàng', 27000.00),
(100205, '2023-06-16 08:45:00+07', '2023-07-28 10:00:00+07', 'jpg', 'L', 'Chanh xanh', 30000.00),
(100205, '2023-06-16 08:45:00+07', '2023-08-20 13:30:00+07', 'jpg', 'L', 'Chanh vàng', 32000.00);

-- Soda chanh dây
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100206, '2023-09-29 10:00:00+07', '2024-01-12 08:00:00+07', 'jpg', 'S', 'default', 25000.00),
(100206, '2023-09-29 10:00:00+07', '2024-02-25 10:30:00+07', 'jpg', 'M', 'default', 30000.00),
(100206, '2023-09-29 10:00:00+07', '2024-04-10 14:45:00+07', 'jpg', 'L', 'default', 35000.00);

-- Soda bạc hà chanh
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100207, '2024-01-06 09:00:00+07', '2024-03-11 12:00:00+07', 'jpg', 'S', 'ít đá', 27000.00),
(100207, '2024-01-06 09:00:00+07', '2024-03-12 09:15:00+07', 'jpg', 'S', 'thêm chanh', 28000.00),
(100207, '2024-01-06 09:00:00+07', '2024-05-22 16:10:00+07', 'jpg', 'M', 'ít đá', 32000.00),
(100207, '2024-01-06 09:00:00+07', '2024-06-15 18:00:00+07', 'jpg', 'M', 'thêm chanh', 33000.00);

-- Soda blue curacao
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100208, '2024-03-29 14:00:00+07', '2024-06-05 10:30:00+07', 'jpg', 'S', 'default', 29000.00),
(100208, '2024-03-29 14:00:00+07', '2024-07-01 12:10:00+07', 'jpg', 'M', 'default', 34000.00),
(100208, '2024-03-29 14:00:00+07', '2024-07-20 16:30:00+07', 'jpg', 'L', 'default', 39000.00);

-- Soda việt quất
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100209, '2024-06-19 09:15:00+07', '2024-09-03 17:00:00+07', 'jpg', 'S', 'ít ngọt', 28000.00),
(100209, '2024-06-19 09:15:00+07', '2024-09-04 08:30:00+07', 'jpg', 'S', 'thêm syrup', 30000.00),
(100209, '2024-06-19 09:15:00+07', '2024-10-12 10:20:00+07', 'jpg', 'M', 'ít ngọt', 33000.00),
(100209, '2024-06-19 09:15:00+07', '2024-10-15 11:00:00+07', 'jpg', 'M', 'thêm syrup', 35000.00),
(100209, '2024-06-19 09:15:00+07', '2025-02-10 15:00:00+07', 'jpg', 'L', 'ít ngọt', 38000.00),
(100209, '2024-06-19 09:15:00+07', '2025-03-22 18:00:00+07', 'jpg', 'L', 'thêm syrup', 40000.00);

-- Soda dâu
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100210, '2024-09-11 09:45:00+07', '2025-01-20 11:20:00+07', 'jpg', 'S', 'default', 27000.00),
(100210, '2024-09-11 09:45:00+07', '2025-03-05 10:45:00+07', 'jpg', 'M', 'default', 32000.00),
(100210, '2024-09-11 09:45:00+07', '2025-06-01 08:30:00+07', 'jpg', 'L', 'default', 37000.00);

-- Soda cam
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price) VALUES
(100211, '2024-12-06 10:00:00+07', '2025-02-25 12:45:00+07', 'jpg', 'S', 'ít đá', 26000.00),
(100211, '2024-12-06 10:00:00+07', '2025-03-10 09:30:00+07', 'jpg', 'S', 'thêm cam tươi', 28000.00),
(100211, '2024-12-06 10:00:00+07', '2025-04-01 10:15:00+07', 'jpg', 'M', 'ít đá', 31000.00),
(100211, '2024-12-06 10:00:00+07', '2025-05-02 14:40:00+07', 'jpg', 'M', 'thêm cam tươi', 33000.00),
(100211, '2024-12-06 10:00:00+07', '2025-06-12 15:30:00+07', 'jpg', 'L', 'ít đá', 35000.00),
(100211, '2024-12-06 10:00:00+07', '2025-08-20 16:10:00+07', 'jpg', 'L', 'thêm cam tươi', 37000.00);
