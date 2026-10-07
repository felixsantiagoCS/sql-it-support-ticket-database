# IT Support Ticket Reports

Fictional sample data for a portfolio practice project. Sample records: October 1-6, 2026. All timestamps are UTC.

**18 tickets: 12 resolved and 6 active. Sixteen tickets are assigned; two are unassigned.**

## Active tickets by priority

Active means Open or In Progress. Resolved tickets are excluded.

| priority | active_tickets | open_tickets | in_progress_tickets |
| --- | --- | --- | --- |
| Critical | 1 | 1 | 0 |
| High | 3 | 2 | 1 |
| Medium | 1 | 1 | 0 |
| Low | 1 | 0 | 1 |

## Tickets per technician

Includes all four technicians. The two unassigned tickets appear in report 5.

| technician_id | technician | total_assigned_tickets | active_tickets | resolved_tickets |
| --- | --- | --- | --- | --- |
| 101 | Avery Brooks | 6 | 2 | 4 |
| 103 | Casey Morgan | 5 | 1 | 4 |
| 102 | Jordan Quinn | 5 | 1 | 4 |
| 104 | Taylor Reed | 0 | 0 | 0 |

## Resolution times for individual tickets

Elapsed calendar hours from creation to resolution; resolved tickets only.

| ticket_id | title | technician | priority | created_at | resolved_at | resolution_hours |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | Spreadsheet application closes unexpectedly | Avery Brooks | Medium | 2026-10-01 12:00:00 | 2026-10-02 12:00:00 | 24.0 |
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

Average, fastest, and slowest elapsed hours across the 12 resolved tickets.

| resolved_tickets | average_resolution_hours | fastest_resolution_hours | slowest_resolution_hours |
| --- | --- | --- | --- |
| 12 | 5.63 | 0.5 | 24.0 |

## Unassigned active tickets

These two tickets need a technician assignment.

| ticket_id | title | priority | status | requester | asset_tag |
| --- | --- | --- | --- | --- | --- |
| 18 | Laptop cannot connect to the office network | High | Open | Nina Patel | LT-002 |
| 16 | Reporting application needs installation | Medium | Open | Omar Rivera | DT-001 |

## Reading the results

- The active backlog contains 1 Critical, 3 High, 1 Medium, and 1 Low ticket.

- Avery has 2 active tickets; Jordan and Casey have 1 each. Taylor has 0.

- The other 2 active tickets are unassigned.

- Resolved tickets total 67.5 elapsed hours: 67.5 / 12 = 5.625, displayed as 5.63 average hours.

- This sample does not establish service-level targets or technician performance. No business-hours adjustment is applied.
