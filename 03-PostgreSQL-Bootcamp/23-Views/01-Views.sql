/*
================================================================================
PostgreSQL Views — Complete Tutorial
================================================================================

Overview:
---------
- A VIEW stores a query for reuse.
- Useful for simplifying complex queries and avoiding repetition (DRY principle).
- Acts like a virtual table — results are generated dynamically from the base table(s).
- Types of views:
    1. Regular views (dynamic)
    2. Updatable views
    3. Views with CHECK OPTION
    4. Materialized views

Key Notes:
----------
- You can SELECT from a view just like a table.
- You cannot rearrange existing columns in a view.
- You can add new columns to a view (at the end), but not remove columns without recreating it.
================================================================================
*/


-- ============================================================================
-- 1. Creating a Simple View
-- ============================================================================

CREATE OR REPLACE VIEW v_movie_quick AS 
SELECT 
    movie_name,
    movie_length,
    release_date
FROM movies;

SELECT * FROM v_movie_quick;


-- ============================================================================
-- 2. View Joining Multiple Tables
-- ============================================================================

CREATE OR REPLACE VIEW v_movies_directors AS
SELECT
    d.first_name,
    d.last_name
FROM movies m
JOIN directors d USING (director_id)
WHERE m.movie_lang = 'English';

SELECT * FROM v_movies_directors;


-- ============================================================================
-- 3. Renaming & Dropping Views
-- ============================================================================

ALTER VIEW v_movie_quick RENAME TO v_movie_quick1;
DROP VIEW v_movies_quick;


-- ============================================================================
-- 4. Views with Filters & Ordering
-- ============================================================================

CREATE OR REPLACE VIEW v_movies_after_1997 AS
SELECT *
FROM movies
WHERE release_date >= '1997-12-31'
ORDER BY release_date DESC;

CREATE OR REPLACE VIEW v_movie_english AS 
SELECT movie_name
FROM movies
WHERE movie_lang = 'English'
  AND release_date >= '1997-12-31';

-- Using one view inside another ("half view")
SELECT movie_name
FROM v_movies_after_1997
WHERE movie_lang = 'English';


-- ============================================================================
-- 5. Reducing Joins into a View
-- ============================================================================

CREATE OR REPLACE VIEW v_american_japanese_director_movie AS
SELECT m.movie_name
FROM movies m
JOIN directors d USING (director_id)
WHERE d.nationality IN ('American', 'Japanese');

SELECT * FROM v_american_japanese_director_movie;


-- ============================================================================
-- 6. UNION in Views
-- ============================================================================

CREATE OR REPLACE VIEW v_people AS 
SELECT first_name, last_name, 'ACTORS' AS "PEOPLE"
FROM actors
UNION
SELECT first_name, last_name, 'DIRECTORS' AS "PEOPLE"
FROM directors;

SELECT * FROM v_people
WHERE "PEOPLE" = 'ACTORS';


-- ============================================================================
-- 7. Connecting Multiple Tables in a View
-- ============================================================================

CREATE OR REPLACE VIEW v_movie_director_revenues AS 
SELECT 
    mv.movie_name,
    d.first_name,
    d.last_name,
    r.revenues_domestic,
    r.revenues_international
FROM movies mv
JOIN directors d USING (director_id)
JOIN movies_revenues r USING (movie_id);

SELECT * FROM v_movie_director_revenues;


-- ============================================================================
-- 8. Modifying Views
-- ============================================================================

-- Adding a column to an existing view
CREATE OR REPLACE VIEW v_movies_directors AS
SELECT
    d.first_name,
    d.last_name,
    d.nationality
FROM movies m
JOIN directors d USING (director_id)
WHERE m.movie_lang = 'English';

-- Cannot rearrange or remove columns in an existing view; must recreate it.


-- ============================================================================
-- 9. Updatable Views
-- ============================================================================

CREATE OR REPLACE VIEW uv_director AS 
SELECT first_name, last_name
FROM directors;

-- Insert via view (affects base table)
INSERT INTO uv_director (first_name) VALUES ('dir1'), ('dir2');

SELECT * FROM uv_director;
SELECT * FROM directors;

DELETE FROM directors WHERE first_name IN ('dir1', 'dir2');


-- ============================================================================
-- 10. Views with CHECK OPTION
-- ============================================================================

CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_code VARCHAR(4),
    city_name VARCHAR(100)
);

INSERT INTO countries (country_code, city_name) VALUES
('US','New York'), ('US','Houston'), ('UK','London');

CREATE OR REPLACE VIEW v_us_cities AS
SELECT *
FROM countries
WHERE country_code = 'US'
WITH CHECK OPTION;

-- Valid insert
INSERT INTO v_us_cities (country_code, city_name) VALUES ('US','Dallas');

-- Invalid insert (violates CHECK OPTION)
INSERT INTO v_us_cities (country_code, city_name) VALUES ('UK','Manchester');


-- ============================================================================
-- 11. LOCAL vs CASCADED CHECK OPTION
-- ============================================================================

CREATE OR REPLACE VIEW v_cities_c AS
SELECT *
FROM countries
WHERE city_name LIKE 'C%';

CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT country_id, country_code, city_name
FROM v_cities_c
WHERE country_code = 'US'
WITH LOCAL CHECK OPTION;

-- LOCAL: Checks only condition of current view
INSERT INTO v_cities_c_us (country_code, city_name) VALUES ('US','Connecticut');

-- CASCADED: Checks all conditions in nested views
CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT country_id, country_code, city_name
FROM v_cities_c
WHERE country_code = 'US'
WITH CASCADED CHECK OPTION;


-- ============================================================================
-- 12. Materialized Views
-- ============================================================================

-- Stores query result physically (useful for heavy queries)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS
SELECT first_name, last_name
FROM directors
WITH DATA;

SELECT * FROM mv_directors;

-- Materialized view without data
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_nodata AS
SELECT first_name, last_name
FROM directors
WITH NO DATA;

-- Populate it later
REFRESH MATERIALIZED VIEW mv_directors_nodata;

-- Check if populated
SELECT relispopulated
FROM pg_class
WHERE relname = 'mv_directors_nodata';


-- ============================================================================
-- 13. Materialized View with Filter & CONCURRENTLY
-- ============================================================================

CREATE MATERIALIZED VIEW mv_directors_us AS
SELECT *
FROM directors
WHERE nationality = 'American'
WITH NO DATA;

-- Create unique index for CONCURRENTLY refresh
CREATE UNIQUE INDEX idx_u_mv_directors_us_director_id
ON mv_directors_us (director_id);

-- Refresh without locking
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_directors_us;


-- ============================================================================
-- 14. Listing Materialized Views
-- ============================================================================

SELECT oid::regclass::text
FROM pg_class
WHERE relkind = 'm'
ORDER BY 1;
