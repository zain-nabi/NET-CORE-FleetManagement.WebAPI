USE TritonFleetManagement
GO

IF NOT EXISTS (SELECT SS.name AS SchemaName, SP.name AS StoredProc 
    FROM sys.procedures SP
    INNER JOIN sys.schemas SS on SP.schema_id = SS.schema_id
    WHERE SS.name = 'dbo' and SP.name = 'proc_Bookings_Total_Yesterday_Weekly_Monthly_Select'
	)
BEGIN

    DECLARE @SQL NVARCHAR(MAX)

    SELECT @SQL = 'CREATE PROC [dbo].[proc_Bookings_Total_Yesterday_Weekly_Monthly_Select]
					AS
					BEGIN
					WITH TodaysBookings AS
					(
						SELECT 
							COUNT(B.BookingsID) TodaysBookings
						FROM TritonFleetManagement.dbo.Bookings B
						WHERE B.DeletedByUserID IS NULL AND B.DeletedOn IS NULL AND CONVERT(DATE, B.CreatedOn) = CONVERT(DATE, GETDATE())
					),
					YesterdaysBookings AS
					(
						SELECT 
							COUNT(B.BookingsID) AS YesterdaysBookings
						FROM TritonFleetManagement.dbo.Bookings B
						WHERE B.CreatedOn >= DATEADD(DAY,DATEDIFF(DAY,1,GETDATE()),0)
						AND B.CreatedOn < DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()),0)
						AND B.DeletedByUserID IS NULL AND B.DeletedOn IS NULL
					),
					WeeklyBookings AS
					(
						SELECT
							COUNT(B.BookingsID) AS WeeklyBookings
						FROM TritonFleetManagement.dbo.Bookings B
						WHERE B.CreatedOn > = DATEADD(wk, DATEDIFF(wk, 0, GETDATE() -1 ),0) AND B.DeletedByUserID IS NULL
						AND B.DeletedOn IS NULL
						GROUP BY DATEPART(week, B.CreatedOn)
					),
					MonthlyBookings AS
					(
						SELECT 
							COUNT(B.BookingsID) AS MonthlyBookings
						FROM TritonFleetManagement.dbo.Bookings B
						WHERE DATEPART(mm, B.CreatedOn) = MONTH(GETDATE())   
						AND DATEPART(yyyy, B.CreatedOn) = YEAR(GETDATE())   
						AND B.DeletedByUserID IS NULL AND B.DeletedOn IS NULL
					),
					TotalBookings AS
					(
						SELECT 
							COUNT(B.BookingsID) TotalBookings
						FROM TritonFleetManagement.dbo.Bookings B
						WHERE B.DeletedByUserID IS NULL AND B.DeletedOn IS NULL
					)
					SELECT 
						TB.TodaysBookings TodaysBookings,
						YB.YesterdaysBookings YesterdaysBookings,
						WB.WeeklyBookings WeeklyBookings,
						MB.MonthlyBookings MonthlyBookings,
						TOB.TotalBookings TotalBookings, 
						ROUND(CAST(TB.TodaysBookings AS FLOAT) / CAST(TOB.TotalBookings AS FLOAT) * 100,0) TodaysPerc,
						ROUND(CAST(YB.YesterdaysBookings AS FLOAT) / CAST(TOB.TotalBookings AS FLOAT) * 100,0) YesterdaysPerc,
						ROUND(CAST(WB.WeeklyBookings AS FLOAT) / CAST(TOB.TotalBookings AS FLOAT) * 100,0) WeeklyPerc
					FROM 
						TodaysBookings TB,
						YesterdaysBookings YB,
						WeeklyBookings WB,
						MonthlyBookings MB,
						TotalBookings TOB
					END'

    EXEC sp_EXECUTESQL @SQL
END
 

