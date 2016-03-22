SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	CREATE PROCEDURE [dbo].[usp_dev_UpdateCokeDevicesWorkingKeyUsage]
	@Id NVARCHAR(32)
	AS
    BEGIN
	DECLARE @Count SMALLINT
	SELECT @Count=CountUsed FROM dbo.tbl_DeviceCokeKeyWorking WHERE id=@id
	IF @Count=200
	UPDATE dbo.tbl_DeviceCokeKeyWorking SET CountUsed=1 WHERE Id=@Id
	ELSE
	UPDATE dbo.tbl_DeviceCokeKeyWorking SET CountUsed=CountUsed+1 WHERE Id=@Id
    END
GO
