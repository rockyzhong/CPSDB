SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DeviceError]  

AS
  SELECT DeviceId
  FROM dbo.tbl_DeviceError
  WHERE ResolvedDate IS NULL
  GROUP BY DeviceId
GO
