USE TritonFleetManagement
GO



IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Customer' 
    AND column_name = 'AccountNumber'
)
BEGIN
 ALTER TABLE Customer
 DROP COLUMN AccountNumber
END

IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Customer' 
    AND column_name = 'Email'
)
BEGIN
 ALTER TABLE Customer
 DROP COLUMN Email
END

IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Customer' 
    AND column_name = 'TelephoneNumber'
)
BEGIN
 ALTER TABLE Customer
 DROP COLUMN TelephoneNumber
END

IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Customer' 
    AND column_name = 'CellphoneNumber'
)
BEGIN
 ALTER TABLE Customer
 DROP COLUMN CellphoneNumber
END