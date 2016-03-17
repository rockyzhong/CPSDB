SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_gam_InsertGamblersAddictionCard]
@GamblersAddictionCardId bigint OUT,
@CustomerMediaData       nvarchar(50),
@UpdatedUserId           bigint,
@SmartAcquireId        bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @CustomerMediaDataHash varbinary(512),@CustomerMediaDataEncrypted varbinary(512)
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT
  EXEC dbo.usp_sys_Encrypt @CustomerMediaData,@CustomerMediaDataEncrypted OUT

  INSERT INTO dbo.tbl_GamblersAddictionCard(CustomerMediaDataHash,CustomerMediaDataEncrypted,Active,UpdatedDate,UpdatedUserId) 
  VALUES(@CustomerMediaDataHash,@CustomerMediaDataEncrypted,1,GETUTCDATE(),@UpdatedUserId)
  
  SELECT @GamblersAddictionCardId=IDENT_CURRENT('tbl_GamblersAddictionCard')

  exec [dbo].[usp_acq_InsertGamblersUpdateCommands] @SmartAcquireId
  RETURN 0
END
GO
