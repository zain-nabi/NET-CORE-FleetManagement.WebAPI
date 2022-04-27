USE TritonFleetManagement
GO

IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'VendorCode' 
    AND column_name = 'VendorCodeTFM'
)
BEGIN
 ALTER TABLE VendorCode
 DROP COLUMN VendorCodeTFM
END

IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'VendorCode' 
    AND column_name = 'VendorCodeTTM'
)
BEGIN
 ALTER TABLE VendorCode
 DROP COLUMN VendorCodeTTM
END

IF NOT EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'VendorCode' 
    AND column_name = 'VendorCodes'
)
BEGIN
 ALTER TABLE VendorCode
 ADD  VendorCodes VARCHAR(10) NULL
END

