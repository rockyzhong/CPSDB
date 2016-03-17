SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceMasterKeys] 
  @DeviceId              bigint,
  @PinKeyId1             nvarchar(32) OUTPUT,
  @PinKeyCheckDigits1    nvarchar(16) OUTPUT,
  @PinKeyId2             nvarchar(32) OUTPUT,
  @PinKeyCheckDigits2    nvarchar(16) OUTPUT,
  @MacKeyIsSameToPinKey  bit          OUTPUT,   
  @MacKeyId1             nvarchar(32) OUTPUT,
  @MacKeyCheckDigits1    nvarchar(16) OUTPUT
AS
BEGIN 
   SET NOCOUNT ON
   
   DECLARE @KeyClass bigint

   SELECT @PinKeyId1=Id,@PinKeyCheckDigits1=CheckDigits,@KeyClass=KeyClass FROM dbo.tbl_DeviceKeyMaster WHERE DeviceId=@DeviceId AND KeyClass IN (0,1) AND KeySequence=1 AND DeactivatedDate IS NULL
   SELECT @PinKeyId2=Id,@PinKeyCheckDigits2=CheckDigits FROM dbo.tbl_DeviceKeyMaster WHERE DeviceId=@DeviceId AND KeyClass=1 AND KeySequence=2 AND DeactivatedDate IS NULL
   SELECT @MacKeyId1=Id,@MacKeyCheckDigits1=CheckDigits FROM dbo.tbl_DeviceKeyMaster WHERE DeviceId=@DeviceId AND KeyClass=2 AND KeySequence=1 AND DeactivatedDate IS NULL
   
   IF @KeyClass=0
     SET @MacKeyIsSameToPinKey=1
   ELSE
     SET @MacKeyIsSameToPinKey=0

   RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceMasterKeys] TO [WebV4Role]
GO
