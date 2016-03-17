SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceCutoverOffsetInterchange] 
  @DeviceId       bigint
AS
BEGIN 
  EXEC dbo.usp_dev_GetDeviceCutoverOffset @DeviceId,3
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceCutoverOffsetInterchange] TO [WebV4Role]
GO
