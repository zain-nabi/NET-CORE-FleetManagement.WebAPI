USE [TritonGroup]
GO
/****** Object:  StoredProcedure [dbo].[proc_LookUpCodesID_Select]    Script Date: 2021/04/29 3:59:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_LookUpCodesID_Select]
AS
BEGIN
	SELECT 
		L.LookupcodeID
	FROM [TritonGroup].[dbo].[Lookupcodes] L
	LEFT OUTER JOIN [TritonGroup].[dbo].[LookupcodeCategories] LC ON LC.LookupcodeCategoryID = L.LookupcodeCategoryID
	WHERE L.Name = 'Awaiting Mechanic'
END