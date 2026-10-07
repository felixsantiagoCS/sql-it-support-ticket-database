-- Question: How many elapsed hours did each resolved ticket take?
-- strftime('%s', ...) returns Unix seconds; divide the difference by 3600.0.
-- This is elapsed calendar time, not hours actively spent working.
SELECT
    t.ticket_id,
    t.title,
    tech.full_name AS technician,
    t.priority,
    t.created_at,
    t.resolved_at,
    ROUND(
        (CAST(strftime('%s', t.resolved_at) AS INTEGER)
         - CAST(strftime('%s', t.created_at) AS INTEGER)) / 3600.0,
        2
    ) AS resolution_hours
FROM tickets AS t
JOIN technicians AS tech
    ON tech.technician_id = t.assigned_technician_id
WHERE t.status = 'Resolved'
ORDER BY resolution_hours DESC, t.ticket_id;
