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
CREATE INDEX index_name ON table_name [USING method]
(
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
SELECT * FROM pg_indexes WHERE schemaname = 'public';

-- Indexes for a specific table
SELECT * FROM pg_indexes WHERE tablename = 'orders';

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
SELECT * FROM pg_stat_all_indexes WHERE schemaname = 'public';

-- For a specific table
SELECT * FROM pg_stat_all_indexes WHERE relname = 'orders';


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
================================================================================
