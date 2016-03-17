SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_UpdateDevice]
@DeviceId           bigint,
@ModelId            bigint,
@IsoId              bigint,
@ReportName         nvarchar(50),
@SerialNumber       nvarchar(50),
@SequenceNumber     bigint,
@RoutingFlags       bigint,
@FunctionFlags      bigint,
@Currency           bigint,
@QuestionablePolicy bigint,
@FeeType            bigint,
@LocationType       bigint,
@Location           nvarchar(50),
@TimeZoneId         bigint,
@DeviceStatus       bigint,
@UpdatedUserId      bigint,
@SmartAcquireId     bigint =0
AS
BEGIN
  SET NOCOUNT ON
 
  DECLARE @AddressId bigint,@ObjectId bigint,@TermOwnUserId  dbo.Sourcetable,@OldIsoId bigint,@OldDeviceStatus bigint
  SELECT @AddressId=AddressId,@OldIsoId = IsoId,@OldDeviceStatus=DeviceStatus  FROM dbo.tbl_Device WHERE Id=@DeviceId
  -------------------- FOR EXISTS deivces and related iso -------
  IF @IsoId <> @OldIsoId
  BEGIN
    SELECT @ObjectId=Id FROM tbl_upm_Object WHERE SourceId=@DeviceId AND SourceType=1
	INSERT INTO @TermOwnUserId SELECT Id from tbl_upm_User where ParentId = 1 and IsoId = @IsoId
	DELETE tbl_upm_ObjectToUser WHERE ObjectId=@ObjectId AND UserId in (SELECT Id from tbl_upm_User where ParentId = 1 and IsoId = @OldIsoId)
	INSERT INTO tbl_upm_ObjectToUser (UserId,ObjectId,IsGranted,UpdatedUserId) SELECT Id,@ObjectId,1,@UpdatedUserId FROM @TermOwnUserId
  END

  IF @IsoId <> @OldIsoId AND  @AddressId = (SELECT AddressId FROM dbo.tbl_IsoAddress WHERE IsoId=(SELECT Isoid FROM dbo.tbl_Device WHERE Id=@DeviceId) AND IsoAddressType=1)
  BEGIN
    INSERT INTO dbo.tbl_Address(RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,UpdatedUserId) SELECT RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,@UpdatedUserId FROM tbl_Address WHERE Id=@AddressId
    SELECT @AddressId=IDENT_CURRENT('tbl_Address')
  END
 

  DECLARE @ActivatedDate datetime
  IF @DeviceStatus=1 AND EXISTS(SELECT Id FROM dbo.tbl_Device WHERE Id=@DeviceId AND DeviceStatus=3)
    SET @ActivatedDate=GETUTCDATE()

  UPDATE dbo.tbl_Device SET 
  ModelId=@ModelId,IsoId=@IsoId,ReportName=@ReportName,SerialNumber=@SerialNumber,
  RoutingFlags=@RoutingFlags,FunctionFlags=@FunctionFlags,Currency=@Currency,QuestionablePolicy=@QuestionablePolicy,FeeType=@FeeType,LocationType=@LocationType,
  Location=@Location,AddressId=@AddressId,TimeZoneId=@TimeZoneId,DeviceStatus=@DeviceStatus,ActivatedDate=ISNULL(ActivatedDate,@ActivatedDate),UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@DeviceId
  
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  ELSE IF @OldDeviceStatus=1 AND @DeviceStatus in (2,4)
  exec usp_acq_InsertDevicesClearCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDevice] TO [WebV4Role]
GO
