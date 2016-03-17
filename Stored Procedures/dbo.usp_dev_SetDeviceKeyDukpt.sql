SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceKeyDukpt]
@SerialNum NVARCHAR(11)
AS
BEGIN
  IF NOT EXISTS (SELECT Id FROM dbo.tbl_DeviceKeyDukpt WHERE SerialNum=@SerialNum)
  INSERT INTO dbo.tbl_DeviceKeyDukpt
          ( SerialNum ,
            MasterKeyId ,
            AssignedDate
          )
  VALUES  ( @SerialNum , -- SerialNum - nvarchar(11)
            N'99999999' , -- MasterKeyId - nvarchar(32)
            GETUTCDATE()  -- AssignedDate - datetime
          )
  ELSE 
  RETURN 1
END
GO
