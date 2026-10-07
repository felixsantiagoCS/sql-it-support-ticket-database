# Explain the Project

## The idea in plain language

A support ticket is a record of a computer problem. This project stores who reported it, which device is involved, who is handling it, its priority, its status, and when it was opened or resolved. The queries turn those records into useful reports.

## What each table does

| Table | What one row represents | Why it is separate |
| --- | --- | --- |
| `users` | One person who can request help | Name and department stay in one place |
| `technicians` | One support technician | A technician can handle many tickets, or none |
| `devices` | One tracked device | Asset tags can be connected to users and tickets |
| `tickets` | One support issue | The issue connects to people and equipment through IDs |

A **primary key** identifies a row in its own table. A **foreign key** points to a row in another table. Ticket 2 has `requester_id = 4`; matching that to `users.user_id = 4` gives Chris Lee's name. It also has `assigned_technician_id = 102`, which matches Jordan Quinn.

## Report 1: active tickets by priority

Read `queries/01_open_tickets_by_priority.sql` in this order:

1. `FROM tickets` selects the source table.
2. `WHERE status IN ('Open', 'In Progress')` keeps unfinished tickets.
3. `GROUP BY priority` makes one group for each priority present in that backlog.
4. `COUNT(*)` counts the tickets in each group.
5. `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` counts a matching status by adding a 1 for each matching row.
6. `ORDER BY CASE ...` gives priorities a deliberate severity order. Alphabetical order would put Critical, High, Low, and Medium in the wrong operational sequence.

The result has 1 Critical, 3 High, 1 Medium, and 1 Low active ticket: 6 total.

## Report 2: tickets per technician

`LEFT JOIN` starts with every technician and adds matching tickets. Taylor Reed has no tickets but still appears. `COUNT(t.ticket_id)` counts only actual ticket IDs, so Taylor's total is 0. `COUNT(*)` would count the unmatched joined row and incorrectly show 1.

Grouping uses both technician ID and name. Two people could share a name; the ID keeps their groups distinct. Sixteen tickets have technician assignments. Two have no assignment and appear in report 5.

## Reports 3 and 4: resolution time

```sql
(CAST(strftime('%s', resolved_at) AS INTEGER)
 - CAST(strftime('%s', created_at) AS INTEGER)) / 3600.0
```

`strftime('%s', ...)` converts a timestamp to Unix seconds. Subtract creation seconds from resolution seconds, then divide by 3,600 seconds per hour. The `.0` makes the calculation use decimal division, preserving a half-hour resolution as `0.5` rather than truncating it.

For ticket 2: 09:30 minus 09:00 is 1,800 seconds. `1800 / 3600.0 = 0.5` hours.

Only resolved tickets have a completion time. Report 3 lists each duration; report 4 uses `AVG`, `MIN`, and `MAX` for a summary. The twelve durations sum to 67.5 hours; `67.5 / 12 = 5.625`, displayed as 5.63 after rounding.

This measures elapsed time, including time outside working hours. It does not measure how long the technician was actively working.

## Report 5: unassigned active tickets

`IS NULL` finds records with no technician assignment. `JOIN users` adds the requester's name. `LEFT JOIN devices` keeps a ticket even if no device has been recorded. `COALESCE(d.asset_tag, 'No device recorded')` replaces a missing tag with a readable label.

## Validation and debugging

- `NOT NULL` requires essential information.
- `UNIQUE` prevents duplicate asset tags and duplicate emails within the respective tables.
- Foreign keys prevent links to missing users, technicians, or devices.
- `CHECK` limits status/priority values and prevents resolution before creation.
- A resolved ticket requires an assigned technician, completion time, and resolution notes.
- Tests compare report output with manually calculated expectations and try invalid updates.

Indexes give SQLite a lookup structure for frequently joined or filtered columns. The sample is small; this project makes no measured speed-improvement claim.

## Interview explanation to practice

“This is a SQLite support-ticket reporting project using fictional data. It has related tables for users, technicians, devices, and tickets. I use joins and grouped queries to show the backlog, technician assignments, and elapsed resolution times. I validate the results against known sample totals and test data-integrity rules.”

Be prepared to open a query, explain one clause at a time, and change it yourself. Treat this explanation as a starting point after you have run and reviewed the project.
