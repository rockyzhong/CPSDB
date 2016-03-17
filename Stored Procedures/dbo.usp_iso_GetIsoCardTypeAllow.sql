SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoCardTypeAllow]
@IsoId   bigint
AS
BEGIN
  SET NOCOUNT ON
  Select * FROM dbo.tbl_IsoCardTypeAllow where  IsoId=@IsoId order by Id
  RETURN 0
END
GO
