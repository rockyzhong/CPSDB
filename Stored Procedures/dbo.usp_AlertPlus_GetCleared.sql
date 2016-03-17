SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_AlertPlus_GetCleared]
AS
BEGIN
-- get cleared alerts
-- Revision 1.0.1 2014.09.09 by Julian Wu
SET NOCOUNT ON

SELECT 
	d.TerminalName
	,d.Location
	,a.PageDetail
	,dbo.udf_GetDeviceAlertPlusShiftEmail(a.DeviceId, a.PageType) ShiftEmail
	,a.AccessoryCode
	,a.ErrorCode
	,a.Repeats
	,a.PageType
	,p.AuditEmail
FROM dbo.tbl_DeviceAlertPlusActivePage a (NOLOCK)
	JOIN dbo.tbl_Device d (NOLOCK)
		ON d.Id = a.DeviceId
	JOIN dbo.tbl_DeviceAlertPlus p (NOLOCK)
		ON p.DeviceId = a.DeviceId
WHERE 
	a.ClearedStatus=4
--ORDER BY d.TerminalName,a.PageType,a.AccessoryCode

END
GO
