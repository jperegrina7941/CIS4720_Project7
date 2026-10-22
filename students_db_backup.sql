/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected to students_db, then run the
   whole file. Lab7b walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you get errors,
   because the table already exists and the rows are already there. Step 10
   of the lab explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

-- CREATE TABLE STUDENT (
--     student_id  INT          NOT NULL,
--     first_name  VARCHAR(30)  NOT NULL,
--     last_name   VARCHAR(30)  NOT NULL,
--     major       VARCHAR(40),
--     gpa         DECIMAL(3,2),
--     enrolled_on DATE,
--     PRIMARY KEY (student_id)
-- );


-- -- ======================================================================
-- -- SECTION 3. The data
-- -- Five students. Two enrolled in the same term, which is useful later when
-- -- you start filtering on a date.
-- -- ======================================================================

-- INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
-- INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
-- INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
-- INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
-- INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- -- ======================================================================
-- -- SECTION 4. The view
-- -- A view is a stored SELECT statement you can query as if it were a table.
-- -- This one shows only the names and the grade average, so anyone using it
-- -- cannot reach the id, the major or the enrollment date.
-- -- ======================================================================

-- CREATE VIEW STUDENT_GPA AS
-- SELECT first_name, last_name, gpa
-- FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view, highest grade average first. Three columns, not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema
-- Shows which schema I'm connected to and lists all tables and views in it
SELECT DATABASE() AS my_schema;

-- Lists tables AND views, with a column showing which is which
SHOW FULL TABLES;


-- STEP 12. Section 5.2, look at the data types
-- Shows each column in STUDENT and the data type chosen for it
DESCRIBE STUDENT;

-- STEP 13. Section 5.3, create a table by copying with a subquery
-- Creates a new table by copying selected columns from STUDENT
-- CREATE TABLE STUDENT_COPY AS
-- SELECT student_id, first_name, last_name, gpa
-- FROM STUDENT;

-- Shows the rows copied into the new table
SELECT * FROM STUDENT_COPY;

-- Shows the structure of the copied table (notice: no primary key)
SHOW CREATE TABLE STUDENT_COPY;


-- STEP 14. Section 5.4, change the structure of the copy
-- Adds a new column at the end of the table
-- ALTER TABLE STUDENT_COPY ADD COLUMN honors CHAR(1);

-- -- Widens last_name and keeps NOT NULL so the rule is not removed
-- ALTER TABLE STUDENT_COPY MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

-- -- Adds back the primary key that the copy did not inherit
-- ALTER TABLE STUDENT_COPY ADD PRIMARY KEY (student_id);

-- Shows the updated structure
DESCRIBE STUDENT_COPY;

-- This should fail, proving the primary key constraint works
-- INSERT INTO STUDENT_COPY VALUES (1,'Duplicate','Row',0.00,NULL);

-- Removes the honors column we added earlier
-- ALTER TABLE STUDENT_COPY DROP COLUMN honors;


-- STEP 15. Section 5.5, insert, update and delete a row
-- Inserts a new student into the copy table
-- INSERT INTO STUDENT_COPY VALUES (6,'Omar','Faruqi',3.10);
 SELECT * FROM STUDENT_COPY WHERE student_id = 6;

-- Updates the GPA for the student we just added
-- UPDATE STUDENT_COPY SET gpa = 3.35 WHERE student_id = 6;
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

-- Deletes the student we added
-- DELETE FROM STUDENT_COPY WHERE student_id = 6;
SELECT COUNT(*) AS rows_left FROM STUDENT_COPY;


-- STEP 16. Section 5.6, create a view and update through it
-- Creates a view showing only students whose GPA is 3.50 or higher
-- Create a view of students with GPA 3.50 or higher
-- CREATE VIEW HIGH_GPA AS
-- SELECT student_id, first_name, last_name, gpa
-- FROM STUDENT_COPY
-- WHERE gpa >= 3.50;

-- Check which rows are in the view
SELECT * FROM HIGH_GPA ORDER BY gpa DESC;

-- Before update: look at the real table
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

-- Update through the view (this changes the real table)
-- UPDATE HIGH_GPA SET gpa = 3.95 WHERE student_id = 1;

-- After update: confirm the change in the real table
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

-- Create a non-updatable view using aggregates
-- CREATE VIEW GPA_SUMMARY AS
-- SELECT COUNT(*) AS n, ROUND(AVG(gpa), 2) AS avg_gpa
-- FROM STUDENT_COPY;

-- This should fail (error 1288 is expected)
-- UPDATE GPA_SUMMARY SET avg_gpa = 4.00;
#####################################################################################################
-- STEP 5. Run starter file once to rebuild lab7b tables
-- This step makes sure the STUDENT table and data from lab7b are restored.
-- I run the file once to recreate all tables and rows, then check that there are 5 students
-- and the average GPA is 3.43. After confirming, I comment out all CREATE and INSERT lines
-- so the file can be run again without errors before starting Project 7.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa
FROM STUDENT;
#####################################################################################################
-- =================================================================
-- PROJECT 7 STEP 6. Create the COURSE table
-- =================================================================
-- Creates a table that stores all the courses offered.
-- course_id is the primary key, so each course must have a unique id.
CREATE TABLE COURSE (
    course_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(50) NOT NULL,
    credits INT,
    dept VARCHAR(30),
    PRIMARY KEY (course_id)
);

-- Shows the structure of the COURSE table to confirm course_id is the primary key
DESCRIBE COURSE;
-- =================================================================
-- PROJECT 7 STEP 7. Add rows to COURSE
-- =================================================================
-- Adds five courses across three departments. One course has no students on purpose for Step 11.
INSERT INTO COURSE VALUES (101, 'CIS4720', 'Database Management and SQL', 3, 'CIS');
INSERT INTO COURSE VALUES (102, 'CIS2000', 'Intro to Programming', 3, 'CIS');
INSERT INTO COURSE VALUES (103, 'MATH1600', 'Calculus I', 4, 'Mathematics');
INSERT INTO COURSE VALUES (104, 'BUS2100', 'Principles of Management', 3, 'Business');
INSERT INTO COURSE VALUES (105, 'CIS4850', 'Advanced Python', 3, 'CIS');

-- Shows all five courses to confirm they were added correctly
SELECT * FROM COURSE;
-- =================================================================
-- PROJECT 7 STEP 8. Create the ENROLLMENT table
-- =================================================================
-- Creates a table that connects students to the courses they take.
-- Each row shows one student enrolled in one class.
-- The primary key uses both columns together so the same student
-- can’t be listed twice in the same course.
-- The foreign keys make sure the student and course both exist
-- before an enrollment can be added.
CREATE TABLE ENROLLMENT (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(15),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT (student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE (course_id)
);

-- Shows the structure of the ENROLLMENT table to confirm the keys are set correctly
DESCRIBE ENROLLMENT;
-- =================================================================
-- PROJECT 7 STEP 9. Add rows to ENROLLMENT
-- =================================================================
-- Adds eight enrollments showing which students are in which classes.
-- Student 5 is not listed here on purpose for Step 11.
INSERT INTO ENROLLMENT VALUES (1,101,'Fall 2026','A');
INSERT INTO ENROLLMENT VALUES (1,102,'Fall 2026','B');
INSERT INTO ENROLLMENT VALUES (1,103,'Spring 2026','A');
INSERT INTO ENROLLMENT VALUES (2,101,'Fall 2026','B');
INSERT INTO ENROLLMENT VALUES (2,104,'Fall 2026','C');
INSERT INTO ENROLLMENT VALUES (3,101,'Fall 2026','A');
INSERT INTO ENROLLMENT VALUES (3,103,'Spring 2026','A');
INSERT INTO ENROLLMENT VALUES (4,102,'Fall 2026','C');

-- Checks that eight rows were added to the ENROLLMENT table
SELECT COUNT(*) AS enrollment_rows FROM ENROLLMENT;
-- =================================================================
-- PROJECT 7 STEP 9. Test the key constraints
-- =================================================================
-- Tries to add a student who does not exist. Should fail with ERROR 1452 (foreign key constraint).
-- INSERT INTO ENROLLMENT VALUES (99,101,'Fall 2026','A');

-- -- Tries to add a class that does not exist. Should fail with ERROR 1452 (foreign key constraint).
-- INSERT INTO ENROLLMENT VALUES (1,999,'Fall 2026','A');

-- -- Tries to add a duplicate pairing that already exists. Should fail with ERROR 1062 (duplicate entry for key 'PRIMARY').
-- INSERT INTO ENROLLMENT VALUES (1,101,'Spring 2027','B');

-- =================================================================
-- PROJECT 7 STEP 10. Join one, all three tables together
-- =================================================================
-- Shows every enrollment with the student's name and the course title.
-- ENROLLMENT connects STUDENT and COURSE, so both tables are joined through it.
-- The aliases s, e, and c make the query easier to read.
SELECT s.first_name, s.last_name, c.course_code, c.course_title,
       e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_code;
-- =================================================================
-- PROJECT 7 STEP 11. Join two, an outer join that keeps the rows with no match
-- =================================================================
-- Shows every student and how many classes they are taking.
-- LEFT JOIN keeps all students, even those with no enrollments.
-- If a student has no classes, the course_id column shows NULL.
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS courses_taken
FROM STUDENT s
LEFT JOIN ENROLLMENT e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_taken DESC, s.last_name;

-- =================================================================
-- PROJECT 7 STEP 11A. Classes with no students
-- =================================================================
-- Finds courses that have no students enrolled.
-- LEFT JOIN keeps all courses, even if no one signed up.
-- WHERE e.student_id IS NULL filters to only the empty classes.
SELECT c.course_code, c.course_title
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;
-- =================================================================
-- PROJECT 7 STEP 12. View one, STUDENT_SCHEDULE
-- =================================================================
-- Saves the three-table join from Step 10 as a view.
-- This view shows each student's full class schedule without writing the join again.
CREATE VIEW STUDENT_SCHEDULE AS
SELECT s.first_name, s.last_name, c.course_code, c.course_title,
       e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id;

-- Uses the view to show all enrollments
SELECT * FROM STUDENT_SCHEDULE;

-- Filters the view to show only Ana Reyes
SELECT * FROM STUDENT_SCHEDULE WHERE last_name = 'Reyes';

-- Filters the view to show only the CIS4720 course
SELECT * FROM STUDENT_SCHEDULE WHERE course_code = 'CIS4720';
-- =================================================================
-- PROJECT 7 STEP 13. View two, COURSE_HEADCOUNT
-- =================================================================
-- Shows how many students are in each class.
-- Uses the outer join so empty classes still appear with a count of zero.
CREATE VIEW COURSE_HEADCOUNT AS
SELECT c.course_code, c.course_title,
       COUNT(e.student_id) AS students_enrolled
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title;

-- Lists all courses with the number of students enrolled, highest first
SELECT * FROM COURSE_HEADCOUNT ORDER BY students_enrolled DESC;
-- Shows all tables and views in the database to confirm everything was created.
SHOW FULL TABLES;
-- =================================================================
-- PROJECT 7 STEP 13. Test view update rule
-- =================================================================
-- Tries to update a view that uses an aggregate, which should fail.
-- Expected error: 1288 (the target table COURSE_HEADCOUNT is not updatable)
-- UPDATE COURSE_HEADCOUNT SET students_enrolled = 99 WHERE course_code = 'CIS4720';