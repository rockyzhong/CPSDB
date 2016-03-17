SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_gam_DeleteGamblersAddictionCard]
@CustomerMediaData       nvarchar(50),
@UpdatedUserId           bigint,
@SmartAcquireId        bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @CustomerMediaDataHash varbinary(512)
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT

  UPDATE dbo.tbl_GamblersAddictionCard SET Active=0,UpdatedUserId=@UpdatedUserId WHERE CustomerMediaDataHash=@CustomerMediaDataHash
 
  exec [dbo].[usp_acq_InsertGamblersUpdateCommands] @SmartAcquireId
  RETURN 0
END
GO
