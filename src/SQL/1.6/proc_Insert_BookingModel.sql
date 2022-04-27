USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_Bookings_Insert_BookingsModel]    Script Date: 2021/04/30 4:30:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[proc_Bookings_Insert_BookingsModel]
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
	@StatusLCID				  INT,	

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
           ,[CreatedByUserID],[DeletedOn],[DeletedByUserID],[QuotationsLCID],[BranchID],[OrderNumber],[StatusLCID])
     VALUES
           (
		     @CustomerID,@VehicleID,@ServiceCategoryTypesLCID,@MileAgeOrHourLCID,@MileAge,@Hour
            ,@EstimatedArrival,@Authorisation,@Notes,@CreatedOn,@CreatedByUserID,NULL,NULL,@QuotationsLCID,@BranchID,@OrderNumber, @StatusLCID
			)

    SET    @BookingID = SCOPE_IDENTITY()

  INSERT INTO [dbo].[BookingReason]([BookingReasonLCID], [BookingsID],[VehicleID])

          SELECT * FROM TritonGroup.dbo.SplitText_For_Insert(@BookingReasonLCID,',',@BookingID,@VehicleID)
  


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