USE TritonFleetManagement
GO


CREATE PROCEDURE proc_Vehicle_GetVehicleByCustomerID
@CustomerID INT
AS
BEGIN
  SELECT * FROM TritonFleetManagement.dbo.Vehicle V WITH(NOLOCK)
  WHERE V.CustomerID = @CustomerID 

END



