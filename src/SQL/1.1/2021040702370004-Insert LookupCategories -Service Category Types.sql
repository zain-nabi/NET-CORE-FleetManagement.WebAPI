USE [TritonGroup]
GO

DECLARE @CreatedByUserID INT = 88392
DECLARE @Category VARCHAR(100) ='Service Category Types'
IF (SELECT COUNT(*) FROM [dbo].[LookupcodeCategories] WHERE [Category] = @Category ) = 0
BEGIN
INSERT INTO [dbo].[LookupcodeCategories]
           ([Category]
           ,[CreatedByUserID]
           ,[CreatedOn]
           ,[DeletedByUserID]
           ,[DeletedOn])
     VALUES
           (@Category
           ,@CreatedByUserID
           ,GETDATE()
           ,NULL
           ,NULL)
END



GO