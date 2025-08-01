-- PRIMARY KEY constraints
-- ######################
/*
1. The PRIMARY KEY constraint is used to uniquely identify each record in a database table.
2. A table can have only one PRIMARY KEY constraint, but it can consist of one or more columns (a composite primary key).
3. A column defined as PRIMARY KEY must contain unique values and cannot contain NULL values.
4. The PRIMARY KEY ensures that no duplicate records can exist in the table, ensuring data integrity.
5. The PRIMARY KEY can be defined during table creation or can be added to an existing table.
6. The syntax to create a PRIMARY KEY constraint is as follows:

   CREATE TABLE table_name (
       column_name data_type PRIMARY KEY,
       ...
   );

   OR to create a composite primary key:

   CREATE TABLE table_name (
       column1 data_type,
       column2 data_type,
       PRIMARY KEY (column1, column2)
   );
   
   OR to add a PRIMARY KEY to an existing table:

   ALTER TABLE table_name
   ADD PRIMARY KEY (column_name);
*/


CREATE TABLE table_items (
	item_id INTEGER PRIMARY KEY,
	item_name VARCHAR (100) NOT NULL
);

INSERT INTO table_items (item_id, item_name) VALUES
(1, 'PEN');

SELECT * FROM table_items;

--DROP a CONSTRAINT
ALTER TABLE table_items
DROP CONSTRAINT table_items_pkey;

-- Add Primary Key to existing TABLE
ALTER TABLE table_items
ADD PRIMARY KEY(item_id);


-- PRIMARY KEY Constraint on multiple columns = Composite PRIMARY KEY
-- ###############################################################

CREATE TABLE t_grades (
    course_id VARCHAR(100) NOT NULL,
    student_id VARCHAR(100) NOT NULL,
    grade INT NOT NULL
);

SELECT * FROM t_grades;

INSERT INTO t_grades (course_id, student_id, grade) VALUES
    ('MATH', 'S1', 50),
    ('CHEMISTRY', 'S1', 70),
    ('ENGLISH', 'S2', 70),
    ('PHYSICS', 'S1', 80);


DROP TABLE t_grades;

CREATE TABLE t_grades (
    course_id VARCHAR(100) NOT NULL,
    student_id VARCHAR(100) NOT NULL,
    grade INT NOT NULL,
	PRIMARY KEY(course_id,student_id)
);

INSERT INTO t_grades (course_id, student_id, grade) VALUES
    ('MATH', 'S1', 50),
    ('CHEMISTRY', 'S1', 70),
    ('ENGLISH', 'S2', 70),
    ('PHYSICS', 'S1', 80);

INSERT INTO t_grades (course_id, student_id, grade) VALUES
    ('MATH', 'S2', 50),
    ('CHEMISTRY', 'S2', 70),
    ('ENGLISH', 'S1', 70),
    ('PHYSICS', 'S2', 80);

SELECT * FROM t_grades;


ALTER TABLE t_grades
DROP CONSTRAINT t_grades_pkey;

ALTER TABLE t_grades
ADD CONSTRAINT t_grades_course_id_session_id_pkey
PRIMARY KEY (course_id, student_id);

