SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceConnection]
    @DeviceId   bigint ,
	@ProtocolType  bigint ,
	@Caller  bigint ,
	@LocalAddress  bigint,
	@CommsAPIType  bigint,
	@LocalIPAddress nvarchar(15),
	@LocalPort  bigint ,
	@RemoteIPAddress nvarchar(15),
	@RemotePort bigint ,
	@IPAddressFlags bigint,
	@UpdatedUserId bigint,
    @SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceStatus bigint
  IF not exists (select id from tbl_DeviceConnection where DeviceId=@DeviceId)
  insert into tbl_DeviceConnection values (@DeviceId,@ProtocolType,@Caller, @LocalAddress,
  @CommsAPIType,REPLACE(RTRIM(@LocalIPAddress), '0.0.0.0', ''),@LocalPort,REPLACE(RTRIM(@RemoteIPAddress), '0.0.0.0', ''),@RemotePort,@IPAddressFlags,
  @UpdatedUserId)
  ELSE 
  UPDATE tbl_DeviceConnection SET ProtocolType=@ProtocolType,Caller=@Caller,LocalAddress=@LocalAddress,CommsAPIType=@CommsAPIType,
  LocalIPAddress= REPLACE(RTRIM(@LocalIPAddress), '0.0.0.0', ''),LocalPort=@LocalPort,RemoteIPAddress=REPLACE(RTRIM(@RemoteIPAddress), '0.0.0.0', ''),
  RemotePort=@RemotePort,IPAddressFlags=@IPAddressFlags,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId

  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END

GO
