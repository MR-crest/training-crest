-- CREATE 'customers' TABLE
CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(150),
	age INT
);


-- Insert data into Table
INSERT INTO customers(first_name, last_name, email, age) VALUES('John', 'Doe', 'john.doe@gmail.com', 25);

-- Insert multiple rows at once
INSERT INTO customers(first_name, last_name, email, age) VALUES
('Bob', 'Smith', 'bob.smith@gmail.com', 35),
('Alice', 'Johnson', 'alice.johnson@gmail.com', 40);

-- Insert data with quotes
INSERT INTO customers(first_name, last_name, email, age) VALUES('Bill''O Sullivan', 'Smith', 'bill.smith@gmail.com', 35); 



SELECT * FROM customers;