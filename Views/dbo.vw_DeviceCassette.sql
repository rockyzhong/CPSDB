SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_DeviceCassette]
AS
  SELECT DeviceId,SUM(MediaCurrentCount) CassetteTotalCount,SUM(MediaCurrentCount*CONVERT(money,MediaValue)/100) CassetteTotalValue, MAX(CassetteStatus) CassetteStatus
  FROM dbo.tbl_DeviceCassette
  GROUP BY DeviceId
GO
