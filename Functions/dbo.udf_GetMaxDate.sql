SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetMaxDate] (@Date1 datetime,@Date2 datetime,@Date3 datetime)
RETURNS datetime
AS
BEGIN
  IF @Date1 IS NULL  SET @Date1='2010-01-01'
  IF @Date2 IS NULL  SET @Date2='2010-01-01'
  IF @Date3 IS NULL  SET @Date3='2010-01-01'
    
  DECLARE @Date datetime
  IF @Date1>=@Date2 AND @Date1>=@Date3
    SET @Date=@Date1
  ELSE IF @Date2>=@Date1 AND @Date2>=@Date3
    SET @Date=@Date2
  ELSE
    SET @Date=@Date3
  RETURN @Date
END
GO
