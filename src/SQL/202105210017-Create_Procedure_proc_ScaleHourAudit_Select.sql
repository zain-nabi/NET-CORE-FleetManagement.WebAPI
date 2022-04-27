USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_ScaleHourAudit_Select]    Script Date: 2021/05/24 2:24:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_ScaleHourAudit_Select]
(
	@EmployeeID				INT
)
AS
BEGIN
DECLARE @ScaleHourAudit		TABLE
(
	ScaleHourAuditID		BIGINT,
	Type					VARCHAR(50),
	PKColumnName			VARCHAR(1000),
	PK						BIGINT,
	FieldName				VARCHAR(255),
	OldValue				VARCHAR(1000),
	NewValue				VARCHAR(1000),
	CreatedOn				DATETIME,
	CreatedByUserID			INT,
	CreatedBy				VARCHAR(500)
)
INSERT INTO @ScaleHourAudit(ScaleHourAuditID, Type, PKColumnName, PK, FieldName, OldValue, NewValue, CreatedOn, CreatedByUserID)
select 
	SC.ScaleHourAuditID,
	SC.Type,
	SC.PKColumnName,
	SC.PK,
	SC.FieldName,
	SC.OldValue,
	SC.NewValue,
	SC.CreatedOn,
	SC.CreatedByUserID
from TritonFleetManagement.dbo.ScaleHourAudit SC where [Type] = 'U'

UPDATE @ScaleHourAudit SET OldValue = CONCAT(E.FullNames,' ',E.Surname)
FROM @ScaleHourAudit S
INNER JOIN LeaveManagement.dbo.Employees E on E.EmployeeID = S.OldValue
WHERE FieldName IN ('EmployeeID')

UPDATE @ScaleHourAudit SET NewValue = CONCAT(E.FullNames,' ',E.Surname)
FROM @ScaleHourAudit S
INNER JOIN LeaveManagement.dbo.Employees E on E.EmployeeID = S.NewValue
WHERE FieldName IN ('EmployeeID')

UPDATE @ScaleHourAudit SET OldValue = U.Name
FROM @ScaleHourAudit S
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = S.OldValue
WHERE FieldName IN ('DeletedByUserID')

UPDATE @ScaleHourAudit SET NewValue = U.Name
FROM @ScaleHourAudit S
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = S.NewValue
WHERE FieldName IN ('DeletedByUserID')  

UPDATE @ScaleHourAudit SET CreatedBy = U.Name
FROM @ScaleHourAudit S
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = S.CreatedByUserID

 
SELECT 
	S.ScaleHourAuditID ScaleHourAuditID,
	S.Type Type,
	S.PKColumnName PKColumnName,
	S.PK PK,
	(CASE
		WHEN S.FieldName = 'EmployeeID' THEN 'Employee'
		WHEN S.FieldName = 'CostScaleHour' THEN 'Cost Scale Hour'
		WHEN S.FieldName = 'CreatedOn' THEN 'Created On'
		WHEN S.FieldName = 'CreatedByUserID' THEN 'Created By'
		WHEN S.FieldName = 'DeletedOn' THEN 'Deleted On'
		WHEN S.FieldName = 'DeletedByUserID' THEN 'Deleted By'
		END
	) FieldName,
	S.OldValue OldValue,
	S.NewValue NewValue,
	S.CreatedOn CreatedOn,
	S.CreatedByUserID CreatedByUserID,
	S.CreatedBy CreatedBy
FROM @ScaleHourAudit S
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = S.CreatedByUserID
INNER JOIN TritonFleetManagement.dbo.ScaleHours SC ON SC.ScaleHourID = S.PK
WHERE SC.EmployeeID =  @EmployeeID
ORDER BY CreatedOn DESC
END
