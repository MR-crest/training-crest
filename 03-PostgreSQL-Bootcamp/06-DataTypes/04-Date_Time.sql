-- Date/Time data types
-- ######################

/*
  1. Assigned to the variable that is supposed to store only the time value.
  2. One of the most important types.
  3. Below is the date/time data types available:

     Data Type   | Stores                    | Low Value    | High Value
    -------------|---------------------------|--------------|--------------
    Date         | date only                 | 4713 BC      | 294276 AD
    Time         | time only                 | 4713 BC      | 5874897 AD
    Timestamp    | data and time             | 4713 BC      | 294276 AD
    Timestamptz  | data, time, and timestamp | 4713 BC      | 294276 AD
    Interval     | store values              |              |
*/


CREATE TABLE table_dates (
	id serial primary key,
	employee_name varchar (100) NOT NULL,
	hire_date DATE NOT NULL,
	add_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO table_dates (employee_name, hire_date) VALUES
('ADAM', '2020-01-01'),
('LINDA', '2020-02-01');

-- current date
SELECT CURRENT_DATE;

--current date and time
SELECT NOW();

SELECT * FROM table_dates;


CREATE TABLE table_time(
	id serial primary key,
	class_name varchar (100) not null,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL
);

INSERT INTO table_time (class_name, start_time, end_time) VALUES
('MATH', '08:00:00','09:00:00'),
('CHEMISTRY', '09:01:00', '10:00:00');

SELECT * FROM table_time;


--Getting current time
SELECT CURRENT_TIME;

--Getting current time with precision
SELECT CURRENT_TIME (4);

-- Use local time
SELECT CURRENT_TIME, LOCALTIME;

--Using Interval
-- interval 'n type';

-- n = number
-- type = second, minute, hours, day, month, year....

SELECT CURRENT_TIME, CURRENT_TIME + interval '2 hours' as result;

-- TIMESTAMP and TIMESTAMPTZ

CREATE TABLE table_time_tz(
	ts TIMESTAMP,
	tstz TIMESTAMPTZ
);

INSERT INTO table_time_tz (ts, tstz) VALUES
('2020-02-22 10:10:10-07','2020-02-22 10:10:10-07');

SELECT * FROM table_time_tz;

-- SHOW CURRENT TIMEZONE

SHOW TIMEZONE;

--Lets change the timezone
SET TIMEZONE = 'America/New_York';

SELECT CURRENT_TIMESTAMP;

--Current time of the day
SELECT TIMEOFDAY();

--Using timezone() function to convert time based on a time zone

SELECT timezone ('Asia/Singapore', '2020-01-01 00:00:00')
