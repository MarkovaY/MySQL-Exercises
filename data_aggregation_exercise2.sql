-- Part 3
-- soft_uni DB

-- Two additional higher difficulty tasks

-- Write a query that returns:
-- • first_name
-- • last_name
-- • department_id
-- for all employees who have salary higher than the average salary of their respective departments. 
-- Select only the first 10 rows. Order by department_id, employee_id.

SELECT DISTINCT
    first_name, last_name, department_id
FROM
    employees AS e1
WHERE
    salary > (SELECT 
            AVG(`salary`)
        FROM
            employees AS e2
        WHERE
            e1.department_id = e2.department_id)
ORDER BY department_id , employee_id
LIMIT 10;

-- Find the third highest salary in each department if there is such. 
-- Sort result by department_id in increasing order.

SELECT 
    department_id,
    (SELECT DISTINCT
            salary
        FROM
            employees AS e2
        WHERE
            e1.department_id = e2.department_id
        ORDER BY salary DESC
        LIMIT 1 OFFSET 2) AS 'third_highest_salary'
FROM
    employees AS e1
GROUP BY department_id
HAVING `third_highest_salary` IS NOT NULL
ORDER BY department_id;