SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_GetDevicesByInterchangeSchemeId]
@InterchangeSchemeId       bigint
AS
BEGIN
  SELECT d.Id DeviceId,d.TerminalName,d.ReportName,d.SerialNumber,
         d.RoutingFlags,d.Currency,d.CreatedDate,d.UpdatedDate,d.DeviceStatus,
         i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode
  FROM dbo.tbl_DeviceToInterchangeScheme s LEFT JOIN dbo.tbl_Device d ON s.DeviceId=d.Id LEFT JOIN dbo.tbl_Iso i ON d.IsoId=i.Id 
  WHERE s.InterchangeSchemeId=@InterchangeSchemeId
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_GetDevicesByInterchangeSchemeId] TO [WebV4Role]
GO
