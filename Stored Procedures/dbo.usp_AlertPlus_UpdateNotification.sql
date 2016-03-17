SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_AlertPlus_UpdateNotification]
	@TerminalName  NVARCHAR(200)
	,@AccessoryCode BIGINT
	,@ErrorCode     BIGINT
AS
BEGIN
-- get alerts
-- Revision 1.0.1 2014.09.09 by Julian Wu
SET NOCOUNT ON

DECLARE @DeviceId BIGINT

UPDATE a
SET CallCount = a.CallCount+1
	,LastCallDate = GETUTCDATE()
	,ClearedStatus = CASE 
						WHEN a.Repeats <> -1 AND a.Repeats <= a.CallCount + 1 THEN 3 
						ELSE a.ClearedStatus 
					 END
FROM dbo.tbl_DeviceAlertPlusActivePage a
	JOIN dbo.tbl_Device d
		ON a.DeviceId = d.Id	
		AND d.TerminalName = @TerminalName
		AND a.AccessoryCode = @AccessoryCode
		AND a.ErrorCode = @ErrorCode
		AND a.ClearedStatus = 0 -- active only

-- todo: update using TerminalName + PageType + CreatedDate
END

GO
