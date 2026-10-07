# Saved export verification

The supplied SQLite Fiddle database was opened read-only and checked after the ticket 16 exercise. The included `helpdesk_after_practice.sqlite3` is a byte-for-byte copy of that export. All records describe fictional scenarios.

| Check | Result |
| --- | --- |
| SQLite integrity check | `ok` |
| Foreign-key relationship check | No errors |
| Table counts | 5 users, 4 technicians, 7 devices, 18 tickets |
| Status counts | 3 Open, 2 In Progress, 13 Resolved |
| Active tickets | 5 |
| Unassigned active tickets | 1, ticket 18 |
| Completed ticket | Ticket 16, assigned to technician 104 |
| Completion timestamp | 2026-10-06 12:00:00 UTC |
| Resolution notes | Demo: installed reporting application and verified a sample report. |
| Elapsed duration for ticket 16 | 24 hours |
| Changed records relative to the original sample | Ticket 16 only; users, technicians, and devices match |
| Workflow replay on the original sample | All records in all four tables match the saved export |
| Workflow rerun on the completed sample | Completed records stay unchanged |

To reproduce the saved exercise, load `helpdesk_project.sql` into a new, empty SQLite database, then run `practice/ticket_16_workflow.sql`. To inspect the saved export directly, use SQLite Fiddle's **Load DB...** option and select `practice/helpdesk_after_practice.sqlite3`. Enable `PRAGMA foreign_keys = ON;` on every new SQLite connection before making changes.

The original 16-test suite checks the original dataset independently. Its results and coverage are documented in `docs/TEST_RESULTS.md`.
