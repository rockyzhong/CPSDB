SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetCokeDevicesMasterKey]
	@Id NVARCHAR(32)  
	AS
    BEGIN
	SELECT ID,Variant,CurrKey AS 'Key' FROM tbl_DeviceCokeKeyMaster WHERE Id=@Id
    END
GO
