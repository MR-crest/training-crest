-- UNIQUE constraints
-- ################
/*
	1. The UNIQUE constraint ensures that all values in a column are distinct.
	2. It prevents duplicate values from being inserted into the column.
	3. A column with a UNIQUE constraint can accept NULL values, but each NULL value must be unique in the column.
	4. You can add a UNIQUE constraint to a column during table creation or alter an existing table to add it.
	5. A table can have multiple UNIQUE constraints on different columns.
	6. The syntax to add a UNIQUE constraint is as follows:
	
	   CREATE TABLE table_name (
	       column_name data_type UNIQUE,
	       ...
	   );
	
	   OR to add to an existing table:
	   
	   ALTER TABLE table_name
	   ADD CONSTRAINT constraint_name UNIQUE (column_name);
*/


CREATE TABLE table_emails(
	id SERIAL PRIMARY KEY,
	email TEXT UNIQUE
);

INSERT INTO table_emails (email) VALUES ('A@B.com');


--CREATE UNIQUE KEY on multiple COLUMNS

CREATE TABLE table_products(
	id SERIAL PRIMARY KEY,
	product_code VARCHAR(10),
	product_name TEXT
);

ALTER TABLE table_products
ADD CONSTRAINT unique_product_cide UNIQUE (product_code, product_name);

INSERT INTO table_products (product_code, product_name) VALUES ('A','apple');

SELECT * FROM table_products;



