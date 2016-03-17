SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoTimeZone]
@IsoId          bigint
AS
BEGIN
  SELECT t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime 
  FROM dbo.tbl_TimeZone t 
  JOIN dbo.tbl_Iso i on t.Id=i.TimeZoneId
  WHERE i.Id=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoTimeZone] TO [WebV4Role]
GO
