USE [TritonFleetManagement]
GO

/****** Object:  StoredProcedure [dbo].[proc_Bookings_Delete_DocumentRepository]    Script Date: 2021/05/13 08:39:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[proc_Bookings_Delete_DocumentRepository]
(
	@VehicleDocumentID		INT,
	@DeletedByUserID		INT
)
AS
DECLARE     @IsUpdateCompletedSuccessfully BIT = 0

BEGIN TRAN
BEGIN TRY

	DECLARE @DocumentRepositoryID INT = (SELECT DocumentRepositoryID FROM VehicleDocument WHERE VehicleDocumentID  = @VehicleDocumentID)

	UPDATE [TritonFleetManagement].[dbo].[DocumentRepository]
	SET DeletedByUserID = @DeletedByUserID, DeletedOn = GETDATE()
	WHERE DocumentRepositoryID = @DocumentRepositoryID

	UPDATE [TritonFleetManagement].[dbo].[VehicleDocument]
	SET DeletedByUserID = @DeletedByUserID, DeletedOn = GETDATE()
	WHERE VehicleDocumentID = @VehicleDocumentID

	COMMIT;

	SET @IsUpdateCompletedSuccessfully = 1
END TRY

BEGIN CATCH
           IF(@IsUpdateCompletedSuccessfully = 0)
		   BEGIN
		    ROLLBACK TRANSACTION
		   END
     SELECT @IsUpdateCompletedSuccessfully       
END CATCH
GO


