--Sequences

-- 1. Create a sequence
-- CREATE SEQUENCE IF NOT EXISTS name
-- CREATE SEQUENCE name

CREATE SEQUENCE IF NOT EXISTS test_seq;

-- 2. Advance sequence and return new value
-- SELECT nextval(name)

SELECT nextval('test_seq');

-- 3. Return most current value of the sequence
-- SELECT currval(name)

SELECT currval('test_seq');

-- 4. Set a sequence
-- SELECT setval(name, value)

SELECT setval('test_seq', 100);

-- 5. Set a sequence and do not skip over
-- SELECT setval(name, value, false)

SELECT setval('test_seq', 200, false);


-- 6. Control the sequence START value
-- CREATE SEQUENCE IF NOT EXISTS name START WITH value
-- CREATE SEQUENCE name START WITH value

CREATE SEQUENCE IF NOT EXISTS test_seq2 START WITH 100;

-- 7. Use multiple sequence parameters to create a sequence
-- CREATE SEQUENCE name
-- START WITH value
-- INCREMENT value
-- MINVALUE value
-- MAXVALUE value

CREATE SEQUENCE IF NOT EXISTS test_seq3
    INCREMENT 50
    MINVALUE 400
    MAXVALUE 6000
    START WITH 500;

SELECT nextval('test_seq3');

-- 8. Specify the data type of a sequence (SMALLINT | INT | BIGINT)
-- Default is BIGINT
-- CREATE SEQUENCE IF NOT EXISTS name AS data_type
-- CREATE SEQUENCE name AS data_type

CREATE SEQUENCE IF NOT EXISTS test_seq_smallint AS SMALLINT;
CREATE SEQUENCE IF NOT EXISTS test_seq_smallint AS INT;
CREATE SEQUENCE IF NOT EXISTS test_seq4 AS BIGINT;

SELECT nextval('test_seq_smallint');

-- 9. Create a Descending sequence and CYCLE | NO CYCLE
-- CREATE SEQUENCE seq_des
-- INCREMENT -1
-- MINVALUE 1
-- MAXVALUE 3
-- START 3
-- CYCLE;

CREATE SEQUENCE seq_asc;
SELECT nextval('seq_asc');

CREATE SEQUENCE seq_des
    INCREMENT -1
    MINVALUE 1
    MAXVALUE 3
    START 3
    CYCLE;

SELECT nextval('seq_des');


-- 10. Alter a sequence
-- ALTER SEQUENCE name RESTART WITH value
-- ALTER SEQUENCE name RENAME TO new_name

SELECT nextval('test_seq');

ALTER SEQUENCE test_seq RESTART WITH 100;

ALTER SEQUENCE test_seq RENAME TO my_sequence4;


-- 11. Delete/Drop a sequence
-- DROP SEQUENCE name

DROP SEQUENCE test_seq2;


-- 13. Attaching sequence to a table
-- To attach a sequence to an existing table
-- Step 1 > Create a sequence and attach it to a table

CREATE TABLE users(
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(50)
);


INSERT INTO users (user_name) VALUES ('ADNAN4');

SELECT * FROM users;

ALTER SEQUENCE users_user_id_seq RESTART WITH 100;



CREATE TABLE users2
(
    user2_id INT PRIMARY KEY,
    user2_name VARCHAR(50)
);

-- CREATE SEQUENCE name
-- START WITH value OWNED BY tablename.columnname

CREATE SEQUENCE users2_user2_id_seq
    START WITH 100 OWNED BY users2.user2_id;


-- Step 2 > Alter table column and set sequence
-- ALTER TABLE tablename
-- ALTER COLUMN columnname SET DEFAULT nextval(sequencename)

ALTER TABLE users2
ALTER COLUMN user2_id SET DEFAULT nextval('users2_user2_id_seq');

INSERT INTO users2 (user2_name) VALUES ('ADAM');

SELECT * from users2;


--12. Listing all sequence
SELECT relname sequence_name
FROM pg_class
WHERE
relkind = 'S';

-- 15. Share sequence among tables

CREATE SEQUENCE common_fruits_seq START WITH 100;

CREATE TABLE apples
(
    fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
    fruit_name VARCHAR(50)
);


-- 15. Share sequence among tables

CREATE SEQUENCE common_fruits_seq START WITH 100;

CREATE TABLE apples
(
    fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
    fruit_name VARCHAR(50)
);

CREATE TABLE mangoes
(
    fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
    fruit_name VARCHAR(50)
);

INSERT INTO apples (fruit_name) VALUES ('big apple');

SELECT * from apples;

INSERT INTO mangoes (fruit_name) VALUES ('big mango');

SELECT * from mangoes;


-- How to create an Alpha-numeric sequence
-- By default sequences are only consist of numbers.
-- First, lets see how normally sequence are worked

-- Create a table with SERIAL data type for sequence
CREATE TABLE contacts (
    contact_id SERIAL PRIMARY KEY,
    contact_name VARCHAR(150)
);

-- Insert some data, and see the sequence
INSERT INTO contacts (contact_name) VALUES ('ADNAN');


SELECT * FROM contacts;

-- Now, Drop the Table
DROP TABLE contacts;

-- Create a sequence
CREATE SEQUENCE table_seq;

-- Create a table and use DEFAULT to add an alphanumeric sequence
-- ID1, ID2, ID3

CREATE TABLE contacts
(
    contact_id TEXT NOT NULL DEFAULT ('ID' || nextval('table_seq')),
    contact_name VARCHAR(150)
);

-- Alter Sequence and attached to table column
ALTER SEQUENCE table_seq OWNED BY contacts.contact_id;

-- Insert some data
INSERT INTO contacts (contact_name) VALUES ('ADNAN');

SELECT * FROM contacts;
