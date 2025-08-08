/*
================================================================================
JSON & JSONB in PostgreSQL — Complete Tutorial
================================================================================

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
------------------
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
================================================================================
*/


-- ============================================================================
-- 1. Representing JSON in PostgreSQL
-- ============================================================================

-- Raw JSON as text
SELECT '{"title":"The Lord of the Rings"}'::TEXT;

-- Casting to JSON (preserves whitespace)
SELECT '{
    "title": "The Lord of the Rings"
}'::JSON;

-- Casting to JSONB (removes extra whitespace)
SELECT '{
    "title": "The Lord of the Rings",
    "author": "J.R.R. Tolkien"
}'::JSONB;


-- ============================================================================
-- 2. Creating a Table with JSONB
-- ============================================================================

DROP TABLE IF EXISTS books;

CREATE TABLE books (
    book_id  SERIAL PRIMARY KEY,
    book_info JSONB
);

-- ============================================================================
-- 3. Inserting JSONB Data
-- ============================================================================

-- Single record
INSERT INTO books (book_info)
VALUES ('{
    "title": "Book Title 1",
    "author": "Author 1"
}');

-- Multiple records
INSERT INTO books (book_info)
VALUES
('{"title": "Book Title 2", "author": "Author 2"}'),
('{"title": "Book Title 3", "author": "Author 3"}'),
('{"title": "Book Title 4", "author": "Author 4"}'),
('{"title": "Book Title 5", "author": "Author 5"}');

SELECT * FROM books;


-- ============================================================================
-- 4. Selecting JSON Data
-- ============================================================================

-- Entire JSON
SELECT book_info FROM books;

-- ->  returns JSON field as JSON
SELECT book_info->'title' FROM books;

-- ->> returns JSON field as TEXT
SELECT
    book_info->>'title'  AS title,
    book_info->>'author' AS author
FROM books;

-- Filtering based on JSON value
SELECT
    book_info->>'title'  AS title,
    book_info->>'author' AS author
FROM books
WHERE book_info->>'author' = 'Author 1';


-- ============================================================================
-- 5. Updating JSONB Data
-- ============================================================================

-- Update a value
UPDATE books
SET book_info = book_info || '{"author": "Meet"}'
WHERE book_info->>'author' = 'Author 5';

UPDATE books
SET book_info = book_info || '{"title": "Crest"}'
WHERE book_info->>'title' = 'Book Title 5';

-- Add a new field
UPDATE books
SET book_info = book_info || '{"Best Seller": true}'
WHERE book_info->>'title' = 'Book Title 1';

UPDATE books
SET book_info = book_info || '{"Best Seller": true}'
WHERE book_info->>'author' = 'Author 2';

-- Add multiple key-value pairs
UPDATE books
SET book_info = book_info || '{"Pages": 100, "Description": "Hello!!"}'
WHERE book_info->>'author' = 'Author 3';

-- Remove a field (- operator)
UPDATE books
SET book_info = book_info - 'Best Seller'
WHERE book_info->>'author' = 'Author 4';

UPDATE books
SET book_info = book_info - 'Best Seller'
WHERE book_info->>'author' = 'Author 2';

-- Add nested array
UPDATE books
SET book_info = book_info || '{
    "Availability Location": ["New York", "Oklahoma", "San Jose", "Baltimore"]
}'
WHERE book_info->>'author' = 'Author 2';

-- Remove element from array (#- operator)
UPDATE books
SET book_info = book_info #- '{"Availability Location", 1}'
WHERE book_info->>'author' = 'Author 2';


-- ============================================================================
-- 6. JSON Functions & Conversions
-- ============================================================================

-- Convert table row to JSON
SELECT row_to_json(d) FROM directors d;

-- Convert selected columns to JSON
SELECT row_to_json(t)
FROM (
    SELECT first_name, last_name
    FROM directors
) AS t;

-- Aggregating related records into JSON
SELECT
    *,
    (
        SELECT json_agg(x) AS all_movies
        FROM (
            SELECT movie_name
            FROM movies
            WHERE director_id = directors.director_id
        ) AS x
    )
FROM directors;

-- Build JSON arrays & objects
SELECT json_build_array(1, 2, 3, 4);
SELECT json_build_array(1, 2, 3, 4, 'Hi');
SELECT json_build_object(1, 2, 3, 4, 5, 'Hi');

-- Create JSON from keys & values
SELECT json_object('{name,email}', '{Drake,a@b}');


-- ============================================================================
-- 7. Storing Complex JSONB Documents
-- ============================================================================

CREATE TABLE directors_docs (
    id   SERIAL PRIMARY KEY,
    body JSONB
);

-- Insert directors with their movies
INSERT INTO directors_docs (body)
SELECT row_to_json(a)::JSONB
FROM (
    SELECT
        first_name,
        last_name,
        date_of_birth,
        nationality,
        (
            SELECT json_agg(x)
            FROM (
                SELECT movie_name
                FROM movies
                WHERE director_id = directors.director_id
            ) AS x
        ) AS all_movies
    FROM directors
) AS a;

-- Handling empty arrays gracefully
INSERT INTO directors_docs (body)
SELECT row_to_json(a)::JSONB
FROM (
    SELECT
        director_id,
        first_name,
        last_name,
        date_of_birth,
        nationality,
        (
            SELECT CASE WHEN COUNT(x) = 0 THEN '[]' ELSE json_agg(x) END
            FROM (
                SELECT movie_name
                FROM movies
                WHERE director_id = directors.director_id
            ) AS x
        ) AS all_movies
    FROM directors
) AS a;


-- ============================================================================
-- 8. Working with JSONB Data
-- ============================================================================

-- Length of JSON array
SELECT *,
       jsonb_array_length(body->'all_movies') AS total_movies
FROM directors_docs;

-- Get all keys from JSON object
SELECT jsonb_object_keys(body) FROM directors_docs;

-- Iterate over key-value pairs
SELECT j.key, j.value
FROM directors_docs, jsonb_each(body) AS j;

-- Convert JSON object to record
SELECT j.*
FROM directors_docs,
     jsonb_to_record(body) AS j(
         director_id INT,
         first_name  VARCHAR(255),
         nationality VARCHAR(100)
     );


/*
================================================================================
Notes:
- In JSON, `null` is a valid literal value and is different from SQL NULL.
- Always choose JSONB unless you specifically need to preserve formatting/whitespace.
================================================================================
*/
