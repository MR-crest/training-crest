CREATE TABLE persons (
person_id SERIAL PRIMARY KEY,
first_name VARCHAR (20) not null,
last_name VARCHAR (20) NOT NULL
);

ALTER TABLE persons
ADD COLUMN age INT NOT NULL;

SELECT * FROM persons;

ALTER TABLE persons
ADD COLUMN nationality VARCHAR(20) not null,
ADD COLUMN email varchar(100) UNIQUE

-- Modify table strucuture
--Rename a table
ALTER TABLE persons
RENAME TO users;

ALTER TABLE users
RENAME TO persons;

--Rename a column
ALTER TABLE persons
RENAME COLUMN age TO person_age;

--Drop a column
ALTER TABLE persons
DROP COLUMN person_age;

ALTER TABLE persons
ADD COLUMN age VARCHAR(10);

--Change the data type of a column
ALTER TABLE persons
ALTER COLUMN age TYPE int
USING age::integer;

--Set a default values of a column
ALTER TABLE persons
ADD COLUMN is_enable VARCHAR(1);

ALTER TABLE persons
ALTER COLUMN is_enable SET DEFAULT 'Y';

INSERT INTO persons (first_name, last_name, nationality, age)
VALUES 
  ('John', 'Doe', 'American', 30),
  ('Jane', 'Smith', 'Canadian', 25);


SELECT * FROM persons;


-- Add a constant to a column
-- #########################

-- Add a UNIQUE constraint to a column
CREATE TABLE web_links (
    link_id SERIAL PRIMARY KEY,
    link_url VARCHAR(255) NOT NULL,
    link_target VARCHAR(20)
);

INSERT INTO web_links (link_url,link_target) VALUES ('https://www.google.com','_blank');

ALTER TABLE web_links
ADD CONSTRAINT unique_web_url UNIQUE (link_url);

INSERT INTO web_links (link_url,link_target) VALUES ('https://www.amazon.com','_blank');


-- To set a column to accept only defined allowed/acceptable values

ALTER TABLE web_links
ADD COLUMN is_enable VARCHAR(2);

INSERT INTO web_links (link_url, link_target, is_enable) 
VALUES ('https://www.netflex.com', '_blank', 'Y');

ALTER TABLE web_links
ADD CHECK (is_enable IN ('Y', 'N'));

INSERT INTO web_links (link_url, link_target, is_enable) 
VALUES ('https://www.yahoo.com', '_blank', 'N');
-- INSERT INTO web_links (link_url, link_target, is_enable) 
-- VALUES ('https://www.netflex.com', '_blank', 'Q'); -- This will raise an error as Add a CHECK constraint to ensure `is_enable` only accepts 'Y' or 'N'

UPDATE web_links
SET is_enable = 'Y'
WHERE link_id = 1


SELECT * from web_links;