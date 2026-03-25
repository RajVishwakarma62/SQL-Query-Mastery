-- ============================================================================
-- CATEGORY 1: Basic SELECT, WHERE, and Joins
-- ============================================================================

-- 1. Find employees who don't have a department assigned.
SELECT name, job_title 
FROM employees 
WHERE department_id IS NULL;

-- 2. Find employees with no manager assigned.
SELECT name, job_title 
FROM employees 
WHERE manager_id IS NULL;

-- 3. Get departments with no employees.
SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.id IS NULL;

-- 4. Retrieve employees who earn more than their manager.
SELECT e.name AS employee_name, e.salary AS employee_salary, 
       m.name AS manager_name, m.salary AS manager_salary
FROM employees e
INNER JOIN employees m ON e.manager_id = m.id
WHERE e.salary > m.salary;

-- 5. Display employee names alongside their manager names, including those without managers.
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- 6. Find employees who were hired before their managers.
SELECT e.name AS employee_name, e.hire_date AS emp_hire_date, 
       m.name AS manager_name, m.hire_date AS mgr_hire_date
FROM employees e
INNER JOIN employees m ON e.manager_id = m.id
WHERE e.hire_date < m.hire_date;


