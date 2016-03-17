SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[udf_GetDeviceAlertPlusShiftEmail] (@DeviceId bigint,@PageType bigint)
RETURNS nvarchar(200)
AS
BEGIN
  DECLARE @Email nvarchar(200),@Weekday bigint,@Hour bigint
  SET @Weekday=DATEPART(weekday, GETDATE())
  SET @Hour=DATEPART(hour,GETUTCDATE())
  
  SELECT TOP 1 @Email=CASE WHEN @PageType=1 THEN InactivityEMail WHEN @PageType=2 THEN CashThresholdEMail WHEN @PageType=3 THEN DeviceErrorEMail ELSE NULL END
  FROM dbo.tbl_DeviceAlertPlusShift
  WHERE DeviceId=@DeviceId
    AND ((WeekdayType=1 AND @Weekday IN (2,3,4,5,6)) OR (WeekdayType=2 AND @Weekday IN (1,7)) OR WeekdayType=3)
    AND ((EndHour>=StartHour AND StartHour<=@Hour AND EndHour>@Hour) OR (EndHour<StartHour AND (StartHour<=@Hour OR EndHour>@Hour)))
  ORDER BY WeekdayType  
  RETURN @Email
END
GO
