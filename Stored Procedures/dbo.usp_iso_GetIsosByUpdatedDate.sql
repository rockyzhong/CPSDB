SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsosByUpdatedDate]
@IsoId    bigint   = NULL,
@Date     datetime = NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  IF @Date IS NULL  SET @Date=CONVERT(datetime,'20000101',112)

  DECLARE @SQL nvarchar(4000)
  SET @SQL='SELECT i.Id IsoId,i.RegisteredName,i.IsoStatus
  FROM dbo.tbl_Iso i
  WHERE UpdatedDate>@Date'
  IF @IsoId IS NOT NULL  SET @SQL=@SQL+' AND i.Id=@IsoId'
  
  SET @SQL=@SQL+'
  SELECT e.IsoId,i.RegisteredName,e.ExtendedColumnType,e.ExtendedColumnValue
  FROM dbo.tbl_IsoExtendedValue e
  JOIN dbo.tbl_Iso i ON e.IsoId=i.Id
  WHERE i.UpdatedDate>@Date AND i.IsoStatus=1'
  IF @IsoId IS NOT NULL  SET @SQL=@SQL+' AND i.Id=@IsoId'
  
  SET @SQL=@SQL+'
  SELECT f.IsoId,i.RegisteredName,f.FeeType,f.StartDate,f.EndDate,f.AmountFrom,f.AmountTo,f.FeeFixed,f.FeePercentage,f.FeeAddedPercentage
  FROM dbo.tbl_DeviceFee f
  JOIN dbo.tbl_Iso i ON f.IsoId=i.Id
  WHERE i.UpdatedDate>@Date AND i.IsoStatus=1 AND f.EndDate>GETUTCDATE()'
  IF @IsoId IS NOT NULL  SET @SQL=@SQL+' AND i.Id=@IsoId'

  SET @SQL=@SQL+'
  SELECT CONVERT(nvarchar,GETUTCDATE(),121) Date'
   
  EXEC sp_executesql @SQL,N'@IsoId bigint,@Date datetime',@IsoId,@Date
  
    ----  insert deviceupdatecommands
   --INSERT INTO tbl_DeviceUpdateCommands
   --SELECT @SmartAcquierId, GETUTCDATE(), 'Sptermapp\GetIsosByUpdatedDate!'
    
END

GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsosByUpdatedDate] TO [WebV4Role]
GO
