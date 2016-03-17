SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFee] 
@DeviceId                bigint,
@AmountRequest           bigint,
@TransactionType         bigint,
@AmountSurcharge         bigint OUTPUT
AS
BEGIN 
  SET NOCOUNT ON
  
  DECLARE @FeeFixed bigint,@FeePercentage bigint
  EXEC dbo.usp_dev_GetDeviceFeeFixed @DeviceId,@AmountRequest,@TransactionType,NULL,NULL,NULL,NULL,@FeeFixed OUTPUT,@FeePercentage OUTPUT
  SET @AmountSurcharge=@FeeFixed+@AmountRequest*@FeePercentage/10000
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFee] TO [WebV4Role]
GO
