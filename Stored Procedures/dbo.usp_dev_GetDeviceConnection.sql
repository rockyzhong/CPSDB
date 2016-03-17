SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[usp_dev_GetDeviceConnection]
@DeviceId   bigint
AS
BEGIN
  SET NOCOUNT ON
  SELECT ProtocolType ,Caller,LocalAddress,CommsAPIType,LocalIPAddress,LocalPort,RemoteIPAddress,RemotePort,IPAddressFlags FROM tbl_DeviceConnection
  WHERE DeviceId=@DeviceId

END

GO
