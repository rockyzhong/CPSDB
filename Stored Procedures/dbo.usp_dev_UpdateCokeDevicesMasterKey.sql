SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	CREATE PROCEDURE [dbo].[usp_dev_UpdateCokeDevicesMasterKey]
	@Id NVARCHAR(32),
	@Variant TINYINT
	AS
    BEGIN
	UPDATE tbl_DeviceCokeKeyMaster SET Variant=@Variant WHERE Id=@Id
    END
GO
