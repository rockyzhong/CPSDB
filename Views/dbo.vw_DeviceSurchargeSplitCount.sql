SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DeviceSurchargeSplitCount]
AS
  SELECT DeviceId,count(*) SurchargeSplitCount
  FROM dbo.tbl_DeviceToSurchargeSplitAccount
  WHERE StartDate <= GETUTCDATE()
    AND EndDate >= GETUTCDATE()
  GROUP BY DeviceId
GO
