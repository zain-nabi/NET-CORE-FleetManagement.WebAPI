USE [TritonSecurity]
GO


IF (SELECT COUNT(*) FROM [dbo].[Companys] WHERE [ShortCompanyName] = 'TFM' ) = 0
BEGIN

UPDATE Companys
SET ShortCompanyName ='TFM'
WHERE Description='Triton Fleet Management Services'

END


IF (SELECT COUNT(*) FROM [dbo].[Companys] WHERE [ShortCompanyName] = 'TTM' ) = 0
BEGIN

UPDATE Companys
SET ShortCompanyName ='TTM'
WHERE Description='Truck and Trailer Mbombela'

END