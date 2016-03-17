SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_GetUpdateCommands]
@Date DATETIME,
@UpdatedUserId bigint
AS
BEGIN
DECLARE @UTCDate datetime
SET @UTCDate = getutcdate()
SELECT  DISTINCT UpdateCommand
FROM tbl_UpdateCommands
WHERE UpdatedUserId <> (@UpdatedUserId) AND UpdatedDate between @Date and @UTCDate

SELECT CONVERT(nvarchar,@UTCDate,121) Date
RETURN 0
END
GO
