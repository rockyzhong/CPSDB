SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_UpdateIsoCageCheckTransactionConfig]
@IsoCageCheckTransactionConfigId bigint,
@BankName                        nvarchar(200),
@BankAccountNumber               nvarchar(200),
@SettlesmartVendor               bigint,
@MinimumCheckAmount              money,
@DisplayTransactionHistory       bigint,
@DisplayCashToCustomerToday      bigint,
@ManualCardEntryAllowed          bigint,
@NetWorkId                       bigint,
@UpdatedUserId                   bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
 -- DECLARE @IsoId bigint
  SET NOCOUNT ON
  --SELECT @IsoId=IsoId from tbl_IsoAddress where Id=@IsoCageCheckTransactionConfigId
  UPDATE dbo.tbl_IsoCageCheckTransactionConfig SET
  BankName=@BankName,BankAccountNumber=@BankAccountNumber,SettlesmartVendor=@SettlesmartVendor,MinimumCheckAmount=@MinimumCheckAmount,
  DisplayTransactionHistory=@DisplayTransactionHistory,DisplayCashToCustomerToday=@DisplayCashToCustomerToday,
  ManualCardEntryAllowed=@ManualCardEntryAllowed,UpdatedUserId=@UpdatedUserId,NetworkId=@NetWorkId
  WHERE Id=@IsoCageCheckTransactionConfigId
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_UpdateIsoCageCheckTransactionConfig] TO [WebV4Role]
GO
