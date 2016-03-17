SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DeviceOpenTraceCount]
AS
  SELECT t.DeviceId,COUNT(*) OpenTraceCount
  FROM dbo.tbl_trn_Transaction t inner JOIN
  dbo.tbl_trn_Transactionreconandtrace trt ON t.Id=trt.TranId
  WHERE trt.TraceStatus IN (1,3,4)
  GROUP BY t.DeviceId

GO
