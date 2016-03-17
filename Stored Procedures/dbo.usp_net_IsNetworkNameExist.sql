SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_IsNetworkNameExist] 
@NetworkName nvarchar(50),
@IsExist     bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_Network WHERE NetworkName=@NetworkName)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_IsNetworkNameExist] TO [WebV4Role]
GO
