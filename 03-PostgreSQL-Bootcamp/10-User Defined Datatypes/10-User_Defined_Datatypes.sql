-- User-defined data types

-- CREATE DOMAIN data type
-- ##############################################
--1. CREATE DOMAIN statement creates a user-defined data type with a range, optional DEFAULT, NOT NULL and CHECK constraint
--2. They have to be unique within a schema scope. Cannot be re-use outside of scope where they are defined.
--3. Help to STANDERDIZE your database data types in one place.
--4. A domain data type is a COMMON data type and can be RE-USE in multiple columns. Write once and share it all.
--5. NULL is default
--6. Composite Type : Only Single Value return

-- CREATE DOMAIN name AS data_type constraint


-- Example # 1 : 'addr' domain with VARCHAR(100)

CREATE DOMAIN addr VARCHAR(100) NOT NULL;

CREATE TABLE locations (
    address addr
);

INSERT INTO locations (address) VALUES ('123 London');

select * from locations;


-- Example # 4 : 'positive_numeric' domain with a positive NUMERIC i.e > 0

CREATE DOMAIN positive_numeric INT NOT NULL CHECK (VALUE > 0);

CREATE TABLE sample (
    sample_id SERIAL PRIMARY KEY,
    value_num positive_numeric
);

INSERT INTO sample (value_num) VALUES (10);

select * from sample;

INSERT INTO sample (value_num) VALUES (-10);


-- Example # 5 : 'us_postal_code' domain to check for valid US postal code format

CREATE DOMAIN us_postal_code AS TEXT
CHECK (
    VALUE ~ '^\d{5}$'
    OR VALUE ~ '^\d{5}-\d{4}$'
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    postal_code us_postal_code
);

INSERT INTO addresses (postal_code) VALUES ('10000')

SELECT * FROM addresses;


-- Example # 6 : 'proper_email' domain to check for a valid email address

CREATE DOMAIN proper_email VARCHAR(150)
CHECK (VALUE ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$');

CREATE TABLE clients_names (
    client_name_id SERIAL PRIMARY KEY,
    email proper_email
);

INSERT INTO clients_names (email) VALUES ('a@b.com')

SELECT * FROM clients_names;

-- Create an Enumeration Type (Enum or Set of Values) domain

CREATE DOMAIN valid_color VARCHAR(10)
CHECK (VALUE IN ('red','green','blue'));

CREATE TABLE colors (
    color valid_color
);

INSERT INTO colors (color) VALUES ('green');

SELECT * FROM colors;

-- User Status
CREATE DOMAIN user_status VARCHAR(10)
CHECK (VALUE IN('enable','disable','temp'));

CREATE TABLE users_check(
	status user_status
);

INSERT INTO users_check (status) VALUES ('enable')

SELECT * FROM users_check;



-- Get all domain in a schema

SELECT typname
FROM pg_catalog.pg_type
JOIN pg_catalog.pg_namespace
ON pg_namespace.oid = pg_type.typnamespace
WHERE
typtype = 'd' and nspname = 'public';



--Drop a Domain data type
--DROP DOMAIN name

DROP DOMAIN  positive_numeric -- This will give an error as some table are depends on it. For Ex, sample in this case

-- We have to use "CASCADE" to delete all the dependent OBJECT also.
DROP DOMAIN positive_numeric CASCADE

SELECT * FROM sample



-- Composite data types
-- ##############################

-- 1. List of field names wit corresponding data types
-- 2. Used in a table as a 'column'
-- 3. Used in functions or procedures
-- 4. Can return multiple values, its a composite data type

-- CREATE TYPE name AS (fields columns_properties)

-- Example # 1 : Create a address composite data type

CREATE TYPE address AS(
	city VARCHAR(50),
	country VARCHAR(20)
);

CREATE TABLE companies(
	comp_id SERIAL PRIMARY KEY,
	address address
);

INSERT INTO companies (address) VALUES (ROW('LONDON','UK'));

SELECT * FROM companies;

--(composite_column).field

SELECT (address).country FROM companies;

SELECT (address).city FROM companies;

--(tablename.composite_column).field

SELECT (companies.address).city FROM companies;


-- Example # 2 : Create a composite 'inventory_item' data type

CREATE TYPE inventory_item AS
(
    product_name varchar(200),
    supplier_id INT,
    price NUMERIC
);


CREATE TABLE inventory(
	inventory_id SERIAL PRIMARY KEY,
	item inventory_item
);

INSERT INTO inventory (item) VALUES (ROW('PEN',10,4.99));
INSERT INTO inventory (item) VALUES (ROW('PAPER',20,10.99));

SELECT * FROM inventory;

SELECT (item).product_name FROM inventory WHERE (item).price > 3.99;

SELECT (item).product_name FROM inventory WHERE (item).price < 5.99;



-- Example # 3 : Create a currency ENUM data type with currency data

CREATE TYPE currency AS ENUM ('USD','EUR','GBP');

SELECT 'USD'::currency;

ALTER TYPE currency ADD VALUE 'CHF' AFTER 'EUR';

CREATE TABLE stocks
(
    stock_id SERIAL PRIMARY KEY,
    stock_currency currency
);

INSERT INTO stocks (stock_currency) VALUES ('CHF');

SELECT * FROM stocks;

-- DROP TYPE name

CREATE TYPE sample_type AS ENUM ('ABC','123');

DROP TYPE sample_type;



-- Alter Data types
-- #############################################

CREATE TYPE myaddress AS (
    city VARCHAR(50),
    COUNTRY varchar(20)
);

-- Rename a data type
-- ALTER TYPE name RENAME TO newname

ALTER TYPE myaddress RENAME TO my_address;

-- Change the owner
-- ALTER TYPE name OWNER TO username

ALTER TYPE my_address OWNER TO postgres;

-- Change the schema
-- ALTER TYPE name SET SCHEMA schemaname

ALTER TYPE my_address SET SCHEMA test_scm;

-- To add a new attribute
-- ALTER TYPE name ADD ATTRIBUTE attributes

ALTER TYPE test_scm.my_address ADD ATTRIBUTE street_address VARCHAR(150);



-- Alter an ENUM data type
-- ###########################

-- Create a sample ENUM data type
-- CREATE TYPE name AS ENUM (values)

CREATE TYPE mycolors AS ENUM ('green','red','blue');

-- Update a value
-- ALTER TYPE name RENAME VALUE oldvalue TO newvalue

ALTER TYPE mycolors RENAME VALUE 'red' TO 'orange';

-- List all ENUM values
SELECT enum_range(NULL::mycolors);

ALTER TYPE mycolors ADD VALUE 'red' BEFORE 'green'

ALTER TYPE mycolors ADD VALUE 'purple' AFTER 'green'



-- Update an ENUM data in a production server

CREATE TYPE status_enum AS enum ('queued','waiting','running','done');

CREATE TABLE jobs
(
    job_id SERIAL PRIMARY KEY,
    job_status status_enum
);

INSERT INTO jobs (job_status) VALUES ('running');

SELECT * from jobs;

UPDATE jobs SET job_status = 'running' WHERE job_status = 'waiting';

ALTER TYPE status_enum RENAME TO status_enum_old;

CREATE TYPE status_enum AS enum ('queued', 'running', 'done');

ALTER TABLE jobs ALTER COLUMN job_status TYPE status_enum USING job_status::text::status_enum;

DROP TYPE status_enum_old;



-- An ENUM with a DEFAULT value in a table

-- First create an ENUM data type
CREATE TYPE status AS ENUM ('pending','approved','declined');

-- Create a table and assign DEFAULT value to the column
CREATE TABLE cron_jobs (
    cron_job_id INT,
    status status DEFAULT 'pending'
);

-- Test with insert data
INSERT INTO cron_jobs (cron_job_id) VALUES (1);
INSERT INTO cron_jobs (cron_job_id) VALUES (2);
INSERT INTO cron_jobs (cron_job_id,status) VALUES (3,'approved');

SELECT * FROM cron_jobs;



-- How to create a TYPE if not exists using PL/pgSQL

DO
$$
BEGIN
  IF NOT EXISTS (
    SELECT *
    FROM pg_type typ
    INNER JOIN pg_namespace nsp
      ON nsp.oid = typ.typnamespace
    WHERE nsp.nspname = current_schema()
      AND typ.typname = 'ai'
  ) THEN

    CREATE TYPE ai AS (
      a text,
      i integer
    );

  END IF;
END;
$$
LANGUAGE plpgsql;