-- Drops

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
	view_count int ,
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
	UNIQUE (user_id, product_id)
);

ALTER TABLE IF EXISTS public.cart
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
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100010, 27, '2025-06-19 02:16:59+07', '2025-09-01 02:16:59+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 79);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100003, 2, '2024-06-09 07:13:55+07', '2024-12-25 07:13:55+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4962);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100005, 15, '2024-08-13 23:50:16+07', '2025-04-19 23:50:16+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 463);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100009, 18, '2024-06-09 13:41:18+07', '2025-06-27 13:41:18+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1996);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100009, 1, '2023-12-13 17:14:19+07', '2024-02-03 17:14:19+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 935);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100007, 15, '2023-06-13 05:28:35+07', '2024-04-19 05:28:35+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 243);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100004, 1, '2024-07-14 17:50:31+07', '2025-05-30 17:50:31+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1447);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100005, 4, '2024-04-01 22:01:48+07', '2024-10-23 22:01:48+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3257);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100006, 23, '2025-08-03 00:05:25+07', '2026-08-22 00:05:25+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3001);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh flan trứng', 100005, 15, '2024-04-24 08:21:31+07', '2025-02-23 08:21:31+07', 'jpg', 'Bánh flan trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4743);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100001, 3, '2023-03-10 23:11:35+07', '2023-11-28 23:11:35+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 716);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100001, 15, '2025-01-18 23:00:21+07', '2025-05-12 23:00:21+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1457);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100001, 23, '2025-04-28 00:53:42+07', '2026-05-06 00:53:42+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4464);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Chè bưởi', 100004, 1, '2024-12-13 03:07:38+07', '2025-04-19 03:07:38+07', 'jpg', 'Chè bưởi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1600);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cà phê sữa đá', 100001, 1, '2023-08-29 15:38:24+07', '2023-11-26 15:38:24+07', 'jpg', 'Cà phê sữa đá thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 659);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100007, 26, '2024-02-07 21:12:59+07', '2024-11-27 21:12:59+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1034);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100009, 4, '2025-02-09 10:08:30+07', '2025-11-13 10:08:30+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2224);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100001, 2, '2025-07-15 04:36:11+07', '2025-12-04 04:36:11+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1548);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100004, 5, '2025-07-12 06:12:38+07', '2026-04-30 06:12:38+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4379);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100004, 21, '2025-02-05 15:55:45+07', '2025-04-05 15:55:45+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3076);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100008, 4, '2023-08-06 09:26:18+07', '2023-12-17 09:26:18+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4333);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100002, 12, '2024-11-01 08:48:49+07', '2025-06-01 08:48:49+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4592);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh su kem', 100001, 21, '2024-10-24 09:37:38+07', '2025-10-17 09:37:38+07', 'jpg', 'Bánh su kem thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3386);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100006, 18, '2024-04-22 11:45:37+07', '2024-11-17 11:45:37+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1942);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100001, 16, '2023-05-08 08:37:22+07', '2024-05-19 08:37:22+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1491);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100006, 26, '2024-05-10 15:06:48+07', '2025-05-13 15:06:48+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1950);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100003, 26, '2025-07-16 04:04:28+07', '2025-12-05 04:04:28+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4571);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100007, 27, '2025-06-07 08:05:35+07', '2026-06-17 08:05:35+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 920);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100004, 2, '2023-05-19 17:10:32+07', '2023-12-30 17:10:32+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1574);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100006, 16, '2024-12-30 05:18:02+07', '2026-01-01 05:18:02+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2731);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Tokbokki cay', 100005, 1, '2025-01-18 20:25:12+07', '2025-06-28 20:25:12+07', 'jpg', 'Tokbokki cay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2153);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh su kem', 100001, 27, '2025-04-07 13:15:48+07', '2026-04-07 13:15:48+07', 'jpg', 'Bánh su kem thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3360);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100009, 5, '2024-09-25 04:17:17+07', '2025-10-17 04:17:17+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2107);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100010, 5, '2023-12-07 15:48:01+07', '2024-03-03 15:48:01+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 970);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100010, 1, '2025-01-27 23:36:35+07', '2025-12-07 23:36:35+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3857);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100006, 26, '2024-01-23 19:02:09+07', '2024-07-28 19:02:09+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 686);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100008, 1, '2024-05-14 17:18:45+07', '2024-10-08 17:18:45+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 577);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100002, 27, '2025-03-19 03:15:13+07', '2025-09-22 03:15:13+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3439);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Tokbokki cay', 100009, 23, '2023-06-11 21:49:59+07', '2024-06-06 21:49:59+07', 'jpg', 'Tokbokki cay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2535);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100001, 23, '2024-11-24 01:19:43+07', '2025-07-02 01:19:43+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4015);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100004, 16, '2023-10-19 19:09:11+07', '2024-03-10 19:09:11+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1897);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100009, 23, '2023-03-30 10:53:08+07', '2024-04-15 10:53:08+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2980);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100007, 2, '2023-05-06 04:33:15+07', '2023-07-19 04:33:15+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4220);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100007, 27, '2025-04-08 08:36:37+07', '2026-03-10 08:36:37+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3007);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100008, 21, '2023-09-09 15:38:52+07', '2024-06-05 15:38:52+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4361);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà sữa socola', 100004, 15, '2025-05-25 06:39:28+07', '2025-07-11 06:39:28+07', 'jpg', 'Trà sữa socola thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1854);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà tắc', 100010, 12, '2024-08-04 10:16:33+07', '2025-07-10 10:16:33+07', 'jpg', 'Trà tắc thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4031);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100010, 16, '2023-10-04 20:49:37+07', '2024-06-03 20:49:37+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2565);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100008, 21, '2025-07-31 15:35:28+07', '2025-12-11 15:35:28+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 430);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100001, 27, '2025-09-18 02:34:39+07', '2026-01-20 02:34:39+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1554);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100003, 4, '2025-04-04 18:09:23+07', '2026-02-26 18:09:23+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3427);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Tokbokki cay', 100005, 5, '2024-10-31 21:11:00+07', '2025-11-22 21:11:00+07', 'jpg', 'Tokbokki cay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2411);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100002, 27, '2024-05-29 00:42:13+07', '2024-10-25 00:42:13+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3607);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100009, 1, '2024-10-01 03:11:57+07', '2024-12-03 03:11:57+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1106);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh su kem', 100001, 21, '2025-09-06 13:27:11+07', '2026-03-10 13:27:11+07', 'jpg', 'Bánh su kem thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4081);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100005, 26, '2025-06-24 20:38:28+07', '2026-05-24 20:38:28+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4029);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100002, 3, '2023-04-10 14:16:46+07', '2023-05-31 14:16:46+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4293);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100001, 23, '2025-03-09 16:26:45+07', '2025-06-23 16:26:45+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3548);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà sữa socola', 100002, 18, '2023-07-09 22:06:52+07', '2024-02-11 22:06:52+07', 'jpg', 'Trà sữa socola thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4986);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100001, 15, '2025-06-03 10:10:42+07', '2026-07-01 10:10:42+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3919);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100001, 12, '2024-05-30 02:33:31+07', '2025-03-01 02:33:31+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2214);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100001, 27, '2025-02-01 23:09:42+07', '2025-05-31 23:09:42+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1171);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100010, 4, '2023-10-11 06:21:11+07', '2024-03-13 06:21:11+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3198);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100003, 27, '2023-05-04 08:37:39+07', '2024-02-12 08:37:39+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1819);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100002, 26, '2025-07-02 23:48:36+07', '2026-05-25 23:48:36+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3940);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100007, 12, '2024-09-15 03:53:31+07', '2024-11-11 03:53:31+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4120);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100008, 2, '2025-08-18 11:47:51+07', '2026-04-14 11:47:51+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3406);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100010, 23, '2024-01-18 12:13:08+07', '2025-02-03 12:13:08+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4653);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100001, 23, '2023-12-22 19:40:48+07', '2024-04-20 19:40:48+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1304);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100004, 4, '2023-07-11 21:34:47+07', '2023-08-11 21:34:47+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 112);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100007, 12, '2024-10-28 18:07:01+07', '2025-11-16 18:07:01+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1257);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100001, 2, '2025-04-13 22:01:08+07', '2026-02-22 22:01:08+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4028);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100009, 23, '2023-06-15 10:47:41+07', '2024-05-19 10:47:41+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3858);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100009, 4, '2023-07-02 06:16:17+07', '2024-01-08 06:16:17+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 408);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100006, 3, '2024-06-15 07:12:39+07', '2024-10-17 07:12:39+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 377);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100009, 16, '2024-02-25 17:48:31+07', '2024-05-25 17:48:31+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1925);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100003, 26, '2025-05-20 17:42:52+07', '2026-06-08 17:42:52+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3879);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100010, 26, '2024-04-26 07:49:03+07', '2024-06-19 07:49:03+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4693);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100006, 21, '2024-08-31 13:21:39+07', '2024-11-24 13:21:39+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 353);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100002, 4, '2023-09-06 06:15:59+07', '2024-03-28 06:15:59+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 597);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100001, 2, '2024-03-19 06:02:52+07', '2025-03-29 06:02:52+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2765);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Chè bưởi', 100002, 21, '2025-02-21 15:22:20+07', '2025-05-02 15:22:20+07', 'jpg', 'Chè bưởi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 823);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100001, 26, '2024-12-31 17:58:26+07', '2025-11-04 17:58:26+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 733);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100006, 16, '2024-11-24 05:11:21+07', '2025-11-23 05:11:21+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1784);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100001, 16, '2024-04-17 12:17:34+07', '2025-02-07 12:17:34+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4900);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100002, 15, '2023-10-06 02:10:37+07', '2024-07-13 02:10:37+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1853);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100008, 4, '2023-05-10 20:58:04+07', '2023-11-12 20:58:04+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2492);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100007, 23, '2023-12-04 19:07:15+07', '2024-11-18 19:07:15+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 812);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Chè bưởi', 100010, 5, '2024-11-07 00:41:14+07', '2025-11-08 00:41:14+07', 'jpg', 'Chè bưởi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2766);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100007, 27, '2024-03-14 23:02:48+07', '2024-10-26 23:02:48+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1083);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100008, 26, '2024-08-10 02:39:49+07', '2025-09-03 02:39:49+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4551);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100002, 3, '2024-02-17 05:22:30+07', '2024-04-10 05:22:30+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 691);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100004, 18, '2024-03-06 04:25:07+07', '2025-04-10 04:25:07+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4782);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100002, 16, '2024-04-20 18:41:29+07', '2025-04-03 18:41:29+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3411);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100002, 18, '2024-01-28 00:20:07+07', '2024-04-27 00:20:07+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 304);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cà phê sữa đá', 100007, 1, '2025-08-13 02:41:43+07', '2026-03-31 02:41:43+07', 'jpg', 'Cà phê sữa đá thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2618);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100009, 16, '2024-11-10 21:58:22+07', '2025-06-12 21:58:22+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4531);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100007, 3, '2023-11-23 10:03:13+07', '2024-10-02 10:03:13+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1952);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100005, 26, '2025-09-18 03:47:51+07', '2026-08-03 03:47:51+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 855);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100006, 26, '2023-07-22 07:12:45+07', '2023-12-06 07:12:45+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4814);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Tokbokki cay', 100004, 16, '2025-03-31 15:14:11+07', '2025-12-21 15:14:11+07', 'jpg', 'Tokbokki cay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1459);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100007, 26, '2025-03-21 16:04:30+07', '2026-01-24 16:04:30+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2116);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cà phê sữa đá', 100008, 26, '2025-02-27 13:53:39+07', '2025-04-29 13:53:39+07', 'jpg', 'Cà phê sữa đá thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 112);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh flan trứng', 100006, 23, '2024-12-24 10:48:24+07', '2025-09-20 10:48:24+07', 'jpg', 'Bánh flan trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1282);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Tokbokki cay', 100003, 4, '2025-09-03 02:59:12+07', '2026-06-07 02:59:12+07', 'jpg', 'Tokbokki cay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4506);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100007, 16, '2024-05-28 08:28:31+07', '2024-10-18 08:28:31+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3633);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100003, 27, '2025-07-26 07:39:32+07', '2025-08-26 07:39:32+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2002);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100008, 2, '2025-01-31 23:57:18+07', '2025-07-12 23:57:18+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4198);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh su kem', 100010, 4, '2023-03-21 11:21:47+07', '2023-10-04 11:21:47+07', 'jpg', 'Bánh su kem thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2077);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100006, 1, '2023-12-23 13:07:26+07', '2024-04-25 13:07:26+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 89);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100006, 1, '2023-09-02 21:24:14+07', '2023-11-26 21:24:14+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2346);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh flan trứng', 100009, 2, '2025-01-15 23:22:56+07', '2026-02-13 23:22:56+07', 'jpg', 'Bánh flan trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3341);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100010, 15, '2025-07-18 00:57:58+07', '2026-08-06 00:57:58+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4638);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100010, 16, '2023-10-07 18:07:12+07', '2024-08-22 18:07:12+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1464);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Chè bưởi', 100008, 18, '2025-09-30 19:02:49+07', '2026-01-19 19:02:49+07', 'jpg', 'Chè bưởi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3790);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà tắc', 100004, 16, '2023-03-12 09:28:21+07', '2023-09-15 09:28:21+07', 'jpg', 'Trà tắc thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 79);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100002, 4, '2023-08-08 21:38:05+07', '2024-03-09 21:38:05+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 547);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100007, 1, '2023-03-23 18:49:42+07', '2024-03-18 18:49:42+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2687);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100009, 16, '2024-11-03 01:26:41+07', '2024-12-13 01:26:41+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2091);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100010, 1, '2025-09-08 08:26:45+07', '2026-03-26 08:26:45+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1461);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh su kem', 100003, 5, '2023-10-18 19:58:22+07', '2023-12-11 19:58:22+07', 'jpg', 'Bánh su kem thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 231);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà tắc', 100009, 15, '2025-05-21 00:48:23+07', '2025-09-25 00:48:23+07', 'jpg', 'Trà tắc thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2928);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100006, 3, '2025-05-03 21:35:56+07', '2026-04-27 21:35:56+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4071);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100005, 23, '2023-04-26 00:20:43+07', '2023-09-09 00:20:43+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4724);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100009, 21, '2023-06-27 11:03:53+07', '2023-08-26 11:03:53+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 352);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100004, 3, '2024-01-16 05:56:27+07', '2025-01-16 05:56:27+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 230);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100006, 12, '2023-03-03 17:53:51+07', '2023-04-26 17:53:51+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2749);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cà phê sữa đá', 100008, 18, '2025-05-28 17:24:49+07', '2026-03-05 17:24:49+07', 'jpg', 'Cà phê sữa đá thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 561);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100006, 12, '2025-01-09 06:50:21+07', '2026-01-20 06:50:21+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1052);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100001, 15, '2023-05-15 07:18:59+07', '2023-09-19 07:18:59+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2870);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100009, 2, '2023-09-08 11:30:33+07', '2024-05-18 11:30:33+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2708);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100004, 27, '2023-12-09 08:15:02+07', '2024-02-02 08:15:02+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1116);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100005, 26, '2023-04-28 04:01:20+07', '2024-05-09 04:01:20+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1281);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100007, 27, '2025-05-30 09:04:02+07', '2026-05-01 09:04:02+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1242);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100010, 5, '2024-01-25 08:02:31+07', '2024-07-25 08:02:31+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 850);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100002, 23, '2023-10-25 06:33:32+07', '2024-03-22 06:33:32+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4371);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100004, 27, '2023-06-10 22:57:55+07', '2023-08-05 22:57:55+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1399);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100005, 15, '2023-04-29 05:41:48+07', '2024-05-22 05:41:48+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1692);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100009, 18, '2024-12-11 17:23:36+07', '2025-02-10 17:23:36+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3091);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100009, 4, '2025-05-14 01:05:49+07', '2025-07-16 01:05:49+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 536);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mì cay hải sản', 100005, 18, '2024-10-07 11:47:14+07', '2025-10-27 11:47:14+07', 'jpg', 'Mì cay hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2298);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100009, 1, '2024-10-26 09:39:47+07', '2025-11-26 09:39:47+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1407);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100002, 26, '2025-09-29 09:24:25+07', '2026-06-23 09:24:25+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3038);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100006, 3, '2025-03-23 14:46:13+07', '2026-01-08 14:46:13+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3414);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100005, 12, '2024-04-06 22:55:53+07', '2025-05-01 22:55:53+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2716);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100005, 12, '2025-08-04 04:10:58+07', '2026-07-08 04:10:58+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 930);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100002, 27, '2024-06-14 12:28:47+07', '2025-01-12 12:28:47+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 286);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100010, 15, '2024-03-06 13:26:15+07', '2025-03-05 13:26:15+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3322);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Sushi cá hồi', 100001, 2, '2023-08-11 10:11:24+07', '2024-04-04 10:11:24+07', 'jpg', 'Sushi cá hồi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 204);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà sữa socola', 100008, 12, '2024-09-01 15:35:22+07', '2025-05-21 15:35:22+07', 'jpg', 'Trà sữa socola thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4187);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100005, 21, '2023-07-13 09:23:25+07', '2023-10-21 09:23:25+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1118);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100001, 4, '2024-08-06 13:01:08+07', '2025-08-24 13:01:08+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1263);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100005, 1, '2024-01-15 10:26:55+07', '2024-05-08 10:26:55+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 438);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà tắc', 100001, 27, '2023-11-14 05:02:03+07', '2024-09-14 05:02:03+07', 'jpg', 'Trà tắc thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4974);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Chè bưởi', 100006, 5, '2023-10-22 17:30:11+07', '2024-07-17 17:30:11+07', 'jpg', 'Chè bưởi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 918);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100007, 27, '2025-09-27 22:39:50+07', '2026-03-22 22:39:50+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1252);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100003, 4, '2025-08-23 13:16:37+07', '2026-07-03 13:16:37+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3835);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100008, 3, '2024-01-01 18:03:17+07', '2024-03-16 18:03:17+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1162);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100010, 2, '2024-09-13 14:12:57+07', '2025-04-09 14:12:57+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2598);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Gà rán giòn', 100008, 2, '2023-08-31 07:13:20+07', '2023-12-13 07:13:20+07', 'jpg', 'Gà rán giòn thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2249);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100002, 5, '2025-06-17 11:10:19+07', '2025-10-15 11:10:19+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 338);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100001, 15, '2025-07-12 04:42:10+07', '2026-05-07 04:42:10+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1922);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Takoyaki truyền thống', 100002, 1, '2023-12-05 09:46:00+07', '2024-03-17 09:46:00+07', 'jpg', 'Takoyaki truyền thống thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3751);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà tắc', 100010, 15, '2023-12-08 12:16:20+07', '2024-04-03 12:16:20+07', 'jpg', 'Trà tắc thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4938);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100008, 23, '2023-03-17 05:02:03+07', '2023-07-11 05:02:03+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4636);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100001, 12, '2023-09-19 18:58:29+07', '2024-10-20 18:58:29+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3293);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100009, 1, '2023-07-01 15:07:33+07', '2024-06-09 15:07:33+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1753);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Udon hải sản', 100006, 27, '2023-12-22 00:20:38+07', '2024-03-04 00:20:38+07', 'jpg', 'Udon hải sản thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1621);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100007, 26, '2024-12-21 04:40:40+07', '2025-12-17 04:40:40+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3737);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà sữa socola', 100009, 3, '2023-03-21 17:01:02+07', '2023-09-04 17:01:02+07', 'jpg', 'Trà sữa socola thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 121);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100010, 1, '2024-12-26 08:01:24+07', '2026-01-01 08:01:24+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1317);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100006, 4, '2025-05-18 17:57:47+07', '2025-07-29 17:57:47+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1021);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Nước ép cam', 100003, 27, '2025-03-04 16:37:21+07', '2025-10-08 16:37:21+07', 'jpg', 'Nước ép cam thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 1190);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100010, 21, '2025-01-03 03:47:57+07', '2026-01-12 03:47:57+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 237);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh mì thịt nướng', 100010, 26, '2025-02-28 15:25:20+07', '2025-06-24 15:25:20+07', 'jpg', 'Bánh mì thịt nướng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2257);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cà phê sữa đá', 100004, 26, '2024-01-29 10:06:26+07', '2024-05-28 10:06:26+07', 'jpg', 'Cà phê sữa đá thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4458);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh flan trứng', 100006, 21, '2024-06-23 00:44:41+07', '2025-01-28 00:44:41+07', 'jpg', 'Bánh flan trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3365);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100007, 1, '2024-01-24 18:42:17+07', '2024-03-16 18:42:17+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 597);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100006, 12, '2025-08-11 09:56:16+07', '2026-03-21 09:56:16+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3074);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100003, 18, '2025-07-26 08:16:25+07', '2026-05-10 08:16:25+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3811);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100006, 21, '2025-02-25 23:41:18+07', '2025-09-04 23:41:18+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3608);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh flan trứng', 100006, 18, '2025-02-06 16:10:24+07', '2025-06-07 16:10:24+07', 'jpg', 'Bánh flan trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3995);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm chiên trứng', 100007, 4, '2024-04-08 07:43:11+07', '2024-12-19 07:43:11+07', 'jpg', 'Cơm chiên trứng thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2999);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100004, 21, '2023-11-04 08:54:03+07', '2024-09-30 08:54:03+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 972);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100003, 27, '2025-08-13 20:31:38+07', '2025-11-09 20:31:38+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 128);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100010, 18, '2024-06-06 22:53:52+07', '2025-04-11 22:53:52+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 482);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bánh bao nhân thịt', 100001, 2, '2024-03-28 23:46:03+07', '2024-12-14 23:46:03+07', 'jpg', 'Bánh bao nhân thịt thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1631);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Cơm gà xối mỡ', 100007, 2, '2023-04-24 00:51:49+07', '2023-07-02 00:51:49+07', 'jpg', 'Cơm gà xối mỡ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 107);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Soda bạc hà', 100002, 12, '2024-06-15 11:20:59+07', '2024-09-11 11:20:59+07', 'jpg', 'Soda bạc hà thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 371);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kem matcha', 100008, 12, '2025-09-25 17:40:29+07', '2026-05-04 17:40:29+07', 'jpg', 'Kem matcha thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4218);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Pancake mật ong', 100006, 1, '2025-02-26 13:07:01+07', '2025-05-29 13:07:01+07', 'jpg', 'Pancake mật ong thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3802);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Chè bưởi', 100006, 3, '2025-05-13 18:54:59+07', '2025-11-05 18:54:59+07', 'jpg', 'Chè bưởi thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 713);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Mochi đậu đỏ', 100003, 3, '2025-05-04 13:23:27+07', '2026-01-11 13:23:27+07', 'jpg', 'Mochi đậu đỏ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2930);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100006, 23, '2023-05-31 19:12:29+07', '2024-05-30 19:12:29+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 3952);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Bibimbap chay', 100003, 2, '2023-10-28 02:43:37+07', '2024-06-26 02:43:37+07', 'jpg', 'Bibimbap chay thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 3139);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100004, 21, '2024-05-15 13:57:29+07', '2025-01-13 13:57:29+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 1175);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Phở bò viên', 100007, 4, '2024-02-10 22:57:57+07', '2024-08-20 22:57:57+07', 'jpg', 'Phở bò viên thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 4249);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Trà sữa socola', 100004, 5, '2024-09-03 10:08:38+07', '2025-06-19 10:08:38+07', 'jpg', 'Trà sữa socola thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', true, 2423);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Kimbap cá ngừ', 100005, 2, '2024-08-01 00:42:50+07', '2025-02-21 00:42:50+07', 'jpg', 'Kimbap cá ngừ thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 2664);

INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active, total_sales)
VALUES ('Súp miso', 100004, 4, '2025-05-22 15:42:22+07', '2025-11-17 15:42:22+07', 'jpg', 'Súp miso thơm ngon, chuẩn vị, được chế biến tươi mỗi ngày.', false, 4030);

-- Product variation
-- Product 100000: Soda bạc hà (Drinks - S, M, L sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100000, '2025-06-19 03:45:22+07', '2025-09-01 03:45:22+07', 'jpg', 'S', 'default', 15000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100000, '2025-06-19 03:50:11+07', '2025-09-01 03:50:11+07', 'jpg', 'M', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100000, '2025-06-19 04:12:33+07', '2025-09-01 04:12:33+07', 'jpg', 'L', 'default', 28000.00);

-- Product 100001: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100001, '2024-06-09 07:45:30+07', '2024-12-25 07:45:30+07', 'jpg', 'default', 'Truyền thống', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100001, '2024-06-09 08:20:15+07', '2024-12-25 08:20:15+07', 'jpg', 'default', 'Đặc biệt', 25000.00);

-- Product 100002: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100002, '2024-08-13 23:55:40+07', '2025-04-19 23:55:40+07', 'jpg', 'default', 'Ít cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100002, '2024-08-14 00:15:22+07', '2025-04-20 00:15:22+07', 'jpg', 'default', 'Vừa cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100002, '2024-08-14 00:35:18+07', '2025-04-20 00:35:18+07', 'jpg', 'default', 'Cay nồng', 48000.00);

-- Product 100003: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100003, '2024-06-09 14:10:25+07', '2025-06-27 14:10:25+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100003, '2024-06-09 14:25:33+07', '2025-06-27 14:25:33+07', 'jpg', 'M', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100003, '2024-06-09 14:40:18+07', '2025-06-27 14:40:18+07', 'jpg', 'L', 'default', 45000.00);

-- Product 100004: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100004, '2023-12-13 17:30:45+07', '2024-02-03 17:30:45+07', 'jpg', 'Nhỏ', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100004, '2023-12-13 17:45:20+07', '2024-02-03 17:45:20+07', 'jpg', 'Lớn', 'default', 50000.00);

-- Product 100005: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100005, '2023-06-13 05:50:12+07', '2024-04-19 05:50:12+07', 'jpg', 'Nhỏ', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100005, '2023-06-13 06:10:35+07', '2024-04-19 06:10:35+07', 'jpg', 'Lớn', 'default', 52000.00);

-- Product 100006: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100006, '2024-07-14 18:15:40+07', '2025-05-30 18:15:40+07', 'jpg', 'default', 'default', 32000.00);

-- Product 100007: Takoyaki truyền thống (6, 8, 12 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100007, '2024-04-01 22:25:30+07', '2024-10-23 22:25:30+07', 'jpg', '6 viên', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100007, '2024-04-01 22:40:15+07', '2024-10-23 22:40:15+07', 'jpg', '9 viên', 'default', 50000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100007, '2024-04-01 22:55:22+07', '2024-10-23 22:55:22+07', 'jpg', '15 viên', 'default', 75000.00);

-- Product 100008: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100008, '2025-08-03 00:30:18+07', '2026-08-22 00:30:18+07', 'jpg', 'default', 'default', 28000.00);

-- Product 100009: Bánh flan trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100009, '2024-04-24 08:45:20+07', '2025-02-23 08:45:20+07', 'jpg', 'default', 'default', 20000.00);

-- Product 100010: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100010, '2023-03-10 23:35:45+07', '2023-11-28 23:35:45+07', 'jpg', 'default', 'Ít cay', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100010, '2023-03-10 23:50:30+07', '2023-11-28 23:50:30+07', 'jpg', 'default', 'Vừa cay', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100010, '2023-03-11 00:10:15+07', '2023-11-29 00:10:15+07', 'jpg', 'default', 'Cay nồng', 45000.00);

-- Product 100011: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100011, '2025-01-18 23:25:45+07', '2025-05-12 23:25:45+07', 'jpg', '6 viên', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100011, '2025-01-18 23:40:20+07', '2025-05-12 23:40:20+07', 'jpg', '9 viên', 'default', 52000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100011, '2025-01-18 23:55:33+07', '2025-05-12 23:55:33+07', 'jpg', '15 viên', 'default', 78000.00);

-- Product 100012: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100012, '2025-04-28 01:20:30+07', '2026-05-06 01:20:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100013: Chè bưởi (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100013, '2024-12-13 03:30:45+07', '2025-04-19 03:30:45+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100013, '2024-12-13 03:45:20+07', '2025-04-19 03:45:20+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100013, '2024-12-13 04:00:15+07', '2025-04-19 04:00:15+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100014: Cà phê sữa đá (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100014, '2023-08-29 15:55:30+07', '2023-11-26 15:55:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100014, '2023-08-29 16:10:45+07', '2023-11-26 16:10:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100014, '2023-08-29 16:25:20+07', '2023-11-26 16:25:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100015: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100015, '2024-02-07 21:35:40+07', '2024-11-27 21:35:40+07', 'jpg', 'Nhỏ', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100015, '2024-02-07 21:50:25+07', '2024-11-27 21:50:25+07', 'jpg', 'Lớn', 'default', 55000.00);

-- Product 100016: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100016, '2025-02-09 10:30:45+07', '2025-11-13 10:30:45+07', 'jpg', 'Nhỏ', 'default', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100016, '2025-02-09 10:45:30+07', '2025-11-13 10:45:30+07', 'jpg', 'Lớn', 'default', 65000.00);

-- Product 100017: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100017, '2025-07-15 05:00:30+07', '2025-12-04 05:00:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100018: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100018, '2025-07-12 06:35:20+07', '2026-04-30 06:35:20+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100018, '2025-07-12 06:50:45+07', '2026-04-30 06:50:45+07', 'jpg', 'M', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100018, '2025-07-12 07:05:30+07', '2026-04-30 07:05:30+07', 'jpg', 'L', 'default', 48000.00);

-- Product 100019: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100019, '2025-02-05 16:20:30+07', '2025-04-05 16:20:30+07', 'jpg', 'default', 'default', 38000.00);

-- Product 100020: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100020, '2023-08-06 09:50:25+07', '2023-12-17 09:50:25+07', 'jpg', 'default', 'default', 30000.00);

-- Product 100021: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100021, '2024-11-01 09:15:30+07', '2025-06-01 09:15:30+07', 'jpg', 'Nhỏ', 'default', 50000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100021, '2024-11-01 09:30:45+07', '2025-06-01 09:30:45+07', 'jpg', 'Lớn', 'default', 68000.00);

-- Product 100022: Bánh su kem (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100022, '2024-10-24 10:00:45+07', '2025-10-17 10:00:45+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100023: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100023, '2024-04-22 12:10:30+07', '2024-11-17 12:10:30+07', 'jpg', 'default', 'default', 38000.00);

-- Product 100024: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100024, '2023-05-08 09:00:30+07', '2024-05-19 09:00:30+07', 'jpg', 'default', 'Ít cay', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100024, '2023-05-08 09:15:45+07', '2024-05-19 09:15:45+07', 'jpg', 'default', 'Vừa cay', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100024, '2023-05-08 09:30:20+07', '2024-05-19 09:30:20+07', 'jpg', 'default', 'Cay nồng', 43000.00);

-- Product 100025: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100025, '2024-05-10 15:30:45+07', '2025-05-13 15:30:45+07', 'jpg', 'Nhỏ', 'default', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100025, '2024-05-10 15:45:30+07', '2025-05-13 15:45:30+07', 'jpg', 'Lớn', 'default', 62000.00);

-- Product 100026: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100026, '2025-07-16 04:30:15+07', '2025-12-05 04:30:15+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100026, '2025-07-16 04:45:30+07', '2025-12-05 04:45:30+07', 'jpg', 'M', 'default', 35000.00);

-- Product 100027: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100027, '2025-06-07 08:30:20+07', '2026-06-17 08:30:20+07', 'jpg', '6 viên', 'default', 32000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100027, '2025-06-07 08:45:35+07', '2026-06-17 08:45:35+07', 'jpg', '9 viên', 'default', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100027, '2025-06-07 09:00:15+07', '2026-06-17 09:00:15+07', 'jpg', '15 viên', 'default', 70000.00);

-- Product 100028: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100028, '2023-05-19 17:35:45+07', '2023-12-30 17:35:45+07', 'jpg', 'Nhỏ', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100028, '2023-05-19 17:50:30+07', '2023-12-30 17:50:30+07', 'jpg', 'Lớn', 'default', 52000.00);

-- Product 100029: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100029, '2024-12-30 05:40:30+07', '2026-01-01 05:40:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100029, '2024-12-30 05:55:45+07', '2026-01-01 05:55:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100030: Tokbokki cay (2 spice levels, 2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100030, '2025-01-18 20:50:30+07', '2025-06-28 20:50:30+07', 'jpg', 'Nhỏ', 'Ít cay', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100030, '2025-01-18 21:05:45+07', '2025-06-28 21:05:45+07', 'jpg', 'Nhỏ', 'Cay nồng', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100030, '2025-01-18 21:20:20+07', '2025-06-28 21:20:20+07', 'jpg', 'Lớn', 'Ít cay', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100030, '2025-01-18 21:35:15+07', '2025-06-28 21:35:15+07', 'jpg', 'Lớn', 'Cay nồng', 48000.00);

-- Product 100031: Bánh su kem (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100031, '2025-04-07 13:40:30+07', '2026-04-07 13:40:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100032: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100032, '2024-09-25 04:40:45+07', '2025-10-17 04:40:45+07', 'jpg', 'default', 'default', 42000.00);

-- Product 100033: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100033, '2023-12-07 16:15:30+07', '2024-03-03 16:15:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100034: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100034, '2025-01-28 00:00:45+07', '2025-12-07 23:59:45+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100035: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100035, '2024-01-23 19:25:30+07', '2024-07-28 19:25:30+07', 'jpg', 'default', 'Truyền thống', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100035, '2024-01-23 19:40:15+07', '2024-07-28 19:40:15+07', 'jpg', 'default', 'Đặc biệt', 28000.00);

-- Product 100036: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100036, '2024-05-14 17:45:30+07', '2024-10-08 17:45:30+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100037: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100037, '2025-03-19 03:40:30+07', '2025-09-22 03:40:30+07', 'jpg', 'default', 'default', 30000.00);

-- Product 100038: Tokbokki cay (2 spice levels, 2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100038, '2023-06-11 22:15:30+07', '2024-06-06 22:15:30+07', 'jpg', 'Nhỏ', 'Ít cay', 32000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100038, '2023-06-11 22:30:45+07', '2024-06-06 22:30:45+07', 'jpg', 'Nhỏ', 'Cay nồng', 32000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100038, '2023-06-11 22:45:20+07', '2024-06-06 22:45:20+07', 'jpg', 'Lớn', 'Ít cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100038, '2023-06-11 23:00:15+07', '2024-06-06 23:00:15+07', 'jpg', 'Lớn', 'Cay nồng', 45000.00);

-- Product 100039: Soda bạc hà (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100039, '2024-11-24 01:45:30+07', '2025-07-02 01:45:30+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100039, '2024-11-24 02:00:15+07', '2025-07-02 02:00:15+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100039, '2024-11-24 02:15:40+07', '2025-07-02 02:15:40+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100040: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100040, '2023-10-19 19:35:30+07', '2024-03-10 19:35:30+07', 'jpg', '6 miếng', 'default', 55000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100040, '2023-10-19 19:50:45+07', '2024-03-10 19:50:45+07', 'jpg', '9 miếng', 'default', 78000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100040, '2023-10-19 20:05:20+07', '2024-03-10 20:05:20+07', 'jpg', '15 miếng', 'default', 120000.00);

-- Product 100041: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100041, '2023-03-30 11:20:30+07', '2024-04-15 11:20:30+07', 'jpg', 'default', 'default', 40000.00);

-- Product 100042: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100042, '2023-05-06 05:00:30+07', '2023-07-19 05:00:30+07', 'jpg', '4 miếng', 'default', 60000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100042, '2023-05-06 05:15:45+07', '2023-07-19 05:15:45+07', 'jpg', '6 miếng', 'default', 85000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100042, '2023-05-06 05:30:20+07', '2023-07-19 05:30:20+07', 'jpg', '9 miếng', 'default', 120000.00);

-- Product 100043: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100043, '2025-04-08 09:00:45+07', '2026-03-10 09:00:45+07', 'jpg', '6 miếng', 'default', 58000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100043, '2025-04-08 09:15:30+07', '2026-03-10 09:15:30+07', 'jpg', '9 miếng', 'default', 82000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100043, '2025-04-08 09:30:15+07', '2026-03-10 09:30:15+07', 'jpg', '15 miếng', 'default', 125000.00);

-- Product 100044: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100044, '2023-09-09 16:05:30+07', '2024-06-05 16:05:30+07', 'jpg', '6 viên', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100044, '2023-09-09 16:20:45+07', '2024-06-05 16:20:45+07', 'jpg', '9 viên', 'default', 53000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100044, '2023-09-09 16:35:20+07', '2024-06-05 16:35:20+07', 'jpg', '15 viên', 'default', 80000.00);

-- Product 100045: Trà sữa socola (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100045, '2025-05-25 07:05:30+07', '2025-07-11 07:05:30+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100045, '2025-05-25 07:20:45+07', '2025-07-11 07:20:45+07', 'jpg', 'M', 'default', 32000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100045, '2025-05-25 07:35:20+07', '2025-07-11 07:35:20+07', 'jpg', 'L', 'default', 40000.00);

-- Product 100046: Trà tắc (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100046, '2024-08-04 10:40:30+07', '2025-07-10 10:40:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100046, '2024-08-04 10:55:45+07', '2025-07-10 10:55:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100046, '2024-08-04 11:10:20+07', '2025-07-10 11:10:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100047: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100047, '2023-10-04 21:15:30+07', '2024-06-03 21:15:30+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100047, '2023-10-04 21:30:45+07', '2024-06-03 21:30:45+07', 'jpg', 'M', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100047, '2023-10-04 21:45:20+07', '2024-06-03 21:45:20+07', 'jpg', 'L', 'default', 45000.00);

-- Product 100048: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100048, '2025-07-31 16:00:30+07', '2025-12-11 16:00:30+07', 'jpg', '4 miếng', 'default', 55000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100048, '2025-07-31 16:15:45+07', '2025-12-11 16:15:45+07', 'jpg', '6 miếng', 'default', 78000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100048, '2025-07-31 16:30:20+07', '2025-12-11 16:30:20+07', 'jpg', '9 miếng', 'default', 110000.00);

-- Product 100049: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100049, '2025-09-18 03:00:30+07', '2026-01-20 03:00:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100049, '2025-09-18 03:15:45+07', '2026-01-20 03:15:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100049, '2025-09-18 03:30:20+07', '2026-01-20 03:30:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100050: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100050, '2025-04-04 18:35:30+07', '2026-02-26 18:35:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100051: Tokbokki cay (2 spice levels, 2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100051, '2024-10-31 21:35:30+07', '2025-11-22 21:35:30+07', 'jpg', 'Nhỏ', 'Ít cay', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100051, '2024-10-31 21:50:45+07', '2025-11-22 21:50:45+07', 'jpg', 'Nhỏ', 'Cay nồng', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100051, '2024-10-31 22:05:20+07', '2025-11-22 22:05:20+07', 'jpg', 'Lớn', 'Ít cay', 52000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100051, '2024-10-31 22:20:15+07', '2025-11-22 22:20:15+07', 'jpg', 'Lớn', 'Cay nồng', 52000.00);

-- Product 100052: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100052, '2024-05-29 01:05:30+07', '2024-10-25 01:05:30+07', 'jpg', '4 miếng', 'default', 58000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100052, '2024-05-29 01:20:45+07', '2024-10-25 01:20:45+07', 'jpg', '6 miếng', 'default', 82000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100052, '2024-05-29 01:35:20+07', '2024-10-25 01:35:20+07', 'jpg', '9 miếng', 'default', 115000.00);

-- Product 100053: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100053, '2024-10-01 03:35:30+07', '2024-12-03 03:35:30+07', 'jpg', 'default', 'default', 32000.00);

-- Product 100054: Bánh su kem (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100054, '2025-09-06 13:50:30+07', '2026-03-10 13:50:30+07', 'jpg', 'default', 'default', 28000.00);

-- Product 100055: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100055, '2025-06-24 21:05:30+07', '2026-05-24 21:05:30+07', 'jpg', 'default', 'Truyền thống', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100055, '2025-06-24 21:20:45+07', '2026-05-24 21:20:45+07', 'jpg', 'default', 'Đặc biệt', 30000.00);

-- Product 100056: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100056, '2023-04-10 14:40:30+07', '2023-05-31 14:40:30+07', 'jpg', '4 miếng', 'default', 62000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100056, '2023-04-10 14:55:45+07', '2023-05-31 14:55:45+07', 'jpg', '6 miếng', 'default', 88000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100056, '2023-04-10 15:10:20+07', '2023-05-31 15:10:20+07', 'jpg', '9 miếng', 'default', 125000.00);

-- Product 100057: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100057, '2025-03-09 16:50:30+07', '2025-06-23 16:50:30+07', 'jpg', '6 viên', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100057, '2025-03-09 17:05:45+07', '2025-06-23 17:05:45+07', 'jpg', '9 viên', 'default', 55000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100057, '2025-03-09 17:20:20+07', '2025-06-23 17:20:20+07', 'jpg', '15 viên', 'default', 82000.00);

-- Product 100058: Trà sữa socola (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100058, '2023-07-09 22:30:30+07', '2024-02-11 22:30:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100058, '2023-07-09 22:45:45+07', '2024-02-11 22:45:45+07', 'jpg', 'M', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100058, '2023-07-09 23:00:20+07', '2024-02-11 23:00:20+07', 'jpg', 'L', 'default', 42000.00);

-- Product 100059: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100059, '2025-06-03 10:35:30+07', '2026-07-01 10:35:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100060: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100060, '2024-05-30 03:00:30+07', '2025-03-01 03:00:30+07', 'jpg', 'default', 'default', 38000.00);

-- Product 100061: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100061, '2025-02-01 23:35:30+07', '2025-05-31 23:35:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100061, '2025-02-01 23:50:45+07', '2025-05-31 23:50:45+07', 'jpg', 'M', 'default', 40000.00);

-- Product 100062: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100062, '2023-10-11 06:45:30+07', '2024-03-13 06:45:30+07', 'jpg', '4 miếng', 'default', 65000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100062, '2023-10-11 07:00:45+07', '2024-03-13 07:00:45+07', 'jpg', '6 miếng', 'default', 92000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100062, '2023-10-11 07:15:20+07', '2024-03-13 07:15:20+07', 'jpg', '9 miếng', 'default', 130000.00);

-- Product 100063: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100063, '2023-05-04 09:00:30+07', '2024-02-12 09:00:30+07', 'jpg', '4 miếng', 'default', 58000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100063, '2023-05-04 09:15:45+07', '2024-02-12 09:15:45+07', 'jpg', '6 miếng', 'default', 80000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100063, '2023-05-04 09:30:20+07', '2024-02-12 09:30:20+07', 'jpg', '9 miếng', 'default', 112000.00);

-- Product 100064: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100064, '2025-07-03 00:15:30+07', '2026-05-25 23:59:30+07', 'jpg', 'default', 'default', 32000.00);

-- Product 100065: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100065, '2024-09-15 04:20:30+07', '2024-11-11 04:20:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100065, '2024-09-15 04:35:45+07', '2024-11-11 04:35:45+07', 'jpg', 'M', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100065, '2024-09-15 04:50:20+07', '2024-11-11 04:50:20+07', 'jpg', 'L', 'default', 50000.00);

-- Product 100066: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100066, '2025-08-18 12:15:30+07', '2026-04-14 12:15:30+07', 'jpg', 'default', 'Ít cay', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100066, '2025-08-18 12:30:45+07', '2026-04-14 12:30:45+07', 'jpg', 'default', 'Vừa cay', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100066, '2025-08-18 12:45:20+07', '2026-04-14 12:45:20+07', 'jpg', 'default', 'Cay nồng', 52000.00);

-- Product 100067: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100067, '2024-01-18 12:40:30+07', '2025-02-03 12:40:30+07', 'jpg', 'Nhỏ', 'default', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100067, '2024-01-18 12:55:45+07', '2025-02-03 12:55:45+07', 'jpg', 'Lớn', 'default', 58000.00);

-- Product 100068: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100068, '2023-12-22 20:05:30+07', '2024-04-20 20:05:30+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100069: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100069, '2023-07-11 22:00:30+07', '2023-08-11 22:00:30+07', 'jpg', 'default', 'default', 42000.00);

-- Product 100070: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100070, '2024-10-28 18:35:30+07', '2025-11-16 18:35:30+07', 'jpg', 'default', 'default', 48000.00);

-- Product 100071: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100071, '2025-04-13 22:30:30+07', '2026-02-22 22:30:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100071, '2025-04-13 22:45:45+07', '2026-02-22 22:45:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100072: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100072, '2023-06-15 11:15:30+07', '2024-05-19 11:15:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100072, '2023-06-15 11:30:45+07', '2024-05-19 11:30:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100072, '2023-06-15 11:45:20+07', '2024-05-19 11:45:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100073: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100073, '2023-07-02 06:40:30+07', '2024-01-08 06:40:30+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100074: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100074, '2024-06-15 07:40:30+07', '2024-10-17 07:40:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100075: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100075, '2024-02-25 18:15:30+07', '2024-05-25 18:15:30+07', 'jpg', 'default', 'Truyền thống', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100075, '2024-02-25 18:30:45+07', '2024-05-25 18:30:45+07', 'jpg', 'default', 'Đặc biệt', 25000.00);

-- Product 100076: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100076, '2025-05-20 18:10:30+07', '2026-06-08 18:10:30+07', 'jpg', '6 miếng', 'default', 60000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100076, '2025-05-20 18:25:45+07', '2026-06-08 18:25:45+07', 'jpg', '9 miếng', 'default', 85000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100076, '2025-05-20 18:40:20+07', '2026-06-08 18:40:20+07', 'jpg', '15 miếng', 'default', 130000.00);

-- Product 100077: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100077, '2024-04-26 08:15:30+07', '2024-06-19 08:15:30+07', 'jpg', 'default', 'default', 28000.00);

-- Product 100078: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100078, '2024-08-31 13:45:30+07', '2024-11-24 13:45:30+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100078, '2024-08-31 14:00:45+07', '2024-11-24 14:00:45+07', 'jpg', 'M', 'default', 35000.00);

-- Product 100079: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100079, '2023-09-06 06:40:30+07', '2024-03-28 06:40:30+07', 'jpg', 'default', 'default', 40000.00);

-- Product 100080: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100080, '2024-03-19 06:30:30+07', '2025-03-29 06:30:30+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100081: Chè bưởi (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100081, '2025-02-21 15:50:30+07', '2025-05-02 15:50:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100081, '2025-02-21 16:05:45+07', '2025-05-02 16:05:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100081, '2025-02-21 16:20:20+07', '2025-05-02 16:20:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100082: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100082, '2024-12-31 18:25:30+07', '2025-11-04 18:25:30+07', 'jpg', 'default', 'Ít cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100082, '2024-12-31 18:40:45+07', '2025-11-04 18:40:45+07', 'jpg', 'default', 'Vừa cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100082, '2024-12-31 18:55:20+07', '2025-11-04 18:55:20+07', 'jpg', 'default', 'Cay nồng', 50000.00);

-- Product 100083: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100083, '2024-11-24 05:40:30+07', '2025-11-23 05:40:30+07', 'jpg', 'default', 'default', 48000.00);

-- Product 100084: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100084, '2024-04-17 12:45:30+07', '2025-02-07 12:45:30+07', 'jpg', 'default', 'default', 30000.00);

-- Product 100085: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100085, '2023-10-06 02:35:30+07', '2024-07-13 02:35:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100085, '2023-10-06 02:50:45+07', '2024-07-13 02:50:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100086: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100086, '2023-05-10 21:25:30+07', '2023-11-12 21:25:30+07', 'jpg', 'default', 'default', 20000.00);

-- Product 100087: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100087, '2023-12-04 19:35:30+07', '2024-11-18 19:35:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100088: Chè bưởi (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100088, '2024-11-07 01:10:30+07', '2025-11-08 01:10:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100088, '2024-11-07 01:25:45+07', '2025-11-08 01:25:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100088, '2024-11-07 01:40:20+07', '2025-11-08 01:40:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100089: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100089, '2024-03-14 23:30:30+07', '2024-10-26 23:30:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100089, '2024-03-14 23:45:45+07', '2024-10-26 23:45:45+07', 'jpg', 'M', 'default', 40000.00);

-- Product 100090: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100090, '2024-08-10 03:05:30+07', '2025-09-03 03:05:30+07', 'jpg', '6 viên', 'default', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100090, '2024-08-10 03:20:45+07', '2025-09-03 03:20:45+07', 'jpg', '9 viên', 'default', 58000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100090, '2024-08-10 03:35:20+07', '2025-09-03 03:35:20+07', 'jpg', '15 viên', 'default', 88000.00);

-- Product 100091: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100091, '2024-02-17 05:50:30+07', '2024-04-10 05:50:30+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100092: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100092, '2024-03-06 04:50:30+07', '2025-04-10 04:50:30+07', 'jpg', 'default', 'default', 28000.00);

-- Product 100093: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100093, '2024-04-20 19:10:30+07', '2025-04-03 19:10:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100093, '2024-04-20 19:25:45+07', '2025-04-03 19:25:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100094: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100094, '2024-01-28 00:45:30+07', '2024-04-27 00:45:30+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100094, '2024-01-28 01:00:45+07', '2024-04-27 01:00:45+07', 'jpg', 'M', 'default', 35000.00);

-- Product 100095: Cà phê sữa đá (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100095, '2025-08-13 03:10:30+07', '2026-03-31 03:10:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100095, '2025-08-13 03:25:45+07', '2026-03-31 03:25:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100095, '2025-08-13 03:40:20+07', '2026-03-31 03:40:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100096: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100096, '2024-11-10 22:25:30+07', '2025-06-12 22:25:30+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100097: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100097, '2023-11-23 10:30:30+07', '2024-10-02 10:30:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100097, '2023-11-23 10:45:45+07', '2024-10-02 10:45:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100098: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100098, '2025-09-18 04:15:30+07', '2026-08-03 04:15:30+07', 'jpg', 'default', 'Ít cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100098, '2025-09-18 04:30:45+07', '2026-08-03 04:30:45+07', 'jpg', 'default', 'Vừa cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100098, '2025-09-18 04:45:20+07', '2026-08-03 04:45:20+07', 'jpg', 'default', 'Cay nồng', 48000.00);

-- Product 100099: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100099, '2023-07-22 07:40:30+07', '2023-12-06 07:40:30+07', 'jpg', 'default', 'Ít cay', 50000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100099, '2023-07-22 07:55:45+07', '2023-12-06 07:55:45+07', 'jpg', 'default', 'Vừa cay', 50000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100099, '2023-07-22 08:10:20+07', '2023-12-06 08:10:20+07', 'jpg', 'default', 'Cay nồng', 55000.00);

-- Product 100100: Tokbokki cay (2 spice levels, 2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100100, '2025-03-31 15:40:30+07', '2025-12-21 15:40:30+07', 'jpg', 'Nhỏ', 'Ít cay', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100100, '2025-03-31 15:55:45+07', '2025-12-21 15:55:45+07', 'jpg', 'Nhỏ', 'Cay nồng', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100100, '2025-03-31 16:10:20+07', '2025-12-21 16:10:20+07', 'jpg', 'Lớn', 'Ít cay', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100100, '2025-03-31 16:25:15+07', '2025-12-21 16:25:15+07', 'jpg', 'Lớn', 'Cay nồng', 48000.00);

-- Product 100101: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100101, '2025-03-21 16:30:30+07', '2026-01-24 16:30:30+07', 'jpg', 'default', 'Ít cay', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100101, '2025-03-21 16:45:45+07', '2026-01-24 16:45:45+07', 'jpg', 'default', 'Vừa cay', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100101, '2025-03-21 17:00:20+07', '2026-01-24 17:00:20+07', 'jpg', 'default', 'Cay nồng', 52000.00);

-- Product 100102: Cà phê sữa đá (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100102, '2025-02-27 14:20:30+07', '2025-04-29 14:20:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100102, '2025-02-27 14:35:45+07', '2025-04-29 14:35:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100102, '2025-02-27 14:50:20+07', '2025-04-29 14:50:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100103: Bánh flan trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100103, '2024-12-24 11:15:30+07', '2025-09-20 11:15:30+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100104: Tokbokki cay (2 spice levels, 2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100104, '2025-09-03 03:25:30+07', '2026-06-07 03:25:30+07', 'jpg', 'Nhỏ', 'Ít cay', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100104, '2025-09-03 03:40:45+07', '2026-06-07 03:40:45+07', 'jpg', 'Nhỏ', 'Cay nồng', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100104, '2025-09-03 03:55:20+07', '2026-06-07 03:55:20+07', 'jpg', 'Lớn', 'Ít cay', 55000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100104, '2025-09-03 04:10:15+07', '2026-06-07 04:10:15+07', 'jpg', 'Lớn', 'Cay nồng', 55000.00);

-- Product 100105: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100105, '2024-05-28 08:55:30+07', '2024-10-18 08:55:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100105, '2024-05-28 09:10:45+07', '2024-10-18 09:10:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100105, '2024-05-28 09:25:20+07', '2024-10-18 09:25:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100106: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100106, '2025-07-26 08:05:30+07', '2025-08-26 08:05:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100106, '2025-07-26 08:20:45+07', '2025-08-26 08:20:45+07', 'jpg', 'M', 'default', 40000.00);

-- Product 100107: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100107, '2025-02-01 00:25:30+07', '2025-07-13 00:25:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100108: Bánh su kem (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100108, '2023-03-21 11:50:30+07', '2023-10-04 11:50:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100109: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100109, '2023-12-23 13:35:30+07', '2024-04-25 13:35:30+07', 'jpg', 'default', 'Truyền thống', 15000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100109, '2023-12-23 13:50:45+07', '2024-04-25 13:50:45+07', 'jpg', 'default', 'Đặc biệt', 22000.00);

-- Product 100110: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100110, '2023-09-02 21:50:30+07', '2023-11-26 21:50:30+07', 'jpg', 'default', 'default', 38000.00);

-- Product 100111: Bánh flan trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100111, '2025-01-15 23:50:30+07', '2026-02-13 23:50:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100112: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100112, '2025-07-18 01:25:30+07', '2026-08-06 01:25:30+07', 'jpg', 'default', 'default', 48000.00);

-- Product 100113: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100113, '2023-10-07 18:35:30+07', '2024-08-22 18:35:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100113, '2023-10-07 18:50:45+07', '2024-08-22 18:50:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100114: Chè bưởi (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100114, '2025-09-30 19:30:30+07', '2026-01-19 19:30:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100114, '2025-09-30 19:45:45+07', '2026-01-19 19:45:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100114, '2025-09-30 20:00:20+07', '2026-01-19 20:00:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100115: Trà tắc (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100115, '2023-03-12 09:55:30+07', '2023-09-15 09:55:30+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100115, '2023-03-12 10:10:45+07', '2023-09-15 10:10:45+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100115, '2023-03-12 10:25:20+07', '2023-09-15 10:25:20+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100116: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100116, '2023-08-08 22:05:30+07', '2024-03-09 22:05:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100116, '2023-08-08 22:20:45+07', '2024-03-09 22:20:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100116, '2023-08-08 22:35:20+07', '2024-03-09 22:35:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100117: Soda bạc hà (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100117, '2023-03-23 19:15:30+07', '2024-03-18 19:15:30+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100117, '2023-03-23 19:30:45+07', '2024-03-18 19:30:45+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100117, '2023-03-23 19:45:20+07', '2024-03-18 19:45:20+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100118: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100118, '2024-11-03 01:55:30+07', '2024-12-13 01:55:30+07', 'jpg', 'default', 'Ít cay', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100118, '2024-11-03 02:10:45+07', '2024-12-13 02:10:45+07', 'jpg', 'default', 'Vừa cay', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100118, '2024-11-03 02:25:20+07', '2024-12-13 02:25:20+07', 'jpg', 'default', 'Cay nồng', 45000.00);

-- Product 100119: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100119, '2025-09-08 08:55:30+07', '2026-03-26 08:55:30+07', 'jpg', 'default', 'default', 40000.00);

-- Product 100120: Bánh su kem (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100120, '2023-10-18 20:25:30+07', '2023-12-11 20:25:30+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100121: Trà tắc (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100121, '2025-05-21 01:15:30+07', '2025-09-25 01:15:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100121, '2025-05-21 01:30:45+07', '2025-09-25 01:30:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100121, '2025-05-21 01:45:20+07', '2025-09-25 01:45:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100122: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100122, '2025-05-03 22:05:30+07', '2026-04-27 22:05:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100122, '2025-05-03 22:20:45+07', '2026-04-27 22:20:45+07', 'jpg', 'M', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100122, '2025-05-03 22:35:20+07', '2026-04-27 22:35:20+07', 'jpg', 'L', 'default', 50000.00);

-- Product 100123: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100123, '2023-04-26 00:45:30+07', '2023-09-09 00:45:30+07', 'jpg', 'default', 'default', 48000.00);

-- Product 100124: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100124, '2023-06-27 11:30:30+07', '2023-08-26 11:30:30+07', 'jpg', 'default', 'Truyền thống', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100124, '2023-06-27 11:45:45+07', '2023-08-26 11:45:45+07', 'jpg', 'default', 'Đặc biệt', 25000.00);

-- Product 100125: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100125, '2024-01-16 06:25:30+07', '2025-01-16 06:25:30+07', 'jpg', 'Nhỏ', 'default', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100125, '2024-01-16 06:40:45+07', '2025-01-16 06:40:45+07', 'jpg', 'Lớn', 'default', 62000.00);

-- Product 100126: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100126, '2023-03-03 18:20:30+07', '2023-04-26 18:20:30+07', 'jpg', '6 miếng', 'default', 52000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100126, '2023-03-03 18:35:45+07', '2023-04-26 18:35:45+07', 'jpg', '9 miếng', 'default', 75000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100126, '2023-03-03 18:50:20+07', '2023-04-26 18:50:20+07', 'jpg', '15 miếng', 'default', 115000.00);

-- Product 100127: Cà phê sữa đá (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100127, '2025-05-28 17:50:30+07', '2026-03-05 17:50:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100127, '2025-05-28 18:05:45+07', '2026-03-05 18:05:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100127, '2025-05-28 18:20:20+07', '2026-03-05 18:20:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100128: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100128, '2025-01-09 07:20:30+07', '2026-01-20 07:20:30+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100129: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100129, '2023-05-15 07:45:30+07', '2023-09-19 07:45:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100130: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100130, '2023-09-08 11:55:30+07', '2024-05-18 11:55:30+07', 'jpg', '6 viên', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100130, '2023-09-08 12:10:45+07', '2024-05-18 12:10:45+07', 'jpg', '9 viên', 'default', 48000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100130, '2023-09-08 12:25:20+07', '2024-05-18 12:25:20+07', 'jpg', '15 viên', 'default', 72000.00);

-- Product 100131: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100131, '2023-12-09 08:40:30+07', '2024-02-02 08:40:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100131, '2023-12-09 08:55:45+07', '2024-02-02 08:55:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100132: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100132, '2023-04-28 04:30:30+07', '2024-05-09 04:30:30+07', 'jpg', 'Nhỏ', 'default', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100132, '2023-04-28 04:45:45+07', '2024-05-09 04:45:45+07', 'jpg', 'Lớn', 'default', 58000.00);

-- Product 100133: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100133, '2025-05-30 09:30:30+07', '2026-05-01 09:30:30+07', 'jpg', 'default', 'Ít cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100133, '2025-05-30 09:45:45+07', '2026-05-01 09:45:45+07', 'jpg', 'default', 'Vừa cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100133, '2025-05-30 10:00:20+07', '2026-05-01 10:00:20+07', 'jpg', 'default', 'Cay nồng', 50000.00);

-- Product 100134: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100134, '2024-01-25 08:30:30+07', '2024-07-25 08:30:30+07', 'jpg', '6 miếng', 'default', 58000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100134, '2024-01-25 08:45:45+07', '2024-07-25 08:45:45+07', 'jpg', '9 miếng', 'default', 82000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100134, '2024-01-25 09:00:20+07', '2024-07-25 09:00:20+07', 'jpg', '15 miếng', 'default', 125000.00);

-- Product 100135: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100135, '2023-10-25 07:00:30+07', '2024-03-22 07:00:30+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100136: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100136, '2023-06-10 23:25:30+07', '2023-08-05 23:25:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100136, '2023-06-10 23:40:45+07', '2023-08-05 23:40:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100137: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100137, '2023-04-29 06:10:30+07', '2024-05-22 06:10:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100137, '2023-04-29 06:25:45+07', '2024-05-22 06:25:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100137, '2023-04-29 06:40:20+07', '2024-05-22 06:40:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100138: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100138, '2024-12-11 17:50:30+07', '2025-02-10 17:50:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100139: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100139, '2025-05-14 01:35:30+07', '2025-07-16 01:35:30+07', 'jpg', '6 viên', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100139, '2025-05-14 01:50:45+07', '2025-07-16 01:50:45+07', 'jpg', '9 viên', 'default', 52000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100139, '2025-05-14 02:05:20+07', '2025-07-16 02:05:20+07', 'jpg', '15 viên', 'default', 78000.00);

-- Product 100140: Mì cay hải sản (3 spice levels)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100140, '2024-10-07 12:15:30+07', '2025-10-27 12:15:30+07', 'jpg', 'default', 'Ít cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100140, '2024-10-07 12:30:45+07', '2025-10-27 12:30:45+07', 'jpg', 'default', 'Vừa cay', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100140, '2024-10-07 12:45:20+07', '2025-10-27 12:45:20+07', 'jpg', 'default', 'Cay nồng', 48000.00);

-- Product 100141: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100141, '2024-10-26 10:05:30+07', '2025-11-26 10:05:30+07', 'jpg', 'default', 'default', 28000.00);

-- Product 100142: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100142, '2025-09-29 09:50:30+07', '2026-06-23 09:50:30+07', 'jpg', 'default', 'default', 40000.00);

-- Product 100143: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100143, '2025-03-23 15:15:30+07', '2026-01-08 15:15:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100143, '2025-03-23 15:30:45+07', '2026-01-08 15:30:45+07', 'jpg', 'M', 'default', 40000.00);

-- Product 100144: Soda bạc hà (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100144, '2024-04-06 23:25:30+07', '2025-05-01 23:25:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100144, '2024-04-06 23:40:45+07', '2025-05-01 23:40:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100144, '2024-04-06 23:55:20+07', '2025-05-01 23:55:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100145: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100145, '2025-08-04 04:40:30+07', '2026-07-08 04:40:30+07', 'jpg', '6 miếng', 'default', 60000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100145, '2025-08-04 04:55:45+07', '2026-07-08 04:55:45+07', 'jpg', '9 miếng', 'default', 85000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100145, '2025-08-04 05:10:20+07', '2026-07-08 05:10:20+07', 'jpg', '15 miếng', 'default', 130000.00);

-- Product 100146: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100146, '2024-06-14 12:55:30+07', '2025-01-12 12:55:30+07', 'jpg', 'default', 'default', 30000.00);

-- Product 100147: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100147, '2024-03-06 13:55:30+07', '2025-03-05 13:55:30+07', 'jpg', 'default', 'Truyền thống', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100147, '2024-03-06 14:10:45+07', '2025-03-05 14:10:45+07', 'jpg', 'default', 'Đặc biệt', 28000.00);

-- Product 100148: Sushi cá hồi (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100148, '2023-08-11 10:40:30+07', '2024-04-04 10:40:30+07', 'jpg', '6 miếng', 'default', 52000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100148, '2023-08-11 10:55:45+07', '2024-04-04 10:55:45+07', 'jpg', '9 miếng', 'default', 73000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100148, '2023-08-11 11:10:20+07', '2024-04-04 11:10:20+07', 'jpg', '15 miếng', 'default', 110000.00);

-- Product 100149: Trà sữa socola (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100149, '2024-09-01 16:05:30+07', '2025-05-21 16:05:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100149, '2024-09-01 16:20:45+07', '2025-05-21 16:20:45+07', 'jpg', 'M', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100149, '2024-09-01 16:35:20+07', '2025-05-21 16:35:20+07', 'jpg', 'L', 'default', 42000.00);

-- Product 100150: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100150, '2023-07-13 09:50:30+07', '2023-10-21 09:50:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100151: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100151, '2024-08-06 13:30:30+07', '2025-08-24 13:30:30+07', 'jpg', 'default', 'Truyền thống', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100151, '2024-08-06 13:45:45+07', '2025-08-24 13:45:45+07', 'jpg', 'default', 'Đặc biệt', 25000.00);

-- Product 100152: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100152, '2024-01-15 10:55:30+07', '2024-05-08 10:55:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100152, '2024-01-15 11:10:45+07', '2024-05-08 11:10:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100152, '2024-01-15 11:25:20+07', '2024-05-08 11:25:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100153: Trà tắc (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100153, '2023-11-14 05:30:30+07', '2024-09-14 05:30:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100153, '2023-11-14 05:45:45+07', '2024-09-14 05:45:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100153, '2023-11-14 06:00:20+07', '2024-09-14 06:00:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100154: Chè bưởi (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100154, '2023-10-22 18:00:30+07', '2024-07-17 18:00:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100154, '2023-10-22 18:15:45+07', '2024-07-17 18:15:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100154, '2023-10-22 18:30:20+07', '2024-07-17 18:30:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100155: Soda bạc hà (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100155, '2025-09-27 23:10:30+07', '2026-03-22 23:10:30+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100155, '2025-09-27 23:25:45+07', '2026-03-22 23:25:45+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100155, '2025-09-27 23:40:20+07', '2026-03-22 23:40:20+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100156: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100156, '2025-08-23 13:45:30+07', '2026-07-03 13:45:30+07', 'jpg', 'default', 'default', 32000.00);

-- Product 100157: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100157, '2024-01-01 18:30:30+07', '2024-03-16 18:30:30+07', 'jpg', 'default', 'default', 32000.00);

-- Product 100158: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100158, '2024-09-13 14:40:30+07', '2025-04-09 14:40:30+07', 'jpg', '4 miếng', 'default', 58000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100158, '2024-09-13 14:55:45+07', '2025-04-09 14:55:45+07', 'jpg', '6 miếng', 'default', 82000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100158, '2024-09-13 15:10:20+07', '2025-04-09 15:10:20+07', 'jpg', '9 miếng', 'default', 115000.00);

-- Product 100159: Gà rán giòn (4, 6, 9 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100159, '2023-08-31 07:40:30+07', '2023-12-13 07:40:30+07', 'jpg', '4 miếng', 'default', 60000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100159, '2023-08-31 07:55:45+07', '2023-12-13 07:55:45+07', 'jpg', '6 miếng', 'default', 85000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100159, '2023-08-31 08:10:20+07', '2023-12-13 08:10:20+07', 'jpg', '9 miếng', 'default', 120000.00);

-- Product 100160: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100160, '2025-06-17 11:40:30+07', '2025-10-15 11:40:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100161: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100161, '2025-07-12 05:10:30+07', '2026-05-07 05:10:30+07', 'jpg', 'Nhỏ', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100161, '2025-07-12 05:25:45+07', '2026-05-07 05:25:45+07', 'jpg', 'Lớn', 'default', 55000.00);

-- Product 100162: Takoyaki truyền thống (6, 9, 15 pieces)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100162, '2023-12-05 10:15:30+07', '2024-03-17 10:15:30+07', 'jpg', '6 viên', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100162, '2023-12-05 10:30:45+07', '2024-03-17 10:30:45+07', 'jpg', '9 viên', 'default', 53000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100162, '2023-12-05 10:45:20+07', '2024-03-17 10:45:20+07', 'jpg', '15 viên', 'default', 80000.00);

-- Product 100163: Trà tắc (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100163, '2023-12-08 12:45:30+07', '2024-04-03 12:45:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100163, '2023-12-08 13:00:45+07', '2024-04-03 13:00:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100163, '2023-12-08 13:15:20+07', '2024-04-03 13:15:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100164: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100164, '2023-03-17 05:30:30+07', '2023-07-11 05:30:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100164, '2023-03-17 05:45:45+07', '2023-07-11 05:45:45+07', 'jpg', 'M', 'default', 38000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100164, '2023-03-17 06:00:20+07', '2023-07-11 06:00:20+07', 'jpg', 'L', 'default', 48000.00);

-- Product 100165: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100165, '2023-09-19 19:25:30+07', '2024-10-20 19:25:30+07', 'jpg', 'Nhỏ', 'default', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100165, '2023-09-19 19:40:45+07', '2024-10-20 19:40:45+07', 'jpg', 'Lớn', 'default', 62000.00);

-- Product 100166: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100166, '2023-07-01 15:35:30+07', '2024-06-09 15:35:30+07', 'jpg', 'default', 'default', 42000.00);

-- Product 100167: Udon hải sản (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100167, '2023-12-22 00:50:30+07', '2024-03-04 00:50:30+07', 'jpg', 'Nhỏ', 'default', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100167, '2023-12-22 01:05:45+07', '2024-03-04 01:05:45+07', 'jpg', 'Lớn', 'default', 58000.00);

-- Product 100168: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100168, '2024-12-21 05:10:30+07', '2025-12-17 05:10:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100168, '2024-12-21 05:25:45+07', '2025-12-17 05:25:45+07', 'jpg', 'M', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100168, '2024-12-21 05:40:20+07', '2025-12-17 05:40:20+07', 'jpg', 'L', 'default', 50000.00);

-- Product 100169: Trà sữa socola (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100169, '2023-03-21 17:30:30+07', '2023-09-04 17:30:30+07', 'jpg', 'S', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100169, '2023-03-21 17:45:45+07', '2023-09-04 17:45:45+07', 'jpg', 'M', 'default', 32000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100169, '2023-03-21 18:00:20+07', '2023-09-04 18:00:20+07', 'jpg', 'L', 'default', 40000.00);

-- Product 100170: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100170, '2024-12-26 08:30:30+07', '2026-01-01 08:30:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100170, '2024-12-26 08:45:45+07', '2026-01-01 08:45:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100171: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100171, '2025-05-18 18:25:30+07', '2025-07-29 18:25:30+07', 'jpg', 'default', 'default', 22000.00);

-- Product 100172: Nước ép cam (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100172, '2025-03-04 17:05:30+07', '2025-10-08 17:05:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100172, '2025-03-04 17:20:45+07', '2025-10-08 17:20:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100172, '2025-03-04 17:35:20+07', '2025-10-08 17:35:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100173: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100173, '2025-01-03 04:15:30+07', '2026-01-12 04:15:30+07', 'jpg', 'default', 'Truyền thống', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100173, '2025-01-03 04:30:45+07', '2026-01-12 04:30:45+07', 'jpg', 'default', 'Đặc biệt', 25000.00);

-- Product 100174: Bánh mì thịt nướng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100174, '2025-02-28 15:55:30+07', '2025-06-24 15:55:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100175: Cà phê sữa đá (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100175, '2024-01-29 10:35:30+07', '2024-05-28 10:35:30+07', 'jpg', 'S', 'default', 22000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100175, '2024-01-29 10:50:45+07', '2024-05-28 10:50:45+07', 'jpg', 'M', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100175, '2024-01-29 11:05:20+07', '2024-05-28 11:05:20+07', 'jpg', 'L', 'default', 38000.00);

-- Product 100176: Bánh flan trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100176, '2024-06-23 01:15:30+07', '2025-01-28 01:15:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100177: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100177, '2024-01-24 19:10:30+07', '2024-03-16 19:10:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100178: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100178, '2025-08-11 10:25:30+07', '2026-03-21 10:25:30+07', 'jpg', 'default', 'default', 30000.00);

-- Product 100179: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100179, '2025-07-26 08:45:30+07', '2026-05-10 08:45:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100179, '2025-07-26 09:00:45+07', '2026-05-10 09:00:45+07', 'jpg', 'M', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100179, '2025-07-26 09:15:20+07', '2026-05-10 09:15:20+07', 'jpg', 'L', 'default', 50000.00);

-- Product 100180: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100180, '2025-02-26 00:10:30+07', '2025-09-04 23:59:30+07', 'jpg', 'default', 'Truyền thống', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100180, '2025-02-26 00:25:45+07', '2025-09-05 00:10:45+07', 'jpg', 'default', 'Đặc biệt', 28000.00);

-- Product 100181: Bánh flan trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100181, '2025-02-06 16:40:30+07', '2025-06-07 16:40:30+07', 'jpg', 'default', 'default', 25000.00);

-- Product 100182: Cơm chiên trứng (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100182, '2024-04-08 08:10:30+07', '2024-12-19 08:10:30+07', 'jpg', 'default', 'default', 38000.00);

-- Product 100183: Soda bạc hà (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100183, '2023-11-04 09:25:30+07', '2024-09-30 09:25:30+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100183, '2023-11-04 09:40:45+07', '2024-09-30 09:40:45+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100183, '2023-11-04 09:55:20+07', '2024-09-30 09:55:20+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100184: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100184, '2025-08-13 21:00:30+07', '2025-11-09 21:00:30+07', 'jpg', 'default', 'default', 38000.00);

-- Product 100185: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100185, '2024-06-06 23:25:30+07', '2025-04-11 23:25:30+07', 'jpg', 'default', 'default', 32000.00);

-- Product 100186: Bánh bao nhân thịt (2 variations)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100186, '2024-03-29 00:15:30+07', '2024-12-14 23:59:30+07', 'jpg', 'default', 'Truyền thống', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100186, '2024-03-29 00:30:45+07', '2024-12-15 00:10:45+07', 'jpg', 'default', 'Đặc biệt', 25000.00);

-- Product 100187: Cơm gà xối mỡ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100187, '2023-04-24 01:20:30+07', '2023-07-02 01:20:30+07', 'jpg', 'default', 'default', 40000.00);

-- Product 100188: Soda bạc hà (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100188, '2024-06-15 11:50:30+07', '2024-09-11 11:50:30+07', 'jpg', 'S', 'default', 18000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100188, '2024-06-15 12:05:45+07', '2024-09-11 12:05:45+07', 'jpg', 'M', 'default', 25000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100188, '2024-06-15 12:20:20+07', '2024-09-11 12:20:20+07', 'jpg', 'L', 'default', 32000.00);

-- Product 100189: Kem matcha (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100189, '2025-09-25 18:10:30+07', '2026-05-04 18:10:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100189, '2025-09-25 18:25:45+07', '2026-05-04 18:25:45+07', 'jpg', 'M', 'default', 40000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100189, '2025-09-25 18:40:20+07', '2026-05-04 18:40:20+07', 'jpg', 'L', 'default', 50000.00);

-- Product 100190: Pancake mật ong (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100190, '2025-02-26 13:35:30+07', '2025-05-29 13:35:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100191: Chè bưởi (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100191, '2025-05-13 19:25:30+07', '2025-11-05 19:25:30+07', 'jpg', 'S', 'default', 20000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100191, '2025-05-13 19:40:45+07', '2025-11-05 19:40:45+07', 'jpg', 'M', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100191, '2025-05-13 19:55:20+07', '2025-11-05 19:55:20+07', 'jpg', 'L', 'default', 35000.00);

-- Product 100192: Mochi đậu đỏ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100192, '2025-05-04 13:50:30+07', '2026-01-11 13:50:30+07', 'jpg', 'default', 'default', 28000.00);

-- Product 100193: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100193, '2023-05-31 19:40:30+07', '2024-05-30 19:40:30+07', 'jpg', 'Nhỏ', 'default', 42000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100193, '2023-05-31 19:55:45+07', '2024-05-30 19:55:45+07', 'jpg', 'Lớn', 'default', 58000.00);

-- Product 100194: Bibimbap chay (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100194, '2023-10-28 03:10:30+07', '2024-06-26 03:10:30+07', 'jpg', 'default', 'default', 45000.00);

-- Product 100195: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100195, '2024-05-15 14:25:30+07', '2025-01-13 14:25:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100195, '2024-05-15 14:40:45+07', '2025-01-13 14:40:45+07', 'jpg', 'M', 'default', 38000.00);

-- Product 100196: Phở bò viên (2 sizes)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100196, '2024-02-10 23:25:30+07', '2024-08-20 23:25:30+07', 'jpg', 'Nhỏ', 'default', 45000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100196, '2024-02-10 23:40:45+07', '2024-08-20 23:40:45+07', 'jpg', 'Lớn', 'default', 62000.00);

-- Product 100197: Trà sữa socola (S, M, L)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100197, '2024-09-03 10:35:30+07', '2025-06-19 10:35:30+07', 'jpg', 'S', 'default', 28000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100197, '2024-09-03 10:50:45+07', '2025-06-19 10:50:45+07', 'jpg', 'M', 'default', 35000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100197, '2024-09-03 11:05:20+07', '2025-06-19 11:05:20+07', 'jpg', 'L', 'default', 42000.00);

-- Product 100198: Kimbap cá ngừ (Single variation)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100198, '2024-08-01 01:10:30+07', '2025-02-21 01:10:30+07', 'jpg', 'default', 'default', 35000.00);

-- Product 100199: Súp miso (S, M)
INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100199, '2025-05-22 16:10:30+07', '2025-11-17 16:10:30+07', 'jpg', 'S', 'default', 30000.00);

INSERT INTO public.product_variation (product_id, date_added, updated_at, image_extension, product_size, variation, price)
VALUES (100199, '2025-05-22 16:25:45+07', '2025-11-17 16:25:45+07', 'jpg', 'M', 'default', 40000.00);