USE TritonFleetManagement
GO



IF EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Bookings' 
    AND column_name = 'Quotations'
)
BEGIN
 ALTER TABLE Bookings
 DROP COLUMN Quotations
END