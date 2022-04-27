USE [TritonGroup]
GO

DECLARE @CreatedByUserID INT = 88392
DECLARE @Category VARCHAR(100) ='Account Status'
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


DECLARE @Category1 VARCHAR(100) ='Customer Types'
IF (SELECT COUNT(*) FROM [dbo].[LookupcodeCategories] WHERE [Category] = @Category1 ) = 0
BEGIN
INSERT INTO [dbo].[LookupcodeCategories]
           ([Category]
           ,[CreatedByUserID]
           ,[CreatedOn]
           ,[DeletedByUserID]
           ,[DeletedOn])
     VALUES
           (@Category1
           ,@CreatedByUserID
           ,GETDATE()
           ,NULL
           ,NULL)
END
GO

DECLARE @Category2 VARCHAR(100) ='Loyality Types'
IF (SELECT COUNT(*) FROM [dbo].[LookupcodeCategories] WHERE [Category] = @Category2 ) = 0
BEGIN
INSERT INTO [dbo].[LookupcodeCategories]
           ([Category]
           ,[CreatedByUserID]
           ,[CreatedOn]
           ,[DeletedByUserID]
           ,[DeletedOn])
     VALUES
           (@Category2
           ,88392
           ,GETDATE()
           ,NULL
           ,NULL)
END
GO

GO


