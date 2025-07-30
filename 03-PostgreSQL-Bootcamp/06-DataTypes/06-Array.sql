-- Array Data Type
-- #################

/*
  The Array data type allows you to store multiple values of the same type in a single column.
  Arrays are useful when you need to represent collections of data, such as a list of numbers, strings, or even other arrays.
  
  PostgreSQL supports arrays of any built-in or user-defined data type. An array can be one-dimensional or multi-dimensional.
  
  Example:
    - Integer array: integer[]
    - String array: text[]
  
  You can also specify the size of the array, such as integer[5] for an array of 5 integers.
  
  Common operations on arrays include:
    - Accessing elements using array indices (e.g., `array[1]` for the first element)
    - Array functions such as `array_length()`, `array_append()`, and `array_prepend()`
  
  To insert or query arrays:
    - Insert: `INSERT INTO table_name (column_name) VALUES (ARRAY[1, 2, 3]);`
    - Query: `SELECT column_name[1] FROM table_name;` (to get the first element)
*/

CREATE TABLE table_array(
	id SERIAL,
	name VARCHAR(100),
	phones text []
);

INSERT INTO table_array (name, phones)
VALUES ('Adam', ARRAY[ '(801)-123-4567','(819)-555-2222']);

INSERT INTO table_array (name, phones)
VALUES ('Linda', ARRAY['(201)-123-4567','(214)-222-3333']);


SELECT * FROM table_array;


SELECT name, phones[1] FROM table_array;

SELECT name FROM table_array WHERE phones[2] = '(214)-222-3333';

