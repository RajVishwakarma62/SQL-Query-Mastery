-- 1. Use the Database
USE SQL_Interview_Practice;
GO

-- 2. THE CLEAN SLATE: Drop constraints and tables if they exist
-- (We drop the constraint first because employees and departments rely on each other)
ALTER TABLE departments DROP CONSTRAINT IF EXISTS fk_dept_manager;

-- Drop child tables first, then parent tables
DROP TABLE IF EXISTS salary_history;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
GO

-- 3. CREATE CORE TABLES
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    manager_id INT,
    budget DECIMAL(15,2),
    creation_date DATE
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(15,2),
    department_id INT REFERENCES departments (department_id),
    manager_id INT REFERENCES employees(id),
    hire_date DATE,
    join_date DATE,
    gender VARCHAR(1),
    job_title VARCHAR(100),
    birth_date DATE,
    termination_date DATE
);

-- 4. TIE THEM TOGETHER
ALTER TABLE departments
ADD CONSTRAINT fk_dept_manager FOREIGN KEY (manager_id) REFERENCES employees(id);
GO

-- ============================================================================
-- 5. INSERT MOCK DATA: DEPARTMENTS
-- ============================================================================
INSERT INTO departments (department_id, department_name, manager_id, budget, creation_date) VALUES 
(1, 'Executive', NULL, 10000000.00, '2015-01-01'),
(2, 'IT', NULL, 4500000.00, '2015-06-15'),
(3, 'Sales', NULL, 3500000.00, '2016-02-20'),
(4, 'Human Resources', NULL, 1200000.00, '2015-03-10'),
(5, 'Marketing', NULL, 2000000.00, '2017-08-01'),
(6, 'Finance', NULL, 1800000.00, '2016-01-15'),
(7, 'Operations', NULL, 2500000.00, '2018-11-05'); -- Intentionally left with 0 employees for edge cases

-- ============================================================================
-- 6. INSERT MOCK DATA: EMPLOYEES
-- ============================================================================
INSERT INTO employees (id, name, salary, department_id, manager_id, hire_date, join_date, gender, job_title, birth_date, termination_date) VALUES 
(1, 'Alice Smith', 350000.00, 1, NULL, '2015-01-10', '2015-01-10', 'F', 'CEO', '1980-05-14', NULL),
(2, 'Bob Johnson', 250000.00, 2, 1, '2015-06-20', '2015-06-20', 'M', 'CTO', '1982-08-22', NULL),
(3, 'Charlie Davis', 240000.00, 3, 1, '2016-03-01', '2016-03-01', 'M', 'VP of Sales', '1981-11-30', NULL),
(4, 'Diana Prince', 150000.00, 2, 2, '2018-04-12', '2018-04-12', 'F', 'IT Director', '1985-02-15', NULL),
(5, 'Evan Wright', 160000.00, 2, 4, '2019-07-23', '2019-07-23', 'M', 'Principal Engineer', '1988-09-10', NULL), 
(6, 'Frank Castle', 110000.00, 2, 5, '2020-01-15', '2020-01-15', 'M', 'Software Engineer', '1992-11-01', NULL),
(7, 'Grace Hopper', 120000.00, 2, 5, '2021-05-10', '2021-05-10', 'F', 'Data Scientist', '1994-03-22', NULL),
(8, 'Henry Ford', 95000.00, 2, 5, '2022-08-01', '2022-08-01', 'M', 'QA Engineer', '1996-07-14', NULL),
(9, 'Irene Adler', 130000.00, 3, 3, '2017-02-01', '2017-02-01', 'F', 'Regional Sales Manager', '1987-12-12', NULL),
(10, 'Jack Bauer', 85000.00, 3, 9, '2019-03-15', '2019-03-15', 'M', 'Account Executive', '1990-05-24', NULL),
(11, 'Karen Page', 85000.00, 3, 9, '2020-11-01', '2020-11-01', 'F', 'Account Executive', '1993-01-18', NULL), 
(12, 'Leo Fitz', 60000.00, 3, 9, '2023-10-01', '2023-10-01', 'M', 'Sales Development Rep', '1998-09-09', NULL),
(13, 'Mona Lisa', 115000.00, 4, 1, '2016-08-20', '2016-08-20', 'F', 'HR Director', '1984-04-04', NULL),
(14, 'Ned Stark', 75000.00, 4, 13, '2021-01-10', '2021-01-10', 'M', 'HR Generalist', '1991-06-15', NULL),
(15, 'Olivia Pope', 140000.00, 5, 1, '2018-09-01', '2018-09-01', 'F', 'CMO', '1986-10-10', NULL),
(16, 'Peter Parker', 65000.00, 5, 15, '2022-03-01', '2022-03-01', 'M', 'Marketing Coordinator', '1999-08-10', NULL),
(17, 'Quinn Fabray', 135000.00, 6, 1, '2017-05-01', '2017-05-01', 'F', 'CFO', '1983-12-25', NULL),
(18, 'Rick Sanchez', 200000.00, NULL, 1, '2023-01-15', '2023-01-15', 'M', 'Strategic Advisor', '1975-02-28', NULL);

-- ============================================================================
-- 7. TIE THEM TOGETHER: UPDATE DEPARTMENTS WITH MANAGERS
-- ============================================================================
UPDATE departments SET manager_id = 1 WHERE department_id = 1;
UPDATE departments SET manager_id = 2 WHERE department_id = 2;
UPDATE departments SET manager_id = 3 WHERE department_id = 3;
UPDATE departments SET manager_id = 13 WHERE department_id = 4;
UPDATE departments SET manager_id = 15 WHERE department_id = 5;
UPDATE departments SET manager_id = 17 WHERE department_id = 6;
GO

-- ============================================================================
-- 8. CREATE HR TRACKING TABLES (DDL)
-- ============================================================================
CREATE TABLE salary_history (
    employee_id INT REFERENCES employees(id),
    change_date DATE,
    raise_date DATE,
    salary DECIMAL(15, 2),
    year INT,
    PRIMARY KEY (employee_id, change_date)
);

CREATE TABLE attendance (
    employee_id INT REFERENCES employees(id),
    attendance_date DATE,
    scheduled_start_time TIME,
    arrival_time TIME,
    PRIMARY KEY (employee_id, attendance_date)
);

CREATE TABLE promotions (
    promotion_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    promotion_date DATE,
    old_salary DECIMAL(15, 2)
);
GO

-- ============================================================================
-- 9. INSERT MOCK DATA: HR TRACKING
-- ============================================================================

-- Salary History (Used for LAG/LEAD and Window Function practice)
INSERT INTO salary_history (employee_id, change_date, raise_date, salary, year) VALUES 
(5, '2020-01-01', '2020-01-01', 130000.00, 2020),
(5, '2022-01-01', '2022-01-01', 145000.00, 2022),
(5, '2024-01-01', '2024-01-01', 160000.00, 2024),
(10, '2020-06-01', '2020-06-01', 75000.00, 2020),
(10, '2022-06-01', '2022-06-01', 85000.00, 2022);

-- Attendance Logs (Designed to test 'Gaps and Islands' and Late Arrivals)
INSERT INTO attendance (employee_id, attendance_date, scheduled_start_time, arrival_time) VALUES 
(6, '2024-03-01', '09:00:00', '08:55:00'),
(6, '2024-03-02', '09:00:00', '08:58:00'),
(6, '2024-03-03', '09:00:00', '09:05:00'), -- Late
(6, '2024-03-05', '09:00:00', '08:50:00'), -- Missed March 4th (Gap)
(6, '2024-03-06', '09:00:00', '08:55:00'),
(12, '2024-03-01', '09:00:00', '09:30:00'), -- Late
(12, '2024-03-02', '09:00:00', '09:45:00'); -- Late

-- Promotion Records 
INSERT INTO promotions (employee_id, promotion_date, old_salary) VALUES 
(2, '2018-01-01', 95000.00),
(6, '2021-07-23', 105000.00);
GO
