USE TritonGroup
GO

    
CREATE PROCEDURE proc_Lookupcodes_ServiceCategoryTypes      
AS      
BEGIN   
  
SELECT LU.[Category],L.* FROM [TritonGroup].[dbo].[Lookupcodes] L WITH(NOLOCK)   
INNER JOIN [TritonGroup].[dbo].LookupcodeCategories LU WITH(NOLOCK) ON L.LookupcodeCategoryID = LU.LookupcodeCategoryID   
WHERE LU.[Category] = 'Service Category Types'   
  
ORDER BY L.Sequence  
  
END
