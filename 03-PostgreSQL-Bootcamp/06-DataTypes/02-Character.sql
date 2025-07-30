/*
  Three main types of CHARACTER data:
  CHARACTER (n), CHAR(n)          : Fixed-length, blank padded
  CHARACTER VARYING (n), VARCHAR(n): Variable-length with length limit
  TEXT, VARCHAR                   : Variable-length, unlimited length

  Where n is the number of characters that column holds. If no value specified then default is 1.
*/

-- CHARACTER (n), CHAR(n)
  --CHAR(10) will store a fixed length of 10 characters.
  --Example: 
    --If you insert a value with less than 10 characters, PostgreSQL will pad the rest of the column with spaces.

SELECT CAST('Adnan' AS character (10)) as "Name";
-- "Adnan     " # Output of above query

SELECT 'Adnan'::char(10) as "Name";

SELECT CAST('Adnan' AS character (10)) as "Name1", 'Adnan'::char(10) as "Name2";

SELECT 'Adnan'::char as "Name"; -- Output will be 'A' as default n in char(n) is 1.

/*
CHARACTER VARYING (n), VARCHAR(n) variable-length with length limit
	1. Useful if entries in a column can vary in length but you do'nt want PostgreSQL to pad the field with blanks.
	2. Store exactly the number of characters provided. Save space! :)
	3. No default value exist for this type.
	4. n here means maximum number of characters
*/

SELECT 'Adnan':: varchar(10);
--"Adnan"

SELECT 'THIS IS A TEST FROM THE SYSTEM':: varchar(10)
--"THIS IS A"

SELECT 'ABCD 123 $&!J**':: varchar(20)
--"ABCD 123 $&!J**"

/*
TEXT
: variable length column, any size
1. variable-length column type
2. Unlimited length (per PostgreSQL it say max approx. 1GB)
3. Not part of SQL standard, but similar types available in Microsoft SQL server and MySQL etc.
*/

SELECT 'Humanity is a virtue rooted in altruistic ethics derived from the human condition. It signifies love and compassion towards others. Unlike justice, which focuses on fairness, humanity involves a deeper level of altruism and individual care. It is one of six virtues that are consistent across all cultures.'::TEXT

-- Table for all CHARACTER types

CREATE TABLE table_character(
	col_char CHAR(10),
	col_varchar VARCHAR(10),
	col_text TEXT
);

SELECT * FROM table_character;

INSERT INTO table_character (col_char, col_varchar, col_text) VALUES
('ABC', 'ABC', 'ABC'),
('xyz', 'xyz', 'xyz');








