-- Question: Which active tickets still need a technician?
-- LEFT JOIN preserves tickets even when no device has been recorded.
SELECT
    t.ticket_id,
    t.title,
    t.priority,
    t.status,
    u.full_name AS requester,
    COALESCE(d.asset_tag, 'No device recorded') AS asset_tag
FROM tickets AS t
JOIN users AS u ON u.user_id = t.requester_id
LEFT JOIN devices AS d ON d.device_id = t.device_id
WHERE t.assigned_technician_id IS NULL
  AND t.status IN ('Open', 'In Progress')
ORDER BY CASE t.priority
    WHEN 'Critical' THEN 1
    WHEN 'High' THEN 2
    WHEN 'Medium' THEN 3
    WHEN 'Low' THEN 4
END, t.created_at, t.ticket_id;
