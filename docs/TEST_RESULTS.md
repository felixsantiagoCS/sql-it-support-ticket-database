# Test Results

Validation run: October 7, 2026 UTC (October 6 in Florida). Python 3.12.14; SQLite 3.53.1.

**Result: all 16 tests passed.** Tests run against fresh in-memory sample databases; the delivered sample database keeps its original 18 records.

## Independently expected results

| Measure | Expected | Observed |
| --- | --- | --- |
| Users / technicians / devices / tickets | 5 / 4 / 7 / 18 | 5 / 4 / 7 / 18 |
| Active / resolved tickets | 6 / 12 | 6 / 12 |
| Assigned / unassigned tickets | 16 / 2 | 16 / 2 |
| Active tickets by Critical / High / Medium / Low | 1 / 3 / 1 / 1 | 1 / 3 / 1 / 1 |
| Avery / Casey / Jordan / Taylor assigned tickets | 6 / 5 / 5 / 0 | 6 / 5 / 5 / 0 |
| Average resolved elapsed hours | 67.5 / 12 = 5.625, rounded to 5.63 | 5.63 |
| Minimum / maximum resolved elapsed hours | 0.5 / 24.0 | 0.5 / 24.0 |
| Foreign-key inconsistencies | 0 | 0 |
| SQLite integrity check | ok | ok |

The individually calculated elapsed hours for tickets 1-12 are: 2, 0.5, 4, 24, 1, 3, 8, 2, 6, 1, 4, and 12. Their sum is 67.5 hours.

## Checks performed

| Test | Result |
| --- | --- |
| Sample row counts, foreign keys, and database integrity | PASS |
| Active-ticket counts and correct severity ordering | PASS |
| Technician workloads including a zero-ticket technician | PASS |
| Each resolution time against manually calculated values | PASS |
| Resolution summary excluding unresolved tickets | PASS |
| Unassigned active tickets appear in their report | PASS |
| Unknown requester is rejected | PASS |
| Unknown device and technician are rejected | PASS |
| Invalid priority and status are rejected | PASS |
| Resolution before creation is rejected | PASS |
| Resolved status requires timestamp, technician, and notes | PASS |
| Active ticket cannot have a resolution timestamp | PASS |
| Invalid creation timestamp is rejected | PASS |
| Ticket without a device remains visible in the left-join report | PASS |
| Ticket can move from Open to In Progress to Resolved | PASS |
| Duplicate email and deletion of a referenced user are rejected | PASS |

## Reproduce the checks

```text
py test_project.py
```

Or use `python test_project.py` where Python is available under that command. The final result should say `Ran 16 tests` and `OK`.

The workflow test temporarily assigns ticket 16 to Taylor and resolves it after 24 hours. It checks the new technician total and the resolution report. Other tests deliberately insert or update bad records and confirm that the database rejects them.
