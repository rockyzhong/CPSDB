SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceFirstTransactionDate] 
AS
BEGIN
  DECLARE @DeviceId bigint,@FirstTransDate datetime
  DECLARE TmpCursor CURSOR LOCAL FOR SELECT Id FROM dbo.tbl_Device WHERE FirstTransDate IS NULL
  OPEN TmpCursor
  FETCH NEXT FROM TmpCursor INTO @DeviceId
  WHILE @@Fetch_Status=0
  BEGIN
    SET @FirstTransDate=NULL
    SELECT @FirstTransDate=MIN(SystemDate) FROM dbo.tbl_trn_Transaction WHERE DeviceId=@DeviceId
    IF @FirstTransDate IS NOT NULL
      UPDATE dbo.tbl_Device SET FirstTransDate=@FirstTransDate WHERE Id=@DeviceId
          
    FETCH NEXT FROM TmpCursor INTO @DeviceId
  END
  CLOSE TmpCursor
  DEALLOCATE TmpCursor
END
GO
