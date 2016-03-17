SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_InsertIsoCageCardTransactionConfig]
@IsoCageCardTransactionConfigId bigint OUTPUT,
@IsoId                          bigint,
@CallCenterPhone                nvarchar(200),
@DAPLookupLevel                 bigint,
@AvsCvv2Required                bit,
@InitializeTransactionAtCage    bit,
@DisplayCashToCustomerToday     bit,
@ManualCardEntryAllowed         bit,
@UpdatedUserId                  bigint,
@PinDebitAllowed                 bit,
@SignDebitAllowed                bit,
@Title31Limit                   MONEY
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON
 
  INSERT INTO dbo.tbl_IsoCageCardTransactionConfig(IsoId,CallCenterPhone,DAPLookupLevel,AvsCvv2Required,InitializeTransactionAtCage,DisplayCashToCustomerToday,ManualCardEntryAllowed,UpdatedUserId,PinDebitAllowed,SignDebitAllowed,Title31Limit)
  VALUES(@IsoId,@CallCenterPhone,@DAPLookupLevel,@AvsCvv2Required,@InitializeTransactionAtCage,@DisplayCashToCustomerToday,@ManualCardEntryAllowed,@UpdatedUserId,@PinDebitAllowed,@SignDebitAllowed,@Title31Limit)
 
  SELECT @IsoCageCardTransactionConfigId=IDENT_CURRENT('tbl_IsoCageCardTransactionConfig')
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_InsertIsoCageCardTransactionConfig] TO [WebV4Role]
GO
