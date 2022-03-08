-- CREATE TABLE EMPLOYEE.
-- HOLDS EMPLOYEE DATA
CREATE TABLE
    IF NOT EXISTS employee (
        id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL
    );

-- CREATE TABLE SHIFT.
-- HOLDS SHIT DATA, date, beginning and end date
CREATE TABLE
    IF NOT EXISTS shift (
        id INT PRIMARY KEY,
        period_name VARCHAR(50) NOT NULL,
        begin_time TIME NOT NULL,
        end_time TIME NOT NULL
    );

-- Create tasks table
-- Holds tasks data
CREATE TABLE
    IF NOT EXISTS task (
        id INT AUTO_INCREMENT PRIMARY KEY,
        task_description VARCHAR(100) NOT NULL UNIQUE
    );

-- CREATE Schedule table / Holds data about schedule -- Considered date an attribute of schedule table
CREATE TABLE
    IF NOT EXISTS schedule (
        id INT AUTO_INCREMENT PRIMARY KEY,
        employee_id INT,
        task_id INT,
        shift_id INT,
        date_schedule DATE NOT NULL,
        FOREIGN KEY (employee_id) REFERENCES employee(id),
        FOREIGN KEY (task_id) REFERENCES task(id),
        FOREIGN KEY (shift_id) REFERENCES shift(id)
    );

--CREATES A TRANSLATE DATE TABLE
-- This table is going to be used to translate days num returned from DAYOFWEEK function
CREATE TABLE
    IF NOT EXISTS day_names (id INT PRIMARY KEY, day_name VARCHAR(16) UNIQUE NOT NULL) -- INSERT EMPLOYEE ROWS INTO EMPLOYEE TABLE
INSERT INTO
    employee (first_name, last_name)
VALUES
    ("Jesse", "Shera"),
    ("Anne Carroll", "Moore"),
    ("Beverly", "Cleary"),
    ("Marcel", "Duchamp"),
    ("Carla", "Hayden"),
    ("Audre", "Lorde"),
    ("Melvil", "Dewey"),
    ("Dolly", "Parton");

-- Insert Shifts rows.
-- I considered shifts exists regarless of date.
-- Therefore, I have removed "date" from the shift table
INSERT INTO
    shift (id, period_name, begin_time, end_time)
VALUES
    (1, 'Morning', '08:00', '12:00'),
    (2, 'Afternoon', '12:00', '16:00');

-- Insert data into assignment table.
INSERT INTO
    task(task_description)
VALUES
    ("main desk"),
    ("catalogue"),
    ("children's library"),
    ("reference");

-- Insert DATA into schedule table
INSERT INTO
    schedule(employee_id, shift_id, date_schedule, task_id)
VALUES
    -- Jesse Shera  1 / shift 1 / day 03/14/2022  / task 1 and 2
    (1, 1, "2022-03-14", 1),
    (1, 1, "2022-03-14", 2),
    -- Anne Carroll Moore 2 / shift 2 / day 03/14/2022 / task 3
    (2, 2, "2022-03-14", 3),
    -- Beverly Cleary 3 / shift 1 / day 03/14/2022 / tasks 4 and 2
    (3, 1, "2022-03-14", 4),
    (3, 1, "2022-03-14", 2),
    -- Marcel Duchamp 4 / shift 1 / day 03/15/2022 / task 1 and 4
    (4, 1, "2022-03-15", 1),
    (4, 1, "2022-03-15", 4),
    -- Carla Hayden 5 / shift 2 / day 03/15/2022 / task 1 and 2
    (5, 2, "2022-03-15", 1),
    (5, 2, "2022-03-15", 2),
    -- Lorde 6 / shift 1 / day 03/16/2022 / task 1 and 2
    (6, 1, "2022-03-16", 1),
    (6, 1, "2022-03-16", 2),
    -- Melvin Dewey 7 / shift 1 / 03/21/2022 / task 1 and 4
    (7, 1, "2022-03-21", 1),
    (7, 1, "2022-03-21", 4),
    -- Parton 8 / shift 1 / 03/21/2022 / task 3
    (8, 1, "2022-03-21", 3),
    -- Beverly Cleary 3 / shift 1 / 03/21/2022 / task 2 and 4
    (3, 1, "2022-03-21", 4),
    (3, 1, "2022-03-21", 2),
    -- Marcel Duchamp 4 / shift 1 / day 03/22/2022 / task 1 and 4
    (4, 1, "2022-03-22", 1),
    (4, 1, "2022-03-22", 4),
    -- Carla Hayden 5 / shift 2 / day 03/22/2022 / task 1 and 2
    (5, 2, "2022-03-22", 1),
    (5, 2, "2022-03-22", 2),
    -- Lorde 6 / shift 1 / day 03/23/2022 / task 1 and 2
    (6, 1, "2022-03-23", 1),
    (6, 1, "2022-03-23", 2);

-- Inserts data into day_names table.
INSERT INTO
    day_names(id, day_name)
VALUES
    (1, "Sunday"),
    (2, "Monday"),
    (3, "Tuesday"),
    (4, "Wednesday"),
    (5, "Thursday"),
    (6, "Friday"),
    (7, "Saturday");