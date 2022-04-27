USE TritonFleetManagement
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ScaleHours_Insert_RemoveDuplicateEmployee]')
AND type in (N'P', N'PC'))

PRINT 'YES'
GO 


CREATE PROC [dbo].[proc_ScaleHours_Insert_RemoveDuplicateEmployee]
(
	@EmployeeID			INT,
	@CostScaleHour		INT,
	@CreatedOn			DATETIME,
	@CreatedByUserID	INT
)
AS
BEGIN TRAN
BEGIN TRY

DECLARE     @IsCompletedSuccessfully BIT = 0
DECLARE		@EmployeeExist			 BIT = 0

	IF EXISTS(SELECT SC.EmployeeID FROM TritonFleetManagement.dbo.ScaleHours SC WHERE SC.EmployeeID = @EmployeeID)
	BEGIN
		SET @EmployeeExist =  1
	END

	IF(@EmployeeExist = 1)
	BEGIN
		DELETE FROM TritonFleetManagement.dbo.ScaleHours WHERE TritonFleetManagement.dbo.ScaleHours.EmployeeID = @EmployeeID
		INSERT INTO TritonFleetManagement.dbo.ScaleHours(EmployeeID, CostScaleHour, CreatedOn, CreatedByUserID)
			VALUES(@EmployeeID, @CostScaleHour, @CreatedOn, @CreatedByUserID)
	END

	ELSE
	BEGIN
		INSERT INTO TritonFleetManagement.dbo.ScaleHours(EmployeeID, CostScaleHour, CreatedOn, CreatedByUserID)
			VALUES(@EmployeeID, @CostScaleHour, @CreatedOn, @CreatedByUserID)
	END
  SET @IsCompletedSuccessfully = 1
  COMMIT 
END TRY
BEGIN CATCH
           IF(@IsCompletedSuccessfully = 0)
		   BEGIN
		    ROLLBACK TRANSACTION

		   END     
END CATCH