-- JSON Data Type
-- ###############

/*
  The JSON data type in PostgreSQL allows you to store JSON (JavaScript Object Notation) formatted data.
  
  JSON is a lightweight, text-based format used to represent structured data based on key-value pairs and arrays.
  
  Key points about the JSON data type:
  
  1. JSON is a string that stores the data as text, but can be queried using PostgreSQL's JSON functions.
  2. JSON values can be objects (key-value pairs) or arrays.
  3. JSON data is flexible, allowing for dynamic structures and hierarchical data storage.
  4. JSON is commonly used for storing unstructured or semi-structured data, especially in web applications or APIs.

  PostgreSQL provides two JSON-related data types:
  - `JSON`: Stores the data as plain text, and it doesn't validate the structure.
  - `JSONB`: Stores the data in a binary format, and it supports indexing for faster queries. It also validates the JSON structure.
  
  Example:
    - JSON: '{"name": "John", "age": 30, "city": "New York"}'
    - JSONB: '{"name": "Jane", "age": 25, "city": "Los Angeles"}'
*/


CREATE TABLE table_json(
	id SERIAL PRIMARY KEY,
	docs JSON
);

INSERT INTO table_json (docs) VALUES
('[1,2,3,4,5,6]'),
('[2,3,4,5,6,7]'),
('{"key":"value"}');


SELECT * FROM table_json;

ALTER TABLE table_json
    ALTER COLUMN docs TYPE JSONB;

SELECT * FROM table_json
WHERE docs @> '2';