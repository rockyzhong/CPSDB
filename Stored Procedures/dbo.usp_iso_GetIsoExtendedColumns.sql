SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoExtendedColumns] 
AS
BEGIN
  SELECT Id IsoExtendedColumnId,ExtendedColumnType,ExtendedColumnLabel,ExtendedColumnDescription
  FROM dbo.tbl_IsoExtendedColumn
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoExtendedColumns] TO [WebV4Role]
GO
