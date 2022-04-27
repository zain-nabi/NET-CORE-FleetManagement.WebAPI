USE [TritonFleetManagement]
GO

CREATE PROCEDURE  proc_Bookings_Update_BookingsModel
(
	/*Bookings Parameters*/
	@BookingsID               INT,
    @CustomerID               INT,
	@VehicleID                INT,
	@ServiceCategoryTypesLCID INT,
	@MileAgeOrHourLCID        INT,
	@MileAge                  INT,
	@Hour                     INT,
	@EstimatedArrival         DATETIME,
	@Authorisation            BIT,
	@Notes                    VARCHAR(Max),
	@CreatedByUserID          INT,
	@QuotationsLCID           INT,
	@BranchID                 INT,
	@OrderNumber              VARCHAR(250),

	/*BookingReasons*/ 
	
	@BookingReasonLCID         VARCHAR(Max)
)
AS
DECLARE		@BookingID	INT
DECLARE     @IsInsertCompletedSuccessfully BIT = 0
 
BEGIN TRAN
BEGIN TRY
  DECLARE
    @counter    INT = 1,
    @max        INT = 0 

  DECLARE @BookingsReasons TABLE  
  (  
    IDCount INT ,
	id INT,
    Value VARCHAR(MAX) 
  ) 
 
  INSERT INTO  @BookingsReasons(IDCount,id,Value)     

  SELECT 
   ROW_NUMBER() OVER (
	ORDER BY Value
   ) IDCount,
   id,
   Value
   FROM TritonGroup.dbo.SplitText(@BookingReasonLCID,',',@BookingsID)
   SELECT @max = (SELECT COUNT(IDCount) FROM @BookingsReasons)


   UPDATE [dbo].[Bookings]
   SET [CustomerID] = @CustomerID
      ,[VehicleID] = @VehicleID
      ,[ServiceCategoryTypesLCID] = @ServiceCategoryTypesLCID
      ,[MileAgeOrHourLCID] = @MileAgeOrHourLCID
      ,[MileAge] = @MileAge
      ,[Hour] = @Hour
      ,[EstimatedArrival] = @EstimatedArrival
      ,[Authorisation] = @Authorisation
      ,[Notes] = @Notes
      ,[DeletedByUserID] = @CreatedByUserID
      ,[QuotationsLCID] = @QuotationsLCID
      ,[BranchID] = @BranchID
      ,[OrderNumber] = @OrderNumber
	  ,[DeletedOn] = GETDATE()
 WHERE BookingsID = @BookingsID

 

-- Loop 
WHILE @counter <= @max
BEGIN

  IF (SELECT count(*) FROM  [TritonFleetManagement].[dbo].[BookingReason] BR WITH(NOLOCK) 
      WHERE BR.BookingsID = @BookingsID
	  AND BR.[BookingReasonLCID] = (SELECT  Value FROM @BookingsReasons WHERE IDCount =@counter) 
	  ) > 0
  BEGIN

 	UPDATE [dbo].[BookingReason]
 	SET BookingReasonLCID =(SELECT  Value FROM @BookingsReasons WHERE IDCount =@counter),
 	    DeletedOn = GETDATE(),
 		DeletedByUserID = @CreatedByUserID
 	WHERE BookingsID = @BookingsID
	AND BookingReasonLCID = (SELECT  Value FROM @BookingsReasons WHERE IDCount =@counter)
 END
 ELSE
  BEGIN
    INSERT INTO [dbo].[BookingReason]([BookingsID],[BookingReasonLCID])

          SELECT Id,Value FROM @BookingsReasons WHERE IDCount = @counter
  END
  SET @counter = @counter + 1
END

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
