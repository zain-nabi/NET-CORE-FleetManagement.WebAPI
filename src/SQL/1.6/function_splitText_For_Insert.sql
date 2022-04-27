USE [TritonGroup]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitText_For_Insert]    Script Date: 2021/04/30 4:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitText_For_Insert]
(
  @List VARCHAR(max),
  @SplitOn NVARCHAR(5),
  @BookingID INT,
  @VehicleID INT
)

RETURNS @RtnValue table
(
  VehicleID INT,
  Id INT ,
  Value NVARCHAR(max)
)
AS

BEGIN
   IF (len(@List) <= 0)
   BEGIN
     RETURN 
   END

WHILE (Charindex(@SplitOn,@List) > 0)
   BEGIN

     INSERT INTO @RtnValue (vehicleid, id,value)
     SELECT 
     Value = ltrim(rtrim(Substring(@List,1,Charindex(@SplitOn,@List)-1))),
	 id = @BookingID,
	 vehicleid = @VehicleID

     SET @List = Substring(@List,Charindex(@SplitOn,@List)+len(@SplitOn),len(@List))
   END

   INSERT INTO @RtnValue (vehicleid,id,Value)
   SELECT   Value = ltrim(rtrim(@List)),id = @BookingID, vehicleid = @VehicleID

   RETURN
END