SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_gam_UpdateGamblersAddictionCard]
@GamblersAddictionCardId bigint,
@CustomerMediaData       nvarchar(50),
@UpdatedUserId           bigint,
@SmartAcquireId        bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @CustomerMediaDataHash varbinary(512),@CustomerMediaDataEncrypted varbinary(512)
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT
  EXEC dbo.usp_sys_Encrypt @CustomerMediaData,@CustomerMediaDataEncrypted OUT

  UPDATE dbo.tbl_GamblersAddictionCard SET CustomerMediaDataHash=@CustomerMediaDataHash,CustomerMediaDataEncrypted=@CustomerMediaDataEncrypted,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@GamblersAddictionCardId
  exec [dbo].[usp_acq_InsertGamblersUpdateCommands] @SmartAcquireId
  RETURN 0
END
GO
