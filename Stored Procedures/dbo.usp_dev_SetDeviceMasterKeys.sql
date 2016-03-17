SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceMasterKeys] 
  @DeviceId             bigint,
  @PinKeyId1            nvarchar(32),
  @PinKeyCheckDigits1   nvarchar(16),
  @PinKeyId2            nvarchar(32),
  @PinKeyCheckDigits2   nvarchar(16),
  @MacKeyIsSameToPinKey bit,   
  @MacKeyId1            nvarchar(32),
  @MacKeyCheckDigits1   nvarchar(16),
  @UpdatedUserId        bigint,
  @SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON

  DECLARE @Now datetime = GETUTCDATE(),@DeviceStatus bigint
  UPDATE dbo.tbl_DeviceKeyMaster SET DeactivatedDate=@Now,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId
   
  IF @PinKeyId1 IS NOT NULL AND @PinKeyCheckDigits1 IS NOT NULL
  BEGIN
    BEGIN
    UPDATE dbo.tbl_DeviceKeyMaster SET DeviceId=@DeviceId,KeyClass=CASE WHEN @MacKeyIsSameToPinKey=1 THEN 0 ELSE 1 END,KeySequence=1,AssignedDate=@Now,DeactivatedDate=NULL,UpdatedUserId=@UpdatedUserId 	WHERE  Id=@PinKeyId1 AND CheckDigits=@PinKeyCheckDigits1 AND (DeviceId IS NULL OR DeviceId=@DeviceId)
    IF @@RowCount=0  RETURN 1
	END
	UPDATE dbo.tbl_DeviceExtendedValue SET ExtendedColumnValue='' 
	WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType IN (300,306,312)
  END
    
  IF @PinKeyId2 IS NOT NULL AND @PinKeyCheckDigits2 IS NOT NULL
  BEGIN
    UPDATE dbo.tbl_DeviceKeyMaster SET DeviceId=@DeviceId,KeyClass=1,KeySequence=2,AssignedDate=@Now,DeactivatedDate=NULL,UpdatedUserId=@UpdatedUserId 
	WHERE Id=@PinKeyId2 AND CheckDigits=@PinKeyCheckDigits2 AND (DeviceId IS NULL OR DeviceId=@DeviceId)
    IF @@RowCount=0  RETURN 2
    UPDATE dbo.tbl_DeviceExtendedValue SET ExtendedColumnValue='' 
	WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType IN (300,306,312)
  END
    
  IF @MacKeyId1 IS NOT NULL AND @MacKeyCheckDigits1 IS NOT NULL
  BEGIN
    UPDATE dbo.tbl_DeviceKeyMaster SET DeviceId=@DeviceId,KeyClass=2,KeySequence=1,AssignedDate=@Now,DeactivatedDate=NULL,UpdatedUserId=@UpdatedUserId 
	WHERE Id=@MacKeyId1 AND CheckDigits=@MacKeyCheckDigits1 AND (DeviceId IS NULL OR DeviceId=@DeviceId)
    IF @@RowCount=0  RETURN 3
	UPDATE dbo.tbl_DeviceExtendedValue SET ExtendedColumnValue='' 
	WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType IN (303,309,315)
  END
    
  --Update device master key cryptogram
 
  DECLARE @MasterPinKeyCryptogram1 nvarchar(32),@MasterPinKeyCryptogram2 nvarchar(32),@MasterPinKeyCryptogram nvarchar(32),@MasterMacKeyCryptogram nvarchar(32)
  SELECT @MasterPinKeyCryptogram1=Cryptogram FROM dbo.tbl_DeviceKeyMaster WHERE DeviceId=@DeviceId AND KeyClass IN (0,1) AND KeySequence=1 AND DeactivatedDate IS NULL
  SELECT @MasterPinKeyCryptogram2=Cryptogram FROM dbo.tbl_DeviceKeyMaster WHERE DeviceId=@DeviceId AND KeyClass=1 AND KeySequence=2 AND DeactivatedDate IS NULL
  SET @MasterPinKeyCryptogram=ISNULL(@MasterPinKeyCryptogram1,'')+ISNULL(@MasterPinKeyCryptogram2,'')

  IF @MacKeyIsSameToPinKey=1  --Mac master key is same as pin master key 1
    SET @MasterMacKeyCryptogram=@MasterPinKeyCryptogram
  ELSE
    SELECT @MasterMacKeyCryptogram=Cryptogram FROM dbo.tbl_DeviceKeyMaster WHERE DeviceId=@DeviceId AND KeyClass=2 AND KeySequence=1 AND DeactivatedDate IS NULL
  ----------- setting  extend value null once PIN and MAC KEY changed ---------------
  --DECLARE @OldMasterPinKeyCryptogram NVARCHAR(32),@OldMasterMacKeyCryptogram NVARCHAR(32)
  --SELECT @OldMasterPinKeyCryptogram=MasterPinKeyCryptogram,@OldMasterMacKeyCryptogram=MasterPinKeyCryptogram FROM dbo.tbl_Device WHERE Id=@DeviceId
  --IF @MasterPinKeyCryptogram <> @OldMasterPinKeyCryptogram 
  --UPDATE dbo.tbl_DeviceExtendedValue SET ExtendedColumnValue='' WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType IN (300,306,312)
  --IF @MasterMacKeyCryptogram <> @OldMasterMacKeyCryptogram
  --UPDATE dbo.tbl_DeviceExtendedValue SET ExtendedColumnValue='' WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ExtendedColumnType IN (303,309,315)

  UPDATE dbo.tbl_Device SET MasterPinKeyCryptogram=@MasterPinKeyCryptogram,MasterMacKeyCryptogram=@MasterMacKeyCryptogram,UpdatedDate=@Now,UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceMasterKeys] TO [WebV4Role]
GO
