USE [TritonFleetManagement]
GO

CREATE PROCEDURE  proc_Bookings_Insert_BookingsModel
(
	/*Bookings Parameters*/
    @CustomerID               INT,
	@VehicleID                INT,
	@ServiceCategoryTypesLCID INT,
	@MileAgeOrHourLCID        INT,
	@MileAge                  INT,
	@Hour                     INT,
	@EstimatedArrival         DATETIME,
	@Authorisation            BIT,
	@Notes                    VARCHAR(Max),
	@CreatedOn                DATETIME,
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

	INSERT INTO [dbo].[Bookings]
           ([CustomerID],[VehicleID],[ServiceCategoryTypesLCID],[MileAgeOrHourLCID],[MileAge]
            ,[Hour],[EstimatedArrival],[Authorisation],[Notes],[CreatedOn]
           ,[CreatedByUserID],[DeletedOn],[DeletedByUserID],[QuotationsLCID],[BranchID],[OrderNumber])
     VALUES
           (
		     @CustomerID,@VehicleID,@ServiceCategoryTypesLCID,@MileAgeOrHourLCID,@MileAge,@Hour
            ,@EstimatedArrival,@Authorisation,@Notes,@CreatedOn,@CreatedByUserID,NULL,NULL,@QuotationsLCID,@BranchID,@OrderNumber
			)

    SET    @BookingID = SCOPE_IDENTITY()

  INSERT INTO [dbo].[BookingReason]([BookingsID],[BookingReasonLCID])

          SELECT * FROM TritonGroup.dbo.SplitText(@BookingReasonLCID,',',@BookingID)
  


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
