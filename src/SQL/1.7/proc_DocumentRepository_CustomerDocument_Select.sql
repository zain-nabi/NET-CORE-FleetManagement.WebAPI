USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_DocumentRepository_CustomerDocument_Select]    Script Date: 2021/05/10 3:17:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_DocumentRepository_CustomerDocument_Select]
(
	@CustomerID			INT
)
AS
BEGIN
SELECT 
	DR.DocumentRepositoryID,
	DR.ImgName,
	DR.ImgData,
	DR.ImgContentType
FROM DocumentRepository DR
INNER JOIN CustomerDocument CD ON CD.DocumentRepositoryID = DR.DocumentRepositoryID
WHERE CD.CustomerID = @CustomerID AND DR.DeletedOn IS NULL AND DR.DeletedByUserID IS NULL AND CD.DeletedOn IS NULL AND CD.DeletedBy IS NULL
END