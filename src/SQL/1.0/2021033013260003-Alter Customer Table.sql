USE [TritonFleetManagement]
GO

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'CompanyID'
          AND Object_ID = Object_ID(N'dbo.Customer'))
BEGIN
	ALTER TABLE dbo.Customer
	ADD CompanyID INT NULL
	
END
GO