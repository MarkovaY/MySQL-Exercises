-- Task 1 - Create DB

CREATE DATABASE restaurant_db;

USE restaurant_db;

-- Task 2 - Create tables

CREATE TABLE `products` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `type` VARCHAR(30) NOT NULL,
    `price` DECIMAL(10 , 2 ) NOT NULL
);

CREATE TABLE `clients` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `card` VARCHAR(50),
    `review` TEXT
);

CREATE TABLE `tables` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `floor` INT NOT NULL,
    `reserved` TINYINT(1),
    `capacity` INT NOT NULL
);

CREATE TABLE waiters(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`email` VARCHAR(50) NOT NULL,
`phone` VARCHAR(50),
`salary` DECIMAL(10, 2)
);

CREATE TABLE orders (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `table_id` INT NOT NULL,
    `waiter_id` INT NOT NULL,
    `order_time` TIME NOT NULL,
    `payed_status` TINYINT(1),
    CONSTRAINT fk_orders_tables FOREIGN KEY (table_id)
        REFERENCES `tables` (id),
    CONSTRAINT fk_orders_waiters FOREIGN KEY (waiter_id)
        REFERENCES `waiters` (id)
);

CREATE TABLE orders_clients (
    `order_id` INT,
    `client_id` INT,
    CONSTRAINT fk_orders_clients_orders FOREIGN KEY (order_id)
        REFERENCES orders (id),
    CONSTRAINT fk_orders_clients_clients FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE orders_products (
    `order_id` INT,
    `product_id` INT,
    CONSTRAINT fk_orders_products_orders FOREIGN KEY (order_id)
        REFERENCES orders (id),
    CONSTRAINT fk_orders_products_products FOREIGN KEY (product_id)
        REFERENCES products (id)
);

-- Task 3 - Insert

INSERT INTO products (`name`, `type`, `price`)
SELECT CONCAT(last_name, ' ', 'specialty'), 'Cocktail', CEIL(salary * 0.01)
FROM waiters
WHERE id > 6;

-- Task 4 - Update

UPDATE orders 
SET 
    table_id = table_id - 1
WHERE
    id >= 12 AND id <= 23;

-- Task 5 - Delete

DELETE FROM waiters 
WHERE
    id NOT IN (SELECT 
        waiter_id
    FROM
        orders);

-- Task 6 - Clients

SELECT 
    *
FROM
    clients
ORDER BY birthdate DESC , id DESC;

-- Task 7 - Birthdate

SELECT 
    first_name, last_name, birthdate, review
FROM
    clients
WHERE
    card IS NULL
        AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC , id ASC
LIMIT 5;

-- Task 8 - Accounts

SELECT 
    CONCAT(last_name,
            first_name,
            CHAR_LENGTH(first_name),
            'Restaurant') AS `username`,
    REVERSE(SUBSTRING(email, 2, 12)) AS `password`
FROM
    waiters
WHERE
    salary IS NOT NULL
ORDER BY `password` DESC;

-- Task 9 - Top of Menu

SELECT 
    id, `name`, COUNT(op.product_id) AS count
FROM
    products AS p
        JOIN
    orders_products AS op ON p.id = op.product_id
GROUP BY id
HAVING count >= 5
ORDER BY count DESC , `name` ASC;

-- Task 10 - Availability

SELECT 
    t.id AS table_id,
    t.capacity,
    COUNT(oc.client_id) AS `count_clients`,
    (CASE
        WHEN capacity > COUNT(oc.client_id) THEN 'Free seats'
        WHEN capacity < COUNT(oc.client_id) THEN 'Extra seats'
        ELSE 'Full'
    END) AS availability
FROM
    `tables` AS t
        JOIN
    orders AS o ON o.table_id = t.id
        JOIN
    orders_clients AS oc ON oc.order_id = o.id
WHERE
    t.floor = 1
GROUP BY t.id
ORDER BY table_id DESC;

-- Task 11 - Extract Bill

DELIMITER $$
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
RETURNS DECIMAL(19, 2)
DETERMINISTIC
BEGIN
	DECLARE space_index INT;
	SET space_index := LOCATE(' ', full_name);
    
	RETURN(SELECT SUM(p.price)
    FROM clients AS c
    JOIN orders_clients as oc ON oc.client_id = c.id
    JOIN orders AS o ON o.id = oc.order_id
    JOIN orders_products AS op ON op.order_id = o.id
    JOIN products AS p ON p.id = op.product_id
    WHERE c.first_name = SUBSTRING(full_name, 1, space_index - 1) AND c.last_name = SUBSTRING(full_name, space_index + 1));
END$$

DELIMITER ;
;

-- Task 12 Happy Hour

DELIMITER $$
CREATE PROCEDURE udp_happy_hour(`type` VARCHAR(50))
BEGIN
	UPDATE products AS p
    SET price = price - (price * 0.2)
    WHERE p.`type` LIKE `type` AND p.price >= 10;
END$$

DELIMITER ;
;
