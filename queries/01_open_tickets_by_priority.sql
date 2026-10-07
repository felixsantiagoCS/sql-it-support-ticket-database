-- Question: Which priorities make up the active backlog?
-- "Active" includes both Open and In Progress tickets.
SELECT
    priority,
    COUNT(*) AS active_tickets,
    SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) AS open_tickets,
    SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) AS in_progress_tickets
FROM tickets
WHERE status IN ('Open', 'In Progress')
GROUP BY priority
ORDER BY CASE priority
    WHEN 'Critical' THEN 1
    WHEN 'High' THEN 2
    WHEN 'Medium' THEN 3
    WHEN 'Low' THEN 4
END;
