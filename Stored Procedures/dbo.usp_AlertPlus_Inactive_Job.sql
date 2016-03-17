SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_AlertPlus_Inactive_Job]
AS
BEGIN
-- Revision 1.0.1 2008.06.26 by Adam Glover
-- Added code to clear pages for deleted terminals.
-- Corrected DeviceID 7 references to DeviceID 0.
--
-- Revison 1.0.2 2009.07.28 by Adam Glover
-- E-Mail output of Last Mgmt Time corrected.

-- Rev 1.0.3 - Adam Glover - 2010.01.28
--  Correct NotifReason filter to accomodate MachineStatus Down flag
--
-- Rev 1.0.4 - Adam Glover - 2012.08.01
--  Clear active alerts for any terminals where inactivity alerts have been turned off

-- Revision 1.1.0 2014.05.27 by Adam Glover
--   READ UNCOMMITTED isolation level

-- Revision 4.0.0 2014.09.10 by Julian Wu
--   Update for V4
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Inactive Threshold MU paging
-- 1. Create list of all inactive terminals.
-- 2. Add pages for terminals that do not already have a page.
IF OBJECT_ID('tempdb..#InactiveThresholdDevice') IS NOT NULL
	DROP TABLE #InactiveThresholdDevice
	
SELECT 
	ap.DeviceId
	,ap.InactiveTime
INTO #InactiveThresholdDevice
FROM dbo.tbl_DeviceAlertPlus ap (NOLOCK)
	JOIN dbo.tbl_Device d (NOLOCK)
		ON ap.DeviceId = d.Id
		AND ap.NotificationReason & 2 > 0
		--AND ap.NotificationReason IN (2, 3, 6, 7, 10, 11, 14, 15)
		AND ap.InactiveTime > 0
		AND d.DeviceStatus = 1 -- 1: enabled, 2: disabled, 3: pending, 4: deletion in tbl_TypeValue
		
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
	DeviceId = a.DeviceId
	,AccessoryCode = 0 
	,ErrorCode = 1
	,PageType = 1
	,PageDetail = 'Dev: 0 (Machine)' + CHAR(13) + CHAR(10)
		+ 'Err: 1 (Inactive)' + CHAR(13) + CHAR(10) +CHAR(13) + CHAR(10)
		+ 'Cut-off:   ' + ISNULL(CONVERT(VARCHAR(24), DATEADD(mi, -a.InactiveTime, GETDATE())), '') + CHAR(13) + CHAR(10)
		+ 'Last Txn:  '+ ISNULL(CONVERT(VARCHAR(24), a.LastTransTime), '') + CHAR(13) + CHAR(10)
		+ 'Last Mgmt: '+ ISNULL(CONVERT(VARCHAR(24), a.LastMgmtTime), '') + CHAR(13) + CHAR(10)
	,CreatedDate = GETDATE()
	,LastCallDate = '1900-01-01 00:00:00.000'
	,ClearedDate = '1900-01-01 00:00:00.000'
	,Repeats = -1
	,CallCount = 0
	,ClearedStatus = 0
	,UpdatedUserId = 0
FROM (
		SELECT 
			ap.DeviceId
			,ap.InactiveTime
			,LastTransTime = MAX(ISNULL(t.SystemTime, '1900-01-01 00:00:00.000'))
			,LastMgmtTime = MAX(ISNULL(m.ManagementDate, '1900-01-01 00:00:00.000'))
		FROM #InactiveThresholdDevice ap (NOLOCK)
			LEFT JOIN dbo.tbl_trn_Transaction t (NOLOCK)
				ON t.DeviceId = ap.DeviceId
			LEFT JOIN dbo.tbl_DeviceManagementActivity m (NOLOCK)
				ON m.DeviceId = ap.DeviceId
		GROUP BY ap.DeviceId, ap.InactiveTime
	) a
	LEFT JOIN dbo.tbl_DeviceAlertPlusActivePage b (NOLOCK)
		ON a.DeviceId = b.DeviceId
		AND b.AccessoryCode = 0
		AND b.ErrorCode = 1
		AND b.PageType = 1	
WHERE 
	DATEADD(MINUTE, -a.InactiveTime, GETDATE()) > a.LastTransTime
	AND DATEADD(MINUTE, -a.InactiveTime, GETDATE()) > a.LastMgmtTime
	AND b.DeviceId IS NULL



-- 3. Clear pages without notification for any terminals which are deleted or Inactive Threshold unchecked
-- 4. Clear pages (status=4) for any terminals that are no longer inactive
UPDATE a
SET
	ClearedStatus = 
		CASE 
			WHEN a.ClearedStatus = 0 THEN 4
			WHEN a.ClearedStatus = 3 THEN 2
		END	
	,ClearedDate = GETDATE()
FROM dbo.tbl_DeviceAlertPlusActivePage a
	LEFT JOIN #InactiveThresholdDevice ap (NOLOCK)
		ON a.DeviceId = ap.DeviceId
WHERE
	a.PageType = 1
	AND a.ClearedStatus IN (0, 3)
	AND ap.DeviceId IS NULL

IF OBJECT_ID('tempdb..#InactiveThresholdDevice') IS NOT NULL
BEGIN
	TRUNCATE TABLE #InactiveThresholdDevice
	DROP TABLE #InactiveThresholdDevice
END

END

GO
