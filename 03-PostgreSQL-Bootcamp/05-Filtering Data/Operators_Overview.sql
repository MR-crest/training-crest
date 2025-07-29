-- SQL Operators in PostgreSQL
-- Operators in SQL are symbols or keywords used to perform operations on data.
-- They can be categorized into the following types:

-- 1. Arithmetic Operators: Used to perform mathematical operations.
--    Examples: 
--      + (addition), - (subtraction), * (multiplication), / (division), % (modulo)

-- 2. Comparison Operators: Used to compare two values.
--    Examples:
--      = (equal to), <> or != (not equal to), < (less than), > (greater than),
--      <= (less than or equal to), >= (greater than or equal to)
SELECT * FROM movies WHERE movie_length > 100 ORDER BY movie_length;
SELECT * FROM movies WHERE movie_length < 100 ORDER BY movie_length;

SELECT * FROM movies WHERE movie_length >= 100 ORDER BY movie_length;
SELECT * FROM movies WHERE movie_length <= 100 ORDER BY movie_length;

SELECT * FROM movies WHERE release_date >= '2000-01-01' ORDER BY release_date;

SELECT * FROM movies WHERE movie_lang <> 'English' ORDER BY movie_lang; 


-- 3. Logical Operators: Used to combine multiple conditions in a WHERE clause.
--    Examples:
--      AND, OR, NOT

SELECT * FROM movies WHERE movie_lang = 'English' AND age_certificate = '18';

SELECT * FROM movies WHERE movie_lang = 'Japanese' AND age_certificate = '18';

SELECT * FROM movies WHERE movie_lang = 'English' OR movie_lang = 'Chinese' ORDER BY movie_lang ASC;

SELECT * FROM movies WHERE movie_lang = 'English' OR director_id = 10;

SELECT * FROM movies WHERE NOT movie_lang = 'English';

SELECT * FROM movies WHERE movie_lang = 'English' OR movie_lang = 'Chinese' AND age_certificate = '12' ORDER BY movie_lang;

SELECT * FROM movies WHERE (movie_lang = 'English' OR movie_lang = 'Chinese') AND age_certificate = '12' ORDER BY movie_lang;

-- 4. String Operators: Used to manipulate string data.
--    Examples:
--      || (concatenation), LIKE (pattern matching), SIMILAR TO (regular expression matching)
-- Concatenation
SELECT 'Hello' || ' ' || 'World';

SELECT CONCAT(first_name, ' ', last_name) AS "Actor Name" FROM actors ORDER BY first_name;

SELECT CONCAT_WS(', ', first_name, last_name, date_of_birth) FROM actors ORDER BY first_name;


--IN & NOT IN
SELECT * FROM actors WHERE movie_lang IN ('English', 'Chinese', 'Japanese') ORDER BY movie_lang;

SELECT * FROM movies WHERE age_certificate IN ('12', 'PG') ORDER BY age_certificate ASC;

SELECT * FROM movies WHERE director_id NOT IN (13,10) ORDER BY director_id;

--BETWEEN & NOT BETWEEN
SELECT * FROM actors WHERE date_of_birth BETWEEN '1991-01-01' AND '1995-12-31' ORDER BY date_of_birth;

SELECT * FROM movies WHERE release_date BETWEEN '1998-01-01' AND '2002-12-31' ORDER BY release_date;

SELECT * FROM movies WHERE movie_length NOT BETWEEN 100 AND 200 ORDER BY movie_length;

--LIKE & ILIKE
SELECT 'hello' LIKE 'hello';

SELECT 'hello' LIKE '%';

SELECT 'hello' LIKE '%e%';

SELECT 'hello' LIKE 'hell%';

--single character search using 
SELECT 'hello' LIKE '_ello';

SELECT 'hello' LIKE '_ll_';

--Using % and _ together
SELECT 'hello' LIKE '%ll_';
