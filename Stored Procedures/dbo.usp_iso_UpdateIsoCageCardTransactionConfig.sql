SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_UpdateIsoCageCardTransactionConfig]
@IsoCageCardTransactionConfigId bigint,
@CallCenterPhone                nvarchar(200),
@DAPLookupLevel                 bigint,
@AvsCvv2Required                bit,
@InitializeTransactionAtCage    bit,
@DisplayCashToCustomerToday     bit,
@ManualCardEntryAllowed         bit,
@UpdatedUserId                  bigint,
@PinDebitAllowed                 bit,
@SignDebitAllowed                bit,
@Title31Limit                    MONEY
--@SmartAcquireId  bigint =0
AS
BEGIN
  --DECLARE @IsoId bigint
  SET NOCOUNT ON
 -- SELECT @IsoId=IsoId from tbl_IsoAddress where Id=@IsoCageCardTransactionConfigId
  UPDATE dbo.tbl_IsoCageCardTransactionConfig SET 
  CallCenterPhone=@CallCenterPhone,DAPLookupLevel=@DAPLookupLevel,AvsCvv2Required=@AvsCvv2Required,
  InitializeTransactionAtCage=@InitializeTransactionAtCage,DisplayCashToCustomerToday=@DisplayCashToCustomerToday,
  ManualCardEntryAllowed=@ManualCardEntryAllowed,UpdatedUserId=@UpdatedUserId,PinDebitAllowed=@PinDebitAllowed,
  SignDebitAllowed=@SignDebitAllowed,Title31Limit=@Title31Limit
  WHERE Id=@IsoCageCardTransactionConfigId
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_UpdateIsoCageCardTransactionConfig] TO [WebV4Role]
GO
