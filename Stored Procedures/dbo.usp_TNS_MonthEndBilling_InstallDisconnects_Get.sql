SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_InstallDisconnects_Get]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT d.IsoId, i.RegisteredName AS ISOName, d.CreatedDate AS ProcDate,
         d.TerminalName AS TerminalInstalled, '' AS TerminalDisconnected
  FROM dbo.tbl_Device d
  JOIN dbo.tbl_Iso i ON i.Id = d.IsoId
  WHERE d.CreatedDate >= @pStartDate AND d.CreatedDate <= @pEndDate
    AND d.IsoId = @pISOID
  UNION ALL
  SELECT d.IsoId, i.RegisteredName AS ISOName, a.UpdatedDate AS ProcDate,
    (CASE WHEN a.NewValue IN ('1', '3') THEN d.TerminalName ELSE '' END) AS TerminalInstalled,
    (CASE WHEN a.NewValue IN ('1', '3') THEN '' ELSE d.TerminalName END) AS TerminalDisconnected
  FROM dbo.tbl_AuditLog a
  JOIN dbo.tbl_Device d ON d.Id=a.PrimaryKeyValue
  JOIN dbo.tbl_Iso    i ON i.Id=d.IsoId
  WHERE a.TableName = 'tbl_Device'
    and a.FieldName = 'DeviceStatus'
    and a.UpdatedDate >= @pStartDate AND a.UpdatedDate <= @pEndDate + 1
    AND d.IsoId = @pISOID
    AND ((a.OldValue IN ('1', '3') AND a.NewValue NOT IN ('1', '3')) OR (a.OldValue NOT IN ('1', '3') AND a.NewValue IN ('1', '3')))
  ORDER BY ISOName, ProcDate, TerminalInstalled
END
GO
