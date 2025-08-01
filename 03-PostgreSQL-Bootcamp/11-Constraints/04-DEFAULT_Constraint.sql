-- DEFAULT constraints
-- ##################
/*
	1. The DEFAULT constraint is used to provide a default value for a column when no value is specified during record insertion.
	2. The value assigned by the DEFAULT constraint is automatically inserted if no other value is provided for the column.
	3. It helps to ensure that a column always has a valid value, even if no value is explicitly given.
	4. The DEFAULT constraint can be applied to various data types, including strings, numbers, and dates.
	5. You can define the DEFAULT constraint during table creation or add it to an existing table.
	6. The syntax to create a DEFAULT constraint is as follows:
	
	   CREATE TABLE table_name (
	       column_name data_type DEFAULT default_value,
	       ...
	   );
	
	   OR to add to an existing table:
	
	   ALTER TABLE table_name
	   ALTER COLUMN column_name SET DEFAULT default_value;
*/

CREATE TABLE employees(
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	is_enable VARCHAR(2) DEFAULT 'Y'
);


INSERT INTO employees(first_name, last_name) VALUES ('John','ADAM');
INSERT INTO employees(first_name, last_name, is_enable) VALUES ('John','ADAM','N');


SELECT * FROM employees;

ALTER TABLE employees
ALTER COLUMN is_enable SET DEFAULT 'N';

INSERT INTO employees(first_name, last_name) VALUES ('John','Doe');

SELECT * FROM employees;