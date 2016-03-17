SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetSettleSmartVendor]
AS
BEGIN
  SELECT Id SettleSmartVendorId,SmartABA,SmartBankName,SmartCity,SmartAccountNumber FROM dbo.tbl_SettleSmartVendor
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetSettleSmartVendor] TO [WebV4Role]
GO
