SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_SetCutoverFromMidnight]
(@pCutoverFromBase int, @pCurrencyCode int)
RETURNS int
AS
BEGIN 
  DECLARE @Ret int
  DECLARE @CutoverBaseTime char(4)
  
  IF @pCurrencyCode = 840
  BEGIN
    SET @CutoverBaseTime = '0100'
  END
  ELSE
  BEGIN
    SET @CutoverBaseTime = '2100'
  END
  IF LEN(@CutoverBaseTime) <> 4
  BEGIN
    SET @Ret = 0
  END
  ELSE IF @CutoverBaseTime = '2100' AND @pCutoverFromBase = 0
  BEGIN
    SET @Ret = @pCutoverFromBase - 1435
      + (60 * convert(int, substring(@CutoverBaseTime, 1, 2)))
      + convert(int, substring(@CutoverBaseTime, 3, 2))
  END
  ELSE IF @CutoverBaseTime >= '1200'
  BEGIN
    SET @Ret = @pCutoverFromBase - 1440
      + (60 * convert(int, substring(@CutoverBaseTime, 1, 2)))
      + convert(int, substring(@CutoverBaseTime, 3, 2))
  END
  ELSE
  BEGIN
    SET @Ret = @pCutoverFromBase
      + (60 * convert(int, substring(@CutoverBaseTime, 1, 2)))
      + convert(int, substring(@CutoverBaseTime, 3, 2))
  END
  RETURN @Ret
END
GO
