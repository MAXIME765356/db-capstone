CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


DROP PROCEDURE IF EXISTS CancelOrder;

DELIMITER //

CREATE PROCEDURE CancelOrder(
    IN order_id_param VARCHAR(10), 
    OUT confirmation_msg VARCHAR(100)
)
BEGIN
    -- Delete the order
    DELETE FROM Orders 
    WHERE OrderID = order_id_param;

    -- Check if the order was successfully deleted
    IF ROW_COUNT() > 0 THEN
        SET confirmation_msg = CONCAT('Success: Order ', order_id_param, ' was cancelled.');
    ELSE
        SET confirmation_msg = CONCAT('Error: Order ', order_id_param, ' not found or already deleted.');
    END IF;
END //

DELIMITER ;

-- Call the procedure with the order ID and a variable to store the message
CALL CancelOrder('1', @message);

-- Display the confirmation message
SELECT @message AS Confirmation;