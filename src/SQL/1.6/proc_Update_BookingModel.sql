USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_Bookings_Update_BookingsModel]    Script Date: 2021/04/30 4:31:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE  [dbo].[proc_Bookings_Update_BookingsModel]  
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
 @ActualArrival			   DATETIME,
 @Authorisation            BIT,  
 @Notes                    VARCHAR(Max),  
 @CreatedByUserID          INT,  
 @QuotationsLCID           INT,  
 @BranchID                 INT,  
 @OrderNumber              VARCHAR(250),  
 @isJobCard				   BIT,
 @StatusLCID			   INT,
 @MechanicEmployeeID	   INT,
  
 /*BookingReasons*/   
   
 @BookingReasonLCID         VARCHAR(Max),
 @DeleteBookingReasonLCID   VARCHAR(Max)
 
)  
AS  
DECLARE  @BookingID INT  
DECLARE     @IsInsertCompletedSuccessfully BIT = 0  
   
BEGIN TRAN  
BEGIN TRY  
  DECLARE  
    @counter           INT = 1,  
    @max               INT = 0,   
    @DeleteCounter     INT = 1,  
    @DeleteMax         INT = 0


  IF(@DeleteBookingReasonLCID IS NOT NULL)
  BEGIN
    DECLARE @DeleteBookingsReasons TABLE    
  (    
    IDCount INT ,  
    id INT,  
    Value VARCHAR(MAX)   
  )   
   
   INSERT INTO  @DeleteBookingsReasons(IDCount,id,Value)       
  
  SELECT   
   ROW_NUMBER() OVER (  
   ORDER BY Value  
   ) IDCount,  
   id,  
   Value  
   FROM TritonGroup.dbo.SplitText(@DeleteBookingReasonLCID,',',@BookingsID)  

  SELECT @DeleteMax = (SELECT COUNT(IDCount) FROM @DeleteBookingsReasons)  
 
  END

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
	  ,[ActualArrival] =  @ActualArrival
      ,[Authorisation] = @Authorisation  
      ,[Notes] = @Notes  
      ,[QuotationsLCID] = @QuotationsLCID  
      ,[BranchID] = @BranchID  
      ,[OrderNumber] = @OrderNumber 
	  ,[isJobCard] = @isJobCard
	  ,[StatusLCID] = @StatusLCID
	  ,[MechanicEmployeeID] = @MechanicEmployeeID
 WHERE BookingsID = @BookingsID  
  
-- Loop Removed Items 
 IF(@DeleteBookingReasonLCID IS NOT NULL)
 BEGIN
   WHILE @DeleteCounter <= @DeleteMax  
BEGIN  
  
  IF (SELECT count(*) FROM  [TritonFleetManagement].[dbo].[BookingReason] BR WITH(NOLOCK)   
      WHERE BR.BookingsID = @BookingsID  
   AND BR.[BookingReasonLCID] = (SELECT  Value FROM @DeleteBookingsReasons WHERE IDCount = @DeleteCounter)   
   ) > 0  
  BEGIN  
  
  UPDATE [dbo].[BookingReason]  
  SET BookingReasonLCID =(SELECT  Value FROM @DeleteBookingsReasons WHERE IDCount =@DeleteCounter),  
      DeletedOn = GETDATE(),  
   DeletedByUserID = @CreatedByUserID  
  WHERE BookingsID = @BookingsID  
  AND BookingReasonLCID = (SELECT  Value FROM @DeleteBookingsReasons WHERE IDCount =@DeleteCounter)  
  SET @DeleteCounter = @DeleteCounter + 1 
  
 END  
 ELSE  
  BEGIN  
    PRINT 'NO'
  END  
 
END  
 END

 WHILE @counter <= @max  
 BEGIN  
  
  IF (SELECT count(*) FROM  [TritonFleetManagement].[dbo].[BookingReason] BR WITH(NOLOCK)   
      WHERE BR.BookingsID = @BookingsID  
   AND BR.[BookingReasonLCID] = (SELECT  Value FROM @BookingsReasons WHERE IDCount =@counter)   
   ) > 0  
  BEGIN  
  
  UPDATE [dbo].[BookingReason]  
  SET BookingReasonLCID =(SELECT  Value FROM @BookingsReasons WHERE IDCount =@counter),  
    DeletedOn = NULL,
	DeletedByUserID = NULL
  WHERE BookingsID = @BookingsID  
 AND BookingReasonLCID = (SELECT  Value FROM @BookingsReasons WHERE IDCount =@counter)  
 END  
 ELSE  
  BEGIN  
    INSERT INTO [dbo].[BookingReason]([BookingsID],[BookingReasonLCID],VehicleID)  
  
          SELECT Id,Value,@VehicleID FROM @BookingsReasons WHERE IDCount = @counter  
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