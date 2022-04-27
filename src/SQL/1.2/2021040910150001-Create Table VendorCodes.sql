USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[ContactType]    Script Date: 2021/04/10 11:01:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VendorCode]') AND type in (N'U'))
PRINT 'YES'
GO



CREATE TABLE [dbo].[VendorCode]
(
	[VendorCodeID] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CustomerID] INT NOT NULL,
	[CompanyID] INT NOT NULL,
	[VendorCodeTFM] VARCHAR(10) NULL,
	[VendorCodeTTM] VARCHAR(10) NULL,

) 
GO
