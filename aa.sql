/*=========================================================
  SCHOOL MANAGEMENT ANALYSIS PROJECT - SQL PORTFOLIO
  ========================================================= */
  create database school
  use school
  go

/*---------------- PART 1: SCHEMA CREATION ---------------- */

DROP TABLE IF EXISTS exam_results;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS teachers;

CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50),
    grade_level INT
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    subject_specialty VARCHAR(50)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    class_id INT,
    enrollment_date DATE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    date DATE,
    status VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE exam_results (
    result_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    marks INT,
    exam_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


/* ---------------- PART 2: SAMPLE DATA ---------------- */

INSERT INTO classes VALUES
(1,'Grade 10-A',10),
(2,'Grade 10-B',10),
(3,'Grade 11-A',11);

INSERT INTO teachers VALUES
(1,'John','Smith','Math'),
(2,'Sarah','Johnson','English'),
(3,'Ali','Khan','Science');

INSERT INTO students VALUES
(1,'Ahmed','Ali','Male',1,'2023-09-01'),
(2,'Sara','Ahmed','Female',1,'2023-09-01'),
(3,'Usman','Khan','Male',2,'2023-09-01');

INSERT INTO subjects VALUES
(1,'Math',1),
(2,'English',2),
(3,'Science',3);

INSERT INTO attendance VALUES
(1,1,'2024-01-10','Present'),
(2,1,'2024-01-11','Absent'),
(3,2,'2024-01-10','Present');

INSERT INTO exam_results VALUES
(1,1,1,85,'2024-02-01'),
(2,1,2,78,'2024-02-01'),
(3,2,1,90,'2024-02-01');


/* ---------------- PART 3: ANALYTICAL QUERIES ---------------- */

-- 1. Average marks per student
SELECT 
    s.student_id,
    s.first_name,
    AVG(er.marks) AS avg_marks
FROM students s
JOIN exam_results er ON s.student_id = er.student_id
GROUP BY s.student_id, s.first_name;

-- 2. Top performing students
SELECT 
    s.first_name,
    SUM(er.marks) AS total_marks
FROM students s
JOIN exam_results er ON s.student_id = er.student_id
GROUP BY s.student_id
ORDER BY total_marks DESC;

-- 3. Attendance percentage
SELECT 
    s.first_name,
    COUNT(CASE WHEN a.status='Present' THEN 1 END)*100.0/COUNT(*) AS attendance_pct
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id;

-- 4. Subject wise average marks
SELECT 
    sub.subject_name,
    AVG(er.marks) AS avg_marks
FROM exam_results er
JOIN subjects sub ON er.subject_id = sub.subject_id
GROUP BY sub.subject_name;

-- 5. Class performance
SELECT 
    c.class_name,
    AVG(er.marks) AS class_avg
FROM classes c
JOIN students s ON c.class_id = s.class_id
JOIN exam_results er ON s.student_id = er.student_id
GROUP BY c.class_name;