/*Drop VIEW*/
/*Drop FUNCTIONS*/
DROP FUNCTION IF EXISTS getPerson;

/*DROP VIEW*/
DROP VIEW if EXISTS report;


/*DROP TRIGGERS*/
DROP TRIGGER if EXISTS log_tasks_create;

DROP TRIGGER if EXISTS log_tasks_create;

DROP TRIGGER if EXISTS log_tasks_updates;

/*DROP TABLES*/
DROP TABLE
    if EXISTS task_log;

DROP TABLE
    if EXISTS task2;

DROP TABLE
    if EXISTS course;

DROP TABLE
    if EXISTS student;

DROP TABLE
    if EXISTS person;

DROP TABLE
    if EXISTS institution;

DROP TABLE
    if EXISTS status;

/*Creates Person Entity. 
 * Email is unique because it is going to be used for login. 
 * Id will be used to anonymize in analytical studies and identify customers internally*/
CREATE TABLE
    if NOT EXISTS person (
        id INT PRIMARY KEY AUTO_INCREMENT,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL
    );

/* TEST -  Insert into person*/
INSERT INTO
    person (first_name, last_name, email)
VALUES
    ("Veveto", "Xavs", "veve@test.com"),
    ("Nicoli", "Mayumi", "ninini@test.com"),
    ("Dayane", "Kosteck", "dayday@test.com"),
    ("Daniel", "Freitas", "dandan@test.com"),
    ("Lari", "Batista", "larilari@test.com");

/*Creates Institution Entity.*/
CREATE TABLE
    if NOT EXISTS institution (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL UNIQUE,
        address VARCHAR(200)
    );

/*TEST -  Insert into institution*/
INSERT INTO
    institution(name, address)
VALUES
    ("Humber", "Toronto"),
    ("Langara", "Vancouver"),
    ("Conestoga", "Waterloo"),
    ("Algonquin", "Otawa");

/*Creates Student Entity.*/
CREATE TABLE
    if NOT EXISTS student (
        id INT AUTO_INCREMENT PRIMARY KEY,
        register_id VARCHAR(10),
        institution_id INT,
        person_id INT,
        FOREIGN KEY (institution_id) REFERENCES institution (id),
        FOREIGN KEY (person_id) REFERENCES person(id)
        ON
        UPDATE
            CASCADE,
            FOREIGN KEY (person_id) REFERENCES person (id)
            ON
        UPDATE
            CASCADE
            
    );

/*Insert into student table*/
INSERT INTO
    student (register_id, institution_id, person_id)
VALUES
    ("n11111", 1, 1),
    ("n11111", 1, 2),
    ("n22221", 1, 3),
    ("n33311", 1, 4),
    ("n23231", 2, 4),
    ("n12121", 3, 4),
    ("n11111", 1, 5);

/*Creates Course Entity.*/
CREATE TABLE
    if NOT EXISTS course (
        id int PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(10) NOT NULL,
        description VARCHAR(100) NOT NULL
        /*created_by VARCHAR(10),
        FOREIGN KEY (created_by) REFERENCES student (register_id)
        PRIMARY KEY (id,created_by)*/
    );

/*Insert into course table*/
INSERT INTO
    course (`name`, description)
VALUES
    ("S1212", "SQL Course"),
    ("C1213", "C Sharp"),
    ("E1232", "Poetry"),
    ("T12", "Course"),
    ("T1212", "SQL Course");

/*Insert into Status Table*/
CREATE TABLE
    if NOT EXISTS status (
        id INT PRIMARY KEY AUTO_INCREMENT,
        description VARCHAR(100) NOT NULL UNIQUE
    );

/*Insert into Status Table*/
INSERT INTO
    status (description)
VALUES
    ("Created"),
    ("Ongoing"),
    ("Finished"),
    ("Deleted");

/*Creates Task Entity.*/
CREATE TABLE
    if NOT EXISTS task2 (
        id INT PRIMARY KEY AUTO_INCREMENT,
        description VARCHAR(100) NOT NULL,
        due_date DATE,
        hours_spent TIME,
        course_id int,
        status_id INT,
        student_id INT,
        FOREIGN KEY (course_id) REFERENCES course (id)
        ON
        UPDATE
            CASCADE,
            FOREIGN KEY (status_id) REFERENCES status (id)
            ON
        UPDATE
            CASCADE,
            FOREIGN KEY (student_id) REFERENCES student (id)
            ON
        UPDATE
            CASCADE
    );

/*Create table to log changes in Task table*/
CREATE TABLE
    if NOT EXISTS task_log(
        change_id INT AUTO_INCREMENT PRIMARY KEY,
        `action` VARCHAR(100),
        task_id INT,
        change_ocurred DATE,
        status_origin INT,
        status_destiny INT

    );

/*CREATES TRIGGER FOR UPDATES ins the STATUS of TASK2 rows*/
DELIMITER // 
CREATE TRIGGER log_tasks_updates AFTER
UPDATE
    ON task2 FOR EACH ROW BEGIN IF NEW.status_id <> OLD.status_id
    THEN
INSERT INTO
    task_log (
        `action`,
        task_id,
        status_origin,
        status_destiny,
        change_ocurred
    )
VALUES
    (
        'update',
        NEW.id,
        OLD.status_id,
        NEW.status_id,
        NOW()
    );

END IF;

END;

// 
DELIMITER ;

/*CREATES TRIGGER FOR INSERTS TASK2*/
DELIMITER //
CREATE TRIGGER log_tasks_create AFTER INSERT
ON task2 FOR EACH ROW BEGIN
INSERT INTO
    task_log (
        `action`,
        task_id,
        status_origin,
        status_destiny,
        change_ocurred
    )
VALUES
    ('create', NEW.id, NULL, NEW.status_id, NOW());

END;

//
DELIMITER ;

/*CREATES TRIGGER FOR DELETES TASK2*/
DELIMITER // 
CREATE TRIGGER log_tasks_delete BEFORE DELETE
ON task2 FOR EACH ROW BEGIN
INSERT INTO
    task_log (
        `action`,
        task_id,
        status_origin,
        status_destiny,
        change_ocurred
    )
VALUES
    ('removed', OLD.id, OLD.status_id, NULL, NOW());

END;

// 

DELIMITER ;
/*Insert into Task2*/
INSERT INTO
    task2(course_id, status_id, student_id, description)
VALUES
    (1, 1, 1, "Task blabla 01"),
    (2, 2, 2, "Task blabla 02"),
    (2, 1, 3, "Task blabla 01"),
    (3, 3, 4, "Task blabla 03"),
    (4, 3, 5, "Task blabla 04"),
    (2, 1, 6, "Task blabla 05"),
    (5, 1, 7, "Task blabla 06"),
    (2, 1, 1, "Task blabla 07"),
    (5, 2, 2, "Task blabla 08"),
    (3, 1, 3, "Task blabla 09"),
    (5, 3, 1, "Task blabla 00"),
    (1, 1, 2, "Task blabla 01"),
    (2, 2, 3, "Task blabla 02"),
    (2, 1, 4, "Task blabla 01"),
    (3, 3, 5, "Task blabla 03"),
    (4, 3, 6, "Task blabla 04"),
    (2, 1, 7, "Task blabla 05"),
    (5, 1, 5, "Task blabla 06"),
    (2, 1, 4, "Task blabla 07"),
    (5, 2, 3, "Task blabla 08"),
    (3, 1, 2, "Task blabla 09"),
    (5, 3, 1, "Task blabla 00"),
    (2, 1, 2, "Task blabla 01");
/*Updating some values to see if triggers are correct*/
UPDATE
    task2
SET
    description = "updated description"
WHERE
    id = 1;

UPDATE
    task2
SET
    status_id = 2
WHERE
    (id % 2) =0;

UPDATE
    task2
SET
    status_id = 3
WHERE
    (id % 2) <>0;

/*Deleting a task to check trigger*/
DELETE FROM task2 WHERE id = 1;
    
   

/*Create Function this functions is used inside the view and is used to return the value of @var*/
CREATE FUNCTION getPerson() RETURNS VARCHAR(200)
  RETURN @person;

/*Create View this view shows every task of a person (excluding deleted tasks)*/
CREATE VIEW report AS
  SELECT t.`description` as "task_description", t.due_date ,t.hours_spent, s.`description`as "status_description", i.name , s2.register_id  , c.`name` as "course_name",c.description as course_description 
  FROM task2 t 
    JOIN status s ON (t.status_id = s.id) 
    JOIN course c ON (c.id = t.course_id) 
    JOIN student s2 ON (s2.id = t.student_id)
    JOIN person p ON (p.id = s2.person_id)
    JOIN institution i ON (i.id = s2.institution_id)
  WHERE p.email = getPerson() AND s.id <>4;

 /*TESTING VIEW- Person Options:veve@test.com, ninini@test.com, dayday@test.com, dandan@test.com, larilari@test.com*/
SET @person = "dandan@test.com";
SELECT * FROM report;

/*Procedure*/

DELIMITER //
CREATE PROCEDURE cleanTasks ()
BEGIN
  DELETE from task2
  WHERE status = 4;
END;
//
DELIMITER ;

