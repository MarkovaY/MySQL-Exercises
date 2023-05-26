-- Book library DB

-- Write a SQL query to find books which titles start with "The". Order the result by id. 

SELECT 
    title
FROM
    books
WHERE
    SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;

-- Write a SQL query to find books which titles start with "The" and replace the substring with 3 asterisks. 
-- Retrieve data about the updated titles. Order the result by id.

SELECT 
    REPLACE(title, 'The', '***')
FROM
    books
WHERE
    SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;


-- Write a SQL query to calculate the days that an author lived. Your query should return:
-- • Full Name – the full name of the author.
-- • Days Lived – days that he/she lived. NULL values mean that the author is still alive.

SELECT 
    CONCAT_WS(' ', first_name, last_name) AS `Full Name`,
    TIMESTAMPDIFF(DAY, born, died) AS `Days Lived`
FROM
    authors;

-- Write a SQL query to retrieve titles of all the Harry Potter books. Order the information by id.

SELECT 
    title
FROM
    books
WHERE
    title LIKE 'Harry Potter%'
ORDER BY id;