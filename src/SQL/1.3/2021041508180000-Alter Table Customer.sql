USE TritonFleetManagement
GO

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'CompanyRegistration'
          AND Object_ID = Object_ID(N'dbo.Customer'))
BEGIN
	ALTER TABLE dbo.Customer
	ADD CompanyRegistration VARCHAR(250) NULL
	
END
GO