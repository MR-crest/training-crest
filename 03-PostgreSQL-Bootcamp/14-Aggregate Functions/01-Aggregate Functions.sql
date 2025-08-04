-- Count results using COUNT
-- ##########################

-- SELECT COUNT(*) FROM tablename
-- SELECT COUNT(columnname) FROM tablename

-- 1. Count all records
-- Count total numbers of movies

SELECT COUNT(*) FROM movies

SELECT * FROM movies;

-- 2. Count all records of a specific column

SELECT COUNT (movie_length) FROM movies;

-- 3. Using COUNT with DISTINCT
-- Count all distinct movie languages
-- WITHOUT DISTINCT clause

SELECT COUNT(movie_lang)
FROM movies;

-- WITH DISTINCT clause
-- COUNT(DISTINCT(columnname))

SELECT COUNT(DISTINCT movie_lang)
FROM movies;

-- 4. Count all distinct movie directors
SELECT COUNT(DISTINCT director_id)
FROM movies;

-- 5. Count all English movies
-- WHERE clause

SELECT COUNT(*)
FROM movies
WHERE movie_lang = 'English';



-- Sum with SUM function
-- ######################
-- SELECT SUM(columnname) FROM tablename

-- 1. Lets look at all movies revenues records
SELECT * FROM movies_revenues;


-- 2. Get total domestic revenues for all movies
SELECT SUM(revenues_domestic) FROM movies_revenues;

-- 3. Get the total domestic revenues for all movies where domestic revenue is greater than 200
SELECT SUM(revenues_domestic) 
FROM movies_revenues
WHERE revenues_domestic > 200;

-- 4. Find the total movie length of all English language movies
SELECT * FROM movies;

SELECT SUM(movie_length)
FROM movies
WHERE movie_lang = 'English';

-- 5. Can I sum all movies names?
SELECT SUM(movie_length)
FROM movies;

-- only numbers are allowed

-- 7. Using SUM with DISTINCT
-- SUM(DISTINCT expression)

-- Without DISTINCT
-- Get total domestic revenues for all movies
SELECT SUM(revenues_domestic)
FROM movies_revenues;

-- With DISTINCT
-- It will ignore duplicate values
SELECT SUM(DISTINCT revenues_domestic)
FROM movies_revenues;



-- MIN and MAX functions
-- ##########################
-- MIN - Minimum, MAX - Maximum
-- 
-- SELECT MIN(columnname) FROM tablename
-- SELECT MAX(columnname) FROM tablename


-- 1. What is the longest length movie in movies table
SELECT movie_length
FROM movies
ORDER BY movie_length DESC;

SELECT MAX(movie_length)
FROM movies;

-- 2. What is the shortest length movie in movies table
SELECT movie_length
FROM movies
ORDER BY movie_length ASC;

SELECT MIN(movie_length)
FROM movies;

-- 3. What is the longest length movie in movies table within all English based language
SELECT MAX(movie_length)
FROM movies
WHERE movie_lang = 'English';

-- 4. What is the latest release movie in English language
SELECT *
FROM movies
WHERE movie_lang = 'English'
ORDER BY release_date DESC;

SELECT MAX(release_date)
FROM movies
WHERE movie_lang = 'English';

-- 5. What was the first movie release in Chinese language
SELECT *
FROM movies
WHERE movie_lang = 'Chinese'
ORDER BY release_date ASC;

SELECT MAX(release_date)
FROM movies
WHERE movie_lang = 'Chinese';

-- 6. Can we use MIN and MAX for text data types (VARCHAR etc.)
-- First get all movies records order by movie_name
SELECT * FROM movies ORDER BY movie_name ASC;

-- Lets use MAX function on movie_name
SELECT MAX(movie_name) FROM movies;

-- Lets use MIN function on movie_name
SELECT MIN(movie_name) FROM movies;





-- Using GREATEST and LEAST functions
-- ##############################

/* 
1. The GREATEST and LEAST functions select the largest or smallest value from a list of any number of expressions.
   -- Quick example of list of numbers;
*/

SELECT GREATEST(200, 20, 30);

SELECT LEAST(20, 10, 45);

/* 
2. The expressions must all be convertible to a common data type, which will be the type of the result.
   Can we compare INT and VARCHAR in a list?
*/

SELECT LEAST('A', 'B', 'C');

SELECT GREATEST(1, 'A', 2, 3);

-- 3. Find the greatest and least revenues per each movie
SELECT 
    movie_id,
    revenues_domestic,
    revenues_international,
    GREATEST(revenues_domestic, revenues_international) AS "Greatest",
    LEAST(revenues_domestic, revenues_international) AS "Least"
FROM movies_revenues;




-- AVG Average Function
-- #############################

-- Calculate average value on a set
-- returns 1 value
-- AVG(columnname)
-- SELECT AVG(columnname) FROM tablename

-- 1. Get average movie length for all movies
-- First, lets look at all movies data and structure of movie_length

SELECT * FROM movies;

SELECT 
    movie_length
FROM movies
ORDER BY movie_length;

SELECT 
    AVG(movie_length)
FROM movies;

-- Please note AVG will return the 'numeric' type value as a result
-- 2. Get average movie length for all english based movies
SELECT 
    AVG(movie_length)
FROM movies
WHERE movie_lang = 'English';

-- 3. Get average movie length for all english based movies
-- Using AVG with DISTINCT
-- WITHOUT DISTINCT
SELECT 
    AVG(movie_length)
FROM movies
WHERE movie_lang = 'English';

SELECT 
    movie_length
FROM movies
WHERE movie_lang = 'English'
ORDER BY movie_length;

-- With DISTINCT
-- use only unique values
SELECT 
    AVG(DISTINCT movie_length)
FROM movies
WHERE movie_lang = 'English';

-- 4. Can I run an average on movie names?
SELECT 
    AVG(movie_name)
FROM movies;

-- 5. Using AVG and SUM functions together
-- Get average and sum for all english based movies
SELECT 
    AVG(movie_length),
    SUM(movie_length)
FROM movies
WHERE movie_lang = 'English';



-- Combining columns using Mathematical Operators
-- ###############################

-- Addition : +
-- Subtraction : -
-- Division. : /
-- Multiplication : *
-- Modulus/Reminder : %

-- 1. Lets practice above

SELECT 2+10 AS addition;
SELECT 10-2 as substraction;
SELECT 11/2::numeric(10,2) as divide;

SELECT 11/2;
SELECT 2.56*10.23;
SELECT 14%2;

-- 3. Can we combine table columns?
-- Get total revenues for all movies from movies_revenues table
-- Lets first all movies data

SELECT * FROM movies_revenues;

SELECT 
    movie_id,
    revenues_domestic,
    revenues_international,
    (revenues_domestic + revenues_international) AS 'total revenue'
FROM movies_revenues;

-- 4. Lets order by highest revenues movies
SELECT 
    movie_id,
    revenues_domestic,
    revenues_international,
    (revenues_domestic + revenues_international) AS "total revenue"
FROM movies_revenues
ORDER BY 4 DESC NULLS LAST;

-- 5. Lets filter out null revenue rows
SELECT 
    movie_id,
    revenues_domestic,
    revenues_international,
    (revenues_domestic + revenues_international) AS "total revenue"
FROM movies_revenues
WHERE (revenues_domestic + revenues_international) IS NOT NULL
ORDER BY 4 DESC NULLS LAST;
