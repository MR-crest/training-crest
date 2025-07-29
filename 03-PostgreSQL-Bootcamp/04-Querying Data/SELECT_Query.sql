-- SELECT ALL records from a table
SELECT * FROM movies;

SELECT * FROM actors;

-- SELECT Explicit columns from a table
SELECT movie_lang FROM movies;


SELECT movie_name, movie_lang FROM movies;

-- SELECT Columns with ALIAS from a table
SELECT movie_name AS "Movie Name", movie_lang AS "Language" FROM movies;

-- The AS keyword is optional
SELECT movie_name "Movie Name", movie_lang "Language" FROM movies;

-- Combine first name, last name into a single column
SELECT first_name || ' ' || last_name AS "Full Name" FROM actors;

-- Use SELECT to get output of expression without using table name
SELECT 10 + 20;
SELECT 10 * 20;