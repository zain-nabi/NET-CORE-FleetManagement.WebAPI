USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[ContactType]    Script Date: 2021/04/10 11:01:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookingReason]') AND type in (N'U'))
PRINT 'YES'
GO



CREATE TABLE [dbo].[BookingReason]
(
	[BookingReasonsID] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[BookingsID] INT NOT NULL,
	[BookingReasonLCID] INT NOT NULL,
	[DeletedOn] DATETIME NULL,
    [DeletedByUserID] INT NULL
) 
GO
