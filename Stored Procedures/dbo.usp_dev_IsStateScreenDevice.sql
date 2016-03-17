SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_IsStateScreenDevice] 
@DeviceId  bigint,
@IsTrue    bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_Device d JOIN dbo.tbl_DeviceModel m ON m.Id=d.ModelId WHERE d.Id=@DeviceId AND m.DeviceEmulation IN (54,56,256))
    SET @IsTrue=1
  ELSE
    SET @IsTrue=0
  RETURN 0
END
GO
