-- LENGTH function
-- ##################
-- length returns the number of characters or the number of bytes of a string

LENGTH(string);

SELECT LENGTH('Amazing PostgreSQL');

SELECT LENGTH(CAST(100122 AS TEXT));

SELECT LENGTH('What is the length of this string');

SELECT char_length('');

SELECT char_length(' ');

SELECT char_length(NULL);

-- Get the total length of all directors' full name

SELECT 
    first_name || ' ' || last_name AS full_name,
    LENGTH(first_name || ' ' || last_name) AS full_name_length
FROM directors
ORDER BY 2 DESC;

-- POSITION function
-- ######################

/* 
1. PostgreSQL POSITION() function returns the location of a substring in a string.
2. POSITION(substring in string)
3. returns an integer that represents the location of the substring within the string.
4. returns the first instance of the substring in the string.
5. searches for the substring case-insensitively.
*/

SELECT POSITION('Amazing' IN 'Amazing PostgreSQL');

SELECT POSITION('is' IN 'This is a computer');

SELECT POSITION('A' IN 'KlickAnalytics.');



-- STRPOS function
-- ######################
-- function is used to find the position, from where the substring is being matched within the string.

strpos(<string>, <substring>);

SELECT strpos('World Bank', 'Bank');

-- Lets display the first_name, last_name and the position of a specific substring 'on',
-- which must exist within the column last_name from directors

SELECT 
    first_name,
    last_name
FROM directors
WHERE strpos(last_name, 'on') > 0;

/* 
Difference between STRPOS and POSITION functions

1. Those functions do the exactly same thing and differ only in syntax. Documentation for strpos() says:
   Location of specified substring (same as position(substring in string), but note the reversed argument order).

2. Reason why they both exist and differ only in syntax is that POSITION(str1 IN str2) is defined by ANSI SQL standard.

If PostgreSQL had only strpos() it wouldn't be able to run ANSI SQL queries and scripts.
*/



-- SUBSTRING Function
-- ######################

/* 
1. Function allows you to extract a substring from a string.

2. substring( string [from start_position] [for length] )
   SUBSTRING ( string , start_position , length )

3. The first position in string always starts with 1.
*/

SELECT substring('What a wonderful world' from 2 for 8);

SELECT substring('What a wonderful world' from 8 for 10);

SELECT substring('What a wonderful world' for 7);

-- Get initials from directors table

SELECT 
    first_name,
    last_name,
    SUBSTRING(first_name, 1, 1) AS initial
FROM directors
ORDER BY last_name;



-- REPEAT function
-- ######################
--repeats a string a specified number of times.

SELECT repeat('AB', 10);

SELECT repeat('', 10);



-- REPLACE Function
-- ##########################
-- replace function replaces all occurrences of a specified string.

replace(string, from_substring, to_substring);

SELECT REPLACE('ABC XYZ', 'X', '1');

SELECT replace('What a wonderful world', 'a wonderful', 'an amazing');

SELECT replace('I like cats', 'cats', 'dogs');
