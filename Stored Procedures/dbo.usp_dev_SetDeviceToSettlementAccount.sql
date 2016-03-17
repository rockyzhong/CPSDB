SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_SetDeviceToSettlementAccount] 
  @DeviceId                      bigint,
  @BankAccountId                 bigint,
  @UpdatedUserId                 bigint
AS
BEGIN 
  SET NOCOUNT ON
  
  DECLARE @StartDate datetime,@EndDate datetime
  SET @StartDate=GETUTCDATE()
  SET @EndDate=CONVERT(datetime,'39991231',112)
  
  IF EXISTS(SELECT * FROM dbo.tbl_DeviceToSettlementAccount WHERE DeviceId=@DeviceId AND EndDate=@EndDate)
    UPDATE dbo.tbl_DeviceToSettlementAccount SET EndDate=@StartDate,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId AND EndDate=@EndDate
  INSERT INTO dbo.tbl_DeviceToSettlementAccount(DeviceId,BankAccountId,StartDate,EndDate,UpdatedUserId) VALUES(@DeviceId,@BankAccountId,@StartDate,@EndDate,@UpdatedUserId)
    
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceToSettlementAccount] TO [WebV4Role]
GO
