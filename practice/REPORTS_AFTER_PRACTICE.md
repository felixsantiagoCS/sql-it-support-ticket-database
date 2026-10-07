# Reports after the ticket 16 exercise

These results were queried from `helpdesk_after_practice.sqlite3`, the saved SQLite Fiddle export. All names and incidents are fictional; timestamps use UTC.

**18 tickets: 13 resolved, 5 active, and 1 unassigned active ticket.**

Ticket 16 is assigned to technician 104 and resolved. Its 24-hour elapsed duration is included in the 7.04-hour resolution average. Elapsed hours include nights and weekends.

## Active tickets by priority

`queries/01_open_tickets_by_priority.sql`

| priority | active_tickets | open_tickets | in_progress_tickets |
| --- | --- | --- | --- |
| Critical | 1 | 1 | 0 |
| High | 3 | 2 | 1 |
| Low | 1 | 0 | 1 |

## Tickets per technician

`queries/02_tickets_per_technician.sql`

| technician_id | technician | total_assigned_tickets | active_tickets | resolved_tickets |
| --- | --- | --- | --- | --- |
| 101 | Avery Brooks | 6 | 2 | 4 |
| 103 | Casey Morgan | 5 | 1 | 4 |
| 102 | Jordan Quinn | 5 | 1 | 4 |
| 104 | Taylor Reed | 1 | 0 | 1 |

## Resolved ticket durations in elapsed hours

`queries/03_resolution_times.sql`

| ticket_id | title | technician | priority | created_at | resolved_at | resolution_hours |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | Spreadsheet application closes unexpectedly | Avery Brooks | Medium | 2026-10-01 12:00:00 | 2026-10-02 12:00:00 | 24.0 |
| 16 | Reporting application needs installation | Taylor Reed | Medium | 2026-10-05 12:00:00 | 2026-10-06 12:00:00 | 24.0 |
| 12 | Sample CRM export has inconsistent dates | Casey Morgan | Medium | 2026-10-04 09:00:00 | 2026-10-04 21:00:00 | 12.0 |
| 7 | Display disconnects during use | Avery Brooks | High | 2026-10-02 12:00:00 | 2026-10-02 20:00:00 | 8.0 |
| 9 | Application update did not finish | Casey Morgan | Low | 2026-10-03 09:00:00 | 2026-10-03 15:00:00 | 6.0 |
| 3 | User cannot open the call-log report | Casey Morgan | High | 2026-10-01 10:00:00 | 2026-10-01 14:00:00 | 4.0 |
| 11 | Network connection repeatedly drops | Jordan Quinn | High | 2026-10-04 08:00:00 | 2026-10-04 12:00:00 | 4.0 |
| 6 | Browser cannot reach the sample CRM | Casey Morgan | Medium | 2026-10-02 10:00:00 | 2026-10-02 13:00:00 | 3.0 |
| 1 | Workstation cannot access the network | Avery Brooks | High | 2026-10-01 08:00:00 | 2026-10-01 10:00:00 | 2.0 |
| 8 | User account cannot access an assigned folder | Jordan Quinn | Medium | 2026-10-03 08:00:00 | 2026-10-03 10:00:00 | 2.0 |
| 5 | Printer is shown as offline | Jordan Quinn | Low | 2026-10-02 09:00:00 | 2026-10-02 10:00:00 | 1.0 |
| 10 | Call audio plays through the monitor | Avery Brooks | Low | 2026-10-03 11:00:00 | 2026-10-03 12:00:00 | 1.0 |
| 2 | Headset microphone is not selected | Jordan Quinn | Medium | 2026-10-01 09:00:00 | 2026-10-01 09:30:00 | 0.5 |

## Overall resolution summary

`queries/04_resolution_summary.sql`

| resolved_tickets | average_resolution_hours | fastest_resolution_hours | slowest_resolution_hours |
| --- | --- | --- | --- |
| 13 | 7.04 | 0.5 | 24.0 |

## Unassigned active tickets

`queries/05_unassigned_active_tickets.sql`

| ticket_id | title | priority | status | requester | asset_tag |
| --- | --- | --- | --- | --- | --- |
| 18 | Laptop cannot connect to the office network | High | Open | Nina Patel | LT-002 |

The original sample results remain in `reports/`. Running `run_project.py` rebuilds those original results and leaves this saved export unchanged.
