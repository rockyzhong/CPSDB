SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_set_GetCutoverTime]
@ISOId bigint
AS
BEGIN
  SET NOCOUNT ON
  SELECT CutOverTime FROM dbo.tbl_IsoSetCutover WHERE IsoId=@ISOId
END
GO
