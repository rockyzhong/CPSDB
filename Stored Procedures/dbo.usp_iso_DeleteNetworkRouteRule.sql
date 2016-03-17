SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_DeleteNetworkRouteRule] 
@RuleId bigint,
@UpdateUserId bigint
AS
BEGIN
  SET NOCOUNT ON

   UPDATE dbo.tbl_NetworkRouteRule SET RuleStatus = 0, UpdateUserId=@UpdateUserId where Id=@RuleId
END
GO
