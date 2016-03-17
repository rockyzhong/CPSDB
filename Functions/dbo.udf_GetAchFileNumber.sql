SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[udf_GetAchFileNumber] (@SettlementDate datetime,@AchFileId bigint)
RETURNS bigint
AS
BEGIN
  DECLARE @AchFileNumber bigint
  SELECT @AchFileNumber=ISNULL(MAX(AchFileNumber),0)+1 FROM dbo.tbl_AchFileHistory WHERE SettlementDate=@SettlementDate AND AchFileId=@AchFileId
  RETURN @AchFileNumber
END
GO
