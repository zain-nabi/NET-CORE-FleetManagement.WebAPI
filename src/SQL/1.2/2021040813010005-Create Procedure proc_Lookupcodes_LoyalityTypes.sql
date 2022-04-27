USE TritonGroup
GO

CREATE PROCEDURE proc_Lookupcodes_LoyalityTypes 
AS 
BEGIN

SELECT LU.[Category],L.* FROM [TritonGroup].[dbo].[Lookupcodes] L WITH(NOLOCK)   
INNER JOIN [TritonGroup].[dbo].LookupcodeCategories LU WITH(NOLOCK) ON L.LookupcodeCategoryID = LU.LookupcodeCategoryID   
WHERE LU.[Category] ='Loyality Types'  
ORDER BY L.Sequence  

END