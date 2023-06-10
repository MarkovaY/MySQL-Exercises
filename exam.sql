CREATE DATABASE universities_db;

USE universities_db;

CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    population INT,
    country_id INT NOT NULL,
    CONSTRAINT fk_cities_countries FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE universities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE,
    address VARCHAR(80) NOT NULL UNIQUE,
    tuition_fee DECIMAL(19 , 2 ) NOT NULL,
    number_of_staff INT,
    city_id INT,
    CONSTRAINT fk_universities_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    is_graduated TINYINT(1),
    city_id INT,
    CONSTRAINT fk_students_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19 , 2 ),
    start_date DATE,
    teacher_name VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    university_id INT,
    CONSTRAINT fk_courses_universities FOREIGN KEY (university_id)
        REFERENCES universities(id)
);

CREATE TABLE students_courses (
    grade DECIMAL(19 , 2 ) NOT NULL,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_students_courses_students FOREIGN KEY (student_id)
        REFERENCES students (id),
    CONSTRAINT fk_students_courses_courses FOREIGN KEY (course_id)
        REFERENCES courses (id)
);


INSERT INTO courses (`name`, duration_hours, start_date, teacher_name, description, university_id)
SELECT 
CONCAT(teacher_name, ' ', 'course'),
(CHAR_LENGTH(`name`) / 10),
DATE_ADD(start_date, INTERVAL 5 DAY),
REVERSE(teacher_name),
CONCAT('Course', ' ', teacher_name, REVERSE(description)),
DAY(start_date)
FROM courses
WHERE id <= 5;


UPDATE universities 
SET 
    tuition_fee = tuition_fee + 300
WHERE
    id >= 5 AND id <= 12;
    

DELETE FROM universities 
WHERE
    number_of_staff IS NULL;


SELECT 
    id, `name`, population, country_id
FROM
    cities
ORDER BY population DESC;

SELECT 
    first_name, last_name, age, phone, email
FROM
    students
WHERE
    age >= 21
ORDER BY first_name DESC , email , id
LIMIT 10;

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    SUBSTRING(email, 2, 10) AS username,
    REVERSE(phone) AS `password`
FROM
    students
WHERE
    id NOT IN (SELECT 
            student_id
        FROM
            students_courses)
ORDER BY `password` DESC;


SELECT 
    COUNT(sc.student_id) AS students_count,
    u.`name` AS university_name
FROM
    students_courses AS sc
        JOIN
    courses AS c ON sc.course_id = c.id
        JOIN
    universities AS u ON c.university_id = u.id
GROUP BY c.university_id
HAVING students_count >= 8
ORDER BY students_count DESC , u.`name` DESC;


SELECT 
    u.`name` AS university_name,
    c.`name` AS city_name,
    u.address AS address,
    (CASE
        WHEN tuition_fee < 800 THEN 'cheap'
        WHEN tuition_fee < 1200 THEN 'normal'
        WHEN tuition_fee < 2500 THEN 'high'
        ELSE 'expensive'
    END) AS price_rank,
    u.tuition_fee AS tuition_fee
FROM
    universities AS u
        JOIN
    cities AS c ON c.id = u.city_id
ORDER BY tuition_fee;


DELIMITER $$
CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60))
RETURNS DECIMAL (19, 2)
DETERMINISTIC
BEGIN
	RETURN
	(SELECT AVG(sc.grade) 
	FROM courses AS c
	JOIN students_courses AS sc ON c.id = sc.course_id
	JOIN students AS s ON s.id = sc.student_id
	WHERE s.is_graduated = 1 AND c.`name` = course_name
	GROUP BY sc.course_id);
END $$


CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
BEGIN
	UPDATE students AS s
SET is_graduated = 1
WHERE s.id IN (SELECT student_id FROM students_courses WHERE course_id IN 
(SELECT id FROM courses WHERE YEAR(start_date) = year_started));
END $$

DELIMITER ;
;