USE TritonFleetManagement
GO

CREATE PROCEDURE proc_ContactType_GetByCustomerID
@CustomerID INT
AS 
BEGIN

SELECT CT.*
  FROM [TritonFleetManagement].[dbo].[ContactType] CT WITH(NOLOCK)
  WHERE CustomerID = @CustomerID

END



