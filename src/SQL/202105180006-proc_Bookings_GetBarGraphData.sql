USE TritonFleetManagement
GO

IF NOT EXISTS (SELECT SS.name AS SchemaName, SP.name AS StoredProc 
    FROM sys.procedures SP
    INNER JOIN sys.schemas SS on SP.schema_id = SS.schema_id
    WHERE SS.name = 'dbo' and SP.name = 'proc_Bookings_GetBarGraphData'
	)
BEGIN

    DECLARE @SQL NVARCHAR(MAX)

    SELECT @SQL = ' USE TritonFleetManagement
					GO

					CREATE PROC [dbo].[proc_Bookings_GetBarGraphData]
					(
						@startDate			VARCHAR(255),
						@endDate			VARCHAR(255)
					)
					AS
					BEGIN
					DECLARE @DaysOfTheWeek TABLE
					(
						DayOfTheWeek		VARCHAR(255)
					)

					DECLARE @MinDate DATE = CAST(@startDate AS DATETIME),
							@MaxDate DATE = CAST(@endDate AS DATETIME);


					INSERT INTO @DaysOfTheWeek(DayOfTheWeek)
					SELECT  TOP (DATEDIFF(DAY, @MinDate, @MaxDate) + 1)
							Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @MinDate)
					FROM    sys.all_objects a
					CROSS JOIN sys.all_objects b;


					DECLARE @BookingsData TABLE
					(
						Bookings		INT,
						DaysOfTheWeek	VARCHAR(255)
					)
					INSERT INTO @BookingsData(Bookings, DaysOfTheWeek)
					SELECT
						COUNT(B.BookingsID) Bookings,
						CONVERT(varchar, B.CreatedOn, 23) DaysOfTheWeek
					FROM TritonFleetManagement.dbo.Bookings B
					WHERE CONVERT(DATE, B.CreatedOn) >= @startDate and CONVERT(DATE, B.CreatedOn) <= @endDate
					AND B.DeletedByUserID IS NULL AND B.DeletedOn IS NULL
					GROUP BY CONVERT(varchar, B.CreatedOn, 23)

					SELECT 
						ISNULL(BD.Bookings,0) Bookings,
						CAST(DW.DayOfTheWeek AS DATETIME) DayOfTheWeek
					FROM @BookingsData BD
					RIGHT OUTER JOIN @DaysOfTheWeek DW ON DW.DayOfTheWeek = BD.DaysOfTheWeek
					GROUP BY DW.DayOfTheWeek, BD.Bookings
					END'

    EXEC sp_EXECUTESQL @SQL
END
 

