USE [TritonSecurity]
GO

  
CREATE PROCEDURE [dbo].[proc_Branches_GetActiveBranches] 
AS
BEGIN
  SELECT B.* FROM Branches B WITH(NOLOCK)
  WHERE B.CompanyID IN(6,16)
  AND B.Active = 1
  ORDER BY B.BranchFullName

END