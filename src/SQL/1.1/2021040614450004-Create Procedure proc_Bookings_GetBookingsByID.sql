USE TritonFleetManagement
GO


   
CREATE PROCEDURE proc_Bookings_GetBookingsByID        
@BookingsID INT       
AS        
BEGIN        
    
SELECT     
 B.*  
    
FROM [TritonFleetManagement].[dbo].[Bookings] B WITH(NOLOCK)    
WHERE B.BookingsID = @BookingsID    
    
END    
    