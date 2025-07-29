-- The UPSERT operation is used to either insert a new record into a table or update an existing record.
-- It checks for the existence of a record based on a unique identifier (e.g., primary key or unique constraint).
-- If the record does not exist, an INSERT is performed.
-- If the record already exists, an UPDATE is executed to modify the existing record.
-- This operation is particularly useful to ensure that no duplicate records are inserted while keeping existing data up-to-date.
-- Different databases implement UPSERT differently:
--   - In PostgreSQL, it's done with `ON CONFLICT`.

CREATE TABLE t_tags(
    id SERIAL PRIMARY KEY,
    tag text UNIQUE,
    update_date TIMESTAMP DEFAULT NOW()
);

-- Insert some sample DATA
INSERT INTO t_tags (tag) VALUES ('Pen'), ('Pencil'), ('Eraser');

-- Lets insert a record, on conflict do nothing
INSERT INTO t_tags (tag) VALUES ('Pen') ON CONFLICT (tag) DO NOTHING;

-- Lets indert a record, on conflict update the existing record
INSERT INTO t_tags (tag) VALUES ('Pen') ON CONFLICT (tag) DO UPDATE SET update_date = NOW();

SELECT * FROM t_tags;