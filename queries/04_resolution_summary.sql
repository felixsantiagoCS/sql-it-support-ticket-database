-- Question: What are the average, fastest, and slowest resolution times?
-- Only resolved tickets contribute to these measures.
SELECT
    COUNT(*) AS resolved_tickets,
    ROUND(AVG(
        (CAST(strftime('%s', resolved_at) AS INTEGER)
         - CAST(strftime('%s', created_at) AS INTEGER)) / 3600.0
    ), 2) AS average_resolution_hours,
    ROUND(MIN(
        (CAST(strftime('%s', resolved_at) AS INTEGER)
         - CAST(strftime('%s', created_at) AS INTEGER)) / 3600.0
    ), 2) AS fastest_resolution_hours,
    ROUND(MAX(
        (CAST(strftime('%s', resolved_at) AS INTEGER)
         - CAST(strftime('%s', created_at) AS INTEGER)) / 3600.0
    ), 2) AS slowest_resolution_hours
FROM tickets
WHERE status = 'Resolved';
