USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_VehicleAudit_Select]    Script Date: 2021/05/24 2:23:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_VehicleAudit_Select]
(
	@VehicleID			BIGINT
)
AS 
BEGIN
DECLARE @VehicleAudit   TABLE
(
	VehicleAuditID		BIGINT,
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
INSERT INTO @VehicleAudit(VehicleAuditID, Type, PKColumnName, PK, FieldName, OldValue, NewValue, CreatedOn, CreatedByUserID)
SELECT 
	VA.VehicleAuditID,
	VA.Type,
	VA.PKColumnName,
	VA.PK,
	VA.FieldName,
	VA.OldValue,
	VA.NewValue,
	VA.CreatedOn,
	VA.CreatedByUserID
FROM VehicleAudit VA WHERE [Type] = 'U'

 


UPDATE @VehicleAudit SET OldValue = L.Detail
FROM @VehicleAudit V
INNER JOIN TritonGroup.dbo.lookupcodes L on L.LookupcodeID = V.OldValue
WHERE FieldName IN ('ServiceIntervalLCID', 'VehicleBrandLCID', 'VehicleClassLCID', 'TailLiftTypeLCID')

 

UPDATE @VehicleAudit SET NewValue = L.Detail
FROM @VehicleAudit V
INNER JOIN TritonGroup.dbo.lookupcodes L on L.LookupcodeID = V.NewValue
WHERE FieldName IN ('ServiceIntervalLCID', 'VehicleBrandLCID', 'VehicleClassLCID', 'TailLiftTypeLCID')


UPDATE @VehicleAudit SET OldValue = C.Name
FROM @VehicleAudit V
INNER JOIN TritonFleetManagement.dbo.Customer C on C.CustomerID = V.OldValue
WHERE FieldName IN ('CustomerID')

UPDATE @VehicleAudit SET NewValue = C.Name
FROM @VehicleAudit V
INNER JOIN TritonFleetManagement.dbo.Customer C on C.CustomerID = V.NewValue
WHERE FieldName IN ('CustomerID')


UPDATE @VehicleAudit SET OldValue = U.Name
FROM @VehicleAudit V
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = V.OldValue
WHERE FieldName IN ('DeletedByUserID')

UPDATE @VehicleAudit SET NewValue = U.Name
FROM @VehicleAudit V
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = V.NewValue
WHERE FieldName IN ('DeletedByUserID')

UPDATE @VehicleAudit SET CreatedBy = U.Name
FROM @VehicleAudit T
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = T.CreatedByUserID

 

SELECT 
	VT.VehicleAuditID VehicleAuditID,
	VT.Type Type,
	VT.PKColumnName PKColumnName,
	VT.PK PK,
	VT.FieldName FieldName,
	(CASE
		WHEN VT.FieldName = 'CustomerID' THEN 'Customer' 
		WHEN VT.FieldName = 'RegistrationNumber' THEN 'Registration' 
		WHEN VT.FieldName = 'FleetNumber' THEN 'Fleet number'
		WHEN VT.FieldName = 'VinNumber' THEN 'VIN number'
		WHEN VT.FieldName = 'EngineNumber' THEN 'Engine number'
		WHEN VT.FieldName = 'VehicleYear' THEN 'Vehicle year'
		WHEN VT.FieldName = 'GVM' THEN 'GVM'
		WHEN VT.FieldName = 'TailLift' THEN 'Tail lift'
		WHEN VT.FieldName = 'TailLiftTypeLCID' THEN 'Tail lift type'
		WHEN VT.FieldName = 'ServiceIntervalLCID' THEN 'Service interval'
		WHEN VT.FieldName = 'VehicleClassLCID' THEN 'Vehicle model'
		WHEN VT.FieldName = 'VehicleBrandLCID' THEN 'Vehicle brand'
		WHEN VT.FieldName = 'VehicleBrandLCID' THEN 'Vehicle brand'
		WHEN VT.FieldName = 'DeletedByUserID' THEN 'Deleted by'
		WHEN VT.FieldName = 'DeletedOn' THEN 'Deleted On'
		END
	) FieldName,
	(CASE	
		WHEN VT.FieldName = 'TailLift' AND VT.OldValue = 1 THEN 'Yes'
		WHEN VT.FieldName = 'TailLift' AND VT.OldValue = 0 THEN 'No'
		ELSE VT.OldValue
		END
	) OldValue,
	(CASE	
		WHEN VT.FieldName = 'TailLift' AND VT.NewValue = 1 THEN 'Yes'
		WHEN VT.FieldName = 'TailLift' AND VT.NewValue = 0 THEN 'No'
		WHEN VT.FieldName = 'DeletedOn' AND VT.NewValue IS NULL THEN 'Reactivated'
		ELSE VT.NewValue
		END
	) NewValue,
	VT.CreatedOn CreatedOn,
	VT.CreatedByUserID CreatedByUserID,
	VT.CreatedBy CreatedBy
FROM @VehicleAudit VT
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = VT.CreatedByUserID
WHERE VT.PK = @VehicleID
ORDER BY CreatedOn DESC
END

