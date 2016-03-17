SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DeviceDayClose]
AS
  SELECT DeviceId,MAX(ClosedDate) ClosedDate
  FROM dbo.tbl_DeviceDayClose
  GROUP BY DeviceId
GO
