USE [TritonGroup]
GO
/****** Object:  StoredProcedure [dbo].[proc_Lookupcodes_Status]    Script Date: 2021/04/29 3:59:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[proc_Lookupcodes_Status]        
AS        
BEGIN     
    
SELECT L.LookupcodeID LookUpCodeID,  L.Name Name
FROM [TritonGroup].[dbo].[Lookupcodes] L WITH(NOLOCK)     
INNER JOIN [TritonGroup].[dbo].LookupcodeCategories LU WITH(NOLOCK) ON L.LookupcodeCategoryID = LU.LookupcodeCategoryID     
WHERE LU.[Category] = 'Status' 
AND L.DeletedOn IS NULL
    
ORDER BY L.Sequence    
    
END 