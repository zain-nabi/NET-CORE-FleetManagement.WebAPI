USE TritonFleetManagement
GO

IF NOT EXISTS (SELECT SS.name AS SchemaName, SP.name AS StoredProc 
    FROM sys.procedures SP
    INNER JOIN sys.schemas SS on SP.schema_id = SS.schema_id
    WHERE SS.name = 'dbo' and SP.name = 'proc_BookingReasons_VehicleRepairsSelect'
	)
BEGIN

    DECLARE @SQL NVARCHAR(MAX)

    SELECT @SQL = 'CREATE PROC proc_BookingReasons_VehicleRepairsSelect
					AS
					BEGIN
					SELECT 
						B.BookingsID BookingsID,
						C.Name CustomerName,
						V.RegistrationNumber RegistrationNumber,
						V.FleetNumber FleetNumber,
						V.VehicleYear VehicleYear,
						VehicleModel.Name VehicleModel,
						VehicleBrand.Name VehicleMake,
						VehicleBookingReason.Name BookingReason,
						B.EstimatedArrival EstimatedArrival
					FROM TritonFleetManagement.dbo.BookingReason BR
					INNER JOIN TritonFleetManagement.dbo.Bookings B ON B.BookingsID = BR.BookingsID
					INNER JOIN TritonFleetManagement.dbo.Customer C ON C.CustomerID  = B.CustomerID
					INNER JOIN TritonFleetManagement.dbo.Vehicle V ON V.CustomerID = C.CustomerID AND V.CustomerID = B.CustomerID
					INNER JOIN TritonGroup.dbo.Lookupcodes VehicleBrand ON VehicleBrand.LookupcodeID = V.VehicleBrandLCID
					INNER JOIN TritonGroup.dbo.Lookupcodes VehicleModel ON VehicleModel.LookupcodeID = V.VehicleClassLCID
					INNER JOIN TritonGroup.dbo.Lookupcodes VehicleBookingReason ON VehicleBookingReason.LookupcodeID = BR.BookingReasonLCID
					WHERE B.ActualArrival IS NULL AND BR.DeletedByUserID IS NULL AND BR.DeletedOn IS NULL AND BR.BookingReasonLCID = 580 AND B.DeletedByUserID IS NULL
					AND B.DeletedOn IS NULL
					END'

    EXEC sp_EXECUTESQL @SQL
END
 

