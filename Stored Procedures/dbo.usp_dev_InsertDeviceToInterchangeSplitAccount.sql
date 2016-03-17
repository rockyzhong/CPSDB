SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceToInterchangeSplitAccount] 
  @DeviceToInterchangeSplitAccountId bigint OUTPUT,
  @DeviceId                          bigint,
  @BankAccountId                     bigint,
  @Recipient                         bigint,
  @StartDate                         datetime,
  @SplitType                         bigint,
  @SplitData                         bigint,
  @UpdatedUserId                     bigint
AS
BEGIN 
  SET NOCOUNT ON

  DECLARE @MaxSettlementTime datetime
  SELECT @MaxSettlementTime=MAX(SettlementTime) FROM dbo.tbl_AchTransaction WHERE SourceId=@DeviceId AND SourceType=1 AND FundsType=3
  IF @MaxSettlementTime IS NOT NULL AND @MaxSettlementTime>@StartDate
    SET @StartDate = @MaxSettlementTime
  
  DECLARE @EndDate datetime
  SET @EndDate=CONVERT(datetime,'39991231',112)
   
  INSERT INTO dbo.tbl_DeviceToInterchangeSplitAccount(DeviceId,BankAccountId,Recipient,StartDate,EndDate,SplitType,SplitData,UpdatedUserId)
  VALUES(@DeviceId,@BankAccountId,@Recipient,@StartDate,@EndDate,@SplitType,CASE WHEN @SplitType=0 or @SplitType=1 THEN @SplitData ELSE 0 END,@UpdatedUserId)
  SELECT @DeviceToInterchangeSplitAccountId=IDENT_CURRENT('tbl_DeviceToInterchangeSplitAccount')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceToInterchangeSplitAccount] TO [WebV4Role]
GO
