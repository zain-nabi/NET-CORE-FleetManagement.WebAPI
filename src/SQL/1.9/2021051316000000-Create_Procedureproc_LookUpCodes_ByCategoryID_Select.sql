USE TritonGroup
GO


CREATE  PROCEDURE [dbo].[proc_LookUpCodes_ByCategoryID_Select]  
(  
 @LookupcodeCategoryID INT  
)  
AS  
BEGIN  

SELECT L.* FROM [TritonGroup].[dbo].[Lookupcodes] L WITH(NOLOCK)   
INNER JOIN [TritonGroup].[dbo].LookupcodeCategories LU WITH(NOLOCK) ON L.LookupcodeCategoryID = LU.LookupcodeCategoryID   
WHERE LU.LookupcodeCategoryID = @LookupcodeCategoryID    
ORDER BY L.Sequence 

END