SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_AlertPlus_GetOutstanding]
	@DeviceErrorRepeatInterval   BIGINT = 2
	,@InactivityRepeatInterval    BIGINT = 2
	,@CashThresholdRepeatInterval BIGINT = 2
AS
BEGIN
-- get alerts
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
	a.ClearedStatus = 0
	AND a.LastCallDate < DATEADD(HOUR 
		,CASE 
			-- Machine Down (DeviceID = 0 OR AccessoryCode = 0?)
			WHEN a.PageType = 0 AND a.AccessoryCode = 0 AND p.DeviceDownRepeatInterval <= 0 THEN 240000 -- No Repeat
			WHEN a.PageType = 0 AND a.AccessoryCode = 0 THEN ISNULL(p.DeviceDownRepeatInterval, @DeviceErrorRepeatInterval)
			-- Inactive Threshold
			WHEN a.PageType = 1 AND p.InactivityRepeatInterval <= 0 THEN 240000
			WHEN a.PageType = 1 THEN ISNULL(p.InactivityRepeatInterval, @InactivityRepeatInterval)
			-- Cash Threshold
			WHEN a.PageType = 2 AND p.CashThresholdRepeatInterval <= 0 THEN 240000
			WHEN a.PageType = 2 THEN ISNULL(p.CashThresholdRepeatInterval, @CashThresholdRepeatInterval)
			-- Machine Status (DeviceID <> 0)
			WHEN a.PageType = 0 AND p.DeviceErrorRepeatInterval <= 0 THEN 240000
			WHEN a.PageType = 0 THEN ISNULL(p.DeviceErrorRepeatInterval, @DeviceErrorRepeatInterval)
			-- Default
			ELSE 0
		END, GETUTCDATE())
--ORDER BY d.TerminalName,a.PageType,a.AccessoryCode
END

GO
