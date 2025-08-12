/*
================================================================================
PostgreSQL Indexing — Complete Tutorial
================================================================================

Index Overview
--------------
- Indexes help queries run faster by reducing the amount of data scanned.
- You can create indexes on one or more columns.
- Indexing every column is NOT a good idea — it increases storage size and slows writes.
- UNIQUE index ensures that all values in the indexed column(s) are unique.
- PostgreSQL supports indexes on up to 32 columns.

Performance Trade-offs:
------------------------
- SELECT queries → Faster with indexes.
- INSERT, UPDATE, DELETE → Slower with indexes (because they must also be updated).
- Indexes consume additional storage space.
================================================================================
*/


-- ============================================================================
-- 1. Creating Indexes
-- ============================================================================

-- UNIQUE index syntax
CREATE UNIQUE INDEX index_name
ON table_name (col1, col2, ...);

-- Regular index syntax (with ordering and null positioning options)
CREATE INDEX index_name
ON table_name [USING method] (
    column_name [ASC | DESC] [NULLS {FIRST | LAST}]
);


-- ============================================================================
-- 2. Index Examples
-- ============================================================================

-- Single-column indexes
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_ship_city ON orders(ship_city);

-- Multi-column index
CREATE INDEX idx_orders_customer_id_order_id 
ON orders(customer_id, order_id);

-- UNIQUE indexes on single columns
CREATE UNIQUE INDEX idx_u_products_product_id ON products(product_id);
CREATE UNIQUE INDEX idx_u_employees_employee_id ON employees(employee_id);

-- UNIQUE indexes on multiple columns
CREATE UNIQUE INDEX idx_u_orders_customer_id_order_id 
ON orders(customer_id, order_id);

CREATE UNIQUE INDEX idx_u_employees_employee_id_hire_date 
ON employees(employee_id, hire_date);


-- ============================================================================
-- 3. Viewing Indexes
-- ============================================================================

-- All indexes
SELECT * FROM pg_indexes;

-- Indexes in the public schema
SELECT * FROM pg_indexes
WHERE schemaname = 'public';

-- Indexes for a specific table
SELECT * FROM pg_indexes
WHERE tablename = 'orders';

-- Index size for a table
SELECT pg_size_pretty(pg_indexes_size('orders'));


-- ============================================================================
-- 4. Index Size Impact
-- ============================================================================

-- Check current index size
SELECT pg_size_pretty(pg_indexes_size('suppliers'));   -- Example: 16 KB

-- Create index
CREATE INDEX idx_suppliers_region ON suppliers(region);

-- Check size after adding index
SELECT pg_size_pretty(pg_indexes_size('suppliers'));   -- Example: 32 KB


-- ============================================================================
-- 5. Checking Index Usage
-- ============================================================================

-- View index usage statistics
SELECT * FROM pg_stat_all_indexes;

-- For public schema
SELECT * FROM pg_stat_all_indexes
WHERE schemaname = 'public';

-- For a specific table
SELECT * FROM pg_stat_all_indexes
WHERE relname = 'orders';


-- ============================================================================
-- 6. Dropping Indexes
-- ============================================================================

-- Syntax
DROP INDEX [CONCURRENTLY]
[IF EXISTS] index_name
[CASCADE | RESTRICT];

-- Example
DROP INDEX idx_suppliers_region;


-- ============================================================================
-- 7. Query Execution Stages in PostgreSQL
-- ============================================================================

-- SQL execution process:
-- parser --> rewriter --> optimizer --> executor

-- The optimizer uses "nodes" to represent execution operations.
-- Nodes are stackable and represent different query plan elements.

-- View available access methods
SELECT * FROM pg_am;


-- ============================================================================
-- 8. Execution Nodes & EXPLAIN
-- ============================================================================

-- Sequential Scan: Full table scan when no useful index exists
EXPLAIN SELECT * FROM region;

-- Index Scan: Uses index to fetch matching rows
EXPLAIN SELECT * FROM orders WHERE order_id = 1;

-- Index-Only Scan: Uses only the index (no table lookup)
EXPLAIN SELECT order_id FROM orders WHERE order_id = 1;

-- Bitmap Scan: Combines multiple indexes or handles large index matches
-- (Example can be added if multiple conditions require bitmap merge)


-- ============================================================================
-- 9. Join Nodes
-- ============================================================================

-- Join nodes are used when combining data from multiple tables.

-- Hash Join: One table (inner) is loaded into memory as a hash, the other (outer) is scanned
-- SHOW work_mem; -- Memory allocated for hash operations

-- Merge Join: Rows from both tables are read in sorted order
-- Nested Loop: Iterates one table for each row in another table

-- Example join
EXPLAIN SELECT * FROM customers NATURAL JOIN orders;


-- ============================================================================
-- 10. Index Types
-- ============================================================================

-- By default, indexes use B-tree
/*
B-Tree Index:
1. Default index type
2. Self-balancing tree
3. SELECT, INSERT, DELETE, sequential access in logarithmic time
4. Can be used for most operators and column types
5. Supports UNIQUE constraint
6. Normally used for primary key indexes
7. Used when columns involve operators: =, <, <=, >, >=, BETWEEN

Drawback: Copies the whole column(s) values into the tree structure
*/

-- Hash index for equality operator
CREATE INDEX index_name ON table_name USING hash (column_name);
CREATE INDEX idx_orders_order_date_on ON orders USING hash (order_date);

EXPLAIN SELECT * FROM orders ORDER BY order_date;

-- BRIN index
/*
1. Block Range Indexes
2. Index stores min/max per block
3. Smaller than B-tree
4. Less costly to maintain
5. Good for large tables with sequentially ordered data
*/

-- GIN index
/*
1. Generalized Inverted Index
2. Points to multiple tuples
3. Used with array data
4. Useful for full-text search
5. Efficient when multiple values are stored in a single column
*/


-- ============================================================================
-- 11. Using EXPLAIN & EXPLAIN ANALYZE
-- ============================================================================

EXPLAIN SELECT * FROM suppliers WHERE supplier_id = 1;
EXPLAIN SELECT * FROM suppliers ORDER BY company_name;
EXPLAIN SELECT * FROM suppliers WHERE supplier_id = 1 ORDER BY company_name;

EXPLAIN (FORMAT JSON)
SELECT FROM orders WHERE order_id = 1;

EXPLAIN (FORMAT JSON)
SELECT FROM orders WHERE order_id = 1 ORDER BY ship_name;

EXPLAIN ANALYZE
SELECT * FROM orders WHERE order_id = 1 ORDER BY order_id;


-- ============================================================================
-- 12. Large Table Example
-- ============================================================================

CREATE TABLE t_big (id serial, name text);

INSERT INTO t_big (name)
SELECT 'Adam' FROM generate_series(1, 2000000);

INSERT INTO t_big (name)
SELECT 'Linda' FROM generate_series(1, 2000000);

EXPLAIN SELECT * FROM t_big WHERE id = 12345;

SHOW max_parallel_workers_per_gather;
SET max_parallel_workers_per_gather TO 0;

SELECT pg_relation_size('t_big') / 8192.0;

SHOW seq_page_cost;
SHOW cpu_tuple_cost;
SHOW cpu_operator_cost;

SELECT pg_size_pretty(pg_indexes_size('t_big'));
SELECT pg_size_pretty(pg_total_relation_size('t_big'));

EXPLAIN ANALYZE
SELECT FROM t_big WHERE id = 123456;

CREATE INDEX idx_t_big_id ON t_big(id);

SHOW max_parallel_maintenance_workers;

EXPLAIN SELECT * FROM orders WHERE order_id = 1;


-- ============================================================================
-- 13. Indexes for Sorted Output
-- ============================================================================

EXPLAIN SELECT * FROM t_big ORDER BY id LIMIT 20;
EXPLAIN SELECT * FROM t_big ORDER BY name LIMIT 20;

EXPLAIN SELECT MIN(id), MAX(id) FROM t_big;

-- ASC ........ lowest
-- DESC ....... highest


-- ============================================================================
-- 14. Using Multiple Indexes in a Query
-- ============================================================================

EXPLAIN SELECT * FROM t_big WHERE id = 20 OR id = 40;


-- ============================================================================
-- 15. Execution Plans Depend on Input Values
-- ============================================================================

CREATE INDEX idx_t_big_name ON t_big(name);

EXPLAIN SELECT * FROM t_big WHERE name = 'Adam' LIMIT 10;
EXPLAIN SELECT FROM t_big WHERE name = 'Adam' OR name = 'Linda';
EXPLAIN SELECT FROM t_big WHERE name = 'Adam1' OR name = 'Linda1';


-- ============================================================================
-- 16. Organized vs Random Data
-- ============================================================================

SELECT * FROM t_big ORDER BY id LIMIT 10;

EXPLAIN (ANALYZE true, BUFFERS true, TIMING true)
SELECT * FROM t_big WHERE id < 10000;

CREATE TABLE t_big_random AS
SELECT * FROM t_big ORDER BY random();

CREATE INDEX idx_t_big_random_id ON t_big_random(id);

SELECT * FROM t_big_random LIMIT 10;

VACUUM ANALYZE t_big_random;

EXPLAIN (ANALYZE true, BUFFERS true, TIMING true)
SELECT FROM t_big_random WHERE id < 10000;

SELECT tablename, attname, correlation
FROM pg_stats
WHERE tablename IN ('t_big', 't_big_random')
ORDER BY 1, 2;


-- ============================================================================
-- 17. Index Only Scans
-- ============================================================================

EXPLAIN ANALYZE
SELECT * FROM t_big WHERE id = 123456;

EXPLAIN ANALYZE
SELECT id FROM t_big WHERE id = 123456;


-- ============================================================================
-- 18. Partial Index
-- ============================================================================

-- Partial index: improves query performance while reducing index size
CREATE INDEX index_name ON table_name WHERE conditions;

SELECT pg_size_pretty(pg_indexes_size('customers'));

DROP INDEX idx_t_big_name;

CREATE INDEX idx_p_t_big_name ON t_big(name);

CREATE INDEX index_name
ON table_name (expression);


-- ============================================================================
-- 19. Expression Index Example
-- ============================================================================

CREATE TABLE t_dates AS
SELECT d, repeat(md5(d::text), 10) AS padding
FROM generate_series(
    timestamp '1800-01-01',
    timestamp '2100-01-01',
    interval '1 day'
) s(d);

VACUUM ANALYZE t_dates;

SELECT COUNT(*) FROM t_dates;

EXPLAIN ANALYZE
SELECT * FROM t_dates WHERE d BETWEEN '2001-01-01' AND '2001-01-31';

ANALYZE t_dates;

EXPLAIN ANALYZE
SELECT FROM t_dates WHERE EXTRACT(day FROM d) = 1;

CREATE INDEX idx_expr_t_dates ON t_dates (EXTRACT(day FROM d));

ANALYZE t_dates;

EXPLAIN ANALYZE
SELECT FROM t_dates WHERE EXTRACT(day FROM d) = 1;


-- ============================================================================
-- 20. Adding Data While Indexing
-- ============================================================================

CREATE INDEX CONCURRENTLY idx_t_big_name2 ON t_big(name);

SELECT
    oid, relname, relpages, reltuples,
    i.indisunique, i.indisclustered, i.indisvalid,
    pg_catalog.pg_get_indexdef(i.indexrelid, 0, true)
FROM pg_class c
JOIN pg_index i ON c.oid = i.indrelid
WHERE c.relname = 't_big';


-- ============================================================================
-- 21. Invalidating an Index
-- ============================================================================

SELECT
    oid, relname, relpages, reltuples,
    i.indisunique, i.indisclustered, i.indisvalid,
    pg_catalog.pg_get_indexdef(i.indexrelid, 0, true)
FROM pg_class c
JOIN pg_index i ON c.oid = i.indrelid
WHERE c.relname = 'orders';

EXPLAIN SELECT * FROM orders WHERE ship_country = 'USA';

CREATE INDEX idx_orders_ship_country ON orders(ship_country);

EXPLAIN SELECT * FROM orders WHERE ship_country = 'USA';

-- Disable index
UPDATE pg_index
SET indisvalid = false
WHERE indexrelid = (
    SELECT oid FROM pg_class
    WHERE relkind = 'i'
    AND relname = 'idx_orders_ship_country'
);

-- Re-enable index
UPDATE pg_index
SET indisvalid = true
WHERE indexrelid = (
    SELECT oid FROM pg_class
    WHERE relkind = 'i'
    AND relname = 'idx_orders_ship_country'
);


-- ============================================================================
-- 22. Rebuilding an Index (REINDEX)
-- ============================================================================

REINDEX [ (VERBOSE) ] { INDEX | TABLE | SCHEMA | DATABASE | SYSTEM } [CONCURRENTLY] name;
REINDEX (VERBOSE) TABLE CONCURRENTLY orders;
