-- Table: public.users

DROP TABLE IF EXISTS public.admin;
DROP TABLE IF EXISTS public.customer;
DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    user_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100000 MINVALUE 100000 MAXVALUE 999999 CACHE 1 ),
    email character varying(254) COMPRESSION lz4 COLLATE pg_catalog."default" UNIQUE,
	username character varying(64),
	password_hash character varying(64),
	is_active bit NOT NULL,
    creation_date date,
    CONSTRAINT user_pk PRIMARY KEY (user_id)
);

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;

-- Table: public.customer

CREATE TABLE IF NOT EXISTS public.customer
(
    user_id bigint NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (user_id),
    CONSTRAINT customer_fk_user FOREIGN KEY (user_id)
        REFERENCES public.users (user_id)
		ON DELETE CASCADE
);

ALTER TABLE IF EXISTS public.customer
    OWNER to postgres;

-- Table: public.admin

CREATE TABLE IF NOT EXISTS public.admin
(
    user_id bigint NOT NULL,
    CONSTRAINT admin_pk PRIMARY KEY (user_id),
    CONSTRAINT admin_fk_user FOREIGN KEY (user_id) 
        REFERENCES public.users (user_id)
		ON DELETE CASCADE
);

ALTER TABLE IF EXISTS public.admin
    OWNER to postgres;