SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertIsoCageCheckTransactionConfig]
@IsoCageCheckTransactionConfigId bigint OUTPUT,
@IsoId                           bigint,
@BankName                        nvarchar(200),
@BankAccountNumber               nvarchar(200),
@SettlesmartVendor               bigint,
@MinimumCheckAmount              money,
@DisplayTransactionHistory       bigint,
@DisplayCashToCustomerToday      bigint,
@ManualCardEntryAllowed          bigint,
@NetWorkId                       bigint,
@UpdatedUserId                   bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON
 
  INSERT INTO dbo.tbl_IsoCageCheckTransactionConfig(IsoId,BankName,BankAccountNumber,SettlesmartVendor,MinimumCheckAmount,DisplayTransactionHistory,DisplayCashToCustomerToday,ManualCardEntryAllowed,UpdatedUserId,NetworkId)
  VALUES(@IsoId,@BankName,@BankAccountNumber,@SettlesmartVendor,@MinimumCheckAmount,@DisplayTransactionHistory,@DisplayCashToCustomerToday,@ManualCardEntryAllowed,@UpdatedUserId,@NetWorkId)
  
  SELECT @IsoCageCheckTransactionConfigId=IDENT_CURRENT('tbl_IsoCageCheckTransactionConfig')
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_InsertIsoCageCheckTransactionConfig] TO [WebV4Role]
GO
