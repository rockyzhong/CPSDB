CREATE TABLE [dbo].[tbl_DeviceToSettlementAccountOverride]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[BankAccountId] [bigint] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[OverrideType] [bigint] NOT NULL,
[OverrideData] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OverridePriority] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tbl_DeviceToSettlementAccountOverride_AuditLog] ON [dbo].[tbl_DeviceToSettlementAccountOverride]     WITH EXECUTE AS 'dbo' FOR INSERT, UPDATE, DELETE NOT FOR REPLICATION
    AS
      SET NOCOUNT ON
      DECLARE @TableName varchar(200),@UpdatedDate varchar(21),@Type varchar(1),@FieldName varchar(200),@SQL nvarchar(4000)
      SELECT @TableName = 'tbl_DeviceToSettlementAccountOverride'
      SELECT @UpdatedDate = CONVERT(varchar(8), getutcdate(), 112) + ' ' + CONVERT(varchar(12), getutcdate(), 114)
      IF EXISTS (SELECT * FROM inserted)
        IF EXISTS (SELECT * FROM deleted)
          SELECT @Type = 'U'
        ELSE
          SELECT @Type = 'I'
      ELSE
        SELECT @Type = 'D'

      SELECT * INTO #ins FROM inserted
      SELECT * INTO #del FROM deleted

      DECLARE TempCursor CURSOR LOCAL FOR SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TableName AND COLUMN_NAME NOT IN ('UpdatedDate','UpdatedUserId') ORDER BY ORDINAL_POSITION
      OPEN TempCursor
      FETCH NEXT FROM TempCursor INTO @FieldName
      WHILE @@Fetch_Status=0
      BEGIN
        SELECT @SQL = 'INSERT dbo.tbl_AuditLog (Type, TableName, PrimaryKeyField, PrimaryKeyValue, FieldName, OldValue, NewValue, UpdatedDate, UpdatedUserId)'
        SELECT @SQL = @SQL + ' SELECT ''' + @Type + ''''
        SELECT @SQL = @SQL + ',''' + @TableName + ''''
        SELECT @SQL = @SQL + ',''Id'''
        SELECT @SQL = @SQL + ',COALESCE(i.Id,d.Id)'
        SELECT @SQL = @SQL + ',''' + @FieldName + ''''
        SELECT @SQL = @SQL + ',CONVERT(varchar(max),d.' + @FieldName + ')'
        SELECT @SQL = @SQL + ',convert(varchar(max),i.' + @FieldName + ')'
        SELECT @SQL = @SQL + ',''' + @UpdatedDate + ''''
        SELECT @SQL = @SQL + ',COALESCE(i.UpdatedUserId,d.UpdatedUserId)'
        SELECT @SQL = @SQL + ' FROM #ins i FULL OUTER JOIN #del d ON i.id=d.id'
        SELECT @SQL = @SQL + ' WHERE i.' + @FieldName + ' <> d.' + @FieldName
        SELECT @SQL = @SQL + ' OR (i.' + @FieldName + ' IS NULL AND  d.' + @FieldName + ' IS NOT NULL)' 
        SELECT @SQL = @SQL + ' OR (i.' + @FieldName + ' IS NOT NULL AND  d.' + @FieldName + ' IS NULL)' 
        EXEC(@SQL)

        FETCH NEXT FROM TempCursor INTO @FieldName
      END
      CLOSE TempCursor
      DEALLOCATE TempCursor

      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,1,COALESCE(i.DeviceId,d.DeviceId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id
GO
ALTER TABLE [dbo].[tbl_DeviceToSettlementAccountOverride] ADD CONSTRAINT [pk_DeviceToSettlementAccountOverride] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_DeviceToSettlementAccountOverride_DeviceId_EndDate_StartDate_OverrideType_OverrideData] ON [dbo].[tbl_DeviceToSettlementAccountOverride] ([DeviceId], [EndDate], [StartDate], [OverrideType], [OverrideData]) ON [PRIMARY]
GO
