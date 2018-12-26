
-- Use SQL TRIGGER to implement business rules

-- Create a demo database
CREATE DATABASE Flight;

-- Switch to the new database
USE Flight;

-- Create demo tables 
CREATE TABLE Reservation (PassengerName varchar(30), FlightNo smallint, FlightDate date);
CREATE TABLE Behavior (PassengerName varchar(30), BehaviorType varchar(20), BehaviorDate date);

/* If a passenger has ever had any previuos abusive behavior, 
   don't allow the passenger to make a reservation again. */

-- Create TRIGGER to implement the business rule

CREATE TRIGGER TR_CheckBehavior
ON dbo.Reservation
AFTER INSERT AS 
BEGIN
   DECLARE @Count smallint=0;
   SELECT @Count = COUNT(PassengerName) 
      FROM Behavior
      WHERE PassengerName = (SELECT PassengerName FROM Inserted)
      AND BehaviorType = 'Abusive';
   IF @Count > 0 
      BEGIN
	     Rollback;
      END
END;

-- Put some data in the new tables
INSERT INTO Behavior (PassengerName, BehaviorType, BehaviorDate)
VALUES ('Mary', 'Helpful', '08-10-2012'),
       ('Peter', 'Abusive', '4-13-2014');

INSERT INTO Reservation (PassengerName, FlightNo, FlightDate)
VALUES ('Mary', 12, '12-20-2015');

INSERT INTO Reservation (PassengerName, FlightNo, FlightDate)
VALUES ('Peter', 33, '12-30-2015');

-- See what we have in Reservation
SELECT * FROM Reservation;

-- Do housekeeping
USE MASTER;
DROP DATABASE Flight;



