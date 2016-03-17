SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoExtendedValues] 
@IsoId            bigint
AS
BEGIN
  SELECT v.Id IsoExtendedValueId,v.IsoId,v.ExtendedColumnType,c.ExtendedColumnLabel,v.ExtendedColumnValue
  FROM dbo.tbl_IsoExtendedValue v 
  LEFT JOIN dbo.tbl_IsoExtendedColumn c ON v.ExtendedColumnType=c.ExtendedColumnType
  WHERE v.IsoId=@IsoId
  ORDER BY c.ExtendedColumnLabel
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoExtendedValues] TO [WebV4Role]
GO
