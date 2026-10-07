"""Verify report arithmetic, missing assignments, and ticket data integrity."""
import sqlite3
import unittest
from run_project import ROOT, sample_connection, report_results

class HelpdeskTests(unittest.TestCase):
    def setUp(self):
        self.connection = sample_connection()

    def tearDown(self):
        self.connection.close()

    def query(self, filename):
        return report_results(self.connection, ROOT / 'queries' / filename)[1]

    def insert_ticket(self, **changes):
        values = dict(ticket_id=50, requester_id=1, device_id=1,
                      assigned_technician_id=None, title='A new sample issue',
                      category='Software', priority='Medium', status='Open',
                      created_at='2026-10-06 10:00:00', resolved_at=None,
                      resolution_notes=None)
        values.update(changes)
        columns = ', '.join(values)
        parameters = ', '.join('?' for _ in values)
        self.connection.execute('INSERT INTO tickets (' + columns + ') VALUES ('
                                + parameters + ')', list(values.values()))

    def test_sample_counts_and_foreign_keys(self):
        expected = {'users': 5, 'technicians': 4, 'devices': 7, 'tickets': 18}
        for table, total in expected.items():
            self.assertEqual(self.connection.execute('SELECT COUNT(*) FROM ' + table).fetchone()[0], total)
        self.assertEqual(self.connection.execute('PRAGMA foreign_key_check').fetchall(), [])
        self.assertEqual(self.connection.execute('PRAGMA integrity_check').fetchone()[0], 'ok')

    def test_active_backlog_counts_and_severity_order(self):
        self.assertEqual(self.query('01_open_tickets_by_priority.sql'),
                         [('Critical', 1, 1, 0), ('High', 3, 2, 1),
                          ('Medium', 1, 1, 0), ('Low', 1, 0, 1)])

    def test_workload_includes_zero_ticket_technician(self):
        self.assertEqual(self.query('02_tickets_per_technician.sql'),
                         [(101, 'Avery Brooks', 6, 2, 4),
                          (103, 'Casey Morgan', 5, 1, 4),
                          (102, 'Jordan Quinn', 5, 1, 4),
                          (104, 'Taylor Reed', 0, 0, 0)])

    def test_resolution_hours_match_manually_calculated_values(self):
        expected = {1: 2.0, 2: 0.5, 3: 4.0, 4: 24.0, 5: 1.0, 6: 3.0,
                    7: 8.0, 8: 2.0, 9: 6.0, 10: 1.0, 11: 4.0, 12: 12.0}
        rows = self.query('03_resolution_times.sql')
        self.assertEqual({row[0]: row[-1] for row in rows}, expected)
        self.assertEqual(rows[0][0], 4)
        self.assertEqual(rows[-1][0], 2)

    def test_resolution_summary_excludes_unresolved_tickets(self):
        self.assertEqual(self.query('04_resolution_summary.sql'), [(12, 5.63, 0.5, 24.0)])

    def test_unassigned_tickets_are_reported(self):
        self.assertEqual([row[0] for row in self.query('05_unassigned_active_tickets.sql')], [18, 16])

    def test_unknown_requester_is_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.insert_ticket(requester_id=999)

    def test_unknown_device_and_technician_are_rejected(self):
        for field in ['device_id', 'assigned_technician_id']:
            with self.subTest(field=field), self.assertRaises(sqlite3.IntegrityError):
                self.insert_ticket(**{field: 999})

    def test_invalid_priority_and_status_are_rejected(self):
        for changes in [{'priority': 'Urgent'}, {'status': 'Done'}]:
            with self.subTest(changes=changes), self.assertRaises(sqlite3.IntegrityError):
                self.insert_ticket(**changes)

    def test_resolution_before_creation_is_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.insert_ticket(status='Resolved', assigned_technician_id=101,
                               resolved_at='2026-10-06 09:00:00', resolution_notes='Sample fix')

    def test_resolved_ticket_requires_timestamp_technician_and_notes(self):
        complete = dict(status='Resolved', assigned_technician_id=101,
                        resolved_at='2026-10-06 11:00:00', resolution_notes='Sample fix')
        for field in ['assigned_technician_id', 'resolved_at', 'resolution_notes']:
            invalid = {**complete, field: None}
            with self.subTest(field=field), self.assertRaises(sqlite3.IntegrityError):
                self.insert_ticket(**invalid)

    def test_active_ticket_cannot_have_resolution_timestamp(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.insert_ticket(resolved_at='2026-10-06 11:00:00')

    def test_invalid_creation_timestamp_is_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.insert_ticket(created_at='not a timestamp')

    def test_optional_device_is_preserved_by_left_join(self):
        self.connection.execute('UPDATE tickets SET device_id = NULL WHERE ticket_id = 18')
        row = self.query('05_unassigned_active_tickets.sql')[0]
        self.assertEqual(row[0], 18)
        self.assertEqual(row[-1], 'No device recorded')

    def test_ticket_can_progress_through_valid_workflow(self):
        self.connection.execute("UPDATE tickets SET assigned_technician_id = 104, status = 'In Progress' WHERE ticket_id = 16")
        self.connection.execute("UPDATE tickets SET status = 'Resolved', resolved_at = '2026-10-06 12:00:00', resolution_notes = 'Installed and tested the sample application.' WHERE ticket_id = 16")
        taylor = [row for row in self.query('02_tickets_per_technician.sql') if row[0] == 104][0]
        self.assertEqual(taylor, (104, 'Taylor Reed', 1, 0, 1))
        ticket = [row for row in self.query('03_resolution_times.sql') if row[0] == 16][0]
        self.assertEqual(ticket[-1], 24.0)

    def test_duplicate_email_and_referenced_user_deletion_are_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.connection.execute("INSERT INTO users VALUES (90, 'Sample User', 'Records', 'SARA.LOPEZ@example.com')")
        with self.assertRaises(sqlite3.IntegrityError):
            self.connection.execute('DELETE FROM users WHERE user_id = 1')

if __name__ == '__main__':
    unittest.main(verbosity=2)
