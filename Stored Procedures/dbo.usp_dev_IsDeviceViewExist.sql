SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_IsDeviceViewExist] 
@ViewName     nvarchar(50),
@IsExist      bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_DeviceView WHERE ViewName=@ViewName)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
