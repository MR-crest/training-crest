-- The ORDER BY clause sorts the result set by one or more columns in ascending (ASC)
-- or descending (DESC) order. By default, sorting is ascending. It can be used with
-- multiple columns, each having its own sorting order. ORDER BY is commonly combined
-- with LIMIT to control the number of sorted rows returned.

-- ORDER BY with single column
SELECT * FROM movies ORDER BY movie_lang ASC;

-- ORDER BY with multiple columns
SELECT * FROM movies ORDER BY movie_lang, movie_name ASC ;

-- ORDER BY with DESC
SELECT * FROM movies ORDER BY movie_lang DESC;

-- ORDER BY with Alias
SELECT movie_name AS "Movie Name", movie_lang AS "Language" FROM movies ORDER BY "Language" ASC;

-- Lets calculate the length of the actor name with LENGTH Function
SELECT first_name, LENGTH(first_name) FROM actors;

--Sort rows by the length of the actor name
SELECT first_name, LENGTH(first_name) FROM actors ORDER BY LENGTH(first_name) DESC;

--use Column number instead of column name for sorting
SELECT first_name, last_name, date_of_birth FROM actors ORDER BY 3 DESC;

-- Use ORDER BY with NULL Values
CREATE TABLE demo_sorting(
    num INT
);

INSERT INTO demo_sorting VALUES (1), (2), (3), (NULL), (4), (5), (NULL);

SELECT * FROM demo_sorting ORDER BY num ASC;

SELECT * FROM demo_sorting ORDER BY num DESC;

SELECT * FROM demo_sorting ORDER BY num ASC NULLS FIRST;

SELECT * FROM demo_sorting ORDER BY num DESC NULLS LAST;

DROP TABLE demo_sorting;

-- Use DISINCT Keyword

SELECT * FROM movies;

SELECT movie_lang FROM movies;

SELECT DISTINCT movie_lang FROM movies ORDER BY movie_lang ASC;

SELECT DISTINCT director_id FROM movies ORDER BY director_id ASC;

-- Multiple Distinct Columns
SELECT DISTINCT director_id, movie_lang FROM movies ORDER BY director_id, movie_lang ASC;

-- SELECT ALL unique records from a table
SELECT DISTINCT * FROM movies;