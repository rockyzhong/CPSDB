SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDevicesByUserId]
@UserId         bigint,
@IsoId          bigint       = NULL,
@TerminalName   nvarchar(50) = NULL,
@Currency       bigint       = NULL,
@DeviceStatus   bigint       = NULL,
@ModelId        bigint       = NULL,
@TimeZoneId     bigint       = NULL,
@Location       nvarchar(50) = NULL,
@City           nvarchar(20) = NULL,
@Undeleted      bit          = NULL,
@OrderColumn    nvarchar(200),
@OrderDirection nvarchar(200),
@PageSize       bigint,
@PageNumber     bigint,
@Count          bigint OUTPUT
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  SET @TerminalName=REPLACE(@TerminalName,'*','%')
  SET @Location    =REPLACE(@Location,'*','%')
  SET @City        =REPLACE(@City,'*','%')

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1

  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1

  DECLARE @SQL nvarchar(max),@SQL0 nvarchar(max)
  SET @SQL0='
  FROM dbo.tbl_Device d JOIN @Source s ON d.Id=s.Id
  LEFT JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id LEFT JOIN dbo.tbl_TypeValue v ON v.TypeId=131 AND v.Value=o.DeviceEmulation
  LEFT JOIN dbo.tbl_Iso         i ON d.IsoId=i.Id 
  LEFT JOIN dbo.tbl_TimeZone    t ON d.TimeZoneId=t.Id
  LEFT JOIN dbo.tbl_Address     a ON d.AddressId=a.Id  
  WHERE 1>0'
  IF @IsoId        IS NOT NULL  SET @SQL0=@SQL0+' AND d.IsoId=@IsoId'
  IF @TerminalName IS NOT NULL  SET @SQL0=@SQL0+' AND d.TerminalName LIKE @TerminalName'
  IF @Currency     IS NOT NULL  SET @SQL0=@SQL0+' AND d.Currency=@Currency'
  IF @DeviceStatus IS NOT NULL  SET @SQL0=@SQL0+' AND d.DeviceStatus=@DeviceStatus'
  IF @ModelId      IS NOT NULL  SET @SQL0=@SQL0+' AND d.ModelId=@ModelId'
  IF @TimeZoneId   IS NOT NULL  SET @SQL0=@SQL0+' AND d.TimeZoneId=@TimeZoneId'
  IF @Location     IS NOT NULL  SET @SQL0=@SQL0+' AND d.Location LIKE @Location'
  IF @City         IS NOT NULL  SET @SQL0=@SQL0+' AND a.City LIKE @City'
  IF @Undeleted=1               SET @SQL0=@SQL0+' AND d.DeviceStatus<>4'

  SET @SQL='
  SELECT @Count=Count(*) '+@SQL0
  EXEC sp_executesql @SQL,N'@Source SourceTABLE READONLY,@IsoId bigint,@TerminalName nvarchar(50),@Currency bigint,@DeviceStatus bigint,@ModelId bigint,@TimeZoneId bigint,@Location nvarchar(50),@City nvarchar(50),@Count bigint OUTPUT',@Source,@IsoId,@TerminalName,@Currency,@DeviceStatus,@ModelId,@TimeZoneId,@Location,@City,@Count OUTPUT

  SET @SQL='
  WITH Devices AS (
  SELECT d.Id DeviceId,d.TerminalName,d.ReportName,d.SerialNumber,d.RoutingFlags,d.FunctionFlags,d.Currency,d.Location,d.CreatedDate,d.UpdatedDate,d.DeviceStatus,o.Id ModelId,o.Make,o.Model,o.DeviceEmulation,v.Name DeviceEmulationName,i.id IsoId,i.RegisteredName,t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,a.City,
  ROW_NUMBER() OVER(ORDER BY '+@OrderColumn+' '+@OrderDirection+N') AS RowNumber '+@SQL0+')

  SELECT DeviceId,TerminalName,ReportName,SerialNumber,RoutingFlags,FunctionFlags,Currency,Location,CreatedDate,UpdatedDate,DeviceStatus,ModelId,Make,Model,DeviceEmulation,DeviceEmulationName,IsoId,RegisteredName,TimeZoneId,TimeZoneName,TimeZoneTime,City
  FROM Devices WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY '+@OrderColumn+' '+@OrderDirection
  
  EXEC sp_executesql @SQL,N'@Source SourceTABLE READONLY,@IsoId bigint,@TerminalName nvarchar(50),@Currency bigint,@DeviceStatus bigint,@ModelId bigint,@TimeZoneId bigint,@Location nvarchar(50),@City nvarchar(50),@StartRow bigint,@EndRow bigint',@Source,@IsoId,@TerminalName,@Currency,@DeviceStatus,@ModelId,@TimeZoneId,@Location,@City,@StartRow,@EndRow

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDevicesByUserId] TO [WebV4Role]
GO
