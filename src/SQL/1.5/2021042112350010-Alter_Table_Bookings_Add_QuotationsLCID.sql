USE TritonFleetManagement
GO


IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'QuotationsLCID'
          AND Object_ID = Object_ID(N'dbo.Bookings')
		  )
BEGIN
	ALTER TABLE dbo.Bookings
	ADD QuotationsLCID INT  NULL
	
END
GO
