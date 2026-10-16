-- SOURCE CODE / SQL QUERIES 
-- 1. INNER JOIN 
-- Display employee names, salaries and their department names using an INNER JOIN. 
SELECT 
e.emp_id, 
e.emp_name, 
e.salary, 
d.dept_name 
FROM Employee e 
INNER JOIN Department d 
ON e.dept_id = d.dept_id 
ORDER BY e.emp_id; 

-- 2. LEFT JOIN 
-- Display all departments and the employees belonging to them. LEFT JOIN keeps every department from the left 
-- table even if no matching employee exists. 
SELECT 
d.dept_id, 
d.dept_name, 
e.emp_name, 
e.salary 
FROM Department d 
LEFT JOIN Employee e 
ON d.dept_id = e.dept_id 
ORDER BY d.dept_id, e.emp_id;

-- 3. SELF-JOIN 
-- Compare two employees belonging to the same department. The Employee table is joined to itself using two 
-- aliases. 
SELECT 
e1.emp_name AS employee_1, 
e2.emp_name AS employee_2, 
e1.dept_id, 
e1.salary AS salary_1, 
e2.salary AS salary_2 
FROM Employee e1 
INNER JOIN Employee e2 
ON e1.dept_id = e2.dept_id 
AND e1.emp_id < e2.emp_id 
ORDER BY e1.dept_id, e1.emp_id, e2.emp_id 
LIMIT 10; 

-- 4. 3-WAY JOIN 
-- Display employee name, department, project and salary by joining Employee, Department and Project. 
SELECT 
e.emp_name, 
d.dept_name, 
p.project_name, 
e.salary 
FROM Employee e 
INNER JOIN Department d 
ON e.dept_id = d.dept_id 
INNER JOIN Project p 
ON e.project_id = p.project_id 
ORDER BY d.dept_name, e.emp_name;

-- 5. CORRELATED SUBQUERY 
-- Display employees whose salary is greater than the average salary of their own department. The inner query 
-- refers to the outer Employee row, making it a correlated subquery. 
SELECT 
e.emp_id, 
e.emp_name, 
e.salary, 
e.dept_id 
FROM Employee e 
WHERE e.salary > ( 
SELECT AVG(e2.salary) 
FROM Employee e2 
WHERE e2.dept_id = e.dept_id 
) 
ORDER BY e.dept_id, e.salary DESC;  

-- 6. EXISTS 
-- Find departments that have at least one employee with a salary greater than 80,000. 
SELECT 
d.dept_id, 
d.dept_name 
FROM Department d 
WHERE EXISTS ( 
SELECT 1 
FROM Employee e 
WHERE e.dept_id = d.dept_id 
AND e.salary > 80000 
) 
ORDER BY d.dept_id;  

-- 7. SIMULATED INTERSECT 
SELECT emp_id, emp_name, salary 
FROM Employee 
WHERE emp_id IN ( 
SELECT emp_id 
FROM Employee 
WHERE dept_id = 1 
) 
AND emp_id IN ( 
SELECT emp_id 
FROM Employee 
WHERE salary > 70000 
) 
ORDER BY emp_id; 

-- 8. SIMULATED EXCEPT 
-- Simulate EXCEPT by selecting employees with salary greater than 70,000 while excluding employees 
-- belonging to IT. 
SELECT emp_id, emp_name, salary 
FROM Employee 
WHERE emp_id IN ( 
SELECT emp_id 
FROM Employee 
WHERE salary > 70000 
) 
AND emp_id NOT IN ( 
SELECT emp_id 
FROM Employee 
WHERE dept_id = 1 
)  
ORDER BY emp_id;

