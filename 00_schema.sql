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
