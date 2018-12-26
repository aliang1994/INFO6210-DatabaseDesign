CREATE DATABASE OurInsteadOfTrigger;
GO

USE OurInsteadOfTrigger;

CREATE TABLE dbo.Customers
    (
    CustomerID varchar(5) NOT NULL PRIMARY KEY ,
    Name varchar(40) NOT NULL
    );

CREATE TABLE dbo.Orders
     (
    OrderID int IDENTITY NOT NULL PRIMARY KEY,
    CustomerID varchar(5) NOT NULL
        REFERENCES Customers(CustomerID),
    OrderDate datetime NOT NULL
    );

CREATE TABLE dbo.Products
     (
    ProductID int IDENTITY NOT NULL PRIMARY KEY,
    Name varchar(40) NOT NULL,
    UnitPrice money NOT NULL
    );

CREATE TABLE dbo.OrderItems
     (
    OrderID int NOT NULL
        REFERENCES dbo.Orders(OrderID),
    ProductID int NOT NULL
        REFERENCES dbo.Products(ProductID),
    UnitPrice money NOT NULL,
    Quantity int NOT NULL
        CONSTRAINT PKOrderItem PRIMARY KEY CLUSTERED 
             (OrderID, ProductID)
    );

-- INSERT sample records
INSERT dbo.Customers
    VALUES ('ABCDE', 'Bob''s Pretty Good Garage');

INSERT dbo.Orders
    VALUES ('ABCDE', CURRENT_TIMESTAMP);

INSERT dbo.Products
    VALUES ('Widget', 5.55),
           ('Thingamajig', 8.88)

INSERT dbo.OrderItems
    VALUES (1, 1, 5.55, 3);


CREATE VIEW CustomerOrders_vw
WITH SCHEMABINDING
AS
SELECT o.OrderID, o.OrderDate, od.ProductID, p.Name, od.Quantity, od.UnitPrice
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS od
ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
ON od.ProductID = p.ProductID;

/*ERROR: View or function 'CustomerOrders_vw' is not updatable because the modification affects multiple base tables.*/

INSERT INTO CustomerOrders_vw
    (OrderID, OrderDate, ProductID, Quantity, UnitPrice)
VALUES
    (1, '1998-04-06', 2, 10, 6.00 );

------------------------------------------------------------------------------------------
/*SOLUTION: INSTEAD OF TRIGGERS */
   
   
CREATE TRIGGER trCustomerOrderInsert 
ON CustomerOrders_vw
INSTEAD OF INSERT
AS
BEGIN
    -- Check to see whether the INSERT actually tried to feed us any rows.
    -- (A WHERE clause might have filtered everything out)
    IF (SELECT COUNT(*) FROM Inserted) > 0
    BEGIN
        INSERT INTO dbo.OrderItems
            SELECT  i.OrderID, i.ProductID, i.UnitPrice, i.Quantity
            FROM Inserted AS i
            JOIN Orders AS o
                ON i.OrderID = o.OrderID;
        -- If we have records in Inserted, but no records could join to
        -- the orders table, then there must not be a matching order            
        IF @@ROWCOUNT = 0
            RAISERROR('No matching Orders. Cannot perform insert',10,1);
    END
END;



INSERT INTO CustomerOrders_vw
    (OrderID, OrderDate, ProductID, Quantity, UnitPrice)
VALUES
    (1, '1998-04-06', 2, 10,  6.00);

   
   
   
SELECT * FROM CustomerOrders_vw; 



-----------------------------------------------------------------------------------------------
CREATE TRIGGER trCustomerOrderDelete ON CustomerOrders_vw
INSTEAD OF DELETE
AS
BEGIN

    -- Check to see whether the DELETE actually tried to feed us any rows
    -- (A WHERE clause might have filtered everything out)
    IF (SELECT COUNT(*) FROM Deleted) > 0
    BEGIN
        DELETE oi
            FROM dbo.OrderItems AS oi
            JOIN Deleted AS d
                ON d.OrderID = oi.OrderID
               AND d.ProductID = oi.ProductID;

        DELETE Orders
            FROM Orders AS o
            JOIN Deleted AS d
                ON o.OrderID = d.OrderID
            LEFT JOIN OrderItems AS oi
                ON oi.OrderID = d.OrderID
            WHERE oi.OrderID IS NULL;
    END
END

DELETE CustomerOrders_vw
WHERE OrderID = 1
  AND ProductID = 2;

DELETE CustomerOrders_vw
WHERE OrderID = 1;

USE master;

DROP DATABASE OurInsteadOfTrigger;
