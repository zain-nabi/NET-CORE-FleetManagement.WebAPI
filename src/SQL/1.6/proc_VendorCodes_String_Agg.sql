USE [TritonFleetManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_VendorCodes_String_Agg]    Script Date: 2021/04/29 3:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_VendorCodes_String_Agg]
AS 
BEGIN
WITH CustomersData AS
(
    SELECT 
        C.CustomerID,
        C.Name
    FROM Customer C
	INNER JOIN [TritonFleetManagement].[dbo].Vehicle V ON V.CustomerID = C.CustomerID
),
VendorCodesConcatenatedData AS
(
SELECT CustomerID, VendorCodes = STUFF(
        (SELECT DISTINCT ',' +' '+ VendorCodes
            FROM VendorCode AS t1
            WHERE t1.CustomerID = t2.CustomerID
            FOR XML PATH ('')
        ), 1, 1, '') 
FROM VendorCode AS t2
GROUP BY CustomerID

)
SELECT 
    CD.CustomerID CustomerID,
	CD.Name,
	VC.VendorCodes VendorCodes,
    CONCAT(CD.Name,' ',VC.VendorCodes) CustomerNameVendorCodes
FROM VendorCodesConcatenatedData VC
RIGHT OUTER JOIN CustomersData CD ON CD.CustomerID = VC.CustomerID
INNER JOIN [TritonFleetManagement].[dbo].Vehicle V ON CD.CustomerID = V.CustomerID
GROUP BY CD.CustomerID, CD.Name, VC.VendorCodes  
END
