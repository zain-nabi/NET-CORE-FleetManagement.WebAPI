USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_Bookings_BookingReasons_Customers_Select]    Script Date: 2021/05/03 2:49:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_Bookings_BookingReasons_Customers_Select]
(
	@CustomerID			INT,
	@startDate			VARCHAR(255),
	@endDate			VARCHAR(255)
)
AS
BEGIN
DECLARE @BookingsData TABLE
(
	CreatedBy varchar(255),
	BookingsID	int,
	OrderNumber varchar(255),
	CreatedOn datetime,
	EstimatedArrival datetime, 
	ActualArrival datetime,
	CustomerName varchar(255),
	RegistrationNumber varchar(255),
	CustomerID int,
	DeletedOn	Datetime
)

DECLARE @BookingReasons TABLE
(
	BookingsID	INT,
	BookingReasons VARCHAR(255)
)

IF @CustomerID = 0
BEGIN
INSERT INTO @BookingsData(CreatedBy, BookingsID, OrderNumber, CreatedOn, EstimatedArrival, ActualArrival, CustomerName, RegistrationNumber, CustomerID, DeletedOn)
SELECT DISTINCT
		U.Name CreatedBy,
		B.BookingsID,
		B.OrderNumber,
		B.CreatedOn,
		B.EstimatedArrival,
		B.ActualArrival,
		C.Name CustomerName,
		V.RegistrationNumber,
		C.CustomerID,
		B.DeletedOn
        FROM [TritonFleetManagement].[dbo].[Bookings] B 
		INNER JOIN  [TritonFleetManagement].[dbo].[Customer] C  ON C.CustomerID = B.CustomerID
		INNER JOIN  [TritonFleetManagement].[dbo].[Vehicle] V  ON V.VehicleID = B.VehicleID
		INNER JOIN  [TritonSecurity].[dbo].[Users] U ON U.UserID = B.CreatedByUserID
		INNER JOIN BookingReason BR1 ON BR1.BookingsID = B.BookingsID
		INNER JOIN [TritonGroup].[dbo].Lookupcodes L ON L.LookupcodeID = BR1.BookingReasonLCID
		WHERE B.DeletedOn IS NULL AND B.DeletedByUserID IS NULL 
		AND CONVERT(DATE, B.EstimatedArrival) >=  @startDate and CONVERT(DATE, B.EstimatedArrival) <=  @endDate


INSERT INTO @BookingReasons(BookingsID, BookingReasons)
		SELECT DISTINCT B.BookingsID, L.Name
        FROM [TritonFleetManagement].[dbo].[Bookings] B 
		INNER JOIN  [TritonFleetManagement].[dbo].[Customer] C  ON C.CustomerID = B.CustomerID
		INNER JOIN  [TritonFleetManagement].[dbo].[Vehicle] V  ON V.VehicleID = B.VehicleID
		INNER JOIN  [TritonSecurity].[dbo].[Users] U ON U.UserID = B.CreatedByUserID
		INNER JOIN BookingReason BR ON BR.BookingsID = B.BookingsID
		INNER JOIN [TritonGroup].[dbo].Lookupcodes L ON L.LookupcodeID = BR.BookingReasonLCID
		WHERE BR.DeletedOn IS NULL AND BR.DeletedByUserID IS NULL 
		AND CONVERT(DATE, B.EstimatedArrival) >=  @startDate and CONVERT(DATE, B.EstimatedArrival) <=  @endDate

SELECT 
BD.CreatedBy,
BD.BookingsID,
BD.OrderNumber,
BD.CreatedOn,
BD.EstimatedArrival,
BD.ActualArrival,
BD.CustomerName, 
BD.RegistrationNumber,
BookingReasons = STUFF((SELECT ',' +' '+ BR.BookingReasons FROM @BookingReasons BR WHERE BR.BookingsID = BR1.BookingsID FOR XML PATH ('')), 1, 1, '')
from @BookingReasons BR1
INNER JOIN @BookingsData BD on BD.BookingsID = BR1.BookingsID
WHERE BD.DeletedOn IS NULL AND CONVERT(DATE, BD.EstimatedArrival) >=  @startDate and CONVERT(DATE, BD.EstimatedArrival) <=  @endDate
GROUP BY BR1.BookingsID,
	BD.CreatedBy,
	BD.BookingsID,
	BD.OrderNumber,
	BD.CreatedOn,
	BD.EstimatedArrival,
	BD.ActualArrival,
	BD.CustomerName, 
	BD.RegistrationNumber
END

ELSE
BEGIN
INSERT INTO @BookingsData(CreatedBy, BookingsID, OrderNumber, CreatedOn, EstimatedArrival, ActualArrival, CustomerName, RegistrationNumber, CustomerID, DeletedOn)
SELECT DISTINCT
		U.Name CreatedBy,
		B.BookingsID,
		B.OrderNumber,
		B.CreatedOn,
		B.EstimatedArrival,
		B.ActualArrival,
		C.Name CustomerName,
		V.RegistrationNumber,
		C.CustomerID,
		B.DeletedOn
        FROM [TritonFleetManagement].[dbo].[Bookings] B 
		INNER JOIN  [TritonFleetManagement].[dbo].[Customer] C  ON C.CustomerID = B.CustomerID
		INNER JOIN  [TritonFleetManagement].[dbo].[Vehicle] V  ON V.VehicleID = B.VehicleID
		INNER JOIN  [TritonSecurity].[dbo].[Users] U ON U.UserID = B.CreatedByUserID
		INNER JOIN BookingReason BR1 ON BR1.BookingsID = B.BookingsID
		INNER JOIN [TritonGroup].[dbo].Lookupcodes L ON L.LookupcodeID = BR1.BookingReasonLCID
		WHERE B.DeletedOn IS NULL AND B.DeletedByUserID IS NULL
		AND CONVERT(DATE, B.EstimatedArrival) >=  @startDate and CONVERT(DATE, B.EstimatedArrival) <=  @endDate


INSERT INTO @BookingReasons(BookingsID, BookingReasons)
		SELECT DISTINCT B.BookingsID, L.Name
        FROM [TritonFleetManagement].[dbo].[Bookings] B 
		INNER JOIN  [TritonFleetManagement].[dbo].[Customer] C  ON C.CustomerID = B.CustomerID
		INNER JOIN  [TritonFleetManagement].[dbo].[Vehicle] V  ON V.VehicleID = B.VehicleID
		INNER JOIN  [TritonSecurity].[dbo].[Users] U ON U.UserID = B.CreatedByUserID
		INNER JOIN BookingReason BR ON BR.BookingsID = B.BookingsID
		INNER JOIN [TritonGroup].[dbo].Lookupcodes L ON L.LookupcodeID = BR.BookingReasonLCID
		WHERE BR.DeletedOn IS NULL AND BR.DeletedByUserID IS NULL 
		AND CONVERT(DATE, B.EstimatedArrival) >=  @startDate and CONVERT(DATE, B.EstimatedArrival) <=  @endDate

SELECT 
BD.CreatedBy,
BD.BookingsID,
BD.OrderNumber,
BD.CreatedOn,
BD.EstimatedArrival,
BD.ActualArrival,
BD.CustomerName, 
BD.RegistrationNumber,
BookingReasons = STUFF((SELECT ',' +' '+ BR.BookingReasons FROM @BookingReasons BR WHERE BR.BookingsID = BR1.BookingsID FOR XML PATH ('')), 1, 1, '')
from @BookingReasons BR1
INNER JOIN @BookingsData BD on BD.BookingsID = BR1.BookingsID
WHERE BD.CustomerID = @CustomerID AND  BD.DeletedOn IS NULL AND CONVERT(DATE, BD.EstimatedArrival) >=  @startDate and CONVERT(DATE, BD.EstimatedArrival) <=  @endDate
GROUP BY BR1.BookingsID,
	BD.CreatedBy,
	BD.BookingsID,
	BD.OrderNumber,
	BD.CreatedOn,
	BD.EstimatedArrival,
	BD.ActualArrival,
	BD.CustomerName, 
	BD.RegistrationNumber
END
END


