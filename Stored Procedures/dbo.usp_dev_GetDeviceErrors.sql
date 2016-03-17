SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceErrors]
@DeviceId          bigint,
@ErrorStatus       bigint,   -- 1 active, 2 resolved, 3 all
@StartedDate       datetime,
@ResolvedDate      datetime,
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
    DECLARE @DeviceErrors TABLE(DeviceId bigint,DeviceEmulation bigint,AccessoryCode bigint,StartedDate datetime,ErrorCode bigint,ErrorText nvarchar(200),ResolvedDate datetime,ResolvedText nvarchar(200),RowNumber bigint)
    INSERT INTO @DeviceErrors
    SELECT DeviceId,DeviceEmulation,AccessoryCode,StartedDate,ErrorCode,ErrorText,ResolvedDate,ResolvedText,ROW_NUMBER() OVER(ORDER BY StartedDate) AS RowNumber
    FROM dbo.tbl_DeviceError
    WHERE DeviceId=@DeviceId'
  IF @StartedDate IS NOT NULL
    SET @SQL=@SQL+' AND StartedDate>=@StartedDate'
  IF @ErrorStatus=1       
    SET @SQL=@SQL+' AND ResolvedDate IS NULL'
  ELSE IF @ErrorStatus=2
  BEGIN
    IF @ResolvedDate IS NOT NULL 
      SET @SQL=@SQL+' AND ResolvedDate<@ResolvedDate'
    ELSE
      SET @SQL=@SQL+' AND ResolvedDate IS NOT NULL'
  END
  ELSE IF @ErrorStatus=3
  BEGIN
    IF @ResolvedDate IS NOT NULL 
      SET @SQL=@SQL+' AND (ResolvedDate<@ResolvedDate OR ResolvedDate IS NULL)'
  END
  
  SET @SQL=@SQL+'
    SELECT @Count=COUNT(*) FROM @DeviceErrors
    SELECT DeviceId,DeviceEmulation,AccessoryCode,StartedDate,ErrorCode,ErrorText,ResolvedDate,ResolvedText
    FROM @DeviceErrors WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY StartedDate'
  EXEC sp_executesql @SQL,N'@DeviceId bigint,@StartedDate datetime,@ResolvedDate datetime,@StartRow bigint,@EndRow bigint,@Count bigint OUTPUT',@DeviceId,@StartedDate,@ResolvedDate,@StartRow,@EndRow,@Count OUTPUT
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceErrors] TO [WebV4Role]
GO
