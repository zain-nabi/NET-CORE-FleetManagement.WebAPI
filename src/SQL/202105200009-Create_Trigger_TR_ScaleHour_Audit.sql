USE TritonFleetManagement
GO
/****** Object:  Trigger [dbo].[TR_Deliveries_AUDIT]    Script Date: 2021/05/20 9:11:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_ScaleHour_Audit] ON [dbo].[ScaleHours] FOR INSERT, UPDATE, DELETE
AS

DECLARE @bit INT ,
       @field INT ,
       @maxfield INT ,
       @char INT ,
       @fieldname VARCHAR(128) ,
       @TableName VARCHAR(128) ,
       @PKCols VARCHAR(1000) ,
       @sql VARCHAR(2000), 
       @UpdateDate VARCHAR(21) ,
       @UserName INT,
       @Type CHAR(1) ,
       @PKSelect VARCHAR(1000),
	   @PKColumnName	VARCHAR(1000)


--You will need to change @TableName to match the table to be audited. 
-- Here we made GUESTS for your example.
SELECT @TableName = 'ScaleHours'

-- date and user
SELECT @UserName = CAST(REPLACE(CAST(CONTEXT_INFO() AS VARCHAR(128)) COLLATE Latin1_General_100_BIN , 0x00, '') AS INT), @UpdateDate = CONVERT(VARCHAR(8), GETDATE(), 112) + ' ' + CONVERT(VARCHAR(12), GETDATE(), 114)

--SELECT @UserName = 1, @UpdateDate = CONVERT(VARCHAR(8), GETDATE(), 112) + ' ' + CONVERT(VARCHAR(12), GETDATE(), 114)

if (@UserName is null)
	set @UserName=0
--SET @UserName = (SELECT CONVERT(VARCHAR(128), CONTEXT_INFO()))

-- Action
IF EXISTS (SELECT * FROM inserted)
       IF EXISTS (SELECT * FROM deleted)
               SELECT @Type = 'U'
       ELSE
               SELECT @Type = 'I'
ELSE
       SELECT @Type = 'D'

-- get list of columns
SELECT * INTO #ins FROM inserted
SELECT * INTO #del FROM deleted

-- Get primary key columns for full outer join
SELECT @PKCols = COALESCE(@PKCols + ' and', ' on') + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME
       FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk, INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
       WHERE   pk.TABLE_NAME = @TableName
       AND     CONSTRAINT_TYPE = 'PRIMARY KEY'
       AND     c.TABLE_NAME = pk.TABLE_NAME
       AND     c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

-- Get primary key select for insert
SELECT @PKSelect = RTRIM(LTRIM(COALESCE(@PKSelect+'+','') + ''''  + '''+convert(varchar(100),
coalesce(i.' + COLUMN_NAME +',d.' + COLUMN_NAME + '))+'''''))
       FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
               INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
       WHERE   pk.TABLE_NAME = @TableName
       AND     CONSTRAINT_TYPE = 'PRIMARY KEY'
       AND     c.TABLE_NAME = pk.TABLE_NAME
       AND     c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

-- Get primary key Column name select for insert
SELECT @PKColumnName = COALESCE(@PKColumnName + '+', '') + COLUMN_NAME 
       FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk, INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
       WHERE   pk.TABLE_NAME = @TableName
       AND     CONSTRAINT_TYPE = 'PRIMARY KEY'
       AND     c.TABLE_NAME = pk.TABLE_NAME
       AND     c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME



IF @PKCols IS NULL
BEGIN
       RAISERROR('no PK on table %s', 16, -1, @TableName)
       RETURN
END

SELECT @field = 0, @maxfield = MAX(ORDINAL_POSITION)
FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName
WHILE @field < @maxfield
BEGIN
       SELECT @field = MIN(ORDINAL_POSITION) 
               FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = @TableName 
               AND ORDINAL_POSITION > @field

       SELECT @bit = (@field - 1 )% 8 + 1
       SELECT @bit = POWER(2,@bit - 1)
       SELECT @char = ((@field - 1) / 8) + 1

       IF SUBSTRING(COLUMNS_UPDATED(), @char, 1) & @bit > 0 OR @Type IN ('I','D')
       BEGIN
               SELECT @fieldname = COLUMN_NAME 
                       FROM INFORMATION_SCHEMA.COLUMNS 
                       WHERE TABLE_NAME = @TableName 
                       AND ORDINAL_POSITION = @field

SELECT @sql = '
INSERT ScaleHourAudit (Type, TableName, PKColumnName, PK, FieldName, OldValue, NewValue, CreatedOn, CreatedByUserID)
SELECT ''' + @Type + ''',''' + @TableName + ''',''' + @PKColumnName + ''',' + @PKSelect + ',''' + @fieldname + '''' + ',convert(varchar(1000),d.' + @fieldname + ')'
       + ', convert(varchar(1000),i.' + @fieldname + ')'
       + ',''' + @UpdateDate + ''''
       + ', ' + CONVERT(varchar(10), @UserName) + ''
       + ' FROM #ins i FULL OUTER JOIN #del d'
       + @PKCols
       + ' WHERE i.' + @fieldname + ' <> d.' + @fieldname 
       + ' OR (i.' + @fieldname + ' IS NULL AND d.'
                                + @fieldname
                                + ' IS NOT NULL)' 
       + ' OR (i.' + @fieldname + ' IS NOT NULL AND d.' 
                                + @fieldname
                                + ' IS NULL)' 
               EXEC (@sql)
       END

	SET CONTEXT_INFO 0x /*Gets padded with zeros when cast to binary(128)*/
END
