CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


CREATE VIEW OrdersView AS SELECT
OrderID,Quantity,TotalCost FROM Orders 
WHERE Quantity > 2;

SELECT * FROM OrdersView;