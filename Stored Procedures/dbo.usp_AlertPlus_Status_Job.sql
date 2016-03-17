SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_AlertPlus_Status_Job]
AS
BEGIN
-- Revision 1.0.1 2008.06.26 by Adam Glover
--   Added code to clear pages for deleted terminals.
--
-- Revision 1.0.2 2010.01.28 by Adam Glover
--   Add Support for NotifReason 8 MachineStatus = Down pages.
--   Generate PageType 1 Alert if the Error is on DeviceID 0
--
-- Revision 4.0.0 2014.09.09 by Julian Wu
-- Support V4

-- Machine Status Pages
-- 1. Pull list of terminals that have an error code
-- 2. Pull the error code data and page type if it exists
INSERT INTO dbo.tbl_DeviceAlertPlusActivePage
(
	DeviceId
	,AccessoryCode
	,ErrorCode
	,PageType
	,PageDetail
	,CreatedDate
	,LastCallDate
	,ClearedDate
	,Repeats
	,CallCount
	,ClearedStatus
	,UpdatedUserId
)
SELECT
	DeviceId = d.TerminalName
	,AccessoryCode = e.AccessoryCode 
	,ErrorCode = e.ErrorCode
	,PageType = 0
	,PageDetail = 'Dev: ' + CAST(e.AccessoryCode AS VARCHAR) + ' (' + ISNULL(MAX(tv.Name), '') + ') ' + CHAR(13) + CHAR(10) 
				+ 'Err: ' + CAST(e.ErrorCode AS VARCHAR) + ' (' + ISNULL(RTRIM(MAX(e.ErrorText)), '') + ')'	
				+ CHAR(13) + CHAR(10) +CHAR(13) + CHAR(10)
	,CreatedDate = GETDATE()
	,LastCallDate = '1900-01-01 00:00:00.000'
	,ClearedDate = '1900-01-01 00:00:00.000'
	,Repeats = -1
	,CallCount = 0
	,ClearedStatus = 0
	,UpdatedUserId = 0
FROM dbo.tbl_DeviceAlertPlus ap (NOLOCK)
	JOIN dbo.tbl_Device d (NOLOCK)
		ON ap.DeviceId = d.Id
		AND d.DeviceStatus = 1 -- 1: enabled, 2: disabled, 3: pending, 4: deletion in tbl_TypeValue
	JOIN dbo.tbl_DeviceError e (NOLOCK)
		ON e.DeviceId = d.Id
		AND e.ResolvedDate IS NULL
		AND (ap.NotificationReason & 1 > 0 AND e.AccessoryCode <> 0
			OR ap.NotificationReason & 8 > 0 AND e.AccessoryCode = 0) 
		--AND (ap.NotificationReason IN (1, 3, 5, 7, 9, 11, 13, 15) AND e.AccessoryCode <> 0
		--	OR ap.NotificationReason IN (8, 9, 10, 11, 12, 13, 14, 15) AND e.AccessoryCode = 0) 
	LEFT JOIN dbo.tbl_TypeValue tv (NOLOCK)
		ON e.AccessoryCode = tv.Value
		AND tv.TypeId = 117 -- AccessoryCode
	LEFT JOIN dbo.tbl_DeviceAlertPlusActivePage b
		ON d.TerminalName = b.DeviceId
		AND e.AccessoryCode = b.AccessoryCode
		AND e.ErrorCode = b.ErrorCode
		AND b.PageType = 0
WHERE
	b.DeviceId IS NULL
GROUP BY 
	d.TerminalName
	,e.AccessoryCode
	,e.ErrorCode

-- Clear not-resolved pages for inactive machines  
UPDATE a
SET ClearedStatus = 2
	,ClearedDate = GETDATE()
FROM  dbo.tbl_DeviceAlertPlusActivePage a
	JOIN dbo.tbl_Device d
		ON a.DeviceId = d.Id
		AND d.DeviceStatus <> 1 
		AND a.ClearedStatus IN (0, 3)
		AND a.PageType = 0


-- Pages of status =0 or 3 which errors have been resolved
-- If ever sent email before, then change status to 4 to send a resolved message
-- change to 2 to not send the message
UPDATE a
SET ClearedStatus = 
		CASE 
			WHEN a.ClearedStatus = 0 THEN 4
			WHEN a.ClearedStatus = 3 THEN 2
		END
	,ClearedDate = GETDATE()	
FROM dbo.tbl_DeviceAlertPlusActivePage a
	JOIN dbo.tbl_DeviceError e
		ON a.DeviceId = e.DeviceId
		AND a.AccessoryCode = e.AccessoryCode
		AND a.ErrorCode = e.ErrorCode
		AND a.PageType = 0
		AND e.ResolvedDate IS NOT NULL
		AND a.ClearedStatus IN (0, 3)
		
END

GO
