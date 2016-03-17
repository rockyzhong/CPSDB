SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DeviceLastManagementActivity]
AS
  SELECT DeviceId,ManagementDate LastMgmtDate,ManagementData LastMgmtData
  FROM dbo.tbl_DeviceManagementActivity WHERE Id IN (SELECT MAX(Id) FROM dbo.tbl_DeviceManagementActivity GROUP BY DeviceId)
GO
