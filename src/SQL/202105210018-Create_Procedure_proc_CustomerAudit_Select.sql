USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_CustomerAudit_Select]    Script Date: 2021/05/24 2:25:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_CustomerAudit_Select]
(
	@CustomerID			INT
)
AS
BEGIN
DECLARE @CustomerAudit	TABLE
(
	CustomerAuditID		BIGINT,
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
INSERT INTO @CustomerAudit(CustomerAuditID, Type, PKColumnName, PK, FieldName, OldValue, NewValue, CreatedOn, CreatedByUserID)
SELECT 
	C.CustomerAuditID,
	C.Type,
	C.PKColumnName,
	C.PK,
	C.FieldName,
	C.OldValue,
	C.NewValue,
	C.CreatedOn,
	C.CreatedByUserID
FROM TritonFleetManagement.dbo.CustomerAudit C where [Type] = 'U'

 


UPDATE @CustomerAudit SET OldValue = L.Detail
FROM @CustomerAudit C
INNER JOIN TritonGroup.dbo.lookupcodes L on L.LookupcodeID = C.OldValue
WHERE FieldName IN ('LoyaltyStatusLCID', 'AccountStatusTypeLCID', 'CustomerTypeLCID')

 

UPDATE @CustomerAudit SET NewValue = L.Detail
FROM @CustomerAudit C
INNER JOIN TritonGroup.dbo.lookupcodes L on L.LookupcodeID = C.NewValue
WHERE FieldName IN ('LoyaltyStatusLCID', 'AccountStatusTypeLCID', 'CustomerTypeLCID')


UPDATE @CustomerAudit SET OldValue = C.Description
FROM @CustomerAudit CA
INNER JOIN [TritonSecurity].[dbo].[Companys] C on c.CompanyID = CA.OldValue
WHERE FieldName IN ('CompanyID')

UPDATE @CustomerAudit SET NewValue = C.Description
FROM @CustomerAudit CA
INNER JOIN [TritonSecurity].[dbo].[Companys] C on c.CompanyID = CA.NewValue
WHERE FieldName IN ('CompanyID')


UPDATE @CustomerAudit SET OldValue = U.Name
FROM @CustomerAudit B
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = B.OldValue
WHERE FieldName IN ('DeletedByUserID')

UPDATE @CustomerAudit SET NewValue = U.Name
FROM @CustomerAudit B
INNER JOIN TritonSecurity.dbo.Users U on U.UserID = B.NewValue
WHERE FieldName IN ('DeletedByUserID')
 
UPDATE @CustomerAudit SET CreatedBy = U.Name
FROM @CustomerAudit CA
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = CA.CreatedByUserID

 

SELECT 
	CA.CustomerAuditID CustomerAuditID,
	CA.Type Type,
	CA.PKColumnName PKColumnName,
	CA.PK PK,
	(CASE
		WHEN CA.FieldName = 'Name' THEN 'Company name'
		WHEN CA.FieldName = 'VatRegistration' THEN 'VAT registration'
		WHEN CA.FieldName = 'CreditLimit' THEN 'Credit limit'
		WHEN CA.FieldName = 'LoyaltySpend' THEN 'Loyalty spend'
		WHEN CA.FieldName = 'LoyaltyStatusLCID' THEN 'Loyalty status'
		WHEN CA.FieldName = 'AccountStatusTypeLCID' THEN 'Account status'
		WHEN CA.FieldName = 'CustomerTypeLCID' THEN 'Customer type'
		WHEN CA.FieldName = 'PhysicalAddress1' THEN 'Physical address 1'
		WHEN CA.FieldName = 'PhysicalAddress2' THEN 'Physical address 2'
		WHEN CA.FieldName = 'PhysicalSuburb' THEN 'Physical suburb'
		WHEN CA.FieldName = 'PhysicalPostalCode' THEN 'Physical postal code'
		WHEN CA.FieldName = 'PostalAddress1' THEN 'Postal address 1'
		WHEN CA.FieldName = 'PostalAddress2' THEN 'Postal address 2'
		WHEN CA.FieldName = 'PostalSuburb' THEN 'Postal suburb'
		WHEN CA.FieldName = 'PostalCode' THEN 'Postal code'
		WHEN CA.FieldName = 'CreatedOn' THEN 'Created on'
		WHEN CA.FieldName = 'CreatedByUserID' THEN 'Created By'
		WHEN CA.FieldName = 'DeletedOn' THEN 'Deleted On'
		WHEN CA.FieldName = 'DeletedByUserID' THEN 'Deleted by'
		WHEN CA.FieldName = 'CompanyID' THEN 'Company'
		WHEN CA.FieldName = 'CompanyRegistration' THEN 'Company registration'
		END
	) FieldName,
	CA.OldValue OldValue,
	CA.NewValue NewValue,
	CA.CreatedOn CreatedOn,
	CA.CreatedByUserID CreatedByUserID,
	CA.CreatedBy CreatedBy
FROM @CustomerAudit CA
INNER JOIN TritonSecurity.dbo.Users U ON U.UserID = CA.CreatedByUserID
WHERE CA.PK = @CustomerID
ORDER BY CreatedOn DESC
END


