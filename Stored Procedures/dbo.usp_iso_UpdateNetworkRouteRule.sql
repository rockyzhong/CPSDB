SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_UpdateNetworkRouteRule] 
@RuleId bigint,
@ConditionType bigint,
@ConditionValue bigint,
@ConditionExtendValue nvarchar(255),
@NetworkCode nvarchar(50),
@UpdateUserId bigint
AS
BEGIN
  SET NOCOUNT ON
   update dbo.tbl_NetworkRouteRule set ConditionType=@ConditionType, ConditionValue=@ConditionValue, ConditionExtendValue=@ConditionExtendValue,NetworkCode=@NetworkCode,UpdateUserId=@UpdateUserId where Id=@RuleId
END
GO
