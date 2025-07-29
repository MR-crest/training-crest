-- Create the actors table
CREATE TABLE IF NOT EXISTS actors(
    actor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(1),
    date_of_birth DATE,
    add_date DATE,
    update_date DATE
);

SELECT * FROM actors;

-- Create the directors table
CREATE TABLE IF NOT EXISTS directors(
    director_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    nationality VARCHAR(20),
    add_date DATE,
    update_date DATE
);

SELECT * FROM directors;

-- Create the movies table
CREATE TABLE IF NOT EXISTS movies(
    movie_id SERIAL PRIMARY KEY,
    movie_name VARCHAR(100),
    movie_length INTEGER,
    movie_lang VARCHAR(20),
    age_certificate VARCHAR(10),
    release_date DATE,
    director_id INT REFERENCES directors (director_id)
);

SELECT * FROM movies;

-- Create the movies revenues table
CREATE TABLE IF NOT EXISTS movies_revenues(
    revenue_id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies (movie_id),
    revenues_domestic NUMERIC(10,2),
    revenues_international NUMERIC(10,2)
);

-- Create the movies actors junction table
CREATE TABLE IF NOT EXISTS movies_actors(
    movie_id INT REFERENCES movies (movie_id),
    actor_id INT REFERENCES actors (actor_id),
    PRIMARY KEY (movie_id, actor_id)
);

SELECT * FROM movies_actors;
