USE TritonFleetManagement
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ScaleHour_Users_Select]')
AND type in (N'P', N'PC'))

PRINT 'YES'
GO 

CREATE PROC proc_ScaleHour_Users_Select 
AS
BEGIN
SELECT 
E.employeeID UserID, 
CONCAT(E.FullNames,' ',E.Surname) Name
from leavemanagement.dbo.Employees E
INNER JOIN leavemanagement.dbo.orgOrganogram O on O.EmployeeID = E.EmployeeID
INNER JOIN leavemanagement.dbo.JobProfiles JP ON JP.JobProfileID = O.orgJobTitle
WHERE JP.Description IN ('Mechanic', 'Assistant Mechanic', 'Workshop Foreman', 'Branch Supervisor' ,'Tyre Fitter' ,'Welder')
END
