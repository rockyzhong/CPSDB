SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetAll]
AS
BEGIN
  SELECT 
    i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.Website,i.IsoCode,i.IsoStatus,i.ParentId,
    t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,t.TimeZoneOffset,t.DayLightSavingTime
  FROM dbo.tbl_Iso i 
  JOIN dbo.tbl_TimeZone t ON t.Id=i.TimeZoneId
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetAll] TO [WebV4Role]
GO
