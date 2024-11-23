-- Create the 'actor' table
CREATE TABLE actor (
    actor_id integer PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL
);

-- Create the 'country' table
CREATE TABLE country (
    country_id integer PRIMARY KEY,
    country text NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL
);


-- Create the 'city' table
CREATE TABLE city (
    city_id integer PRIMARY KEY,
    city text NOT NULL,
    country_id smallint NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create the 'address' table
CREATE TABLE address (
    address_id integer PRIMARY KEY,
    address text NOT NULL,
    address2 text,
    district text NOT NULL,
    city_id smallint NOT NULL,
    postal_code text,
    phone text NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(city_id) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Create the 'category' table
CREATE TABLE category (
    category_id integer PRIMARY KEY,
    name text NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL
);


-- Create the 'store' table
CREATE TABLE store (
    store_id integer PRIMARY KEY,
    manager_staff_id smallint NOT NULL,
    address_id smallint NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

--Create the 'customer' table
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    store_id smallint NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text,
    address_id smallint NOT NULL,
    activebool boolean DEFAULT true NOT NULL,
    create_date date DEFAULT ('now'::text)::date NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    active integer,
    FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Create the 'language' table
CREATE TABLE language (
    language_id integer PRIMARY KEY,
    name character(20) NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL
);


CREATE TYPE mpaa_rating AS ENUM (
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17'
);

-- Create the 'film' table
CREATE TABLE film (
    film_id integer PRIMARY KEY,
    title text NOT NULL,
    description text,
    release_year smallint,
    language_id smallint NOT NULL,
    original_language_id smallint,
    rental_duration smallint DEFAULT 3 NOT NULL,
    rental_rate numeric(4,2) DEFAULT 4.99 NOT NULL,
    length smallint,
    replacement_cost numeric(4,2) DEFAULT 19.99 NOT NULL,
    rating mpaa_rating DEFAULT 'G'::mpaa_rating,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    special_features text[],
    fulltext tsvector NOT NULL,
    FOREIGN KEY (language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (original_language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Create the 'film_actor' table
CREATE TABLE film_actor (
    actor_id smallint,
    film_id smallint,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT
);



-- Create the 'film_category' table
CREATE TABLE film_category (
    film_id smallint,
    category_id smallint,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    PRIMARY KEY (film_id, category_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Create the 'inventory' table
CREATE TABLE inventory (
    inventory_id integer PRIMARY KEY,
    film_id smallint NOT NULL,
    store_id smallint NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Create the 'staff' table
CREATE TABLE staff (
    staff_id integer PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    address_id smallint NOT NULL,
    email text,
    store_id smallint NOT NULL,
    active boolean DEFAULT true NOT NULL,
    username text NOT NULL,
    password text,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    picture bytea,
    FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);



-- Create the 'rental' table
CREATE TABLE rental (
    rental_id integer PRIMARY KEY,
    rental_date timestamp with time zone NOT NULL,
    inventory_id integer NOT NULL,
    customer_id smallint NOT NULL,
    return_date timestamp with time zone,
    staff_id smallint NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT
);



-- Create the 'payment' table
CREATE TABLE payment (
    payment_id integer NOT NULL,
    customer_id smallint NOT NULL,
    staff_id smallint NOT NULL,
    rental_id integer NOT NULL,
    amount numeric(5,2) NOT NULL,
    payment_date timestamp with time zone NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id) ON UPDATE CASCADE ON DELETE RESTRICT
);







