-- Question: How many tickets are assigned to each technician?
-- LEFT JOIN includes Taylor Reed, who has no tickets.
-- COUNT(t.ticket_id), rather than COUNT(*), correctly gives zero for Taylor.
SELECT
    tech.technician_id,
    tech.full_name AS technician,
    COUNT(t.ticket_id) AS total_assigned_tickets,
    SUM(CASE WHEN t.status IN ('Open', 'In Progress') THEN 1 ELSE 0 END)
        AS active_tickets,
    SUM(CASE WHEN t.status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_tickets
FROM technicians AS tech
LEFT JOIN tickets AS t
    ON t.assigned_technician_id = tech.technician_id
GROUP BY tech.technician_id, tech.full_name
ORDER BY active_tickets DESC, total_assigned_tickets DESC, tech.full_name;
