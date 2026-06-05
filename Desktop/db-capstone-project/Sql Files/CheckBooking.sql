CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;



DROP PROCEDURE IF EXISTS CheckBooking;

DELIMITER //

CREATE PROCEDURE CheckBooking(
    IN booking_date VARCHAR(10),
    IN table_num VARCHAR(10),
    OUT confirmation_msg VARCHAR(100)
)
BEGIN
    DECLARE is_booked INT;

    -- Check if the table is already booked on that date
    SELECT COUNT(*) 
    INTO is_booked 
    FROM Bookings 
    WHERE BookingDate = booking_date AND TableNumber = table_num;

    -- If is_booked is greater than 0, the table is reserved
    IF is_booked > 0 THEN
        SET confirmation_msg = CONCAT('Table ', table_num, ' is already booked ');
    ELSE
        SET confirmation_msg = CONCAT('Table ', table_num, ' is available for booking.');
    END IF;
END //

DELIMITER ;

-- Call the procedure with the date and table number
CALL CheckBooking("2022-10-13", "2", @message);

-- Display the confirmation message
SELECT @message AS Booking_Status;