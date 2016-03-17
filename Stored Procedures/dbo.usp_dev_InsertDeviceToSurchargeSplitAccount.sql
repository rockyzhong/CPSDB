SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceToSurchargeSplitAccount] 
  @DeviceToSurchargeSplitAccountId bigint OUTPUT,
  @DeviceId                        bigint,
  @BankAccountId                   bigint,
  @StartDate                       datetime,
  @SplitType                       bigint,
  @SplitData                       bigint,
  @UpdatedUserId                   bigint
AS
BEGIN 
  SET NOCOUNT ON

  DECLARE @MaxSettlementTime datetime
  SELECT @MaxSettlementTime=MAX(SettlementTime) FROM dbo.tbl_AchTransaction WHERE SourceId=@DeviceId AND SourceType=1 AND FundsType=2
  IF @MaxSettlementTime IS NOT NULL AND @MaxSettlementTime>@StartDate
    SET @StartDate = @MaxSettlementTime
  
  DECLARE @EndDate datetime
  SET @EndDate=CONVERT(datetime,'39991231',112)
   
  INSERT INTO dbo.tbl_DeviceToSurchargeSplitAccount(DeviceId,BankAccountId,StartDate,EndDate,SplitType,SplitData,UpdatedUserId)
  VALUES(@DeviceId,@BankAccountId,@StartDate,@EndDate,@SplitType,@SplitData,@UpdatedUserId)
  SELECT @DeviceToSurchargeSplitAccountId=IDENT_CURRENT('tbl_DeviceToSurchargeSplitAccount')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceToSurchargeSplitAccount] TO [WebV4Role]
GO
