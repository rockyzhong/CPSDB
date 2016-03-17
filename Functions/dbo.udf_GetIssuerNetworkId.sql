SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***** Get IsserNetworkId *****/
CREATE FUNCTION [dbo].[udf_GetIssuerNetworkId](@IssuerNetworkId nvarchar(50),@IssuerInstitutionId nvarchar(10))
RETURNS nvarchar(50)
AS
BEGIN
  --Overwrite IssuerNetworkId when Issuer Institution ID is 1002004020 or 1003004029 in Moneris File 
  IF @IssuerNetworkId=N'INT'
  BEGIN
    IF @IssuerInstitutionId=N'1002004020'  SET @IssuerNetworkId=N'PUL'
    IF @IssuerInstitutionId=N'1003004029'  SET @IssuerNetworkId=N'CUP'
  END
  RETURN @IssuerNetworkId
END
GO
