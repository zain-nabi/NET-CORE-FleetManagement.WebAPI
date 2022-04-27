USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[ContactType]    Script Date: 2021/04/10 11:01:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactType]') AND type in (N'U'))
PRINT 'YES'
GO



CREATE TABLE [dbo].[ContactType]
(
	[ContactTypeID] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CustomerID] INT NOT NULL,
	[ContactTypeLCID] INT NOT NULL,
	[Name] VARCHAR(50) NULL,
	[TelephoneNumber] VARCHAR(20) NULL,
	[Email] VARCHAR(250) NULL,


) 
GO


