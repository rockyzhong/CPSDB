SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_GetGamblersAddictionState]
@RegionId bigint,
@IdState  nvarchar(2),
@IdNumber nvarchar(30)
AS
BEGIN
  SELECT Id,RegionId,SSN,IdState,IdNumber
  FROM dbo.tbl_GamblersAddictionState
  WHERE RegionId=@RegionId AND IdState=@IdState AND IdNumber=@IdNumber
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_GetGamblersAddictionState] TO [WebV4Role]
GO
