USE [TritonFleetManagement]
GO

/****** Object:  StoredProcedure [dbo].[proc_Bookings_Insert_DocumentRepository]    Script Date: 2021/05/13 08:38:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[proc_Bookings_Insert_DocumentRepository]
(
	/*Bookings Parameters*/
	@ImgName                  VARCHAR(100),
	@ImgData				  VARBINARY(MAX),
	@ImgContentType           VARCHAR(100),
	@ImgLength                INT,
	@BookingID				  INT,
	@CreatedByUserID          INT
)
AS
DECLARE     @IsInsertCompletedSuccessfully	BIT = 0,
			@DocumentRepositoryID INT

BEGIN TRAN
BEGIN TRY

	INSERT INTO [dbo].[DocumentRepository]
           ([ImgName], [ImgData], [ImgContentType], [ImgLength],  [CreatedOn], [CreatedByUserID])
    VALUES
           (@ImgName,CAST(@ImgData AS VARBINARY(MAX)),@ImgContentType,@ImgLength,GETDATE(),@CreatedByUserID)

	SELECT @DocumentRepositoryID = MAX(DocumentRepositoryID) FROM DocumentRepository

	INSERT INTO [dbo].[VehicleDocument] 
			([BookingID],[DocumentRepositoryID],[CreatedOn],[CreatedByUserID])
	VALUES 
			(@BookingID,@DocumentRepositoryID,GETDATE(),@CreatedByUserID)
	COMMIT

	SET @IsInsertCompletedSuccessfully = 1
END TRY

BEGIN CATCH
           IF(@IsInsertCompletedSuccessfully = 0)
		   BEGIN
		    ROLLBACK TRANSACTION
		   END
     SELECT @IsInsertCompletedSuccessfully       
END CATCH
GO


