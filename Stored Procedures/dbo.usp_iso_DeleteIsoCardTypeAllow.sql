SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_DeleteIsoCardTypeAllow]
@IsoId          bigint,
@CardTypeValue  bigint
AS
BEGIN
  SET NOCOUNT ON
  DELETE FROM dbo.tbl_IsoCardTypeAllow where  IsoId=@IsoId and CardTypeValue=@CardTypeValue
  RETURN 0
END
GO
