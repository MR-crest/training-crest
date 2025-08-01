-- FOREIGN KEY constraints
-- ######################
/*
	1. The FOREIGN KEY constraint is used to establish a relationship between two tables by linking a column in one table to the primary key or unique key in another table.
	2. The column in the child table that acts as the foreign key must match the primary key (or a unique key) in the parent table.
	3. The FOREIGN KEY constraint ensures referential integrity, meaning that a value in the foreign key column must exist in the referenced parent table or be NULL (if allowed).
	4. A table can have multiple foreign keys, each referencing a different parent table.
	5. The FOREIGN KEY constraint ensures that you cannot insert a value into the child table unless it exists in the parent table, or NULL is allowed.
	6. The FOREIGN KEY can be defined during table creation or added to an existing table.
	7. The behavior when referenced data in the parent table is updated or deleted can be controlled with options like:
	   - **CASCADE**: Automatically updates or deletes related rows in the child table.
	   - **SET NULL**: Sets the foreign key value to NULL in the child table when the referenced row is deleted or updated.
	   - **SET DEFAULT**: Sets the foreign key value to its default value when the referenced row is deleted or updated.
	   - **NO ACTION/RESTRICT**: Prevents the deletion or update of the referenced row if there are dependent rows in the child table.
	8. The syntax to create a FOREIGN KEY constraint is as follows:
	
	   CREATE TABLE child_table (
	       column_name data_type,
	       FOREIGN KEY (column_name) REFERENCES parent_table(parent_column)
	   );
	
	   OR to create a foreign key in an existing table:
	
	   ALTER TABLE child_table
	   ADD CONSTRAINT fk_constraint_name
	   FOREIGN KEY (column_name) REFERENCES parent_table(parent_column);
*/

CREATE TABLE t_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    supplier_id INT NOT NULL
);

CREATE TABLE t_suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL
);

INSERT INTO t_suppliers(supplier_id, supplier_name) VALUES
    (1, 'SUPPLIER 1'),
    (2, 'SUPPLIER 2');

SELECT * FROM t_suppliers;


INSERT INTO t_products (product_id, product_name, supplier_id) VALUES
    (1, 'PEN', 1),
    (2, 'PAPER', 2);

SELECT * FROM t_products;

INSERT INTO t_products (product_id, product_name, supplier_id) VALUES
    (4, 'COMPUTER', 10);


DROP TABLE t_products;
DROP TABLE t_suppliers;

CREATE TABLE t_suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL
);

CREATE TABLE t_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES t_suppliers(supplier_id)
);


