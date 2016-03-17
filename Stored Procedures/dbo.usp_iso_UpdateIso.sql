SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_UpdateIso]
@IsoId            bigint,
@RegisteredName   nvarchar(50),
@TradeName1       nvarchar(50),
@TradeName2       nvarchar(50),
@TradeName3       nvarchar(50),
@Website          nvarchar(100),
@IsoCode          nvarchar(13),
@IsoStatus        bigint,
@TimeZoneId       bigint,
@UpdatedUserId    bigint,
@BusinessTime     nvarchar(4),
@SmartAcquireId  bigint =0

AS
BEGIN
  SET NOCOUNT ON
  DECLARE @ParentId bigint 
  UPDATE dbo.tbl_Iso SET 
  RegisteredName=@RegisteredName,TradeName1=@TradeName1,TradeName2=@TradeName2,TradeName3=@TradeName3,Website=@Website,BusinessTime=@BusinessTime,
  IsoCode=@IsoCode,IsoStatus=@IsoStatus,TimeZoneId=@TimeZoneId,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@IsoId
  select @ParentId=ParentId from tbl_Iso where Id=@IsoId
  IF @ParentId is NOT NULL
  UPDATE tbl_Device set TimeZoneId=@TimeZoneId, UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId where IsoId=@IsoId

  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_iso_UpdateIso] TO [WebV4Role]
GO
