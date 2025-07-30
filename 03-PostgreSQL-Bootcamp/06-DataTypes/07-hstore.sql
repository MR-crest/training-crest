-- hstore data type
-- #################

/*
  1. hstore is a data type that stores data in key-value pairs.
  2. The hstore module implements the hstore data type.
  3. Both the keys and values are text strings only.
*/

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE table_hstore(
	book_id SERIAL PRIMARY KEY,
	title VARCHAR (100) NOT NULL,
	book_info hstore
);

INSERT INTO table_hstore (title, book_info) VALUES
(
'TITLE 1',
	'
		"publisher" => "ABC publisher",
		"paper_cost" => "10.00",
		"e_cost" => "5.85"
	'
)


INSERT INTO table_hstore (title, book_info) VALUES
(
  'TITLE 2',
  '
    "publisher" => "XYZ Books",
    "paper_cost" => "12.50",
    "e_cost" => "7.30",
    "author" => "John Doe"
  '
),
(
  'TITLE 3',
  '
    "publisher" => "LMN Publications",
    "paper_cost" => "15.00",
    "e_cost" => "8.90",
    "author" => "Jane Smith",
    "edition" => "2nd Edition"
  '
),
(
  'TITLE 4',
  '
    "publisher" => "PQR Publishers",
    "paper_cost" => "18.00",
    "e_cost" => "9.50",
    "author" => "Alice Johnson",
    "genre" => "Fiction"
  '
);

SELECT* FROM table_hstore;

SELECT
	book_info -> 'publisher' as "publisher",
	book_info -> 'e_cost' as "Electronic Cost"
FROM table_hstore;