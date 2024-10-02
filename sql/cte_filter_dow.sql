WITH dataset AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY record_id ORDER BY ingestion_timestamp DESC) AS rn
    FROM
        schema_name.source_table
)
SELECT 
    count(*)
FROM 
    dataset
WHERE 
    rn = 1
    AND -- get Day Of the Week and filter from Monday load only
    CAST(FROM_UNIXTIME(ingestion_timestamp) AS DATE) >=
    CURRENT_DATE - (CASE WHEN EXTRACT(DOW FROM CURRENT_DATE) = 1 THEN 0 ELSE (EXTRACT(DOW FROM CURRENT_DATE) + 6) % 7 END)
    -- active ones only
    AND is_active = true;
