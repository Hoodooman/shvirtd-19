# Connect to database
```bash
psql -h hostname -p port -U username -d database_name
psql -U username -d database_name
```
# Connect to default database
```bash
psql postgres
psql -U username
```
# Basic psql Meta-Commands
```sql
-- List all databases
\l
\l+

-- Connect to different database
\c database_name

-- List all tables
\dt
\dt+

-- List tables including system tables
\dt *
\dt+ *

-- Describe table structure
\d table_name
\d+ table_name

-- List all schemas
\dn
\dn+

-- List all functions
\df
\df+

-- List all views
\dv
\dv+

-- List all indexes
\di
\di+
Information Commands
sql
-- Show current connection info
\conninfo

-- Show current user
\du
\du+

-- Show tablespaces
\db
\db+

-- Show current database
SELECT current_database();

-- Show version
SELECT version();

-- Show current time
SELECT now();
File Operations
sql
-- Execute SQL from file
\i filename.sql

-- Output results to file
\o filename.txt

-- Read input from file
\i path/to/file.sql
Display Settings
sql
-- Toggle query execution time timing
\timing

-- Toggle expanded display
\x
\x auto

-- Set output format
\a (aligned/unaligned)
\f (field separator)

-- Show command history
\s

-- Save command history to file
\s filename
Export/Import
sql
-- Export query results to CSV
\copy (SELECT * FROM table) TO 'file.csv' WITH CSV HEADER

-- Import CSV to table
\copy table_name FROM 'file.csv' WITH CSV HEADER

-- Export entire database
pg_dump database_name > backup.sql

-- Import database
psql -d database_name -f backup.sql
Transaction Commands
sql
-- Begin transaction
BEGIN;

-- Commit transaction
COMMIT;

-- Rollback transaction
ROLLBACK;

-- Savepoint
SAVEPOINT savepoint_name;

-- Rollback to savepoint
ROLLBACK TO SAVEPOINT savepoint_name;
Utility Commands
sql
-- Show help
\?
\h (SQL command help)
\h CREATE TABLE

-- Clear screen
\! clear  (Linux/Mac)
\! cls    (Windows)

-- Execute shell command
\! command

-- Quit psql
\q
\quit

-- Show all psql commands
\?
Common SQL Commands in psql
sql
-- Create database
CREATE DATABASE dbname;

-- Create table
CREATE TABLE table_name (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert data
INSERT INTO table_name (name) VALUES ('John');

-- Select data
SELECT * FROM table_name;

-- Update data
UPDATE table_name SET name = 'Jane' WHERE id = 1;

-- Delete data
DELETE FROM table_name WHERE id = 1;
Configuration Commands
sql
-- Set environment variables in psql
\set NAME value

-- Unset variable
\unset NAME

-- Show all variables
\set

-- Set prompt
\set PROMPT1 '%/%R%# '
\set PROMPT2 '%/%R%# '
```
# Tips for Using psql
- Auto-completion: Press Tab for command and table name completion

- Command History: Use up/down arrows to navigate history

- Search History: Ctrl+R to search command history

- Edit Command: Use your default editor with \e

- Repeat Last Command: \g

This covers the most commonly used psql commands for database administration and development.
