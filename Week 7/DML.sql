-- 1) One that can tell me the names and shifts
-- of the librarians working not the first Monday,
-- but the Monday after
SELECT
    DISTINCT(e.id),
    e.first_name,
    e.last_name,
    s2.id AS "Shift",
    s2.period_name,
    date_schedule,
    day_name
FROM
    schedule s
    JOIN employee e
    ON (s.employee_id = e.id)
    JOIN shift s2
    ON (s.shift_id = s2.id)
    JOIN day_names dn
    ON (DAYOFWEEK(s.date_schedule) = dn.id)
WHERE
    s.date_schedule = "2022-03-21";

-- 2) One that can tell me Beverly Cleary's assignments for that day.
SELECT
    DISTINCT(e.id),
    e.first_name,
    e.last_name,
    date_schedule,
    day_name,
    t.task_description
FROM
    schedule s
    JOIN employee e
    ON (s.employee_id = e.id)
    JOIN task t
    ON (s.task_id = t.id)
    JOIN day_names dn
    ON (DAYOFWEEK(s.date_schedule) = dn.id)
WHERE
    s.date_schedule = "2022-03-21" AND
    e.first_name = "Beverly" AND
    e.last_name = "Cleary";