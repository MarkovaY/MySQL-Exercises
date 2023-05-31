-- Part 2

-- Geography DB

-- Combine all peak names with all river names, so that the last letter of each peak name is the same as 
-- the first letter of its corresponding river name. 
-- Display the peak name, the river name, and the obtained mix(converted to lower case). 
-- Sort the results by the obtained mix alphabetically.

SELECT 
    p.peak_name,
    r.river_name,
    LOWER(CONCAT(LEFT(p.peak_name,
                        CHAR_LENGTH(p.peak_name) - 1),
                    r.river_name)) AS mix
FROM
    peaks AS p,
    rivers AS r
WHERE
    UPPER(RIGHT(p.peak_name, 1)) = UPPER(LEFT(r.river_name, 1))
ORDER BY mix ASC;


-- Part 3 - Diablo DB

-- Find the top 50 games ordered by start date, then by name. 
-- Display only the games from the years 2011 and 2012. Display the start date in the format "YYYY-MM-DD".

SELECT 
    `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS `start`
FROM
    `games`
WHERE
    YEAR(start) IN (2011 , 2012)
ORDER BY `start`
LIMIT 50;

-- Find information about the email providers of all users. 
-- Display the user_name and the email provider. 
-- Sort the results by email provider alphabetically, then by username.

SELECT 
    user_name,
    SUBSTRING_INDEX(email, '@', - 1) AS `email_provider`
FROM
    users
ORDER BY email_provider , user_name;

-- Second solution with regex

SELECT 
    user_name,
    REGEXP_REPLACE(email, '.*@', '') AS `email_provider`
FROM
    users
ORDER BY email_provider , user_name;

-- Find the user_name and the ip_address for each user, sorted by user_name alphabetically. 
-- Display only the rows, where the ip_address matches the pattern: "___.1%.%.___".

SELECT 
    user_name, ip_address
FROM
    users
WHERE
    ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- Find all games with their corresponding part of the day and duration. 
-- Parts of the day should be 
-- Morning (start time is >= 0 and < 12), 
-- Afternoon (start time is >= 12 and < 18), 
-- Evening (start time is >= 18 and < 24). 
-- Duration should be Extra Short (smaller or equal to 3), 
-- Short (between 3 and 6 including), 
-- Long (between 6 and 10 including) and 
-- Extra Long in any other cases or without duration.

SELECT 
    name AS `game`,
    CASE
        WHEN HOUR(start) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(start) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS `Part of the Day`,
    CASE
        WHEN duration <= 3 THEN 'Extra Short'
        WHEN duration BETWEEN 4 AND 6 THEN 'Short'
        WHEN duration BETWEEN 7 AND 10 THEN 'Long'
        ELSE 'Extra Long'
    END AS `Duration`
FROM
    games
ORDER BY `game`;


-- Part 3 

-- Orders DB

-- You are given a table orders (id, product_name, order_date) filled with data. 
-- Consider that the payment for an order must be accomplished within 3 days after the order date. 
-- Also the delivery date is up to 1 month. 
-- Write a query to show each product's name, order date, pay and deliver due dates.

SELECT 
    product_name,
    order_date,
    DATE_ADD(order_date, INTERVAL 3 DAY) AS pay_due,
    DATE_ADD(order_date, INTERVAL 1 MONTH) AS deliver_due
FROM
    orders;