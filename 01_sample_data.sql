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
