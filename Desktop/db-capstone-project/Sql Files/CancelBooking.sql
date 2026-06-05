CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


DROP PROCEDURE IF EXISTS CancelBooking;

DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN booking_id VARCHAR(10), 
    OUT confirmation_msg VARCHAR(100)
)
BEGIN
    -- Delete the order
    DELETE FROM Bookings WHERE 
    BookingID = booking_id;

    -- Check if the order was successfully deleted
    IF ROW_COUNT() > 0 THEN
        SET confirmation_msg = CONCAT(' Booking ', booking_id , ' cancelled.');
    ELSE
        SET confirmation_msg = CONCAT('Booking', ' error.');
    END IF;
END //

DELIMITER ;

-- Call the procedure with the order ID and a variable to store the message
CALL CancelBooking("1", @message);

-- Display the confirmation message
SELECT @message AS Confirmation;



