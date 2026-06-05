CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;

SELECT MenuName 
FROM Menus 
WHERE MenuID IN (
    SELECT MenuID 
    FROM Orders 
    WHERE Quantity > 2
); 