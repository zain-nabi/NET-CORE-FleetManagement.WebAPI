USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_BookingDetails_GetByID]    Script Date: 2021/04/29 3:55:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_BookingDetails_GetByID]
(
	@BookingsID		INT
)
AS BEGIN
SELECT
		B.BookingsID BookingsID,
		B.CustomerID BookingsCustomerID,
		B.VehicleID VehicleID,
		B.ServiceCategoryTypesLCID ServiceCategoryTypesLCID,
		B.MileAgeOrHourLCID MileAgeOrHourLCID,
		B.MileAge MileAge,
		B.Hour MileAgeHour,
		B.EstimatedArrival EstimatedArrival,
		B.ActualArrival ActualArrival,
		B.Authorisation Authorisation,
		B.Notes Notes,
		B.CreatedOn CreatedOn,
		B.CreatedByUserID CreatedByUserID,
		B.DeletedOn DeletedOn,
		B.DeletedByUserID DeletedByUserID,
		B.QuotationsLCID QuotationsLCID,
		B.BranchID BranchID,
		B.OrderNumber OrderNumber,
		B.isJobCard isJobCard,
		B.StatusLCID StatusLCID,
		B.MechanicEmployeeID MechanicEmployeeID,
		C.CustomerID CustomerID,
		C.Name CustomerName,
		V.RegistrationNumber RegistrationNumber,
		L.Name Name
FROM [TritonFleetManagement].[dbo].[Bookings] B 
INNER JOIN  [TritonFleetManagement].[dbo].[Customer] C  ON C.CustomerID = B.CustomerID
INNER JOIN  [TritonFleetManagement].[dbo].[Vehicle] V  ON V.VehicleID = B.VehicleID
INNER JOIN  [TritonGroup].[dbo].[Lookupcodes] L ON L.LookupcodeID = B.StatusLCID
WHERE B.BookingsID = @BookingsID
END

