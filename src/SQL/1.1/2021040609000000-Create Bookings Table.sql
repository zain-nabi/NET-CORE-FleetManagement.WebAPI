USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[Customer]    Script Date: 2021/03/29 2:24:47 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bookings]') AND type in (N'U'))
PRINT 'YES'
GO


CREATE TABLE [dbo].[Bookings](
	[BookingsID] INT  PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CustomerID] INT NOT NULL,
	[VehicleID] INT NOT NULL,
	[BookingReasonLCID] INT NOT NULL, 
	[ServiceCategoryTypesLCID] INT NOT NULL,
	[MileAgeOrHourLCID] INT NOT NULL,
	[MileAge] INT  NULL,
	[Hour] INT NULL,
	[EstimatedArrival] DATETIME NULL,
	[Quotations] BIT NOT NULL,
	[Authorisation] BIT NOT NULL,
	[Notes] VARCHAR (MAX) NULL,
	[CreatedOn] DATETIME NOT NULL,
	[CreatedByUserID] INT NOT NULL,
	[DeletedOn] DATETIME NULL,
	[DeletedByUserID] INT  NULL,
)
GO


