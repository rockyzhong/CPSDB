SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_InsertIsoCardTypeAllow]
@IsoId          bigint,
@CardTypeValue  bigint,
@UpdatedUserId  bigint =null
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tbl_IsoCardTypeAllow(IsoId,CardTypeValue,UpdatedUserId) VALUES(@IsoId,@CardTypeValue,@UpdatedUserId)
  RETURN 0
END
GO
