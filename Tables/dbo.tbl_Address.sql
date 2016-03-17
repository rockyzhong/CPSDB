CREATE TABLE [dbo].[tbl_Address]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[RegionId] [bigint] NULL,
[City] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone1] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension1] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone2] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension2] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone3] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension3] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tbl_Address_AfterInsertUpdateDelete]
   ON  [dbo].[tbl_Address]
   WITH EXECUTE AS 'dbo'
   AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
  SET NOCOUNT ON

  DECLARE @AddressId bigint,@UpdatedUserId bigint
  DECLARE TempCursor CURSOR LOCAL FOR SELECT Id,UpdatedUserId FROM inserted UNION SELECT Id,UpdatedUserId FROM deleted
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @AddressId,@UpdatedUserId
  WHILE @@Fetch_Status=0
  BEGIN
    UPDATE dbo.tbl_Device SET UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId WHERE AddressId=@AddressId
    
    FETCH NEXT FROM TempCursor INTO @AddressId,@UpdatedUserId
  END
  CLOSE TempCursor
  DEALLOCATE TempCursor
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tbl_Address_AuditLog] ON [dbo].[tbl_Address]     WITH EXECUTE AS 'dbo' FOR INSERT, UPDATE, DELETE NOT FOR REPLICATION
    AS
      SET NOCOUNT ON
      DECLARE @TableName varchar(200),@UpdatedDate varchar(21),@Type varchar(1),@FieldName varchar(200),@SQL nvarchar(4000)
      SELECT @TableName = 'tbl_Address'
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

      
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,1,a.Id    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_Device      a ON COALESCE(i.Id,d.Id)=a.AddressId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,2,a.Id    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_upm_User    a ON COALESCE(i.Id,d.Id)=a.AddressId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,3,a.Id    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_BankAccount a ON COALESCE(i.Id,d.Id)=a.AddressId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,4,a.IsoId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_IsoAddress  a ON COALESCE(i.Id,d.Id)=a.AddressId
GO
ALTER TABLE [dbo].[tbl_Address] ADD CONSTRAINT [pk_Address] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Address_RegionId] ON [dbo].[tbl_Address] ([RegionId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
