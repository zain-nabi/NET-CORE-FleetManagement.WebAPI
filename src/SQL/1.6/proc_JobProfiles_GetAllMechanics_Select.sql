USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[proc_JobProfiles_GetAllMechanics_Select]    Script Date: 2021/04/29 4:00:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_JobProfiles_GetAllMechanics_Select]
AS
BEGIN
SELECT 
 EUM.EmployeeID EmployeeID,
 U.Name FullNames
FROM TritonSecurity.dbo.Users U
LEFT OUTER JOIN leavemanagement.dbo.EmployeeUserMap EUM on eum.UserID = U.UserID
LEFT OUTER JOIN leavemanagement.dbo.orgOrganogram O ON O.EMployeeID = EUM.EmployeeID
LEFT OUTER JOIN leavemanagement.dbo.JobProfiles JP ON JP.JobProfileID = O.orgJobTitle
LEFT OUTER JOIN leavemanagement.dbo.JobCategorys JC on JC.JobCategoryID = JP.JobCategoryID
WHERE JP.Description LIKE '%mechanic%'
END