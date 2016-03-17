SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceToSettlementAccount] 
  @DeviceId                      bigint,
  @BankAccountId                 bigint OUTPUT
AS
BEGIN 
  SET NOCOUNT ON
  
  SELECT @BankAccountId=BankAccountId FROM dbo.tbl_DeviceToSettlementAccount WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceToSettlementAccount] TO [WebV4Role]
GO
