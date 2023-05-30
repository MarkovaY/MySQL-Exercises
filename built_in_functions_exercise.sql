-- Write a SQL query to find first and last names of all employees whose first name starts with "Sa" (case insensitively). 
-- Order the information by id.

SELECT 
    first_name, last_name
FROM
    employees
WHERE
    LOWER(first_name) LIKE 'sa%'
ORDER BY employee_id;

-- Write a SQL query to find first and last names of all employees whose last name contains "ei" (case insensitively). 
-- Order the information by id.

SELECT 
    first_name, last_name
FROM
    employees
WHERE
    LOWER(last_name) LIKE '%ei%'
ORDER BY employee_id;

-- Write a SQL query to find the first names of all employees 
-- in the departments with ID 3 or 10 and whose hire year is between 1995 and 2005 inclusively. 
-- Order the information by id.

SELECT 
    first_name
FROM
    employees
WHERE
    department_id IN (3 , 10)
        AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;

-- Write a SQL query to find the first and last names of all employees whose job titles does not contain "engineer". 
-- Order the information by id.

SELECT 
    first_name, last_name
FROM
    employees
WHERE
    job_title NOT LIKE ('%engineer%')
ORDER BY employee_id;

-- Write a SQL query to find town names that are 5 or 6 symbols long and order them alphabetically by town name.

SELECT 
    `name`
FROM
    towns
WHERE
    CHAR_LENGTH(`name`) = 5
        OR CHAR_LENGTH(`name`) = 6
ORDER BY name ASC;

-- Write a SQL query to find all towns that start with letters M, K, B or E (case insensitively). 
-- Order them alphabetically by town name.

SELECT 
    town_id, `name`
FROM
    towns
WHERE
    LOWER(`name`) LIKE 'm%'
        OR LOWER(`name`) LIKE 'k%'
        OR LOWER(`name`) LIKE 'b%'
        OR LOWER(`name`) LIKE 'e%'
ORDER BY `name` ASC;

-- Write a SQL query to find all towns that do not start with letters R, B or D (case insensitively). 
-- Order them alphabetically by name. 

SELECT 
    town_id, `name`
FROM
    towns
WHERE
    `name` NOT REGEXP '^[rbdRBD]'
ORDER BY `name` ASC;

-- Write a SQL query to create view v_employees_hired_after_2000 
-- with the first and the last name of all employees hired after 2000 year.

CREATE VIEW v_employees_hired_after_2000 AS
    SELECT 
        first_name, last_name
    FROM
        employees
    WHERE
        YEAR(hire_date) > 2000;
        
-- Write a SQL query to find the first and last names of all employees whose last name is exactly 5 characters long.

SELECT 
    first_name, last_name
FROM
    employees
WHERE
    CHAR_LENGTH(last_name) = 5;
    
    
-- Geography DB

-- Find all countries that hold the letter 'A' in their name at least 3 times (case insensitively), sorted by ISO code. 
-- Display the country name and the ISO code.

SELECT 
    country_name, iso_code
FROM
    countries
WHERE
    LOWER(country_name) LIKE '%a%a%a%'
ORDER BY iso_code;

-- Combine all peak names with all river names, 
-- so that the last letter of each peak name is the same as the first letter of its corresponding river name. 
-- Display the peak name, the river name, and the obtained mix(converted to lower case). 
-- Sort the results by the obtained mix alphabetically.

