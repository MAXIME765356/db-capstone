CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


INSERT INTO Bookings (BookingID, TableNumber,BookingDate, CustomerID)
VALUES
("1","5","2022-10-10", "1"),
("2", "3", "2022-11-12",  "3"),
("3", "2", "2022-10-11", "2"),
("4", "2", "2022-10-13", "1");

SELECT * FROM Bookings;