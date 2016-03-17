SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  CREATE PROCEDURE [dbo].[usp_dev_GetCokeDevicesWorkingKey]
	@Id NVARCHAR(32)  
	AS
    BEGIN
	SELECT ID,CurrKey AS 'Key',PrevKey previouskey, CountUsed,UpatedDate FROM dbo.tbl_DeviceCokeKeyWorking WHERE Id=@Id
    END
GO
