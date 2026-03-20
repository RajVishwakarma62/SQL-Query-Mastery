-- Make sure we are in the right database
USE SQL_Interview_Practice;
GO

-- ============================================================================
-- 15. CLEAN SLATE: PROJECTS MODULE
-- ============================================================================
DROP TABLE IF EXISTS project_assignments;
DROP TABLE IF EXISTS projects;
GO

-- ============================================================================
-- 16. CREATE PROJECT TABLES (DDL)
-- ============================================================================
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    department_id INT REFERENCES departments(department_id),
    manager_id INT REFERENCES employees(id),
    budget DECIMAL(15, 2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    completion_date DATE
);

CREATE TABLE project_assignments (
    employee_id INT REFERENCES employees(id),
    project_id INT REFERENCES projects(project_id),
    start_date DATE,
    end_date DATE,
    assignment_date DATE,
    hours_worked DECIMAL(10, 2),
    PRIMARY KEY (employee_id, project_id)
);
GO

-- ============================================================================
-- 17. INSERT MOCK DATA: PROJECTS
-- ============================================================================
INSERT INTO projects (project_id, department_id, manager_id, budget, start_date, end_date, status, completion_date) VALUES 
(201, 2, 4, 500000.00, '2022-01-01', '2022-12-31', 'Completed', '2022-12-15'),
(202, 3, 3, 250000.00, '2023-02-01', '2023-08-01', 'Completed', '2023-08-10'),
(203, 2, 4, 1500000.00, '2023-06-01', '2024-12-01', 'Active', NULL),
(204, 5, 15, 800000.00, '2024-01-15', '2024-06-15', 'Active', NULL),
(205, 4, 13, 100000.00, '2024-03-01', '2024-05-01', 'Planned', NULL);

-- ============================================================================
-- 18. INSERT MOCK DATA: PROJECT ASSIGNMENTS
-- Description: Overlapping dates and multiple projects per employee to test logic
-- ============================================================================
INSERT INTO project_assignments (employee_id, project_id, start_date, end_date, assignment_date, hours_worked) VALUES 
(5, 201, '2022-01-01', '2022-12-31', '2021-12-20', 1200.00),
(6, 201, '2022-01-01', '2022-12-31', '2021-12-20', 1500.00),
(5, 203, '2023-06-01', '2024-12-01', '2023-05-15', 800.00), -- Employee 5 is on multiple projects!
(7, 203, '2023-06-01', '2024-12-01', '2023-05-15', 650.00),
(10, 202, '2023-02-01', '2023-08-01', '2023-01-15', 400.00),
(16, 204, '2024-01-15', '2024-06-15', '2024-01-10', 250.00);
GO
