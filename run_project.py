"""Build a sample SQLite database and produce Markdown, HTML, and CSV reports.

Only Python's standard library is used. Every run starts with the supplied
fictional data in memory and refreshes the generated example outputs.
"""
from pathlib import Path
import csv
import html
import sqlite3

ROOT = Path(__file__).resolve().parent
REPORTS = ROOT / 'reports'

REPORT_INFO = {
    '01_open_tickets_by_priority': (
        'Active tickets by priority',
        'Active means Open or In Progress. Resolved tickets are excluded.'),
    '02_tickets_per_technician': (
        'Tickets per technician',
        'Includes all four technicians. The two unassigned tickets appear in report 5.'),
    '03_resolution_times': (
        'Resolution times for individual tickets',
        'Elapsed calendar hours from creation to resolution; resolved tickets only.'),
    '04_resolution_summary': (
        'Overall resolution summary',
        'Average, fastest, and slowest elapsed hours across the 12 resolved tickets.'),
    '05_unassigned_active_tickets': (
        'Unassigned active tickets',
        'These two tickets need a technician assignment.'),
}

def sample_connection():
    connection = sqlite3.connect(':memory:')
    connection.execute('PRAGMA foreign_keys = ON')
    connection.executescript((ROOT / '00_schema.sql').read_text(encoding='utf-8'))
    connection.executescript((ROOT / '01_sample_data.sql').read_text(encoding='utf-8'))
    return connection

def report_results(connection, query_path):
    cursor = connection.execute(query_path.read_text(encoding='utf-8'))
    return [col[0] for col in cursor.description], cursor.fetchall()

def display(value):
    return '' if value is None else str(value)

def markdown_table(headers, rows):
    def line(values):
        return '| ' + ' | '.join(display(v).replace('|', '\\|') for v in values) + ' |'
    return '\n'.join([line(headers), line(['---'] * len(headers))]
                     + [line(row) for row in rows])

def main():
    REPORTS.mkdir(exist_ok=True)
    markdown = ['# IT Support Ticket Reports',
                'Fictional sample data for a portfolio practice project. '
                'Sample records: October 1-6, 2026. All timestamps are UTC.',
                '**18 tickets: 12 resolved and 6 active. '
                'Sixteen tickets are assigned; two are unassigned.**']
    html_parts = []
    with sample_connection() as connection:
        assert connection.execute('PRAGMA foreign_key_check').fetchall() == []
        assert connection.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        for query in sorted((ROOT / 'queries').glob('*.sql')):
            headers, rows = report_results(connection, query)
            title, meaning = REPORT_INFO[query.stem]
            with (REPORTS / (query.stem + '.csv')).open('w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow(headers)
                writer.writerows(rows)
            markdown += ['## ' + title, meaning, markdown_table(headers, rows)]
            cells = '<tr>' + ''.join('<th>' + html.escape(h) + '</th>' for h in headers) + '</tr>'
            for row in rows:
                cells += '<tr>' + ''.join('<td>' + html.escape(display(v)) + '</td>' for v in row) + '</tr>'
            html_parts.append('<section><h2>' + html.escape(title) + '</h2><p>'
                              + html.escape(meaning) + '</p><div class="table-wrap"><table>'
                              + cells + '</table></div></section>')
            print(title + ': ' + str(len(rows)) + ' result rows')
        # This filename is generated output, refreshed from sample data on each run.
        database_path = ROOT / 'helpdesk_demo.db'
        if database_path.exists():
            database_path.unlink()
        with sqlite3.connect(database_path) as destination:
            connection.backup(destination)
    markdown += ['## Reading the results',
                 '- The active backlog contains 1 Critical, 3 High, 1 Medium, and 1 Low ticket.',
                 '- Avery has 2 active tickets; Jordan and Casey have 1 each. Taylor has 0.',
                 '- The other 2 active tickets are unassigned.',
                 '- Resolved tickets total 67.5 elapsed hours: 67.5 / 12 = 5.625, '
                 'displayed as 5.63 average hours.',
                 '- This sample does not establish service-level targets or technician performance. '
                 'No business-hours adjustment is applied.']
    (REPORTS / 'REPORTS.md').write_text('\n\n'.join(markdown) + '\n', encoding='utf-8')
    page = '''<!doctype html><html lang="en"><head><meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>SQL Support Ticket Reports</title><style>
    body{font:15px/1.5 Arial,sans-serif;color:#233244;background:#f2f5f8;margin:0}
    main{max-width:1100px;margin:32px auto;padding:28px;background:white;border-radius:12px}
    h1,h2{color:#213d5b}h1{margin-top:0}h2{font-size:20px}section{margin:30px 0}
    .stats{padding:14px;background:#e9f0f7;border-left:4px solid #213d5b}
    .table-wrap{overflow-x:auto}table{border-collapse:collapse;width:100%;font-size:13px}
    th,td{border-bottom:1px solid #dce3e9;text-align:left;padding:9px;vertical-align:top}
    th{background:#edf2f7}tbody tr:nth-child(even){background:#f7f9fb}
    @media print{body{background:white}main{margin:0;padding:0}section{break-inside:avoid}}
    </style></head><body><main><h1>IT Support Ticket Reports</h1>
    <p>Fictional sample data for a SQL portfolio practice project. October 1-6, 2026; UTC timestamps.</p>
    <p class="stats"><strong>18 tickets | 12 resolved | 6 active | 2 unassigned</strong></p>
    ''' + ''.join(html_parts) + '''<p>Resolution time means elapsed calendar hours, not active work time.
    These sample results do not establish service-level targets or technician performance.</p>
    </main></body></html>'''
    (REPORTS / 'report_preview.html').write_text(page, encoding='utf-8')
    combined = ['-- Run once in a NEW, EMPTY SQLite database.\n']
    combined += [(ROOT / name).read_text(encoding='utf-8') for name in ['00_schema.sql', '01_sample_data.sql']]
    for query in sorted((ROOT / 'queries').glob('*.sql')):
        combined.append('\n-- REPORT: ' + REPORT_INFO[query.stem][0] + '\n' + query.read_text(encoding='utf-8'))
    (ROOT / 'helpdesk_project.sql').write_text('\n\n'.join(combined), encoding='utf-8')
    print('Created helpdesk_demo.db, helpdesk_project.sql, and reports/.')

if __name__ == '__main__':
    main()
