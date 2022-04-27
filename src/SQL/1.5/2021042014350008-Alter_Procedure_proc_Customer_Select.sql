USE TritonFleetManagement
GO
 

ALTER PROCEDURE proc_Customer_Select    
  
AS    
BEGIN  
  
SELECT C.*  
  
FROM[TritonFleetManagement].[dbo].[Customer] C WITH(NOLOCK) 
INNER JOIN [TritonFleetManagement].[dbo].Vehicle V WITH(NOLOCK) ON C.CustomerID = V.CustomerID
  
ORDER BY C.CustomerID  
  
END