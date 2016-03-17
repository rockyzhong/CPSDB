SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertNetworkRouteRule] 
@IsoId bigint,
@ConditionExtendValue nvarchar(255),
@ConditionType bigint,
@ConditionValue bigint,
@NetworkCode nvarchar(50),
@UpdateUserId bigint
AS
BEGIN
  SET NOCOUNT ON

   INSERT INTO dbo.tbl_NetworkRouteRule VALUES(@IsoId, @ConditionType, @ConditionValue, @ConditionExtendValue, @NetworkCode, 1, @UpdateUserId)
END
GO
