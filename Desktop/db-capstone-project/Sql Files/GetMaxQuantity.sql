CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


DROP PROCEDURE IF EXISTS GetMaxQuantity;

DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT 
    Max(Quantity)
    FROM Orders;
END //
DELIMITER ;

CALL GetMaxQuantity();