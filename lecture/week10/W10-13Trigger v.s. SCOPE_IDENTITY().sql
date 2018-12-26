USE LIANG_WENQING_TEST;

CREATE DATABASE OurInsteadOfTrigger;
GO

USE OurInsteadOfTrigger;

CREATE TABLE dbo.Customers (
    CustomerID varchar(5) NOT NULL PRIMARY KEY ,
    Name varchar(40) NOT NULL
    );

CREATE TABLE dbo.Orders (
    OrderID int IDENTITY NOT NULL PRIMARY KEY,
    CustomerID varchar(5) NOT NULL
        REFERENCES Customers(CustomerID),
    OrderDate datetime NOT NULL
    );

CREATE TABLE dbo.Products (
    ProductID int IDENTITY NOT NULL PRIMARY KEY,
    Name varchar(40) NOT NULL,
    UnitPrice money NOT NULL
    );

CREATE TABLE dbo.OrderItems (
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
   
--DROP TABLE dbo.OrderItems;
--SELECT * FROM dbo.OrderItems;

CREATE VIEW CustomerOrders_vw
WITH SCHEMABINDING
AS
SELECT   
	c.CustomerID, o.OrderID, o.OrderDate, od.ProductID, p.Name, od.Quantity, od.UnitPrice
FROM dbo.Orders AS o
JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
JOIN dbo.OrderItems AS od
    ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
    ON od.ProductID = p.ProductID;

   
   
   
   
-- ERROR: View or function 'CustomerOrders_vw' is not updatable because the modification affects multiple base tables.
INSERT INTO CustomerOrders_vw
    (OrderID, OrderDate, ProductID, Quantity, UnitPrice)
VALUES
    (1, getdate(), 2, 10, 6.00);

   
SELECT * FROM CustomerOrders_vw;
   
-- Add an item for an existing order
-- use instead of trigger to insert items into views

   
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
END


-- Add an item, create a new order if necessary

CREATE TRIGGER trCustomerOrderInsert2 
ON CustomerOrders_vw
INSTEAD OF INSERT
AS
BEGIN
    -- Check to see whether the INSERT actually tried to feed us any rows.
    -- (A WHERE clause might have filtered everything out)
    IF (SELECT COUNT(*) FROM Inserted) > 0
    BEGIN
	    DECLARE @cid VARCHAR(5), @oid INT, @newoid INT, @pid INT, @up MONEY, @qt INT;
		SELECT @cid = CustomerID, @oid = OrderID, @pid = ProductID, @up = UnitPrice, @qt = Quantity FROM inserted;
		IF NOT EXISTS (SELECT 1 FROM dbo.Orders WHERE OrderID = @oid)
		   BEGIN
		      INSERT dbo.Orders (CustomerID, OrderDate)
			  VALUES (@cid, getdate());
			  SET @newoid = SCOPE_IDENTITY();
		   END

        IF @newoid IS NULL 
			INSERT INTO dbo.OrderItems VALUES(@oid, @pid, @up, @qt)
		ELSE
			INSERT INTO dbo.OrderItems VALUES (@newoid, @pid, @up, @qt);
    END
END

INSERT INTO CustomerOrders_vw
    (OrderID, OrderDate, ProductID, Quantity,  UnitPrice)
VALUES
    ( 1,  getdate(), 2, 10, 6.00 );

/* 
 * SCOPE_IDENTITY():
 * Returns the last identity value inserted into an identity column in the same scope. 
 * A scope is a module: a stored procedure, trigger, function, or batch. 
 * Therefore, if two statements are in the same stored procedure, function, or batch, they are in the same scope.
 * 
 */
   
   
   
INSERT INTO CustomerOrders_vw
    (CustomerID, OrderDate, ProductID, Quantity, UnitPrice)
VALUES
    ('ABCDE', getdate(), 2, 25, 6.00 );

select * from CustomerOrders_vw;


USE Master;

DROP DATABASE OurInsteadOfTrigger;
