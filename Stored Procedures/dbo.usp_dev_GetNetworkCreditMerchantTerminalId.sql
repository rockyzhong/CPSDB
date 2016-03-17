SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetNetworkCreditMerchantTerminalId]
@DeviceId   bigint,
@MerchantId nvarchar(50) OUTPUT,
@TerminalId nvarchar(50) OUTPUT
AS
BEGIN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM dbo.tbl_DeviceExtendedValue WHERE DeviceId=@DeviceId AND ExtendedColumnType=9)
  BEGIN
    SELECT @MerchantId=ExtendedColumnValue FROM dbo.tbl_DeviceExtendedValue WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType=8
    SELECT @TerminalId=ExtendedColumnValue FROM dbo.tbl_DeviceExtendedValue WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType=9
  END  
  ELSE
  BEGIN
    DECLARE @IsoId bigint
    SELECT @IsoId=IsoId FROM dbo.tbl_Device WHERE Id=@DeviceId
    SELECT @MerchantId=ExtendedColumnValue FROM dbo.tbl_IsoExtendedValue WHERE IsoId=@IsoId AND ExtendedColumnType=8
    SELECT @TerminalId=ExtendedColumnValue FROM dbo.tbl_IsoExtendedValue WHERE IsoId=@IsoId AND ExtendedColumnType=9
  END  
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetNetworkCreditMerchantTerminalId] TO [WebV4Role]
GO
