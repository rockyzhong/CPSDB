SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Nick Liu
-- Create date: 2014-4-25
-- Description:	Get terminal time zone
-- =============================================
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceTimeZone] 
	-- Add the parameters for the stored procedure here
@DeviceId          bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime 
  FROM dbo.tbl_TimeZone t 
  JOIN dbo.tbl_Device d on t.Id=d.TimeZoneId
  WHERE d.Id=@DeviceId
END
GO
