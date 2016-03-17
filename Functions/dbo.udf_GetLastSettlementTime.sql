SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetLastSettlementTime] (@DeviceId bigint,@BankAccountId bigint,@FundsType bigint,@SettlementType bigint)
RETURNS datetime
AS
BEGIN
  DECLARE @Date datetime
  SELECT @Date=MAX(SettlementTime) FROM dbo.tbl_AchTransaction WHERE SourceType=1 AND SourceId=@DeviceId AND BankAccountId=@BankAccountId AND FundsType=@FundsType AND SettlementType=@SettlementType
  IF @Date IS NULL  SET @Date='2013-08-01'
  RETURN @Date
END
GO
