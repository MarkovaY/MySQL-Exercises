-- Write a query to retrieve information about the managers – id, full_name, deparment_id and department_name. 
-- Select the first 5 departments ordered by employee_id.

SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    departments.department_id,
    departments.name
FROM
    departments
        JOIN
    employees ON departments.manager_id = employees.employee_id
ORDER BY employee_id
LIMIT 5;

-- Write a query to get information about the addresses in the database, which are in San Francisco, Sofia or Carnation. 
-- Retrieve town_id, town_name, address_text. Order the result by town_id, then by address_id.

SELECT 
    towns.town_id, name, addresses.address_text
FROM
    towns
        JOIN
    addresses ON towns.town_id = addresses.town_id
WHERE
    towns.name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY town_id , address_id;

-- Write a query to get information about employee_id, first_name, last_name, department_id and salary 
-- for all employees who don't have a manager.

SELECT 
    employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    manager_id IS NULL;
    
    
-- Write a query to count the number of employees who receive salary higher than the average.

SELECT 
    COUNT(*)
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);