USE TritonFleetManagement
GO


CREATE PROCEDURE proc_BookingReason_GetByBookingdID
@BookingdID INT
AS
BEGIN
SELECT B.*
  FROM [TritonFleetManagement].[dbo].[BookingReason] B WITH(NOLOCK)
  WHERE B.BookingsID = @BookingdID

END

