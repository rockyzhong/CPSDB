SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceManagementActivities]
@DeviceId          bigint,
@PageSize          bigint,
@PageNumber        bigint,
@Count             bigint OUTPUT
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1
  
  DECLARE @SQL nvarchar(1000)
  SET @SQL='
    DECLARE @DeviceManagementActivity TABLE(DeviceId bigint,ManagementDate datetime,ManagementData nvarchar(200),RowNumber bigint)
    INSERT INTO @DeviceManagementActivity
    SELECT DeviceId,ManagementDate,ManagementData,ROW_NUMBER() OVER(ORDER BY ManagementDate DESC) AS RowNumber
    FROM dbo.tbl_DeviceManagementActivity
    WHERE DeviceId=@DeviceId
    SELECT @Count=COUNT(*) FROM @DeviceManagementActivity
    SELECT DeviceId,ManagementDate,ManagementData
    FROM @DeviceManagementActivity WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY ManagementDate DESC'
  EXEC sp_executesql @SQL,N'@DeviceId bigint,@StartRow bigint,@EndRow bigint,@Count bigint OUTPUT',@DeviceId,@StartRow,@EndRow,@Count OUTPUT
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceManagementActivities] TO [WebV4Role]
GO
