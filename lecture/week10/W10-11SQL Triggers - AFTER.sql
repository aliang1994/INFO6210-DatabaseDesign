USE AdventureWorks2012;
GO

/************EXAMPLE 1*****************************/

-- Rollback order if the order contains products that were discontinued
CREATE TRIGGER OrderDetailNotDiscontinued
   ON Sales.SalesOrderDetail
   AFTER INSERT, UPDATE
AS
   IF EXISTS (
       SELECT 'True' 
       FROM Inserted i
       JOIN Production.Product p
          ON i.ProductID = p.ProductID
       WHERE p.DiscontinuedDate IS NOT NULL)
   BEGIN
      ROLLBACK TRAN
      RAISERROR('Order Item is discontinued. Transaction Failed.', 16, 1)
   END;

   
DROP TRIGGER Sales.OrderDetailNotDiscontinued 
   
   
   
-- Test the trigger by creating an order with discontinued date product
UPDATE Production.Product
SET DiscontinuedDate = NULL
WHERE ProductID = 680;

SELECT ProductID, Name, DiscontinuedDate 
FROM Production.Product 
WHERE DiscontinuedDate IS NOT NULL;

UPDATE Production.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 680;

INSERT Sales.SalesOrderDetail(
   SalesOrderID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount)
VALUES (43660, 5, 680, 1, 1431, 0);

  




--COALESCE() example
/*
 * 
 * Evaluates the arguments in order and returns the current value of the first expression that initially does not evaluate to NULL. 
 * For example, SELECT COALESCE(NULL, NULL, 'third_value', 'fourth_value'); 
 * returns the third value because the third value is the first value that is not null.
 * 
 */

SELECT Name, Class, Color, ProductNumber,  
COALESCE(Class, Color, ProductNumber) AS FirstNotNull  
FROM Production.Product;  
  
  
  
  
/************EXAMPLE 2*****************************/


CREATE TABLE Production.InventoryAudit (
    TransactionID   int        IDENTITY PRIMARY KEY,
    ProductID       int        NOT NULL REFERENCES Production.Product(ProductID),
    NetAdjustment   smallint    NOT NULL,
    ModifiedDate    datetime    DEFAULT(CURRENT_TIMESTAMP)
);

DROP TABLE Production.InventoryAudit



CREATE TRIGGER ProductAudit
    ON Production.ProductInventory
    FOR INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO Production.InventoryAudit (ProductID, NetAdjustment)
       SELECT 
       		COALESCE(i.ProductID, d.ProductID), 
            ISNULL(i.Quantity, 0) - ISNULL(d.Quantity, 0) AS NetAdjustment
       FROM Inserted i
       FULL JOIN Deleted d
          ON i.ProductID = d.ProductID
          AND i.LocationID = d.LocationID
       WHERE ISNULL(i.Quantity, 0) - ISNULL(d.Quantity, 0) != 0;
END


DROP TRIGGER Production.ProductAudit;


/*
 * ISNULL ( check_expression , replacement_value ):  
 * Replaces NULL with the specified replacement value.
 * 
 * 
 * The FULL JOIN keyword returns all the rows from the left table , 
 * and all the rows from the right table. 
 * If there are rows in LEFT that do not have matches in RIGHT, 
 * or if there are rows in RIGHT that do not have matches in LEFT, 
 * those rows will be listed as NULL.
 * 
 */



PRINT 'The values before the change are:'
SELECT ProductID, LocationID, Quantity
FROM Production.ProductInventory
WHERE ProductID = 1 AND LocationID = 50;

PRINT 'Now making the change'
UPDATE Production.ProductInventory
SET Quantity = Quantity + 7
WHERE ProductID = 1 AND LocationID = 50;

PRINT 'The values after the change are:'
SELECT ProductID, LocationID, Quantity
FROM Production.ProductInventory
WHERE ProductID = 1 AND LocationID = 50;

SELECT * FROM Production.InventoryAudit;








/************EXAMPLE 3*****************************/

ALTER TABLE Production.Product
   ADD InformationFlag    bit
   CONSTRAINT InformationFlagDefault DEFAULT 0 WITH VALUES;

/* When you add a nullable column with a default constraint to a table, 
   then all existing rows will get the new column with a NULL as its value. 
   The defined default values will only be applied to new rows being inserted 
   (if they don't have a value for that column in their INSERT statement).

   When you specify WITH VALUES, then all existing rows will get that defined 
   default value instead of NULL.

   If the column you're adding to your new table is non-nullable and has 
   a default constraint, then that default value is applied to all existing rows 
   in the table automatically (no need for WITH VALUES 
   because the column must have a value other than NULL). */

UPDATE p
SET p.InformationFlag = 1
FROM Production.Product p
WHERE EXISTS (SELECT 1 FROM Production.ProductDocument pd WHERE pd.ProductID = p.ProductID );

/* select 1 from table will return the constant 1 for every row of the table. 
 * It's useful when you want to cheaply determine if record matches your where clause and/or join.*/

CREATE TRIGGER DocumentBelongsToProduct
   ON Production.ProductDocument
   FOR INSERT
AS
BEGIN
   DECLARE @Count   int;
   SELECT @Count = COUNT(*) FROM Inserted;
   IF @Count > 0
   BEGIN
         UPDATE p
            SET p.InformationFlag = 1
            FROM Inserted i
            JOIN Production.Product p
               ON i.ProductID = p.ProductID;
   END
   IF @@ERROR != 0
      ROLLBACK TRAN;
END


SELECT ProductID, InformationFlag 
FROM Production.Product p
WHERE p.ProductID = 1;






INSERT INTO Production.ProductDocument
    (ProductID, DocumentNode)
VALUES
    (1, 0x);

SELECT ProductID, InformationFlag 
FROM Production.Product p
WHERE p.ProductID = 1;





-- Clean up what we did before
DROP TRIGGER Production.DocumentBelongsToProduct

ALTER TABLE Production.Product 
      DROP CONSTRAINT InformationFlagDefault

ALTER TABLE Production.Product
      DROP COLUMN InformationFlag;

DELETE Production.ProductDocument
      WHERE ProductID < 5;

