-- UUID (Universally Unique Identifier)
-- ###################################

/*
  UUID is a data type used to store universally unique identifiers.
  It provides a 128-bit value that is highly likely to be unique across different systems and time periods.
  
  UUIDs are commonly used for unique keys in distributed systems, ensuring that identifiers are globally unique without the need for centralized authority.
  
  A typical UUID is represented as a 32-character hexadecimal string, formatted like: 
  '550e8400-e29b-41d4-a716-446655440000'.
  
  PostgreSQL supports UUIDs natively, and you can generate them using the `uuid-ossp` extension or with built-in functions like `gen_random_uuid()`.
*/

--1. Enable third part UUID extensions first e.g. uuid-ossp
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Generate Sample UUID
SELECT uuid_generate_v1();

SELECT uuid_generate_v4();

--Sample Table
CREATE TABLE table_uuid(
	product_id UUID DEFAULT uuid_generate_v1(),
	product_name VARCHAR (100) not null
);

INSERT INTO table_uuid (product_name) VALUES ('AB111');

--Change UUID default value
ALTER table table_uuid ALTER COLUMN product_id SET DEFAULT uuid_generate_v4();

INSERT INTO table_uuid (product_name) VALUES ('BC222');

SELECT * FROM table_uuid;