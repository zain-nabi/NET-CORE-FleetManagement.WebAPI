USE TritonGroup
GO

CREATE PROCEDURE proc_Lookupcodes_ContactDetails 
AS 
BEGIN

SELECT LU.[Category],L.* FROM [TritonGroup].[dbo].[Lookupcodes] L WITH(NOLOCK)   
INNER JOIN [TritonGroup].[dbo].LookupcodeCategories LU WITH(NOLOCK) ON L.LookupcodeCategoryID = LU.LookupcodeCategoryID   
WHERE LU.[Category] ='Contact Details'  
ORDER BY L.Sequence  

END


