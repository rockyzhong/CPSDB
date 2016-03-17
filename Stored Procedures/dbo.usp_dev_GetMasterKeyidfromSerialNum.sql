SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetMasterKeyidfromSerialNum]
@SerialNum NVARCHAR(11) =NULL   -- smart acquierer null
AS
BEGIN
SET NOCOUNT ON
IF @SerialNum IS NULL
SELECT dkd.MasterKeyId,dkm.Cryptogram FROM tbl_DeviceKeyDukpt  dkd JOIN dbo.tbl_DeviceKeyMaster dkm ON dkd.MasterKeyId=dkm.Id
ELSE
SELECT MasterKeyId FROM tbl_DeviceKeyDukpt WHERE SerialNum=@SerialNum

END
GO
