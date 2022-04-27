USE TritonFleetManagement
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ScaleHour_Delete]')
AND type in (N'P', N'PC'))

PRINT 'YES'
GO 

CREATE PROC proc_ScaleHour_Delete
(
	@ScaleHourID			INT,
	@EmployeeID				INT,
	@CostScaleHour			INT,
	@CreatedOn				DATETIME,
	@CreatedByUserID		INT,
	@DeletedByUserID		INT
)
AS 
BEGIN
	UPDATE TritonFleetManagement.dbo.ScaleHours
	SET ScaleHours.DeletedByUserID  = @DeletedByUserID,
		ScaleHours.DeletedOn = GETDATE()
	WHERE ScaleHours.ScaleHourID = @ScaleHourID
END