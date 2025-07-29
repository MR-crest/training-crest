-- 5. IS Operators: Used to check for NULL values or specific conditions.
--    Examples:
--      IS NULL, IS NOT NULL, IS TRUE, IS FALSE, IS UNKNOWN
SELECT * FROM actors WHERE date_of_birth IS NULL ORDER BY date_of_birth;

SELECT * FROM actors WHERE date_of_birth IS NULL OR first_name IS NULL;

SELECT * FROM movies_revenues WHERE revenues_domestic IS NULL ORDER BY revenues_domestic;

SELECT * FROM movies_revenues WHERE revenues_domestic IS NULL OR revenues_international IS NULL;


-- LIMIT
SELECT * FROM movies ORDER BY movie_length DESC LIMIT 5;

SELECT * FROM directors WHERE nationality = 'American' ORDER BY date_of_birth ASC LIMIT 5;

SELECT * FROM actors WHERE gender = 'F' AND date_of_birth ORDER BY date_of_birth DESC LIMIT 10;

SELECT * FROM movies_revenues ORDER BY revenues_domestic DESC NULLS LAST LIMIT 10;

SELECT * FROM movies_revenues ORDER BY revenues_domestic NULLS LAST LIMIT 10;

--OFFSET

SELECT * FROM movies ORDER BY movie_id LIMIT 5 OFFSET 4;

SELECT * FROM movies_revenues ORDER BY revenues_domestic DESC NULLS LAST LIMIT 5 OFFSET 5;

--FETCH

SELECT * FROM movies FETCH FIRST 5 ROW ONLY;

SELECT * FROM movies ORDER BY movie_length DESC FETCH FIRST 5 ROW ONLY;

SELECT * FROM directors ORDER BY date_of_birth FETCH FIRST 5 ROW ONLY;

SELECT * FROM movies ORDER BY movie_length DESC OFFSET 5 FETCH FIRST 5 ROW ONLY;
