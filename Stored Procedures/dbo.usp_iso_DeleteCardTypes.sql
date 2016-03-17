SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_DeleteCardTypes]
@IsoId BIGINT,
@UpdateUserId BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  UPDATE  dbo.tbl_IsoCardTypeAllow set UpdatedUserId=@UpdateUserId where IsoId=@IsoId
  DELETE FROM dbo.tbl_IsoCardTypeAllow where IsoId=@IsoId
  RETURN 0
END
GO
