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


-- ============================================================================
-- CATEGORY 2: Aggregations & GROUP BY / HAVING
-- ============================================================================

-- 1. List all departments and their employee counts, including departments with zero employees.
-- Logic: We use a LEFT JOIN to ensure Department 7 (Operations) shows up with a 0 count.
SELECT 
    d.department_name, 
    COUNT(e.id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 2. Count employees in each department having more than 5 employees.
-- Logic: HAVING is used to filter the aggregated count *after* the GROUP BY.
SELECT 
    department_id, 
    COUNT(id) AS total_employees
FROM employees
GROUP BY department_id
HAVING COUNT(id) > 5;

-- 3. Find the number of employees in each job title.
SELECT 
    job_title, 
    COUNT(*) AS employee_count
FROM employees
GROUP BY job_title
ORDER BY employee_count DESC;

-- 4. Calculate the average salary by department AND job title.
-- Logic: Grouping by multiple columns creates a specific sub-group for every combination.
SELECT 
    department_id, 
    job_title, 
    AVG(salary) AS avg_salary
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id, job_title
ORDER BY department_id, avg_salary DESC;

-- 5. Find the department with the lowest average salary.
-- Logic: Calculate the average, order it from lowest to highest, and grab the TOP 1.
SELECT TOP 1 
    department_id, 
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary ASC;

-- 6. Perform a conditional aggregation (count males and females in each department).
-- Logic: This is a massive interview favorite. We put a CASE WHEN inside a SUM to "pivot" the data.
SELECT 
    department_id,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id;

-- 7. Get the number of employees hired each year.
-- Logic: Extract the YEAR from the hire_date to group them into annual cohorts.
SELECT 
    YEAR(hire_date) AS hire_year, 
    COUNT(*) AS employees_hired
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- ============================================================================
-- CATEGORY 3: Subqueries
-- ============================================================================

-- 1. Find the second highest salary from the Employee table.
-- Logic: Find the max salary first, then find the max salary that is strictly less than that.
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary) 
    FROM employees
);

-- 2. Find employees with a salary greater than the average salary in the entire company.
-- Logic: The subquery calculates the company-wide average dynamically.
SELECT name, job_title, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) 
    FROM employees
);

-- 3. Find employees with salaries higher than their department average.
-- Logic: This is a "Correlated Subquery". The inner query recalculates the average for EVERY row based on the outer query's department_id.
SELECT e1.name, e1.department_id, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);

-- 4. Find the employee with the maximum salary in each department.
-- Logic: We use a subquery in the FROM clause (a derived table) to find the max per department, then JOIN it back to the employees table.
SELECT e.name, e.department_id, e.salary
FROM employees e
INNER JOIN (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
) dept_max ON e.department_id = dept_max.department_id AND e.salary = dept_max.max_salary;

-- 5. Find employees whose salary is above their department's average but below the overall average salary.
-- Logic: Combining a correlated subquery and a scalar subquery in the same WHERE clause!
SELECT e1.name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(salary) 
    FROM employees e2 
    WHERE e1.department_id = e2.department_id
) 
AND e1.salary < (
    SELECT AVG(salary) 
    FROM employees
);

-- 6. Find employees with no corresponding entries in the salary_history table.
-- Logic: NOT EXISTS is highly optimized in SQL Server for finding missing records across tables.
SELECT name, job_title
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 
    FROM salary_history sh 
    WHERE sh.employee_id = e.id
);
