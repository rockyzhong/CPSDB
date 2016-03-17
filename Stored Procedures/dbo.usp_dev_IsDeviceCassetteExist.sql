SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_IsDeviceCassetteExist] 
@DeviceId   bigint,
@CassetteId bigint,
@IsExist    bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_DeviceCassette WHERE DeviceId=@DeviceId AND CassetteId=@CassetteId)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_IsDeviceCassetteExist] TO [WebV4Role]
GO
