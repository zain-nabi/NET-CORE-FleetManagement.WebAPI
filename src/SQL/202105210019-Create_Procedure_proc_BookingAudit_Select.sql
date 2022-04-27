USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_BookingAudit_Select]    Script Date: 2021/05/24 2:25:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_BookingAudit_Select]
(
	@BookingID			INT
)
AS
BEGIN
DECLARE @BookingAudit	TABLE
(
	BookingAuditID		BIGINT,
	Type				VARCHAR(50),
	PKColumnName		VARCHAR(1000),
	PK					BIGINT,
	FieldName			VARCHAR(255),
	OldValue			VARCHAR(1000),
	NewValue			VARCHAR(1000),
	CreatedOn			DATETIME,
	CreatedByUserID		INT,
	CreatedBy			VARCHAR(500)
)
INSERT INTO @BookingAudit(BookingAuditID, Type, PKColumnName, PK, FieldName, OldValue, NewValue, CreatedOn, CreatedByUserID)
SELECT 
	BA.BookingAuditID,
	BA.Type,
	BA.PKColumnName,
	BA.PK,
	BA.FieldName,
	BA.OldValue,
	BA.NewValue,
	BA.CreatedOn,
	BA.CreatedByUserID
FROM TritonFleetManagement.dbo.BookingAudit BA where [Type] = 'U'

 


UPDATE @BookingAudit SET OldValue = L.Detail
FROM @BookingAudit B
INNER JOIN TritonGroup.dbo.lookupcodes L on L.LookupcodeID = B.OldValue
WHERE FieldName IN ('ServiceCategoryTypesLCID', 'MileAgeOrHourLCID', 'QuotationsLCID', 'StatusLCID')

 

UPDATE @BookingAudit SET NewValue = L.Detail
FROM @BookingAudit B
INNER JOIN TritonGroup.dbo.lookupcodes L on L.LookupcodeID = B.NewValue
WHERE FieldName IN ('ServiceCategoryTypesLCID', 'MileAgeOrHourLCID', 'QuotationsLCID', 'StatusLCID')


UPDATE @BookingAudit SET OldValue = C.Name
FROM @BookingAudit B
INNER JOIN TritonFleetManagement.dbo.Customer C on C.CustomerID = B.OldValue
WHERE FieldName IN ('CustomerID')

UPDATE @BookingAudit SET NewValue = C.Name
FROM @BookingAudit B
INNER JOIN TritonFleetManagement.dbo.Customer C on C.CustomerID = B.NewValue
WHERE FieldName IN ('CustomerID')


UPDATE @BookingAudit SET OldValue = V.RegistrationNumber
FROM @BookingAudit B
INNER JOIN TritonFleetManagement.dbo.Vehicle V on V.VehicleID = B.OldValue
WHERE FieldName IN ('VehicleID')

UPDATE @BookingAudit SET NewValue = V.RegistrationNumber
FROM @BookingAudit B
INNER JOIN TritonFleetManagement.dbo.Vehicle V on V.VehicleID = B.NewValue
WHERE FieldName IN ('VehicleID')


UPDATE @BookingAudit SET OldValue = CONCAT(E.FullNames,' ',E.Surname)
FROM @BookingAudit B
INNER JOIN LeaveManagement.dbo.Employees E on E.EmployeeID = B.OldValue
WHERE FieldName IN ('MechanicEmployeeID')

UPDATE @BookingAudit SET NewValue = CONCAT(E.FullNames,' ',E.Surname)
FROM @BookingAudit B
INNER JOIN LeaveManagement.dbo.Employees E on E.EmployeeID = B.NewValue
WHERE FieldName IN ('MechanicEmployeeID')


UPDATE @BookingAudit SET OldValue = Br.BranchFullName
FROM @BookingAudit B
INNER JOIN TritonSecurity.dbo.Branches Br on Br.BranchID = B.OldValue
WHERE FieldName IN ('BranchID')

UPDATE @BookingAudit SET NewValue = Br.BranchFullName
FROM @BookingAudit B
INNER JOIN TritonSecurity.dbo.Branches Br on Br.BranchID = B.NewValue
WHERE FieldName IN ('BranchID')


UPDATE @BookingAudit SET OldValue = U.Name
FROM @BookingAudit B
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = B.OldValue
WHERE FieldName IN ('DeletedByUserID')

UPDATE @BookingAudit SET NewValue = U.Name
FROM @BookingAudit B
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = B.NewValue
WHERE FieldName IN ('DeletedByUserID')

UPDATE @BookingAudit SET CreatedBy = U.Name
FROM @BookingAudit B
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = B.CreatedByUserID

 
SELECT 
	BT.BookingAuditID BookingAuditID,
	BT.Type Type,
	BT.PKColumnName PKColumnName,
	BT.PK PK,
	(CASE	
		WHEN BT.FieldName = 'CustomerID' THEN  'Customer' 
		WHEN BT.FieldName = 'VehicleID' THEN  'Registration Number'  
		WHEN BT.FieldName = 'ServiceCategoryTypesLCID' THEN  'Service Category'
		WHEN BT.FieldName = 'MileAgeOrHourLCID' THEN  'Mileage or Hour'
		WHEN BT.FieldName = 'MileAge' THEN  'Mileage'
		WHEN BT.FieldName = 'Hour' THEN  'Mileage Hour'
		WHEN BT.FieldName = 'EstimatedArrival' THEN  'Estimated Arrival'
		WHEN BT.FieldName = 'ActualArrival' THEN  'Actual Arrival'
		WHEN BT.FieldName = 'Authorisation' THEN  'Booking Autorization'
		WHEN BT.FieldName = 'Notes' THEN  'Booking Notes'
		WHEN BT.FieldName = 'DeletedOn' THEN  'Deleted On'
		WHEN BT.FieldName = 'DeletedByUserID' THEN  'Deleted by'
		WHEN BT.FieldName = 'QuotationsLCID' THEN  'Category'
		WHEN BT.FieldName = 'BranchID' THEN  'Branch'
		WHEN BT.FieldName = 'OrderNumber' THEN  'Order Number'
		WHEN BT.FieldName = 'isJobCard' THEN  'Job Card'
		WHEN BT.FieldName = 'StatusLCID' THEN  'Mechanic Status'
		WHEN BT.FieldName = 'MechanicEmployeeID' THEN  'Mechanic'
		END
	) FieldName,
	(CASE 
		WHEN BT.FieldName = 'isJobCard' AND BT.OldValue = 1 THEN 'Yes'
		WHEN BT.FieldName = 'isJobCard' AND BT.OldValue = 0 THEN 'No'
		WHEN BT.FieldName = 'Authorisation' AND BT.OldValue = 1 THEN 'Yes'
		WHEN BT.FieldName = 'Authorisation' AND BT.OldValue = 0 THEN 'No'
		ELSE BT.OldValue
		END
	) OldValue,
	(CASE 
		WHEN BT.FieldName = 'isJobCard' AND BT.NewValue = 1 THEN 'Yes'
		WHEN BT.FieldName = 'isJobCard' AND BT.NewValue = 0 THEN 'No'
		WHEN BT.FieldName = 'Authorisation' AND BT.NewValue = 1 THEN 'Yes'
		WHEN BT.FieldName = 'Authorisation' AND BT.NewValue = 0 THEN 'No'
		ELSE BT.NewValue
		END
	) NewValue,
	BT.CreatedOn CreatedOn,
	BT.CreatedByUserID CreatedByUserID,
	BT.CreatedBy CreatedBy
FROM @BookingAudit BT
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = BT.CreatedByUserID
WHERE BT.PK = @BookingID
ORDER BY CreatedOn DESC
END

