SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------------------------------- Add fee tab for ISO and make the terminal address from non-ISO can be modified Yijun --------------

CREATE PROCEDURE [dbo].[usp_dev_InsertDevice]
@DeviceId       bigint OUTPUT,
@TerminalName   nvarchar(50),
@ModelId        bigint,
@IsoId          bigint,
@SerialNumber   nvarchar(50),
@Currency       bigint,
@Location       nvarchar(50),
@AddressId      bigint OUTPUT,
@TimeZoneId     bigint,
@UpdatedUserId  bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM dbo.tbl_Iso WHERE Id=@IsoId AND ParentId IS NOT NULL)
  BEGIN
    SELECT @TimeZoneId=TimeZoneId FROM dbo.tbl_Iso WHERE Id=@IsoId
    SELECT @AddressId=AddressId FROM dbo.tbl_IsoAddress WHERE IsoId=@IsoId AND IsoAddressType=1
  END  
  ELSE
  BEGIN  
    INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)  
    SELECT @AddressId=IDENT_CURRENT('tbl_Address')
  END
 
  INSERT INTO dbo.tbl_Device(TerminalName,ModelId,IsoId,SerialNumber,Currency,Location,AddressId,TimeZoneId,CreatedDate,CreatedUserId,UpdatedDate,UpdatedUserId) 
  VALUES(@TerminalName,@ModelId,@IsoId,@SerialNumber,@Currency,@Location,@AddressId,@TimeZoneId,GETUTCDATE(),@UpdatedUserId,GETUTCDATE(),@UpdatedUserId)
  SELECT @DeviceId=IDENT_CURRENT('tbl_Device')
  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@DeviceId,1,@UpdatedUserId)
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDevice] TO [WebV4Role]
GO
