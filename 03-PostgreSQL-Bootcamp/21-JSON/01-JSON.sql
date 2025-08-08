/*
JSON Overview
-------------
- JSON = JavaScript Object Notation: lightweight, human-readable format for storing/exchanging data.
- Popularized by Douglas Crockford (2001, State Software); adopted by Yahoo (2005) & Google (2006).
- Simpler alternative to XML for serializing/transferring data between web servers & applications.
- Widely supported by web APIs (e.g., Twitter API).

Syntax Basics
-------------
- Name/value pairs: "firstName": "Adnan"
- Commas separate pairs: "firstName":"Adnan", "Country":"USA"
- Objects in { }: {"firstName":"Adnan", "Country":"USA"}
- Arrays in [ ]:
  "contacts": [
    {"first_name":"Adnan", "last_name":"Waheed"},
    {"first_name":"Adam", "last_name":"Limbert"}
  ]

PostgreSQL & JSON
-----------------
- Native JSON support since PostgreSQL 9.2; many JSON functions/operators.

Two storage types:
JSON vs JSONB
-------------
JSON:
- Stores text as-is (with whitespace)
- No full-text search indexing
- Limited functions/operators
- Faster raw input storage

JSONB:
- Stores binary format (trims whitespace)
- Supports full-text search indexing
- Full set of JSON functions/operators
- Faster queries/operations
*/


-- Exploring JSON objects
-- #######################

-- 1. How will you represent a JSON object in PostgreSQL
SELECT '{"title":"The lord of the rings"}'::TEXT;

-- 2. Do you have to cast data type to make it JSON data type?
SELECT '{
    "title":"The lord of the rings"
}'::json;

-- 3. What if we do not want white spaces?
SELECT '{
    "title":"The lord of the rings",
    "author":"J.R.R"
}'::jsonb;



-- Create our first table with JSONB data type
-- ############################################

-- 1. Create a table called "books"
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    book_info JSONB
);

-- 2. Insert some JSON data
-- Single record
INSERT INTO books (book_info) VALUES
('{
    "title":"Book title1",
    "author":"author1"
}');

SELECT * FROM books;

-- Multiple records
INSERT INTO books (book_info) VALUES
('{
    "title":"Book title2",
    "author":"author2"
}'),
('{
    "title":"Book title3",
    "author":"author3"
}'),
('{
    "title":"Book title4",
    "author":"author4"
}');

-- 3. Select all JSON records
SELECT * FROM books;

-- 3.1 Use selectors (->, ->>)
-- ->  returns JSON object field as JSON (with quotes)
SELECT book_info FROM books;
SELECT book_info->'title' FROM books;

-- ->> returns JSON object field as TEXT
SELECT
    book_info->>'title' AS title,
    book_info->>'author' AS author
FROM books;

-- 4. Select and filter records
SELECT
    book_info->>'title' AS title,
    book_info->>'author' AS author
FROM books
WHERE book_info->>'author' = 'author1';

