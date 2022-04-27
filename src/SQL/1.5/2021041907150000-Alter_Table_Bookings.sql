USE TritonFleetManagement
GO



IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Bookings' 
    AND column_name = 'BookingReasonLCID'
)
BEGIN
 ALTER TABLE Bookings
 DROP COLUMN BookingReasonLCID
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'QuotationsLCID'
          AND Object_ID = Object_ID(N'dbo.Bookings')
		  )
BEGIN
	ALTER TABLE dbo.Bookings
	ADD QuotationsLCID INT  NULL
	
END
GO


IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'BranchID'
          AND Object_ID = Object_ID(N'dbo.Bookings')
		  )
BEGIN
	ALTER TABLE dbo.Bookings
	ADD BranchID INT  NULL
	
END
GO

IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Bookings' 
    AND column_name = 'Quotations'
)
BEGIN
 ALTER TABLE Bookings
 DROP COLUMN Quotations
END

IF NOT EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Bookings' 
    AND column_name = 'OrderNumber'
)
BEGIN
 ALTER TABLE Bookings
 ADD  OrderNumber VARCHAR(255)
END