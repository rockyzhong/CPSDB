SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/***** Get sunday *****/
CREATE FUNCTION [dbo].[udf_GetSunday]
(@Year bigint,@Month bigint,@Number bigint)
RETURNS datetime
AS
BEGIN
DECLARE @Date datetime,@WeekDay bigint,@i bigint,@j bigint
SET @i = 1
SET @j = 0
WHILE @j<@Number
BEGIN
  SELECT @Date=CONVERT(datetime,CONVERT(nvarchar,@Year)+'/'+CONVERT(nvarchar,@Month)+'/'+CONVERT(nvarchar,@i))
  SET @WeekDay=DATEPART(weekday, @Date)
  IF @WeekDay=1  SET @j=@j+1
  SET @i=@i+1
END
RETURN @Date
END
GO
