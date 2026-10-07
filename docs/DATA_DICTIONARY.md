# Data Dictionary and Design

## users

| Column | Type | Meaning / rule |
| --- | --- | --- |
| `user_id` | INTEGER | Primary key |
| `full_name` | TEXT | Required, nonblank name |
| `department` | TEXT | Required department label |
| `email` | TEXT | Required, unique ignoring letter case |

## technicians

| Column | Type | Meaning / rule |
| --- | --- | --- |
| `technician_id` | INTEGER | Primary key |
| `full_name` | TEXT | Required, nonblank name |
| `email` | TEXT | Required, unique ignoring letter case |

## devices

| Column | Type | Meaning / rule |
| --- | --- | --- |
| `device_id` | INTEGER | Primary key |
| `asset_tag` | TEXT | Required, unique inventory tag |
| `device_type` | TEXT | Desktop, Laptop, Printer, or Headset |
| `operating_system` | TEXT | Optional; NULL for sample peripherals |
| `assigned_user_id` | INTEGER | Optional foreign key to users |

## tickets

| Column | Type | Meaning / rule |
| --- | --- | --- |
| `ticket_id` | INTEGER | Primary key |
| `requester_id` | INTEGER | Required foreign key to users |
| `device_id` | INTEGER | Optional foreign key to devices |
| `assigned_technician_id` | INTEGER | Optional foreign key to technicians; required when resolved |
| `title` | TEXT | Required, nonblank issue description |
| `category` | TEXT | Network, Hardware, Software, Access, or Audio |
| `priority` | TEXT | Low, Medium, High, or Critical |
| `status` | TEXT | Open, In Progress, or Resolved |
| `created_at` | TEXT | Required SQLite-parseable timestamp; sample uses UTC YYYY-MM-DD HH:MM:SS |
| `resolved_at` | TEXT | NULL while active; valid timestamp at/after creation when resolved |
| `resolution_notes` | TEXT | Required, nonblank notes when resolved |

## Relationships and decisions

- One requester can report many tickets. Each ticket requires a known requester.
- One technician can handle many tickets. A ticket can remain unassigned while active.
- One device can be linked to many tickets; an issue can also have no specific device.
- Device user assignments are optional. A ticket requester can report a shared device, so the requester is not forced to match the assigned device user.
- Keeping people and devices separate reduces repeated descriptive data in tickets.
- Foreign keys use the default restriction behavior: referenced records cannot simply be deleted while related records depend on them.
- There is one current assignment and current status per ticket. Assignment/status history would require an additional events table.
- This data model records assignments, not application login roles or security permissions.
