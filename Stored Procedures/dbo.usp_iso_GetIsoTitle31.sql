SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoTitle31]
@IsoId          bigint
AS
BEGIN
  SELECT t.Id IsoTitle31Id,t.IsoId,t.ServiceUrl,t.EntityUID,t.CasinoID,t.TransactionCode,UPPER(v1.Name) Flow,UPPER(v2.Name) LogType,t.CashAdvance,t.Encrypt,t.Status
  FROM dbo.tbl_IsoTitle31 t
  LEFT JOIN dbo.tbl_TypeValue v1 on t.Flow=v1.Value AND v1.TypeId=133
  LEFT JOIN dbo.tbl_TypeValue v2 on t.LogType=v2.Value AND v2.TypeId=135
  WHERE IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoTitle31] TO [WebV4Role]
GO
