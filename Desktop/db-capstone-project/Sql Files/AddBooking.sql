CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


-- Drop the procedure if it already exists to avoid creation errors
DROP PROCEDURE IF EXISTS AddBooking;

DELIMITER //

CREATE PROCEDURE AddBooking(
    IN booking_id INT,
    IN booking_date VARCHAR(10),
    IN customer_id INT,
    IN table_num VARCHAR(10),
    OUT confirmation_msg VARCHAR(100)
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO Bookings (BookingID, TableNumber, BookingDate, CustomerID)
    VALUES (booking_id, table_num, booking_date, customer_id);
    
    -- Check if the row was successfully inserted before committing
    IF ROW_COUNT() > 0 THEN
        COMMIT;
        SET confirmation_msg = 'New booking added';
    ELSE
        ROLLBACK;
        SET confirmation_msg = 'Error adding booking';
    END IF;
END //

DELIMITER ;

-- Correct Call: Matches the parameter order (ID, Date, Customer, Table, Output)
CALL AddBooking(8, '2022-08-06', 8, '14', @message);

-- Display the confirmation message
SELECT @message AS Booking_Status;