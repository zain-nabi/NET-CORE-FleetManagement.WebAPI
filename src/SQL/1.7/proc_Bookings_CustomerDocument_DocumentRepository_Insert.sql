USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_Bookings_CustomerDocument_DocumentRepository_Insert]    Script Date: 2021/05/10 3:19:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[proc_Bookings_CustomerDocument_DocumentRepository_Insert]
(
	/*Bookings Parameters*/
	@ImgName                  VARCHAR(100),
	@ImgData				  VARBINARY(MAX),
	@ImgContentType           VARCHAR(100),
	@ImgLength                INT,
	@CreatedByUserID          INT,
	@CustomerID				  INT,
	@DocumentCategoryLCID	  INT


)
AS
DECLARE     @IsInsertCompletedSuccessfully BIT = 0
DECLARE		@DocRepoID					   INT

BEGIN TRAN
BEGIN TRY
	
		INSERT INTO [dbo].[DocumentRepository]
           ([ImgName], [ImgData], [ImgContentType], [ImgLength], [CreatedOn], [CreatedByUserID])
		VALUES
           (@ImgName,CAST(@ImgData AS VARBINARY(MAX)),@ImgContentType,@ImgLength,GETDATE(),@CreatedByUserID)

	SET    @DocRepoID = SCOPE_IDENTITY()
	INSERT INTO [TritonFleetManagement].[dbo].[CustomerDocument](CustomerID, DocumentRepositoryID, DocumentCategoryLCID, CreatedOn, CreatedBy)
	VALUES(@CustomerID, @DocRepoID, @DocumentCategoryLCID, GETDATE(), @CreatedByUserID)

	SET @IsInsertCompletedSuccessfully = 1
	COMMIT 




END TRY

BEGIN CATCH
           IF(@IsInsertCompletedSuccessfully = 0)
		   BEGIN
		    ROLLBACK TRANSACTION
		   END
     SELECT @IsInsertCompletedSuccessfully       
END CATCH
