SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceNextSequenceNumber] (@DeviceId bigint,@SequenceNumber bigint OUT)
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS (SELECT Id FROM [dbo].[tbl_DeviceSequenceNumber] WHERE DeviceId=@DeviceId)
  BEGIN 
   SELECT @SequenceNumber=SequenceNumber FROM [dbo].[tbl_DeviceSequenceNumber] WHERE DeviceId=@DeviceId
   IF  @SequenceNumber=9999
   SET @SequenceNumber=0
   SET @SequenceNumber=@SequenceNumber+1
   UPDATE dbo.tbl_DeviceSequenceNumber SET SequenceNumber=@SequenceNumber WHERE DeviceId=@DeviceId
  END
  ELSE
  BEGIN
  INSERT INTO [dbo].[tbl_DeviceSequenceNumber] VALUES (@DeviceId,1)
  SET  @SequenceNumber=1
  END
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceNextSequenceNumber] TO [WebV4Role]
GO
