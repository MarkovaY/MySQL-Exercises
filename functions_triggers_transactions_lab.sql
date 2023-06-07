-- Write a function ufn_count_employees_by_town(town_name) that accepts town_name as parameter 
-- and returns the count of employees who live in that town.

DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(`town_name` VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE e_count INT;
	SET e_count := (SELECT COUNT(*)
from employees AS e
JOIN addresses AS a ON e.address_id = a.address_id
JOIN towns AS t ON a.town_id = t.town_id
WHERE t.`name` = town_name);
	RETURN e_count;
END$$

DELIMITER ;
;

-- Write a stored procedure usp_raise_salaries(department_name) to raise the salary 
-- of all employees in given department as parameter by 5%.

DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(20))
BEGIN
UPDATE employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
SET 
    salary = salary * 1.05
WHERE d.name = department_name;
END$$

DELIMITER ;
;

-- Write a stored procedure usp_raise_salary_by_id(id) that raises a given employee's salary (by id as parameter) by 5%. 
-- Consider that you cannot promote an employee that doesn't exist – if that happens, 
-- no changes to the database should be made.

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	START TRANSACTION;
    IF((SELECT count(employee_id) FROM employees WHERE employee_id
LIKE id)<>1) THEN
ROLLBACK;
ELSE
UPDATE employees AS e SET salary = salary + salary * 0.05
WHERE e.employee_id = id;
COMMIT;
END IF;
END$$

DELIMITER ;
;

-- Create a table deleted_employees(employee_id PK, first_name,last_name,middle_name,job_title,deparment_id,salary) 
-- that will hold information about fired(deleted) employees from the employees table. 
-- Add a trigger to employees table that inserts the corresponding information in deleted_employees.

CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(50),
last_name VARCHAR(50),
middle_name VARCHAR(50),
job_title VARCHAR(50),
department_id INT,
salary DECIMAL);

DELIMITER $$
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees (first_name, last_name, middle_name, job_title, department_id, salary)
    VALUES (OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END $$
