-- NOT NULL constraints
-- ######################
/*
	1. NULL represents unknown or information missing.
	2. NULL is not the same as an empty string or the number zero.
	3. To check if a value is NULL or not, you use the IS NULL boolean operator IS.
	4. You create NOT NULL constraint on a table column as follows:

   	CREATE TABLE table_name (
       	column_name data_type NOT NULL,
       	...
   	);
*/

CREATE TABLE table_nn(
	id SERIAL PRIMARY KEY,
	tag TEXT NOT NULL
);

INSERT INTO table_nn (tag) VALUES ('ADAM');

INSERT INTO table_nn (tag) VALUES (NULL); -- This will raise an ERROR.

INSERT INTO table_nn (tag) VALUES ('');

SELECT * FROM table_nn;


-- Adding NOT NULL constraint to an existing table

CREATE TABLE table_nn2(
	id SERIAL PRIMARY KEY,
	tag2 TEXT
);

ALTER TABLE table_nn2
ALTER COLUMN tag2 SET NOT NULL;

INSERT INTO table_nn2 (tag2) VALUES ('ADAM');

INSERT INTO table_nn2 (tag2) VALUES (NULL); -- This will raise an ERROR.

INSERT INTO table_nn2 (tag2) VALUES ('');

SELECT * FROM table_nn2;