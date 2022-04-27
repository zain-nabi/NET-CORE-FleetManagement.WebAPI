USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[Customer]    Script Date: 2021/03/29 2:24:47 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
PRINT 'YES'
GO


CREATE TABLE [dbo].[Customer](
	[CustomerID] [int]  PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[AccountNumber] [varchar](255) NOT NULL,
	[VatRegistration] [varchar](50) NOT NULL,
	[TelephoneNumber] [varchar](20) NOT NULL,
	[CellphoneNumber] [varchar](20) NOT NULL,
	[Email] [varchar](350) NOT NULL,
	[CreditLimit] [decimal](18, 2) NOT NULL,
	[LoyaltySpend] [decimal](18, 2) NOT NULL,
	[LoyaltyStatusLCID] [int] NOT NULL,
	[AccountStatusTypeLCID] [int] NOT NULL,
	[CustomerTypeLCID] [int] NOT NULL,
	[PhysicalAddress1] [varchar](500) NULL,
	[PhysicalAddress2] [varchar](500) NULL,
	[PhysicalSuburb] [varchar](500) NULL,
	[PhysicalPostalCode] [varchar](10) NULL,
	[PostalAddress1] [varchar](500) NULL,
	[PostalAddress2] [varchar](500) NULL,
	[PostalSuburb] [varchar](500) NULL,
	[PostalCode] [varchar](10) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[DeletedOn] [datetime] NULL,
	[DeletedByUserID] [int] NULL,
)
GO


