USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_CustomerDocument_DocumentRepository_Delete]    Script Date: 2021/05/10 3:20:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_CustomerDocument_DocumentRepository_Delete]
(
	@DocumentRepositoryID		INT,
	@CustomerID					INT,
	@DeletedByUserID			INT
)
AS 
BEGIN
	UPDATE DocumentRepository
		SET DocumentRepository.DeletedByUserID = @DeletedByUserID,
			DocumentRepository.DeletedOn = GETDATE()
	WHERE DocumentRepository.DocumentRepositoryID = @DocumentRepositoryID

	UPDATE CustomerDocument
		SET CustomerDocument.DeletedBy = @DeletedByUserID,
			CustomerDocument.DeletedOn = GETDATE()
	WHERE CustomerDocument.DocumentRepositoryID = @DocumentRepositoryID
END