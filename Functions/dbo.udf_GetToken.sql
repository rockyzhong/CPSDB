SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_GetToken] (@type INT, @data TEXT) 
RETURNS CHAR(64) AS
BEGIN
  DECLARE @hash CHAR(64)
  EXEC [master]..[token_test] @type, @data, -1, @hash OUTPUT
  RETURN @hash
END
GO
