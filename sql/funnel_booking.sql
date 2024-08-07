-- Create a materialized view that tracks the booking process funnel for a service

CREATE MATERIALIZED VIEW service.matview_funnel_booking_process
TABLESPACE pg_default
AS 
-- Step 1: Users who first opened the app in the last month
WITH ae_first_open AS (
    SELECT 
        m.distinct_id,
        date_trunc('month', m."time") AS event_time_month
    FROM mobile.mixpanel m
    WHERE m.event = '$ae_first_open' 
        AND m."time" > date_trunc('month', CURRENT_DATE - INTERVAL '1 month')
    GROUP BY m.distinct_id, date_trunc('month', m."time")
), 

-- Step 2: Users who made their first connection
service_first_connection AS (
    SELECT DISTINCT 
        m.distinct_id,
        date_trunc('month', m."time") AS event_time_month
    FROM ae_first_open o
    JOIN mobile.mixpanel m ON m.distinct_id = o.distinct_id
    WHERE m.event = 'service_first_connection'
), 

-- Step 3: Users who started a search
service_search_started AS (
    SELECT DISTINCT 
        m.distinct_id,
        date_trunc('month', m."time") AS event_time_month
    FROM service_first_connection c
    JOIN mobile.mixpanel m ON m.distinct_id = c.distinct_id
    WHERE m.event = 'service_search_started'
), 

-- Step 4: Users who started a reservation
service_reservation_started AS (
    SELECT DISTINCT 
        m.distinct_id,
        date_trunc('month', m."time") AS event_time_month
    FROM service_search_started ss
    JOIN mobile.mixpanel m ON m.distinct_id = ss.distinct_id
    WHERE m.event = 'service_reservation_started'
), 

-- Step 5: Users who completed a reservation
service_reservation_completed AS (
    SELECT DISTINCT 
        m.distinct_id,
        date_trunc('month', m."time") AS event_time_month
    FROM service_reservation_started rs
    JOIN mobile.mixpanel m ON m.distinct_id = rs.distinct_id
    WHERE m.event = 'service_reservation_completed'
), 

-- Step 6: Users who cancelled a reservation
service_reservation_cancelled AS (
    SELECT DISTINCT 
        m.distinct_id,
        date_trunc('month', m."time") AS event_time_month
    FROM service_reservation_completed rc
    JOIN mobile.mixpanel m ON m.distinct_id = rc.distinct_id
    WHERE m.event = 'service_reservation_cancelled'
)

-- Combine all steps to count users at each stage of the funnel
SELECT 
    count(*) AS event_user_count,
    'First App Open' AS event_action_event,
    ae_first_open.event_time_month
FROM ae_first_open
GROUP BY ae_first_open.event_time_month
UNION
SELECT 
    count(*) AS event_user_count,
    'First Connection' AS event_action_event,
    service_first_connection.event_time_month
FROM service_first_connection
GROUP BY service_first_connection.event_time_month
UNION
SELECT 
    count(*) AS event_user_count,
    'Search Started' AS event_action_event,
    service_search_started.event_time_month
FROM service_search_started
GROUP BY service_search_started.event_time_month
UNION
SELECT 
    count(*) AS event_user_count,
    'Reservation Started' AS event_action_event,
    service_reservation_started.event_time_month
FROM service_reservation_started
GROUP BY service_reservation_started.event_time_month
UNION
SELECT 
    count(*) AS event_user_count,
    'Reservation Completed' AS event_action_event,
    service_reservation_completed.event_time_month
FROM service_reservation_completed
GROUP BY service_reservation_completed.event_time_month
UNION
SELECT 
    count(*) AS event_user_count,
    'Reservation Cancelled' AS event_action_event,
    service_reservation_cancelled.event_time_month
FROM service_reservation_cancelled
GROUP BY service_reservation_cancelled.event_time_month
ORDER BY 3 DESC, 1 DESC
WITH DATA;
