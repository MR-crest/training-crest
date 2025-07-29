-- Update data in a table
UPDATE customers SET email = 'john.doe@company.com' WHERE customer_id = 1;

-- Update multiple columns
UPDATE customers SET first_name = 'Alex', last_name = 'Wright' WHERE customer_id = 1;

-- Use RETURNING clause to get info on return rows
UPDATE customers SET age = 30 WHERE customer_id = 1 RETURNING *;

--After the Update, let's return a single column value.
UPDATE customers SET age = 35 WHERE customer_id = 1 RETURNING customer_id;

-- Update All records at once
UPDATE customers SET is_enable = 'Y' RETURNING *;
 

SELECT * FROM customers;