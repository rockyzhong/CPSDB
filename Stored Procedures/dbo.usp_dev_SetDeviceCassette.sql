SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_SetDeviceCassette]
@DeviceId              bigint,
@CassetteId            bigint,
@Currency              bigint,
@MediaCode             bigint,
@MediaValue            bigint,
@MediaCurrentCount     bigint,
@MediaCurrentUse       bigint,
@MediaCurrentAdjust    bigint,
@ReplenishmentDate     datetime = NULL,
@SettlementCard        bigint = 0,
@UpdatedUserId         bigint =0,
@SmartAcquireId        bigint =0
  --   ,@ExtendedColumn
  -- Revision 2.2.0 2014.04.08 by Adam Glover
  --   Add insert to tbl_DeviceUpdateCommands for both SmartAcquirers
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @mc bigint,@mu bigint,@DeviceStatus bigint
  SELECT @mc= MediaCurrentCount,@mu = MediaCurrentUse FROM dbo.tbl_DeviceCassette WHERE DeviceId=@DeviceId AND CassetteId=@CassetteId

  IF EXISTS(SELECT * FROM dbo.tbl_DeviceCassette WHERE DeviceId=@DeviceId AND CassetteId=@CassetteId)
    UPDATE dbo.tbl_DeviceCassette SET
    Currency=@Currency,MediaCode=@MediaCode,MediaValue=@MediaValue,MediaCurrentCount=@MediaCurrentCount,MediaCurrentUse=@MediaCurrentUse,
    MediaCurrentAdjust=ISNULL(@MediaCurrentAdjust,MediaCurrentAdjust),@ReplenishmentDate=ISNULL(@ReplenishmentDate, ReplenishmentDate),
    UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId AND CassetteId=@CassetteId
  ELSE
    INSERT INTO dbo.tbl_DeviceCassette(DeviceId,CassetteId,Currency,MediaCode,MediaValue,MediaCurrentCount,MediaCurrentUse,MediaCurrentAdjust,ReplenishmentDate,UpdatedUserId)
    VALUES (@DeviceId,@CassetteID,@Currency,@MediaCode,@MediaValue,@MediaCurrentCount,@MediaCurrentUse,@MediaCurrentAdjust,@ReplenishmentDate,@UpdatedUserId)

  IF @ReplenishmentDate IS NOT NULL AND (@SettlementCard<>0 OR @MediaCurrentCount>ISNULL(@mc,0) OR @MediaCurrentUse<ISNULL(@mu, 0))
    INSERT INTO dbo.tbl_CashLoadHistory(DeviceId,CassetteId,ReplenishmentDate,ReplenishmentCount,Currency,MediaCode,MediaValue,OldCount,UpdatedUserId) 
    VALUES(@DeviceId,@CassetteId,@ReplenishmentDate,@MediaCurrentCount+@MediaCurrentUse,@Currency,@MediaCode,@MediaValue,@mc,@UpdatedUserId)

 ----------------------------------------------------------------------  
   -- Add update command for Smart Acquirer  
 SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
 IF @DeviceStatus=1
 exec [dbo].[usp_acq_InsertDevicesUpdateCommands] @SmartAcquireId,@DeviceId
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceCassette] TO [WebV4Role]
GO
