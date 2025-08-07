-- Using Schemas
-- ######################

/*
What is a Schema?

- A schema is a namespace that contains named database objects such as;
  - tables,
  - views,
  - indexes,
  - data types,
  - functions,
  - stored procedures and
  - operators.

- Each PostgreSQL Schema should be unique and different from each other.


-- What are are benefits of Schemas?

- Schemas allow you to organize database objects e.g., tables into more logical groups to make them more manageable.
- Schemas enable multiple users to use one database without interfering with each other.
- Schemas allow you to organize and limit database objects access to users.
- PostgreSQL automatically creates a schema called public for every new database.
- A database can contain one or multiple schemas and each schema belongs to only one database.


-- A database can contain one or multiple schemas and each schema belongs to only one database.
- Two schemas can have different objects that share the same name.
*/

--- Schemas

-- --- containing;
--      - tables,
-- 	 - views,
-- 	 - indexes,
-- 	 - data types,
-- 	 - functions,
-- 	 - stored procedures,
-- 	 - operators.


--- CREATE A SCHEMA 
CREATE SCHEMA  sales;
CREATE SCHEMA he;

--- Renaming schema 
ALTER SCHEMA sales RENAME TO programming;



--- Dropping Schema
DROP SCHEMA he;

--- hierchy 
--- host > cluster > database > schema > object name 
--- hr.programming.table_name

--- creating database test 

--- database.public.object_name 
SELECT * FROM employees

--- select table from other than public schema 
SELECT * FROM hr.programming.employee


--- move table to new schema 
ALTER TABLE programming.orders SET SCHEMA PUBLIC

--- SCHEMA search path , when we dont specify , postgre use it
--- select current schema
SELECT CURRENT_SCHEMA();

--- current search path 
SHOW search_path;

--- how to add new schema to search path 
SET search_path TO programming , public;  --- before it was user, public now it is programming, public

SET search_path TO '$user',programming , public;

SELECT * FROM employee   --- from programming schema

SET search_path TO '$user', public,programming;

SELECT * FROM employee;   --- from public schema

--- Show order of schema setup is matters 

--- Changing Schema ownership

ALTER SCHEMA programming OWNER TO "Basit"

--- creating database test data

--- adding table    --- error we need to change into test_data database 
CREATE TABLE test_data.public.songs(
		song_id SERIAL,
		song_title TEXT
);

INSERT INTO songs(song_title) VALUES ('ABC'),('XYZ')

--- dumpping all data of publiuc schema from test_data into one sql file

pg_dump -d test_schema -h loclahost -U postgres -n public > dump.sql

--- renaming current schema 

--- import back the dump file containg all data related to public schema

psql -h localhost -U postgres -d test_schema -f dump.sql

--- postgre's systen catalog schema containing all built in methods , which having names starting with "pg" so avoid usisng that name 