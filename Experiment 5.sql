-- SOURCE CODE / SQL QUERIES 
-- 1. DEPARTMENT SALARY SUMMARY VIEW 
-- Create a view showing employee count, average salary, minimum salary, maximum salary and total salary for 
-- each department. 
CREATE OR REPLACE VIEW department_salary_summary AS 
SELECT 
d.dept_id, 
d.dept_name, 
COUNT(e.emp_id) AS employee_count, 
AVG(e.salary) AS average_salary, 
MIN(e.salary) AS minimum_salary, 
MAX(e.salary) AS maximum_salary, 
SUM(e.salary) AS total_salary 
FROM Department d 
JOIN Employee e 
ON d.dept_id = e.dept_id 
GROUP BY d.dept_id, d.dept_name; 

-- 2. EMPLOYEE HIERARCHY VIEW 
-- Create a view containing each employee and the name of the employee's immediate manager. 
CREATE OR REPLACE VIEW employee_hierarchy AS 
SELECT 
e.emp_id, 
e.emp_name, 
e.dept_id, 
d.dept_name, 
e.manager_id, 
m.emp_name AS manager_name, 
e.salary 
FROM Employee e 
JOIN Department d 
ON e.dept_id = d.dept_id 
LEFT JOIN Employee m 
ON e.manager_id = m.emp_id;

-- 3. TEST UPDATABILITY OF VIEWS 
-- Test an update on a simple employee hierarchy view and then test an update on the grouped department salary 
-- summary view. 
UPDATE employee_hierarchy 
SET salary = salary + 1000 
WHERE emp_id = 6; 
SELECT emp_id, emp_name, salary 
FROM Employee 
WHERE emp_id = 6; 
UPDATE department_salary_summary 
SET average_salary = average_salary + 1000 
WHERE dept_id = 1; 

-- 4. RECURSIVE CTE – REPORTING CHAIN 
-- Display the reporting chain beginning with department heads and recursively follow manager relationships. 
WITH RECURSIVE reporting_chain AS ( 
SELECT 
e.emp_id, 
e.emp_name, 
e.manager_id, 
1 AS level, 
CAST(e.emp_name AS CHAR(500)) AS reporting_path 
FROM Employee e 
WHERE e.manager_id IS NULL 
UNION ALL 
SELECT 
e.emp_id, 
e.emp_name, 
e.manager_id, 
rc.level + 1, 
CONCAT(rc.reporting_path, ' -> ', e.emp_name) 
FROM Employee e 
JOIN reporting_chain rc 
ON e.manager_id = rc.emp_id 
) 
SELECT emp_id, emp_name, manager_id, level, reporting_path 
FROM reporting_chain 
ORDER BY reporting_path;