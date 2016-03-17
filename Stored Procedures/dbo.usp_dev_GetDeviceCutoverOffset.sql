SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceCutoverOffset] 
  @DeviceId       bigint,
  @FundsType      bigint
AS
BEGIN 
  SET NOCOUNT ON
  
  SELECT DepositExec,CutoverOffset FROM dbo.tbl_DeviceCutoverOffset WHERE DeviceId=@DeviceId AND FundsType=@FundsType
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceCutoverOffset] TO [WebV4Role]
GO
