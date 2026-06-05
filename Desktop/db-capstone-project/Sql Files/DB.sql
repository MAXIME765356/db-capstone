CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;

CREATE TABLE Customers (
CustomerID INT AUTO_INCREMENT,
FullName VARCHAR(200),
ContactNumber VARCHAR(100),
Email VARCHAR(100),
PRIMARY KEY (CustomerID)
);

CREATE TABLE Orders (
OrderID INT,
CustomerID INT,
MenuID INT,
TotalCost DECIMAL,
Quantity INT,
PRIMARY KEY (OrderID),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (MenuID) REFERENCES Menus(MenuID)
);

CREATE TABLE Menus (
MenuID INT,
MenuItemID INT,
MenuName VARCHAR(100),
Cuisine VARCHAR(100),
PRIMARY KEY (MenuID, MenuItemID)
);

CREATE TABLE MenuItems (
MenuItemID INT AUTO_INCREMENT,
CourseName VARCHAR(200),
StarterName VARCHAR(100),
DessertName VARCHAR(100),
PRIMARY KEY (MenuItemID)
);

INSERT INTO Orders (OrderID, CustomerID, MenuID, TotalCost, Quantity)
VALUES
("1", "5", "1", "200", "6"),
("2", "4", "2", "250", "37"),
("3", "2", "4", "300",  "7"),
("4", "1", "5", "400", "40"),
("5", "3", "3", "500", "43");


INSERT INTO Customers (CustomerID, FullName, ContactNumber, Email)
VALUES
("1", "max", "634773", "max@gmail.com"),
("2", "joe", "689033", "joe@gmail.com"),
("3", "mike", "690324",  "mike@gmail.com"),
("4", "harris", "678839", "harris@gmail.com"),
("5", "john", "6588995", "john@gmail.com");

INSERT INTO Menus (MenuID, MenuItemID, MenuName, Cuisine)
VALUES
("1", "7","breakfast", "Greek"),
("5", "3","supper", "Italian"),
("2", "9","dinner", "Italian"),
("4", "10","supper", "Italian"),
("3", "16","supper", "Turkish");


INSERT INTO MenuItems (MenuItemID, CourseName, StarterName, DessertName)
VALUES
("7","Olives","moussaka","salad"),
("9","Flatbread","fish", "bread"),
("3", "Minestrone", "peanut butter", "chicken"),
("10", "Tomato bread","bean", "pork"),
("16", "Falafel", "banana", "juice");


CREATE VIEW OrdersView AS SELECT
OrderID,Quantity,TotalCost FROM Orders 
WHERE Quantity > 2;

SELECT * FROM OrdersView;

SELECT 
    Customers.CustomerID, 
    Customers.FullName, 
    Orders.OrderID, 
    Orders.TotalCost,
    MenuItems.CourseName, 
    MenuItems.DessertName
FROM Customers 
INNER JOIN Orders 
    ON Customers.CustomerID = Orders.CustomerID 
INNER JOIN Menus 
    ON Orders.MenuID = Menus.MenuID -- Assumes a linking/bridge table exists
INNER JOIN MenuItems 
    ON MenuItems.MenuItemID = Menus.MenuItemID 
WHERE Orders.TotalCost > 150;

SELECT MenuName 
FROM Menus 
WHERE MenuID IN (
    SELECT MenuID 
    FROM Orders 
    WHERE Quantity > 2
); 



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

SET @id = 1;
PREPARE GetOrderDetail FROM 'SELECT OrderID,Quantity,TotalCost FROM Orders WHERE CustomerID= ?';
EXECUTE GetOrderDetail USING @id;
   

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

SELECT * FROM Orders;



CREATE TABLE Bookings (
BookingID INT AUTO_INCREMENT,
TableNumber INT,
BookingDate DATE NOT NULL,
CustomerID INT,
PRIMARY KEY (BookingID)
);


INSERT INTO Bookings (BookingID, TableNumber,BookingDate, CustomerID)
VALUES
("1","5","2022-10-10", "1"),
("2", "3", "2022-11-12",  "3"),
("3", "2", "2022-10-11", "2"),
("4", "2", "2022-10-13", "1");

SELECT * FROM Bookings;



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
CALL AddValidBooking("2022-10-01", "18", @message);

-- Display the confirmation message
SELECT @message AS Booking_Status;

SELECT * FROM Bookings;



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
CALL AddBooking(8, '2022-08-06', 9, '19', @message);

-- Display the confirmation message
SELECT @message AS Booking_Status;

-- Verify the table contents
SELECT * FROM Bookings;



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
CALL  UpdateBooking("1","2023-01-01", @message);

-- Display the confirmation message
SELECT @message AS Confirmation;

SELECT * FROM Bookings;


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
CALL CancelBooking("2", @message);

-- Display the confirmation message
SELECT @message AS Confirmation;




