SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_IsNetworkExist] 
@NetworkId bigint,
@IsExist   bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_Network WHERE Id=@NetworkId)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_IsNetworkExist] TO [WebV4Role]
GO
