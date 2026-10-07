-- Start with the original sample created by helpdesk_project.sql.
-- All names, incidents, completion times, and resolution notes are fictional.
-- This reproduces the assignment/resolution exercise saved from SQLite Fiddle.
-- Status conditions leave an already resolved ticket unchanged if rerun.
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- Inspect the original ticket.
SELECT ticket_id, title, assigned_technician_id, status
FROM tickets
WHERE ticket_id = 16;

-- Assign the installation request to Taylor Reed and start work.
UPDATE tickets
SET assigned_technician_id = 104,
    status = 'In Progress'
WHERE ticket_id = 16 AND status = 'Open';

SELECT ticket_id, title, assigned_technician_id, status
FROM tickets
WHERE ticket_id = 16;

-- Record the simulated completion and its supporting notes.
UPDATE tickets
SET status = 'Resolved',
    resolved_at = '2026-10-06 12:00:00',
    resolution_notes = 'Demo: installed reporting application and verified a sample report.'
WHERE ticket_id = 16
  AND status = 'In Progress'
  AND assigned_technician_id = 104;

SELECT ticket_id, status, resolved_at, resolution_notes
FROM tickets
WHERE ticket_id = 16;

COMMIT;

-- Expected after the exercise: 3 Open, 2 In Progress, and 13 Resolved.
SELECT status, COUNT(*) AS ticket_count
FROM tickets
GROUP BY status
ORDER BY status;
