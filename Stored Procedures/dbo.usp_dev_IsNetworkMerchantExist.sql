SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_IsNetworkMerchantExist] 
@NetworkId         bigint,
@IsoId             bigint,
@IsExist           bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_NetworkMerchant WHERE NetworkId=@NetworkId AND IsoId=@IsoId)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_IsNetworkMerchantExist] TO [WebV4Role]
GO
