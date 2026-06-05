CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


SET @id = 1;
PREPARE GetOrderDetail FROM 'SELECT OrderID,Quantity,TotalCost FROM Orders WHERE CustomerID= ?';
EXECUTE GetOrderDetail USING @id;
   