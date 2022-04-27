USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[BookingAudit]    Script Date: 2021/05/20 12:05:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerAudit](
	[CustomerAuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [char](1) NULL,
	[TableName] [varchar](128) NULL,
	[PKColumnName] [varchar](1000) NULL,
	[PK] [bigint] NULL,
	[FieldName] [varchar](128) NULL,
	[OldValue] [varchar](1000) NULL,
	[NewValue] [varchar](1000) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
 CONSTRAINT [PK_CustomerAuditID] PRIMARY KEY CLUSTERED 
(
	[CustomerAuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


