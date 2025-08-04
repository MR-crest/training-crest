-- UPPER, LOWER and INITCAP
-- ##########################

-- To convert a string into upper case, you use PostgreSQL UPPER function.
-- UPPER(string)

-- To convert a string into lower case, you use PostgreSQL LOWER function.
-- lower(string)

-- The INITCAP function converts a string expression into proper case or title case,
-- which the first letter of each word is in uppercase and the remaining characters in lowercase.

SELECT UPPER('amazing postgresql');

SELECT 
    UPPER(first_name) as first_name,
    UPPER(last_name) as last_name
FROM directors;

SELECT LOWER('Amazing Postgresql');

-- Initcap
SELECT INITCAP('the world is changing with a lightning speed');

SELECT 
    INITCAP(
        CONCAT(first_name, ' ', last_name)
    ) AS full_name
FROM directors
ORDER BY first_name;


-- LEFT and RIGHT functions
-- ##########################

-- PostgreSQL LEFT() function returns the first n characters in the string
LEFT(string, n);

SELECT LEFT('ABCD', 1);

-- n is -2, therefore, the LEFT() function returns all characters except the last 2 characters:
SELECT LEFT('ABC', -2);

-- Get initial for all directors' names
SELECT LEFT(first_name, 1) AS initial
FROM directors;
ORDER BY 1;

SELECT 
    LEFT(first_name, 1) AS initial, 
    COUNT(*) AS total_initials
FROM directors
GROUP BY 1
ORDER BY 1;

-- Get first 6 characters from all movies
SELECT
    movie_name,
    LEFT(movie_name, 6)
FROM movies;

-- PostgreSQL RIGHT() function returns the last n characters in the string.
RIGHT(string, n);

SELECT RIGHT('ABCD', 3);

-- RIGHT() function returns all characters except for the first character.
SELECT RIGHT('ABCD', -2);

-- Find all directors where their last name ends with 'on'
SELECT last_name, RIGHT(last_name, 2)
FROM directors
WHERE RIGHT(last_name, 2) = 'on';


-- REVERSE function
-- ##################
-- PostgreSQL reverse() function is used to arrange a string in reverse order.

REVERSE(string);

SELECT REVERSE('Amazing Postgresql');

SELECT REVERSE('LQSergtsoP gnizamA');



-- SPLIT_PART function
-- ##################
-- PostgreSQL SPLIT_PART() function splits a string on a specified delimiter and returns the nth substring.

SPLIT_PART(string, delimiter, position);

SELECT SPLIT_PART('1,2,3', ',', 2);

SELECT SPLIT_PART('ONE,TWO,THREE', ',', 2);

SELECT SPLIT_PART('A|B|C|D', '|', 3);


-- Get the release year of all the movies

SELECT 
    movie_name,
    release_date,
    SPLIT_PART(release_date, '-', 1) as release_year
FROM movies;

SELECT * FROM movies;



-- TRIM, BTRIM, LTRIM and RTRIM functions
-- ##############################

/* 
TRIM removes the longest string that contains a specific character from a string.
LTRIM removes all characters, spaces by default, from the beginning of a string.
RTRIM removes all characters, spaces by default, from the end of a string.
BRIM is the combination of the LTRIM() and RTRIM() functions.
*/

-- The TRIM() function removes the longest string that contains a specific character from a string.

TRIM([LEADING | TRAILING | BOTH] [characters] FROM string)

TRIM(LEADING FROM string)

TRIM (TRAILING FROM string)

TRIM (BOTH FROM string);

LTRIM(string, [character]);
RTRIM (string, [character]);
BTRIM (string, [character]);


SELECT 
    TRIM(LEADING FROM ' Amazing PostgreSQL'),
    TRIM(TRAILING FROM 'Amazing PostgreSQL '),
    TRIM(' Amazing PostgreSQL ');

-- removing say leading zero (0) from a number

SELECT 
    TRIM(LEADING '0' FROM CAST(000123456 AS TEXT));

SELECT LTRIM('yummy', 'y');

SELECT RTRIM('yummy', 'y');

SELECT BTRIM('yummy', 'y');

SELECT LTRIM(' Amazing PostgreSQL');

SELECT RTRIM('Amazing PostgreSQL ');

SELECT BTRIM(' Amazing PostgreSQL ');


-- LPAD and RPAD functions
-- ##########################
/*
LPAD function pads a string on the left to a specified length with a sequence of characters.
RPAD function pads a string on the right to a specified length with a sequence of characters.
*/

LPAD(string, length[, fill])
RPAD(string, length[, fill])

-- The fill argument is optional. If you omit the fill argument, its default value is a space.

SELECT LPAD('Database', 15, '*');
SELECT RPAD('Database', 15, '*');

SELECT LPAD('1111', 6, 'A');


SELECT 
    mv.movie_name,
    r.revenues_domestic,
    LPAD('*', CAST(TRUNC(r.revenues_domestic / 10) AS INT), '*') chart
FROM movies mv
INNER JOIN movies_revenues r ON r.movie_id = mv.movie_id
ORDER BY 3 DESC
NULLS LAST;
