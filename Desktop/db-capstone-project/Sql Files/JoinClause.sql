CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;


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