CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;



DROP PROCEDURE IF EXISTS AddValidBooking;

DELIMITER //

CREATE PROCEDURE AddValidBooking(
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
        SET confirmation_msg = CONCAT('Table ', table_num, ' is already booked - booking cancelled ');
    ELSE
        -- Insert new record using input parameters
        START TRANSACTION;
        
        INSERT INTO Bookings (TableNumber, BookingDate)
        VALUES (table_num, booking_date);
        
        COMMIT;
        
         SET confirmation_msg = CONCAT('Table ', table_num, ' available for booking ');
    END IF;
END //

DELIMITER ;

-- Call the procedure with the date and table number
CALL AddValidBooking("2022-10-10", "5", @message);

-- Display the confirmation message
SELECT @message AS BookingStatus;