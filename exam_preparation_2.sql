-- Task 1 - create DB

CREATE DATABASE online_store;
USE online_store;

-- Task 2 - Create tables

CREATE TABLE brands (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    content TEXT,
    rating DECIMAL(10 , 2 ) NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    published_at DATETIME NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    price DECIMAL(19 , 2 ) NOT NULL,
    quantity_in_stock INT,
    description TEXT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    review_id INT,
    CONSTRAINT fk_products_brands FOREIGN KEY (brand_id)
        REFERENCES brands (id),
    CONSTRAINT fk_products_categories FOREIGN KEY (category_id)
        REFERENCES categories (id),
    CONSTRAINT fk_products_reviews FOREIGN KEY (review_id)
        REFERENCES reviews (id)
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    address VARCHAR(60) NOT NULL,
    discount_card BIT(1) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_datetime DATETIME NOT NULL,
    customer_id INT NOT NULL,
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES customers (id)
);

CREATE TABLE orders_products (
    order_id INT,
    product_id INT,
    CONSTRAINT fk_orders_customers_orders FOREIGN KEY (order_id)
        REFERENCES orders (id),
    CONSTRAINT fk_orders_customers_products FOREIGN KEY (product_id)
        REFERENCES products (id)
);


-- Task 3 - Insert

INSERT INTO reviews(content, picture_url, published_at, rating)
SELECT LEFT(p.`description`, 15), REVERSE(p.`name`), DATE('2010-10-10'), (p.price / 8)
FROM products AS p
WHERE p.id >= 5;


-- Task 4 - Update

UPDATE products 
SET 
    quantity_in_stock = quantity_in_stock - 5
WHERE
    quantity_in_stock BETWEEN 60 AND 70;
    
    
-- Task 5 - Delete

DELETE FROM customers as c
WHERE c.id NOT IN (SELECT customer_id FROM orders);


-- Task 6 - Categories

SELECT 
    *
FROM
    categories
ORDER BY `name` DESC;


-- Task 7 - Quantity

SELECT 
    id, brand_id, `name`, quantity_in_stock
FROM
    products
WHERE
    price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock , id;


-- Task 8 - Review

SELECT id, content, rating, picture_url, published_at
FROM reviews
WHERE LOCATE('My', content) AND CHAR_LENGTH(content) > 61
ORDER BY rating DESC;


-- Task 9 - First Customers

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.address,
    o.order_datetime AS order_date
FROM
    customers AS c
        JOIN
    orders AS o ON o.customer_id = c.id
WHERE
    YEAR(o.order_datetime) <= 2018
ORDER BY full_name DESC;


-- Task 10 - Best Categories

SELECT 
    COUNT(c.id) AS items_count,
    c.`name`,
    SUM(p.quantity_in_stock) AS total_quantity
FROM
    products AS p
        JOIN
    categories AS c ON p.category_id = c.id
GROUP BY c.id
ORDER BY items_count DESC , total_quantity ASC
LIMIT 5;


-- Task 11 - Extract Client Cards Count

DELIMITER $$
CREATE FUNCTION udf_customer_products_count(`name` VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE total_products INT;
    SET total_products := (SELECT COUNT(product_id) AS total_products
FROM customers AS c
RIGHT JOIN orders AS o ON o.customer_id = c.id
JOIN orders_products AS op ON op.order_id = o.id
WHERE `name` LIKE c.first_name);
RETURN total_products;
END $$

-- Task 12 - Reduce Price

CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
	UPDATE products AS p
JOIN categories AS c ON c.id = p.category_id
JOIN reviews AS r ON r.id = p.review_id
SET price = price - (price * 0.3) 
WHERE c.`name` LIKE category_name AND r.rating < 4;
END $$

DELIMITER ;
;