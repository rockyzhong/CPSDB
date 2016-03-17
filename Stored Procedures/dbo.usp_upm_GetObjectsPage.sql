SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetObjectsPage]
@UserId         bigint,
@SourceType     bigint,
@IsGranted      bigint = 1,
@OrderColumn    nvarchar(200),
@OrderDirection nvarchar(200),
@PageSize       bigint,
@PageNumber     bigint,
@Count          bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON

  IF @OrderDirection IS NULL OR @OrderDirection=N''  SET @OrderDirection='ASC'
  IF @OrderColumn IS NULL OR @OrderColumn=N''
  BEGIN
    IF @SourceType=1  SET @OrderColumn='TerminalName'
  END

  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,@SourceType,@IsGranted

  SELECT @Count=COUNT(*) FROM @Source

  DECLARE @StartRow bigint,@EndRow bigint,@SQL nvarchar(max)
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1

  EXEC dbo.usp_upm_GetObjectsPageDetail @Source,@SourceType,@OrderColumn,@OrderDirection,@StartRow,@EndRow
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjectsPage] TO [WebV4Role]
GO
