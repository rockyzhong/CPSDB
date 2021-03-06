CREATE TABLE [dbo].[tbl_Device]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ModelId] [bigint] NOT NULL,
[IsoId] [bigint] NOT NULL,
[TerminalName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FunctionFlags] [bigint] NULL,
[RoutingFlags] [bigint] NULL,
[Currency] [bigint] NOT NULL,
[QuestionablePolicy] [bigint] NULL CONSTRAINT [DF_tbl_Device_QuestionablePolicy] DEFAULT ((1)),
[FeeType] [bigint] NULL,
[LocationType] [bigint] NULL,
[Location] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefusedTransactionTypeList] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaximumDispensedAmount] [bigint] NULL,
[MasterPinKeyCryptogram] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterMacKeyCryptogram] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkingPinKeyCryptogram] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkingMacKeyCryptogram] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkingPinKeyUpdatedDate] [datetime] NULL,
[WorkingMACKeyUpdatedDate] [datetime] NULL,
[AddressId] [bigint] NULL,
[TimeZoneId] [bigint] NULL,
[DeviceStatus] [bigint] NULL CONSTRAINT [DF_tbl_Device_DeviceStatus] DEFAULT ((3)),
[ActivatedDate] [datetime] NULL,
[FirstTransDate] [datetime] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_tbl_Device_CreateDate] DEFAULT (getutcdate()),
[CreatedUserId] [bigint] NULL,
[UpdatedDate] [datetime] NULL CONSTRAINT [DF_tbl_Device_UpdatedDate] DEFAULT (getutcdate()),
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[tbl_Device_AuditLog] ON [dbo].[tbl_Device]     WITH EXECUTE AS 'dbo' FOR INSERT, UPDATE, DELETE NOT FOR REPLICATION
    AS
      SET NOCOUNT ON
      DECLARE @TableName varchar(200),@UpdatedDate varchar(21),@Type varchar(1),@FieldName varchar(200),@SQL nvarchar(4000)
      SELECT @TableName = 'tbl_Device'
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

      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,1,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id

GO
ALTER TABLE [dbo].[tbl_Device] ADD CONSTRAINT [pk_DeviceId] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Device_AddressId] ON [dbo].[tbl_Device] ([AddressId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Device_DeviceStatus_UpdatedDate] ON [dbo].[tbl_Device] ([DeviceStatus], [UpdatedDate]) INCLUDE ([Id], [TerminalName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Device_IsoId] ON [dbo].[tbl_Device] ([IsoId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Device_ModelId] ON [dbo].[tbl_Device] ([ModelId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_Device_TerminalName] ON [dbo].[tbl_Device] ([TerminalName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Device_TimeZoneId] ON [dbo].[tbl_Device] ([TimeZoneId]) ON [PRIMARY]
GO
