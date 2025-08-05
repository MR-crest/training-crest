-- DATE/TIME/TIMESTAMPS Data types  
-- #########################

/*  
1. Date – Date only  
- stores year, month, and day values of a date, in that order.  
- year value is 4 digits long, and month and day is 2 digits long.  
- date can represent any date from 0001 to year 9999.  
- the length of the date is ten positions.

2. Time – Time only  
HH:MM:SS

Time with time zone  
- stores hour, month, and seconds values from time.  
- hours and minutes occupy 2 digits.  
- the second value can be of 2 digits and may also expand to include an optional fractional part e.g. 10:30:10 or 10:30:10.436 where 10.436 represents 10.436 seconds, a 6 decimal precision here.

Time without time zone  
- A TIME WITHOUT TIME ZONE value takes up eight positions (including colons)  
- HH:MM:SS.P where P is the number of digits positions to the right of the decimal.  
- 10:30:10.436 where 10.436 represents 10.436 seconds, a 6 decimal precision here.

3. Timestamp – Date and time only  
YYYY-MM-DD HH:MM:SS  
- stores both the date and time information.  
- the lengths and restrictions on the values of the components of TIMESTAMP WITHOUT TIME ZONE data are the same as they are for DATE and TIME WITHOUT TIME ZONE, except for one difference i.e.  
- The default length of the fractional part of the time component is six digits rather than zero.  
*/

-- System Month Date settings  
-- #########################

-- To view current setting for date style  
SHOW DateStyle;

-- To change date style you can use say;  
-- SET DateStyle = 'type, format';  
-- type   : ISO, Postgres, SQL, or German  
-- format : MDY     Month Day Year  
--         DMY     Day Month Year  
--         YMD     Year Month Date  

SET DateStyle = 'ISO, DMY';  
SHOW DateStyle;

-- To reset back to default value i.e. Month Day Year  
SET DateStyle = 'ISO, MDY';



-- Strings to Dates Conversions  
-- #########################

-- 1. String to YYYY-MM-DD format from ISO format  
SELECT  
    TO_DATE('2020-01-01', 'YYYY-MM-DD');  

SELECT  
    TO_DATE('20200101', 'YYYY-MM-DD');  

SELECT  
    TO_DATE('20200101', 'YYYYMMDD');  

-- 2. String to YYYY-MM-DD format from long date  
SELECT  
    TO_DATE('December 1, 2020', 'Month DD, YYYY');  

-- 3. String to YYYY-MM-DD format from short date  
SELECT  
    TO_DATE('Dec 1, 2020', 'Month DD, YYYY');  

SELECT  
    TO_DATE('Dec 1, 2020', 'Mon DD, YYYY');  

SELECT  
    TO_DATE('8th Dec, 2020', 'DDth Mon, YYYY');  

-- What about when input string is not in format?  
SELECT  
    TO_DATE('2020-01-01', 'DD-MM-YYYY');



-- TO_TIMESTAMP Function  
-- #########################


-- String to Timestamp format  
SELECT  
    TO_TIMESTAMP('2020-01-01 10:30:20','YYYY-MM-DD HH:MI:SS');  

SELECT  
    TO_TIMESTAMP('2020-01-01 10:30:20','YYYY-MM-DD HH');  

SELECT  
    TO_TIMESTAMP('2020-01-01 10:30:20','YYYY-MM-DD HH');  

-- TO_TIMESTAMP function validates the input string with minimal error checking.  

SELECT  
    TO_TIMESTAMP('2020-01-31 30:8:00','YYYY-MM-DD HH24:MI:SS');  

-- When converting a string to a timestamp, the TO_TIMESTAMP() function treats  
-- millisecond or microsecond as the seconds after the decimal point.  

SELECT  
    TO_TIMESTAMP('01-01-2020 10:4','DD-MM-YYYY SS:MS');  

-- 4 is not 4 millisecond but 400. i.e.  

SELECT  
    TO_TIMESTAMP('01-01-2020 10:4','DD-MM-YYYY SS:MS'),  
    TO_TIMESTAMP('01-01-2020 10:004','DD-MM-YYYY SS:MS');



-- Formatting Dates  
-- #########################


-- SELECT with timestamp format  
SELECT  
    CURRENT_TIMESTAMP;

SELECT  
    CURRENT_TIMESTAMP,  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMP, 'YYYY Month DD');

SELECT  
    CURRENT_TIMESTAMP,  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMP, 'YYYY Month DD'),  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMPTZ, 'YYYY Month DD');

-- view timezone info  
SELECT  
    CURRENT_TIMESTAMP,  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMP, 'YYYY Month DD'),  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMPTZ, 'YYYY Month DD'),  
    TO_CHAR('2020-01-01T10:45:55-6:00'::TIMESTAMPTZ, 'YYYY Month DD hh:mm:ss tz');

SELECT  
    CURRENT_TIMESTAMP,  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMP, 'YYYY Month DD'),  
    TO_CHAR('2020-01-01 10:00:00'::TIMESTAMPZ, 'YYYY Month DD'),  
    TO_CHAR('2020-01-01T10:45:55-6:00'::TIMESTAMPTZ, 'FMonth DDDth YYYY hh:mm:ss tz');

-- Let view movies release dates  
SELECT  
    movie_name,  
    release_date  
FROM movies;

SELECT  
    movie_name,  
    release_date,  
    TO_CHAR(release_date, 'FMonth DDDth, YYYY')  
FROM movies;

-- with timezone format  
SELECT  
    movie_name,  
    release_date,  
    TO_CHAR(release_date, 'FMonth DDDth, YYYY hh:mm:ss tz')  
FROM movies;



-- Date construction functions
-- ##############################

-- MAKE_DATE(YYYY, MM, DD)

SELECT
    MAKE_DATE(2020,01,01)

SELECT
    MAKE_DATE(2020,12,1)

-- time without timezone
-- MAKE_TIME(HH, MM, SS)

SELECT
    MAKE_TIME(2,3,4.05)


SELECT MAKE_TIMESTAMP(2020,3,22,2,3,4.5)

SELECT MAKE_INTERVAL(2020,03,1,1,1,1,1),
MAKE_INTERVAL(2020,03,2,1,1,1,1),
MAKE_INTERVAL(2020,03,3,1,1,1,1),
MAKE_INTERVAL(2020,03,4,1,1,1,1),
MAKE_INTERVAL(2020,03,5,1,1,1,1)

SELECT 	MAKE_INTERVAL(days => 10)
SELECT MAKE_INTERVAL(months=> 3, days=> 20)

SELECT MAKE_INTERVAL(weeks => 5)

SELECT MAKE_TIMESTAMPTZ(2000,2,2,10,00,30)

SELECT pg_typeof(MAKE_TIMESTAMPTZ(2000,2,2,10,00,30))

SELECT * FROM pg_timezone_names

SELECT MAKE_TIMESTAMPTZ(2000,2,2,10,00,30,'GMT')

SELECT MAKE_TIMESTAMPTZ(2000,2,2,10,00,30,'NZ')

SELECT MAKE_TIMESTAMP(2000,2,2,10,00,30)

SELECT pg_typeof(MAKE_TIMESTAMP(2000,2,2,10,00,30))

--- Date value extraction function
SELECT 
	EXTRACT('Day' FROM CURRENT_TIMESTAMP),
	EXTRACT('Month' FROM CURRENT_TIMESTAMP),
	EXTRACT('Year' FROM CURRENT_TIMESTAMP)

SELECT
	EXTRACT('CENTURY' FROM INTERVAL'500 years')

--- Uisn math operation on date

SELECT DATE '2020-01-01' + 40;

SELECT '2020-01-01'::date + 40;

SELECT TIME '10:01:30' + INTERVAL '2 hours';

SELECT TIME '10:01:30' + '15:2:2';

SELECT CURRENT_TIMESTAMP , CURRENT_TIMESTAMP + '10:10:10';

SELECT DATE '2020-01-01' + TIME '12:30:00';

SELECT TIMESTAMP '2020-01-01 01:01:00' + TIME '12:30:00';

SELECT CURRENT_TIMESTAMP - INTERVAL '2 hours' AS "2 HOURS ago";

SELECT INTERVAL '30 minutes' + INTERVAL '30 minutes';

SELECT INTERVAL '30 minutes' - INTERVAL '30 minutes';

SELECT INTERVAL '30 minutes' + INTERVAL '1 day';

SELECT interval '2:00' / 2 ;
 
--- Overlaps

SELECT (DATE '2000-01-01',DATE '2005-12-31') OVERLAPS (DATE '2006-01-01',DATE '2008-12-31');

SELECT (DATE '2000-02-02', INTERVAL '30 days') OVERLAPS (DATE '2000-02-15',DATE '2000-03-31');

--- Date Time functions
SELECT CURRENT_DATE,
	   CURRENT_TIME,
	   CURRENT_TIME(2),
	   CURRENT_TIMESTAMP,
	   LOCALTIME,
	   LOCALTIME(3),
	   LOCALTIMESTAMP,
	   LOCALTIMESTAMP(3);

--- Postgre Date time function
SELECT NOW(),
		TRANSACTION_TIMESTAMP(), --- Same as NOW()
		STATEMENT_TIMESTAMP(), --- Time of Query Execution
		CLOCK_TIMESTAMP();
SELECT TIMEOFDAY();  --- Return as a string

--- AGE
SELECT AGE('2025-08-05','2004-08-20');

SELECT AGE(timestamp '2004-08-20');

SELECT AGE(CURRENT_DATE , timestamp '2004-08-20');

--- What if date is interchange like order wise
SELECT AGE( timestamp '2004-08-20',CURRENT_DATE);  --- answer comes out in negative

SELECT CURRENT_DATE

SELECT CURRENT_DATE - 1

SELECT CURRENT_DATE + 1

CREATE TABLE time_update(
 	id SERIAL NOT NULL,
	 update_on_date DATE DEFAULT CURRENT_DATE,
	 add_time TIME DEFAULT CURRENT_TIME,
	 entry TEXT
);

INSERT INTO time_update (entry)
VALUES ('ABC') , ('XYZ');

SELECT * FROM time_update;

--- EPOCH --> AGE IS good for subtracting dates but EPOCH is far better 
SELECT (EXTRACT(EPOCH FROM TIMESTAMPTZ '2020-02-01') - EXTRACT(EPOCH FROM TIMESTAMPTZ '2020-01-01')) / 60 / 60 / 24 --- Double precision
, TIMESTAMP '2020-02-01' - TIMESTAMP '2020-01-01' , AGE(TIMESTAMP '2020-02-01',TIMESTAMP '2020-01-01');


INSERT INTO time_update (update_on_date,add_time,entry)
VALUES ('epoch','allballs','ABC');


INSERT INTO time_update (update_on_date,add_time,entry)
VALUES ('-infinity','allballs','ABC');

SELECT * FROM time_update;



---- SETTING UP TIMEZONE

SELECT * FROM pg_timezone_names;

SELECT * FROM pg_timezone_abbrevs;

SHOW TIME ZONE;

SET TIME ZONE 'America/New_York';

ALTER TABLE time_update ADD COLUMN end_timestamp TIMESTAMP WITH TIME ZONE;

ALTER TABLE time_update ADD COLUMN end_time TIME WITH TIME ZONE;

INSERT INTO time_update (end_timestamp,end_time) VALUES
('2020-01-20 11:30:00 US/Pacific','11:30:00+6')

SELECT * FROM time_update

SELECT 
	date_part('year',TIMESTAMP '2017-01-01'),
	date_part('month',TIMESTAMP '2017-05-01'),
	date_part('quarter',TIMESTAMP '2017-12-01'),
	date_part('decade',TIMESTAMP '2017-01-01'),
	date_part('century',TIMESTAMP '2017-01-01');

SELECT 
	date_part('week',TIMESTAMP '2017-01-01'),
	date_part('dow',TIMESTAMP '2017-05-01'),
	date_part('doy',TIMESTAMP '2017-12-01'),
	date_part('day',TIMESTAMP '2017-01-01'),
	date_part('hour',TIMESTAMP '2017-01-01 10:20:30'),
	date_part('min',TIMESTAMP '2017-01-01 10:20:30'),
	date_part('sec',TIMESTAMP '2017-01-01 10:20:30');


--- Date trunc

SELECT date_trunc('hour',TIMESTAMP '2017-01-01 10:20:30'),
	date_trunc('min',TIMESTAMP '2017-01-01 10:20:30'),
	date_trunc('sec',TIMESTAMP '2017-01-01 10:20:30');

SELECT 
	date_trunc('month',release_date) "release month",
	COUNT(movie_id)
FROM 
	movies
GROUP BY 
	"release month"
ORDER BY 
	2 DESC;
	
