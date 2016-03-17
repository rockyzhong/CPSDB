SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceMasterKey] 
  @DeviceKeyId   nvarchar(32)
AS
BEGIN 
  SELECT Id DeviceKeyId,DeviceId,KeyClass,KeySequence,Cryptogram,CheckDigits,AssignedDate,DeactivatedDate
  FROM dbo.tbl_DeviceKeyMaster WHERE Id=@DeviceKeyId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceMasterKey] TO [WebV4Role]
GO
