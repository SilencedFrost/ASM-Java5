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
	role_id int GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 CACHE 1 ),
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
    stock_count integer NOT NULL CHECK (stock_count >= 0),
    image_extension varchar(5),
    product_size varchar(32) NOT NULL,
    variation varchar(32) NOT NULL,
    price numeric(15,2) NOT NULL CHECK (price >= 0),
    is_active boolean NOT NULL,
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
INSERT INTO public.role (role_name) VALUES ('customer');
INSERT INTO public.role (role_name) VALUES ('seller');
INSERT INTO public.role (role_name) VALUES ('admin');

-- User
-- Admin user (role_id = 3)
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) 
VALUES ('thnrgbefv0987@gmail.com', 3, 'admin_master', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-02-15 10:30:00+00');

-- Seller user (role_id = 2)
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) 
VALUES ('minhnqts00553@fpt.edu.vn', 2, 'seller_pro', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-05-22 14:45:00+00');

-- Customer users (role_id = 1)
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('alex.morgan@email.com', 2, 'alex_m', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-03-10 08:20:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('jamie.chen@email.com', 2, 'jamie_c', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-06-18 16:55:00+00');
INSERT INTO public.users (email, role_id, username, password_hash, is_active, creation_date) VALUES ('taylor.smith@email.com', 2, 'taylor_s', '$2a$12$t/XkaAl.A.RqOj2ZsLBOxuyxPmMwQmXZFJ71jM0Rv7yju2A888XPG', true, '2023-08-05 11:30:00+00');
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

-- Customer

INSERT INTO public.customer (user_id) VALUES (100005);
INSERT INTO public.customer (user_id) VALUES (100006);
INSERT INTO public.customer (user_id) VALUES (100007);
INSERT INTO public.customer (user_id) VALUES (100008);
INSERT INTO public.customer (user_id) VALUES (100009);
INSERT INTO public.customer (user_id) VALUES (100010);
INSERT INTO public.customer (user_id) VALUES (100011);
INSERT INTO public.customer (user_id) VALUES (100012);
INSERT INTO public.customer (user_id) VALUES (100013);
INSERT INTO public.customer (user_id) VALUES (100014);
INSERT INTO public.customer (user_id) VALUES (100015);
INSERT INTO public.customer (user_id) VALUES (100016);
INSERT INTO public.customer (user_id) VALUES (100017);
INSERT INTO public.customer (user_id) VALUES (100018);
INSERT INTO public.customer (user_id) VALUES (100019);

-- City
INSERT INTO public.city (city_name) VALUES ('Hồ Chí Minh');
INSERT INTO public.city (city_name) VALUES ('Hà Nội');
INSERT INTO public.city (city_name) VALUES ('Đà Nẵng');
INSERT INTO public.city (city_name) VALUES ('Hải Phòng');
INSERT INTO public.city (city_name) VALUES ('Cần Thơ');
INSERT INTO public.city (city_name) VALUES ('Huế');

-- Category
INSERT INTO public.category (category_name, is_active) values ('Trà sữa', true);
INSERT INTO public.category (category_name, is_active) values ('Phở', true);
INSERT INTO public.category (category_name, is_active) values ('Bún', true);
INSERT INTO public.category (category_name, is_active) values ('Hủ tiếu', true);
INSERT INTO public.category (category_name, is_active) values ('Takoyaki', true);
INSERT INTO public.category (category_name, is_active) values ('Tteokbokki', true);

-- Product
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Trà sữa trân châu đường đen', 100000, 1, '2020-05-12 10:34:00+07', '2022-03-21 15:12:00+07', 'jpg', 'Trà sữa ngọt dịu, topping trân châu dẻo dai.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Trà sữa matcha', 100000, 1, '2021-07-25 14:11:00+07', '2023-02-18 10:45:00+07', 'jpg', 'Trà sữa matcha thơm nhẹ, mát lạnh.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Trà sữa khoai môn', 100000, 1, '2022-11-03 09:40:00+07', '2024-01-15 11:28:00+07', 'jpg', 'Trà sữa vị khoai môn béo ngậy, màu tím nhẹ.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Trà sữa socola', 100000, 1, '2023-02-20 12:32:00+07', '2025-05-17 13:22:00+07', 'jpg', 'Trà sữa hương socola đậm đà, thơm ngọt.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Phở bò tái', 100001, 2, '2020-09-17 07:25:00+07', '2021-12-10 08:45:00+07', 'jpg', 'Phở bò tái truyền thống, nước dùng trong và đậm vị.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Phở gà', 100001, 2, '2021-05-04 06:45:00+07', '2023-09-13 07:12:00+07', 'jpg', 'Phở gà xé phay, hành lá tươi, nước lèo thanh.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Phở bò viên', 100001, 2, '2022-08-12 11:55:00+07', '2024-07-21 13:05:00+07', 'jpg', 'Phở bò viên thơm ngon, thịt bò viên dai giòn.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Bún bò Huế', 100002, 3, '2020-03-28 09:30:00+07', '2023-05-10 12:45:00+07', 'jpg', 'Bún bò Huế cay nồng, nước lèo đậm đà.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Bún riêu cua', 100002, 3, '2021-09-22 10:25:00+07', '2024-03-30 15:10:00+07', 'jpg', 'Bún riêu cua tươi, vị chua thanh nhẹ, riêu mềm.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Bún chả Hà Nội', 100002, 3, '2022-01-09 11:11:00+07', '2024-06-19 14:44:00+07', 'jpg', 'Bún chả với thịt nướng than hoa thơm lừng.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Hủ tiếu Nam Vang', 100002, 4, '2020-10-15 07:10:00+07', '2022-11-18 09:12:00+07', 'jpg', 'Hủ tiếu Nam Vang chuẩn vị miền Nam, topping đa dạng.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Hủ tiếu bò kho', 100002, 4, '2021-04-07 08:20:00+07', '2023-07-16 10:20:00+07', 'jpg', 'Hủ tiếu bò kho mềm thịt, nước dùng thơm nồng.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Hủ tiếu hải sản', 100002, 4, '2022-12-03 09:50:00+07', '2025-03-12 11:33:00+07', 'jpg', 'Hủ tiếu hải sản tươi ngon, vị ngọt từ thiên nhiên.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Takoyaki truyền thống', 100003, 5, '2020-06-09 14:45:00+07', '2022-05-11 16:00:00+07', 'jpg', 'Takoyaki nhân bạch tuộc, ăn kèm sốt mayonnaise.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Takoyaki phô mai', 100003, 5, '2021-11-14 13:33:00+07', '2024-02-25 15:20:00+07', 'jpg', 'Takoyaki nhân phô mai béo ngậy, tan chảy.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Takoyaki cay', 100003, 5, '2023-04-01 12:00:00+07', '2025-06-20 14:30:00+07', 'jpg', 'Takoyaki cay vừa phải, hợp khẩu vị giới trẻ.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Trà sữa bạc hà', 100000, 1, '2020-08-19 15:45:00+07', '2023-09-11 10:33:00+07', 'jpg', 'Trà sữa bạc hà tươi mát, hương thơm nhẹ nhàng.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Bún thịt nướng', 100002, 3, '2023-06-25 10:10:00+07', '2025-08-10 11:40:00+07', 'jpg', 'Bún thịt nướng chả giò, nước mắm pha chuẩn vị.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Phở đặc biệt thập cẩm', 100001, 2, '2024-01-19 09:22:00+07', '2025-07-03 12:15:00+07', 'jpg', 'Phở thập cẩm với nhiều loại thịt bò, gân, viên.', true);
INSERT INTO public.product (product_name, seller_id, category_id, date_added, updated_at, thumbnail_extension, description, is_active)VALUES ('Hủ tiếu sa tế', 100002, 4, '2022-05-09 08:00:00+07', '2025-02-18 10:20:00+07', 'jpg', 'Hủ tiếu sa tế cay nồng, vị lạ miệng hấp dẫn.', true);

-- Product variation
-- 100000: Trà sữa trân châu đường đen
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100000, '2021-03-14 10:30:00+07', '2023-01-21 11:45:00+07', 120, 'jpg', 'M', 'Trân châu', 35000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100000, '2021-03-14 10:30:00+07', '2024-04-09 12:30:00+07', 95, 'jpg', 'L', 'Trân châu', 39000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100000, '2021-03-14 10:30:00+07', '2024-04-09 12:30:00+07', 110, 'jpg', 'L', 'Kem cheese', 42000.00, true);
-- 100001: Trà sữa matcha
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100001, '2022-02-10 09:00:00+07', '2023-06-25 10:00:00+07', 80, 'jpg', 'M', 'default', 36000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100001, '2022-02-10 09:00:00+07', '2024-08-12 12:00:00+07', 65, 'jpg', 'L', 'default', 40000.00, true);
-- 100002: Trà sữa khoai môn
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100002, '2023-01-11 13:20:00+07', '2025-05-05 14:00:00+07', 90, 'jpg', 'M', 'Trân châu', 37000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100002, '2023-01-11 13:20:00+07', '2025-05-05 14:00:00+07', 70, 'jpg', 'L', 'Trân châu', 41000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100002, '2023-01-11 13:20:00+07', '2025-05-05 14:00:00+07', 60, 'jpg', 'L', 'Thạch dừa', 42000.00, true);
-- 100003: Trà sữa socola
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100003, '2023-03-10 10:30:00+07', '2025-02-15 11:00:00+07', 100, 'jpg', 'M', 'default', 38000.00, true);
-- 100004: Phở bò tái
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100004, '2020-10-12 07:00:00+07', '2022-06-19 09:00:00+07', 60, 'jpg', 'default', 'default', 50000.00, true);
-- 100005: Phở gà
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100005, '2021-06-12 07:30:00+07', '2023-08-11 10:00:00+07', 85, 'jpg', 'default', 'default', 45000.00, true);
-- 100006: Phở bò viên
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100006, '2022-10-15 08:30:00+07', '2024-09-18 09:15:00+07', 70, 'jpg', 'default', 'default', 52000.00, true);
-- 100007: Bún bò Huế
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100007, '2020-05-20 09:45:00+07', '2023-06-01 11:30:00+07', 100, 'jpg', 'default', 'default', 55000.00, true);
-- 100008: Bún riêu cua
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100008, '2021-11-10 08:10:00+07', '2024-05-20 09:50:00+07', 90, 'jpg', 'default', 'default', 48000.00, true);
-- 100009: Bún chả Hà Nội
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100009, '2022-02-25 07:50:00+07', '2025-01-12 09:00:00+07', 110, 'jpg', 'default', 'default', 52000.00, true);
-- 100010: Hủ tiếu Nam Vang
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100010, '2020-11-10 06:40:00+07', '2023-03-05 08:20:00+07', 75, 'jpg', 'default', 'default', 48000.00, true);
-- 100011: Hủ tiếu bò khô
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100011, '2021-05-11 07:30:00+07', '2024-02-25 09:10:00+07', 95, 'jpg', 'default', 'default', 49000.00, true);
-- 100012: Hủ tiếu hải sản
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100012, '2023-01-01 08:00:00+07', '2025-05-25 10:00:00+07', 65, 'jpg', 'default', 'default', 52000.00, true);
-- 100013: Takoyaki truyền thống
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100013, '2021-02-15 13:00:00+07', '2023-08-11 14:00:00+07', 130, 'jpg', '6 viên', 'default', 35000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100013, '2021-02-15 13:00:00+07', '2024-02-05 14:00:00+07', 120, 'jpg', '8 viên', 'default', 42000.00, true);
-- 100014: Takoyaki phô mai
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100014, '2022-03-20 13:30:00+07', '2024-09-25 14:30:00+07', 140, 'jpg', '6 viên', 'Phô mai', 38000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100014, '2022-03-20 13:30:00+07', '2024-09-25 14:30:00+07', 100, 'jpg', '8 viên', 'Phô mai', 45000.00, true);
-- 100015: Takoyaki cay
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100015, '2023-04-15 12:10:00+07', '2025-07-11 13:15:00+07', 150, 'jpg', '6 viên', 'Cay', 36000.00, true);
-- 100016: Trà sữa bạc hà
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100016, '2020-09-20 14:00:00+07', '2023-11-11 15:00:00+07', 95, 'jpg', 'M', 'default', 34000.00, true);
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100016, '2020-09-20 14:00:00+07', '2024-09-10 16:00:00+07', 80, 'jpg', 'L', 'default', 38000.00, true);
-- 100017: Bún thịt nướng
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100017, '2023-08-10 09:00:00+07', '2025-08-20 10:15:00+07', 60, 'jpg', 'default', 'default', 50000.00, true);
-- 100018: Phở đặc biệt thập cẩm
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100018, '2024-02-15 07:45:00+07', '2025-07-01 09:00:00+07', 85, 'jpg', 'default', 'default', 58000.00, true);
-- 100019: Hủ tiếu sa tế
INSERT INTO public.product_variation (product_id, date_added, updated_at, stock_count, image_extension, product_size, variation, price, is_active) VALUES (100019, '2022-06-05 07:30:00+07', '2025-02-10 09:30:00+07', 75, 'jpg', 'default', 'default', 51000.00, true);


