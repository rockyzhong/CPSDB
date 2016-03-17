SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***** Get funds type code *****/
CREATE FUNCTION [dbo].[udf_GetFundsTypeCode](@FundsType bigint)
RETURNS nvarchar(4)
AS
BEGIN
  RETURN
  CASE @FundsType
    WHEN 1 THEN 'SETL'
    WHEN 2 THEN 'SRCH'
    WHEN 3 THEN 'INCH'
    ELSE        ''
  END
END
GO
