-- Numbers Data types
-- ######################

/*
  1. Numbers columns can hold various type numbers, but not NULL values.
  2. Math operations (adding, multiplying, dividing, etc.) can be performed on numbers data types.
  3. Two main types of Numbers data are:
     - Integers:          Whole numbers, both +ve and -ve
     - Fixed-point, floating point:  Two formats of fractions of whole numbers

  Integers:
  --------------
  Three main types of integers:
  
    1. smallint:
       - 2 bytes
       - Range: -32768 to +32767
  
    2. integer:
       - 4 bytes
       - Range: -2147483648 to +2147483647
  
    3. bigint:
       - 8 bytes
       - Range: -9223372036854775808 to +9223372036854775807

  Auto-increment integer data type:
  -----------------------------------
  SERIAL:
  An ANSI SQL standard for identity columns. The following are variations of the SERIAL type:
  
    - smallserial:
      - 2 bytes
      - Range: 1 to 32767
  
    - serial:
      - 4 bytes
      - Range: 1 to 2147483647
  
    - bigserial:
      - 8 bytes
      - Range: 1 to 9223372036854775807
*/

-- Table with SERIAL data type

CREATE TABLE table_serial(
	product_id SERIAL,
	product_name VARCHAR(100)
);

INSERT INTO table_serial (product_name) VALUES ('Pencil'), ('Pen'), ('Eraser');

SELECT * FROM table_serial;

-- Numbers Table
CREATE TABLE table_numbers(
	col_numeric numeric(20,5),
	col_real real,
	col_double double precision
);

INSERT INTO table_numbers (col_numeric, col_real, col_double) VALUES
(.9,.9,.9),
(3.13579,3.13579,3.13579),
(4.1357987654,4.1357987654,4.1357987654);



SELECT * FROM table_numbers;