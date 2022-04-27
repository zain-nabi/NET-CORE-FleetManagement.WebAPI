USE [TritonFleetManagement]
GO

/****** Object:  Table [dbo].[DocumentRepository]    Script Date: 2021/05/13 08:28:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocumentRepository](
	[DocumentRepositoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[ImgName] [varchar](100) NOT NULL,
	[ImgData] [varbinary](max) NOT NULL,
	[ImgContentType] [varchar](100) NOT NULL,
	[ImgLength] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[DeletedOn] [datetime] NULL,
	[DeletedByUserID] [int] NULL,
 CONSTRAINT [PK_DocumentRepository_1] PRIMARY KEY CLUSTERED 
(
	[DocumentRepositoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


