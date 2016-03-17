SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoCageCheckTransactionConfig]
@IsoId   bigint
AS
BEGIN
  SET NOCOUNT ON
 
  SELECT cc.Id IsoCageCheckTransactionConfigId,cc.IsoId,cc.BankName,cc.BankAccountNumber,cc.MinimumCheckAmount,cc.DisplayTransactionHistory,cc.DisplayCashToCustomerToday,cc.ManualCardEntryAllowed,
  ss.Id SettleSmartVendorId, ss.SmartABA,ss.SmartBankName,ss.SmartCity,ss.SmartAccountNumber, cc.NetworkId
  FROM dbo.tbl_IsoCageCheckTransactionConfig cc LEFT JOIN dbo.tbl_SettleSmartVendor ss ON cc.SettlesmartVendor = ss.Id
  WHERE IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoCageCheckTransactionConfig] TO [WebV4Role]
GO
