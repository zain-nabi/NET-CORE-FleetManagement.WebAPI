USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_Bookings_Delete]    Script Date: 2021/04/30 4:30:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_Bookings_Delete]
(
	        @BookingsID						INT,
            @DeletedByUserID				INT
)
AS
BEGIN
	DECLARE @VehicleID INT = (SELECT B.VehicleID FROM Bookings B WHERE B.BookingsID = @BookingsID)

	UPDATE Bookings
		SET 
            DeletedOn =	GETDATE(),
            DeletedByUserID = @DeletedByUserID
	WHERE Bookings.VehicleID = @VehicleID
END
