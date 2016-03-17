SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_UpdateAddress]
@AddressId    bigint,
@RegionId     bigint,
@City         nvarchar(20),
@AddressLine1 nvarchar(50),
@AddressLine2 nvarchar(50),
@PostalCode   nvarchar(10),
@Telephone1   nvarchar(20),
@Extension1   nvarchar(20),
@Telephone2   nvarchar(20),
@Extension2   nvarchar(20),
@Telephone3   nvarchar(20),
@Extension3   nvarchar(20),
@Fax          nvarchar(20),
@Email        nvarchar(50),
@UpdatedUserId      bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  DECLARE @DeviceId bigint, @DeviceStatus bigint
  SET NOCOUNT ON
  SELECT @DeviceId=Id from dbo.tbl_Device where AddressId=@AddressId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  UPDATE dbo.tbl_Address SET 
  RegionId=@RegionId,City=@City,AddressLine1=@AddressLine1,AddressLine2=@AddressLine2,PostalCode=@PostalCode,
  Telephone1=@Telephone1,Extension1=@Extension1,Telephone2=@Telephone2,Extension2=@Extension2,
  Telephone3=@Telephone3,Extension3=@Extension3,Fax=@Fax,Email=@Email,UpdatedUserId=@UpdatedUserId
  WHERE Id=@AddressId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_UpdateAddress] TO [WebV4Role]
GO
