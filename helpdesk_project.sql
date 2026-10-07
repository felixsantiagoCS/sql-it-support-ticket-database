-- Run once in a NEW, EMPTY SQLite database.


-- IT Support Ticket Database | SQLite | fictional portfolio data
-- Enable foreign keys on EVERY connection before starting a transaction.
PRAGMA foreign_keys = ON;

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL CHECK (length(trim(full_name)) > 0),
    department TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE COLLATE NOCASE
);

CREATE TABLE technicians (
    technician_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL CHECK (length(trim(full_name)) > 0),
    email TEXT NOT NULL UNIQUE COLLATE NOCASE
);

CREATE TABLE devices (
    device_id INTEGER PRIMARY KEY,
    asset_tag TEXT NOT NULL UNIQUE,
    device_type TEXT NOT NULL
        CHECK (device_type IN ('Desktop', 'Laptop', 'Printer', 'Headset')),
    operating_system TEXT,
    assigned_user_id INTEGER REFERENCES users(user_id)
);

CREATE TABLE tickets (
    ticket_id INTEGER PRIMARY KEY,
    requester_id INTEGER NOT NULL REFERENCES users(user_id),
    device_id INTEGER REFERENCES devices(device_id),
    assigned_technician_id INTEGER REFERENCES technicians(technician_id),
    title TEXT NOT NULL CHECK (length(trim(title)) > 0),
    category TEXT NOT NULL
        CHECK (category IN ('Network', 'Hardware', 'Software', 'Access', 'Audio')),
    priority TEXT NOT NULL
        CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
    status TEXT NOT NULL
        CHECK (status IN ('Open', 'In Progress', 'Resolved')),
    -- Use YYYY-MM-DD HH:MM:SS, in UTC, for this demonstration.
    created_at TEXT NOT NULL CHECK (strftime('%s', created_at) IS NOT NULL),
    resolved_at TEXT,
    resolution_notes TEXT,
    -- Resolved tickets need a technician, a valid timestamp, and notes.
    -- Active tickets must not have a resolution timestamp.
    CHECK (
        (status IN ('Open', 'In Progress') AND resolved_at IS NULL)
        OR
        (status = 'Resolved'
         AND assigned_technician_id IS NOT NULL
         AND resolved_at IS NOT NULL
         AND strftime('%s', resolved_at) IS NOT NULL
         AND CAST(strftime('%s', resolved_at) AS INTEGER)
             >= CAST(strftime('%s', created_at) AS INTEGER)
         AND resolution_notes IS NOT NULL
         AND length(trim(resolution_notes)) > 0)
    )
);

CREATE INDEX idx_tickets_status_priority ON tickets(status, priority);
CREATE INDEX idx_tickets_technician ON tickets(assigned_technician_id);
CREATE INDEX idx_tickets_requester ON tickets(requester_id);
CREATE INDEX idx_tickets_device ON tickets(device_id);
CREATE INDEX idx_devices_assigned_user ON devices(assigned_user_id);


-- Every person, email, device, and incident below is fictional.
BEGIN TRANSACTION;

INSERT INTO users (user_id, full_name, department, email) VALUES
    (1, 'Sara Lopez', 'Records', 'sara.lopez@example.com'),
    (2, 'Omar Rivera', 'Finance', 'omar.rivera@example.com'),
    (3, 'Nina Patel', 'Operations', 'nina.patel@example.com'),
    (4, 'Chris Lee', 'Customer Service', 'chris.lee@example.com'),
    (5, 'Maya Chen', 'Administration', 'maya.chen@example.com');

INSERT INTO technicians (technician_id, full_name, email) VALUES
    (101, 'Avery Brooks', 'avery.brooks@example.com'),
    (102, 'Jordan Quinn', 'jordan.quinn@example.com'),
    (103, 'Casey Morgan', 'casey.morgan@example.com'),
    (104, 'Taylor Reed', 'taylor.reed@example.com');

INSERT INTO devices
    (device_id, asset_tag, device_type, operating_system, assigned_user_id)
VALUES
    (1, 'LT-001', 'Laptop', 'Windows 11', 1),
    (2, 'DT-001', 'Desktop', 'Windows 11', 2),
    (3, 'LT-002', 'Laptop', 'Windows 11', 3),
    (4, 'PR-001', 'Printer', NULL, 2),
    (5, 'HS-001', 'Headset', NULL, 4),
    (6, 'DT-002', 'Desktop', 'Windows 11', 4),
    (7, 'LT-003', 'Laptop', 'Windows 11', 5);

INSERT INTO tickets
    (ticket_id, requester_id, device_id, assigned_technician_id, title,
     category, priority, status, created_at, resolved_at, resolution_notes)
VALUES
    (1, 1, 1, 101, 'Workstation cannot access the network',
     'Network', 'High', 'Resolved', '2026-10-01 08:00:00', '2026-10-01 10:00:00',
     'Reseated Ethernet cable and verified access to the sample application.'),
    (2, 4, 5, 102, 'Headset microphone is not selected',
     'Audio', 'Medium', 'Resolved', '2026-10-01 09:00:00', '2026-10-01 09:30:00',
     'Selected the headset input device and verified microphone audio.'),
    (3, 5, 7, 103, 'User cannot open the call-log report',
     'Access', 'High', 'Resolved', '2026-10-01 10:00:00', '2026-10-01 14:00:00',
     'Administrator corrected the report permission and the user verified access.'),
    (4, 2, 2, 101, 'Spreadsheet application closes unexpectedly',
     'Software', 'Medium', 'Resolved', '2026-10-01 12:00:00', '2026-10-02 12:00:00',
     'Disabled the faulty sample add-in and reopened the test workbook.'),
    (5, 2, 4, 102, 'Printer is shown as offline',
     'Hardware', 'Low', 'Resolved', '2026-10-02 09:00:00', '2026-10-02 10:00:00',
     'Reconnected the printer and verified a test page.'),
    (6, 3, 3, 103, 'Browser cannot reach the sample CRM',
     'Network', 'Medium', 'Resolved', '2026-10-02 10:00:00', '2026-10-02 13:00:00',
     'Corrected the test proxy setting and verified the sample page.'),
    (7, 4, 6, 101, 'Display disconnects during use',
     'Hardware', 'High', 'Resolved', '2026-10-02 12:00:00', '2026-10-02 20:00:00',
     'Replaced a faulty display cable and verified stable output.'),
    (8, 1, 1, 102, 'User account cannot access an assigned folder',
     'Access', 'Medium', 'Resolved', '2026-10-03 08:00:00', '2026-10-03 10:00:00',
     'Administrator reviewed the group assignment and verified the intended access.'),
    (9, 5, 7, 103, 'Application update did not finish',
     'Software', 'Low', 'Resolved', '2026-10-03 09:00:00', '2026-10-03 15:00:00',
     'Completed the sample update and verified the application starts.'),
    (10, 4, 5, 101, 'Call audio plays through the monitor',
     'Audio', 'Low', 'Resolved', '2026-10-03 11:00:00', '2026-10-03 12:00:00',
     'Selected the headset as the output device and verified test audio.'),
    (11, 2, 2, 102, 'Network connection repeatedly drops',
     'Network', 'High', 'Resolved', '2026-10-04 08:00:00', '2026-10-04 12:00:00',
     'Replaced the damaged test Ethernet cable and verified connectivity.'),
    (12, 3, 3, 103, 'Sample CRM export has inconsistent dates',
     'Software', 'Medium', 'Resolved', '2026-10-04 09:00:00', '2026-10-04 21:00:00',
     'Corrected the export format and checked the resulting sample records.'),
    (13, 1, 1, 101, 'Multiple workstations cannot reach the sample CRM',
     'Network', 'Critical', 'Open', '2026-10-05 08:00:00', NULL, NULL),
    (14, 4, 5, 102, 'Headset audio cuts out during calls',
     'Audio', 'High', 'In Progress', '2026-10-05 09:00:00', NULL, NULL),
    (15, 5, 7, 103, 'New user cannot access a required report',
     'Access', 'High', 'Open', '2026-10-05 10:00:00', NULL, NULL),
    (16, 2, 2, NULL, 'Reporting application needs installation',
     'Software', 'Medium', 'Open', '2026-10-05 12:00:00', NULL, NULL),
    (17, 2, 4, 101, 'Printer produces faded test pages',
     'Hardware', 'Low', 'In Progress', '2026-10-06 08:00:00', NULL, NULL),
    (18, 3, 3, NULL, 'Laptop cannot connect to the office network',
     'Network', 'High', 'Open', '2026-10-06 09:00:00', NULL, NULL);

COMMIT;



-- REPORT: Active tickets by priority
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



-- REPORT: Tickets per technician
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



-- REPORT: Resolution times for individual tickets
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



-- REPORT: Overall resolution summary
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



-- REPORT: Unassigned active tickets
-- Question: Which active tickets still need a technician?
-- LEFT JOIN preserves tickets even when no device has been recorded.
SELECT
    t.ticket_id,
    t.title,
    t.priority,
    t.status,
    u.full_name AS requester,
    COALESCE(d.asset_tag, 'No device recorded') AS asset_tag
FROM tickets AS t
JOIN users AS u ON u.user_id = t.requester_id
LEFT JOIN devices AS d ON d.device_id = t.device_id
WHERE t.assigned_technician_id IS NULL
  AND t.status IN ('Open', 'In Progress')
ORDER BY CASE t.priority
    WHEN 'Critical' THEN 1
    WHEN 'High' THEN 2
    WHEN 'Medium' THEN 3
    WHEN 'Low' THEN 4
END, t.created_at, t.ticket_id;
