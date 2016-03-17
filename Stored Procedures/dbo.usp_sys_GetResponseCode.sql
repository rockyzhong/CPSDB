SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_sys_GetResponseCode]
@Id           bigint
AS
BEGIN
  SELECT TOP 1 * FROM dbo.tbl_ResponseCode WHERE Id=@Id
END
GO
