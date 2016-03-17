SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	CREATE PROCEDURE [dbo].[usp_dev_UpdateCokeDevicesWorkingKey]
	@Id NVARCHAR(32),
	@CurrKey TINYINT,
	@PrevKey NVARCHAR(76),
	@CountUsed SMALLINT,
	@UpatedDate BIGINT
	AS
    BEGIN
	UPDATE dbo.tbl_DeviceCokeKeyWorking SET CurrKey=@CurrKey,PrevKey=@PrevKey,CountUsed=@CountUsed,UpatedDate=@UpatedDate WHERE Id=@Id
    END
GO
