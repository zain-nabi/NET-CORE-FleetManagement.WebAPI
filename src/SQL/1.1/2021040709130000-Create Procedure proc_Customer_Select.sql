USE [TritonFleetManagement]
GO

CREATE PROCEDURE proc_Customer_Select  

AS  
BEGIN

SELECT C.*

FROM[TritonFleetManagement].[dbo].[Customer] C WITH(NOLOCK)

ORDER BY C.CustomerID

END