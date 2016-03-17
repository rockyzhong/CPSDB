SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceToSettlementAccountOverride]
@DeviceId         bigint,
@BankAccountId    bigint,
@OverrideType     bigint,
@OverrideData     nvarchar(30),
@OverridePriority bigint,
@Date             datetime,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @StartDate datetime,@MaxSettlementTime datetime
  SELECT @MaxSettlementTime=MAX(SettlementTime) FROM dbo.tbl_AchTransaction WHERE SourceId=@DeviceId AND SourceType=1 AND FundsType=1
  IF @MaxSettlementTime IS NOT NULL AND @MaxSettlementTime>@Date
    SET @StartDate = @MaxSettlementTime
  ELSE
    SET @StartDate = @Date
  
  DECLARE @EndDate datetime
  SET @EndDate=CONVERT(datetime,'39991231',112)

  INSERT INTO dbo.tbl_DeviceToSettlementAccountOverride(DeviceId,BankAccountId,StartDate,EndDate,OverrideType,OverrideData,OverridePriority,UpdatedUserId)
  VALUES(@DeviceId,@BankAccountId,@StartDate,@EndDate,@OverrideType,@OverrideData,@OverridePriority,@UpdatedUserId)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceToSettlementAccountOverride] TO [WebV4Role]
GO
