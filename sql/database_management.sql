-- Grant usage permissions on a schema to a user
GRANT usage ON SCHEMA schema_name TO user_name;
-- Don't forget to commit or set auto-commit
COMMIT;

-- Get the current PostgreSQL log file
SELECT pg_current_logfile();

-- Create a new user with a password
CREATE USER user_name WITH PASSWORD 'example';

-- Grant SELECT permissions on all tables in a schema to a user
GRANT SELECT ON ALL TABLES IN SCHEMA schema_name TO user_name;

-- Grant one user the same roles/permissions as another user
GRANT user_1 TO user_2;

-- Check for hanging queries that have been running longer than 30 minutes
SELECT
    *
FROM pg_stat_activity
WHERE
    (now() - pg_stat_activity.query_start) > interval '30 minutes'
    AND state = 'active';

-- Find queries that are being blocked by other queries
SELECT 
    pid, 
    usename, 
    pg_blocking_pids(pid) AS blocked_by, 
    query AS blocked_query
FROM pg_stat_activity
WHERE cardinality(pg_blocking_pids(pid)) > 0;

-- Cancel a backend query using its process ID
SELECT pg_cancel_backend(pid);

-- View column names and data types for a specific table in the information schema
SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE 
    table_schema = 'schema_name'
    AND table_name = 'table_name';

-----------------------------------------------------------------------------------

-- List all tables in a schema
SELECT 
    table_name
FROM information_schema.tables
WHERE 
    table_schema = 'schema_name';

-- View all users and their roles
SELECT 
    rolname, 
    rolsuper, 
    rolinherit, 
    rolcreaterole, 
    rolcreatedb, 
    rolcanlogin
FROM pg_roles;

-- Check disk space usage by each table in a schema
SELECT 
    table_name,
    pg_size_pretty(pg_total_relation_size('schema_name.' || table_name)) AS size
FROM information_schema.tables
WHERE 
    table_schema = 'schema_name';

-- Analyze the execution plan of a query
EXPLAIN ANALYZE
SELECT 
    *
FROM 
    table_name
WHERE 
    condition;

-- Show active connections and their states
SELECT 
    pid, 
    usename, 
    application_name, 
    client_addr, 
    state, 
    query
FROM pg_stat_activity
ORDER BY 
    state;
