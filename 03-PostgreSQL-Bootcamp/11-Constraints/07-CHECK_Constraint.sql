-- CHECK Constraint
-- ##################
/*
	1. The CHECK constraint is used to limit the values that can be inserted into a column.
	2. It ensures that data entered into the table satisfies specific conditions, such as valid ranges, patterns, or combinations.
	3. The condition inside the CHECK constraint must evaluate to true for the data to be accepted; otherwise, an error will occur.
	4. The CHECK constraint can be defined on a single column or on multiple columns of the table.
	5. It is most commonly used for data validation, such as ensuring numeric ranges or validating values against logical conditions.
	6. Syntax:
	   - For a single column:
	     CREATE TABLE table_name (
	         column_name data_type CHECK (condition)
	     );
	     
	   - For multiple columns:
	     CREATE TABLE table_name (
	         column1 data_type,
	         column2 data_type,
	         CHECK (condition_on_columns)
	     );
	7. The CHECK constraint can also be added to an existing table:
	   ALTER TABLE table_name
	   ADD CONSTRAINT constraint_name CHECK (condition);
*/



CREATE TABLE staff (
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	birth_date DATE CHECK (birth_date > '1900-01-01'),
	joined_date DATE CHECK (joined_date > birth_date),
	salary numeric CHECK (salary > 0)
);

INSERT INTO staff (first_name, last_name, birth_date, joined_date, salary)
VALUES ('ADAM', 'KING', '1999-01-01','2002-01-01',100);

INSERT INTO staff (first_name, last_name, birth_date, joined_date, salary)
VALUES ('John', 'Adams', '2020-01-01', '2020-01-01',100);

SELECT * FROM staff;




CREATE TABLE prices (
	price_id SERIAL PRIMARY KEY,
	product_id INT NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC not null,
	valid_from DATE not null
);


-- Add CONSTRAINT on existing table
ALTER TABLE prices
ADD CONSTRAINT price_check
CHECK (
    price > 0
    AND discount >= 0
    AND price > discount
);

INSERT INTO prices (product_id, price, discount, valid_from)
VALUES ('1', 100, 20, '2020-10-01');

SELECT * FROM prices;


--Rename constraint on new table

ALTER TABLE prices
RENAME CONSTRAINT price_check TO price_discount_check;


--Drop a constaint

ALTER TABLE prices
DROP CONSTRAINT price_discount_check;


ALTER TABLE prices
ADD CONSTRAINT price_discount_check
CHECK
(
	price > 0
	AND discount >=10
	AND price > discount
);