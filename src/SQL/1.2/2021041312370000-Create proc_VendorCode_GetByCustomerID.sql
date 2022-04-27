USE TritonFleetManagement
GO

CREATE PROCEDURE proc_VendorCode_GetByCustomerID
@CustomerID INT
AS 
BEGIN

SELECT VT.*
  FROM [TritonFleetManagement].[dbo].[VendorCode] VT WITH(NOLOCK)
  WHERE CustomerID = @CustomerID
  ORDER BY VT.CompanyID
END