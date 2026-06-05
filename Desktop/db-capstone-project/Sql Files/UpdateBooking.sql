CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


DROP PROCEDURE IF EXISTS UpdateBooking;

DELIMITER //

CREATE PROCEDURE UpdateBooking(
    IN booking_id INT,
    IN booking_date VARCHAR(100),
    OUT confirmation_msg VARCHAR(100)
)
BEGIN
    -- Delete the order
    UPDATE Bookings SET
    BookingDate = booking_date
    WHERE
    BookingID = booking_id;
    -- Check if the order was successfully deleted
    IF ROW_COUNT() > 0 THEN
        SET confirmation_msg = CONCAT('Booking ',booking_id , ' updated');
    ELSE
        SET confirmation_msg = CONCAT('Booking  ', booking_id, ' error');
    END IF;
END //

DELIMITER ;

-- Call the procedure with the order ID and a variable to store the message
CALL  UpdateBooking("1","2026-01-01", @message);

-- Display the confirmation message
SELECT @message AS Confirmation;