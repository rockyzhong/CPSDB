SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_sys_GetDeviceStatus]
AS
BEGIN
  EXEC dbo.usp_sys_GetTypeValues 23
END
GO
