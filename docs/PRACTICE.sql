-- Run AFTER loading the sample data, on the same SQLite connection.
-- This exercise changes ticket 16 temporarily, then restores it with ROLLBACK.
-- The Python runner regenerates original sample outputs rather than reading
-- modifications made in an external editor.
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- Give the unassigned software-installation ticket to Taylor.
UPDATE tickets
SET assigned_technician_id = 104,
    status = 'In Progress'
WHERE ticket_id = 16;

SELECT ticket_id, assigned_technician_id, status
FROM tickets
WHERE ticket_id = 16;

-- Complete it with a timestamp and clear resolution notes.
UPDATE tickets
SET status = 'Resolved',
    resolved_at = '2026-10-06 12:00:00',
    resolution_notes = 'Installed the sample reporting application and verified it opens.'
WHERE ticket_id = 16;

-- Expected here: 13 resolved tickets, 5 active tickets, 1 unassigned ticket.
SELECT
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_tickets,
    SUM(CASE WHEN status IN ('Open', 'In Progress') THEN 1 ELSE 0 END) AS active_tickets,
    SUM(CASE WHEN assigned_technician_id IS NULL THEN 1 ELSE 0 END) AS unassigned_tickets
FROM tickets;

-- Restore the original sample: 12 resolved, 6 active, 2 unassigned.
ROLLBACK;

SELECT
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_tickets,
    SUM(CASE WHEN status IN ('Open', 'In Progress') THEN 1 ELSE 0 END) AS active_tickets,
    SUM(CASE WHEN assigned_technician_id IS NULL THEN 1 ELSE 0 END) AS unassigned_tickets
FROM tickets;
