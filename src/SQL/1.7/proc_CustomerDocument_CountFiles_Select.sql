USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_CustomerDocument_CountFiles_Select]    Script Date: 2021/05/11 11:33:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_CustomerDocument_CountFiles_Select]
(
	@CustomerID				INT
)
AS 
BEGIN
SELECT  
	COUNT(CD.DocumentRepositoryID) DocumentRepositoryID
FROM 
	CustomerDocument CD
WHERE 
	CD.CustomerID = @CustomerID AND CD.DeletedOn IS NULL
GROUP BY
	CD.CustomerID
END