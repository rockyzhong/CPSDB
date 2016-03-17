SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceByUserView]
@ViewId bigint,
@UserId bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--
	-- column list
	--
	DECLARE @ColumnList TABLE (ColumnName varchar(64))

	INSERT INTO @ColumnList 
	SELECT dc.ColumnName
	FROM tbl_DeviceViewColumn dvc
	LEFT JOIN tbl_DeviceColumn dc ON dvc.ColumnId=dc.Id
	WHERE dvc.ViewId=@ViewId
	--select * from @ColumnList

	DECLARE @ColumnNameStr VARCHAR(8000) 
	SELECT @ColumnNameStr = COALESCE(@ColumnNameStr + ', ', '') + ColumnName
	FROM @ColumnList
	WHERE ColumnName IS NOT NULL
	--SELECT @ColumnNameStr

	--
	-- filter list
	--
	DECLARE @FilterList TABLE (ColumnName varchar(64), MactchChoice varchar(5), UserValue varchar(64))

	INSERT INTO @FilterList 
	SELECT dc.ColumnName, dvf.MatchChoice, dvf.Value
	FROM tbl_DeviceViewFilter dvf
	LEFT JOIN tbl_DeviceFilter df on dvf.FilterId=df.Id
	LEFT JOIN tbl_DeviceColumn dc ON df.ColumnId=dc.Id
	WHERE dvf.ViewId=@ViewId
	--select * from @FilterList

	DECLARE @FilterStr VARCHAR(8000) 
	SELECT @FilterStr = COALESCE(@FilterStr + ' AND ', '') + 
		CASE MactchChoice
			WHEN 'SW' THEN ColumnName + ' LIKE ''' + UserValue + '%'''
			WHEN 'CN' THEN ColumnName + ' LIKE ''%' + UserValue + '%'''
			WHEN 'EW' THEN ColumnName + ' LIKE ''%' + UserValue + ''''
			ELSE ColumnName + ' ' + MactchChoice + ' ' + '''' + UserValue + ''''
		END

	FROM @FilterList
	WHERE ColumnName IS NOT NULL 
		AND MactchChoice IS NOT NULL
		AND UserValue IS NOT NULL
	IF @FilterStr is NULL OR len(@FilterStr) = 0 SET @FilterStr = '1=1'
	--SELECT @FilterStr

	DECLARE @SortColumnName varchar(64)
	DECLARE @SortDirection varchar(64)
	SELECT @SortColumnName = dc.ColumnName, @SortDirection = SortDirection 
	FROM tbl_DeviceView dv
	LEFT JOIN tbl_DeviceColumn dc ON dc.Id=dv.SortColumnId
	WHERE dv.Id=@ViewId
	--select @SortColumnName, @SortDirection

	DECLARE @Source SourceTABLE
    INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1
	--fetch granted terminalid

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'SELECT ' + @ColumnNameStr
		+ ' FROM vw_Device d JOIN @Source s ON d.Id=s.Id' 
		+ ' WHERE ' + @FilterStr
		+ ' ORDER BY ' + @SortColumnName + ' ' + @SortDirection
		
	EXEC sp_executesql @SQL, N'@Source SourceTABLE READONLY',@Source 
END
GO
