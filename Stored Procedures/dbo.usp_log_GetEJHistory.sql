SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_log_GetEJHistory]
@DeviceId bigint,
@FileDate datetime,
@UserID   bigint
AS
BEGIN
  DECLARE @IsVisible bigint
  EXEC dbo.usp_upm_IsObjectVisible @UserId,1,@DeviceId,@IsVisible OUTPUT

  IF @IsVisible < 0
    SELECT 0,'Permission Denied'
  ELSE
  BEGIN
    SELECT FileType,FileData
    FROM dbo.tbl_EJHistory
    WHERE DeviceId = @DeviceId
      AND FileDate >= @FileDate
      AND FileDate < @FileDate + 1
    ORDER BY FileDate
  END
END
GO
GRANT EXECUTE ON  [dbo].[usp_log_GetEJHistory] TO [WebV4Role]
GO
