-- Write a query to create two tables – mountains and peaks and link their fields properly. Tables should have:
-- - Mountains:
-- • id
-- • name
-- - Peaks:
-- • id
-- • name
-- • mountain_id

CREATE TABLE mountains (
    id INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    constraint pk_mountains_id primary key (id)
);

CREATE TABLE peaks (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    mountain_id INT NOT NULL,
    CONSTRAINT fk_peaks_mountains_id__mountains_id FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
);

-- Write a query to retrieve information about SoftUni camp's transportation organization. 
-- Get information about the drivers (name and id) and their vehicle type.

SELECT 
    driver_id,
    vehicle_type,
    CONCAT(first_name, ' ', last_name) AS driver_name
FROM
    vehicles
        JOIN
    campers ON driver_id = campers.id;
    
-- Get information about the hiking routes – starting point and ending point, and their leaders – name and id.

SELECT 
    starting_point,
    end_point,
    leader_id,
    CONCAT(first_name, ' ', last_name) AS leader_name
FROM
    routes
        JOIN
    campers ON leader_id = campers.id;
    
-- Drop tables from the task 1.
-- Write a query to create a one-to-many relationship between a table, 
-- holding information about mountains (id, name) and other - about peaks (id, name, mountain_id), 
-- so that when a mountain gets removed from the database, all his peaks are deleted too.

DROP TABLE peaks;
DROP TABLE mountains;

CREATE TABLE mountains (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE peaks (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    mountain_id INT NOT NULL,
        CONSTRAINT fk_peaks_mountain_id_mountains_id FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
        ON DELETE CASCADE
);