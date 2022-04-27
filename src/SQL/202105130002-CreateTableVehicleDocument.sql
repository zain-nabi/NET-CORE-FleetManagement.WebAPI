USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[VehicleDocument]    Script Date: 2021/05/13 08:32:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[VehicleDocument](
	[VehicleDocumentID] [bigint] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL,
	[DocumentRepositoryID] [bigint] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[DeletedOn] [datetime] NULL,
	[DeletedByUserID] [int] NULL,
 CONSTRAINT [PK_VehicleDocument] PRIMARY KEY CLUSTERED 
(
	[VehicleDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


