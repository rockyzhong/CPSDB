SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceAlertPlusActivePage]
@UserId   bigint,
@DeviceId bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SQL nvarchar(max)
  SET @SQL='
  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1
  
  SELECT a.DeviceId,d.TerminalName,a.AccessoryCode,a.ErrorCode,a.PageType,a.PageDetail,a.LastCallDate,dbo.udf_GetDeviceAlertPlusShiftEmail(a.DeviceId,a.PageType) ShiftEmail
  FROM dbo.tbl_DeviceAlertPlusActivePage a
  JOIN dbo.tbl_Device d ON d.Id=a.DeviceId
  WHERE a.ClearedStatus=0 AND a.DeviceId IN (SELECT Id FROM @Source)'
  IF @DeviceId IS NOT NULL  SET @SQL=@SQL+' AND a.DeviceId=@DeviceId'
  
  EXEC sp_executesql @SQL,N'@UserId bigint,@DeviceId bigint',@UserId,@DeviceId
END
GO
