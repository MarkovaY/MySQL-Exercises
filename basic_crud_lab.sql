--  Write a query to select all employees and retrieve information about their
-- id, first_name, last_name and job_title ordered by id. 

SELECT id, first_name, last_name, job_title 
FROM employees 
ORDER BY id;

-- Write a query to select all employees (id, first_name and last_name (as full_name), job_title, salary) 
-- whose salaries are higher than 1000.00, ordered by id. 
-- Concatenate fields first_name and last_name into 'full_name'. 

SELECT id, 
CONCAT(first_name, ' ', last_name) AS full_name,
job_title, salary
FROM employees
WHERE salary > 1000.00
ORDER BY id;

-- Create a view for top-salary employee

CREATE VIEW v_top_paid_employee AS
SELECT * 
FROM employees
ORDER BY salary DESC LIMIT 1;

SELECT * FROM v_top_paid_employee;

SET sql_safe_updates = 0;

UPDATE employees 
SET 
    salary = salary + 100
WHERE
    job_title = 'Manager';
    
DELETE FROM employees
WHERE department_id = 1 OR department_id = 2;

SELECT * FROM employees
ORDER BY id;
