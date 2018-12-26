
-- Use Table-Level CHECK Constraint to implement business rules

-- Create a demo database
CREATE DATABASE Flight;

-- Switch to the new database
USE Flight;

-- Create demo tables 
CREATE TABLE Reservation (PassengerName varchar(30), FlightNo smallint, FlightDate date);
CREATE TABLE Behavior (PassengerName varchar(30), BehaviorType varchar(20), BehaviorDate date);

-- Create a function to check whether a passenger has ever had abusive behavior
-- Function will return a number greater than 0 if a passenger has had abusive behavior before

CREATE FUNCTION CheckBehavior (@PName varchar(30))
RETURNS smallint
AS
BEGIN
   DECLARE @Count smallint=0;
   SELECT @Count = COUNT(PassengerName) 
          FROM Behavior
          WHERE PassengerName = @PName
          AND BehaviorType = 'Abusive';
   RETURN @Count;
END;

-- Add table-level CHECK constraint based on the new function for the Reservation table
ALTER TABLE Reservation ADD CONSTRAINT BanBadBehavior CHECK (dbo.CheckBehavior(PassengerName) = 0);

-- Put some data in the new tables
INSERT INTO Behavior (PassengerName, BehaviorType, BehaviorDate)
VALUES ('Mary', 'Helpful', '08-10-2012'),
       ('Peter', 'Abusive', '4-13-2014');

INSERT INTO Reservation (PassengerName, FlightNo, FlightDate)
VALUES ('Mary', 12, '12-20-2015');

INSERT INTO Reservation (PassengerName, FlightNo, FlightDate)
VALUES ('Peter', 33, '12-30-2015');


SELECT * FROM Reservation;
SELECT * FROM Behavior;

-- Do housekeeping
USE master;
DROP DATABASE Flight;

