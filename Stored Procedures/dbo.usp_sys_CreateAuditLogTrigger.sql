SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_CreateAuditLogTrigger]
AS
BEGIN
SET NOCOUNT ON
DECLARE @SQL nvarchar(max), @TableName nvarchar(200)
DECLARE TempCursor CURSOR LOCAL FOR SELECT TableName FROM dbo.tbl_AuditLogTable
OPEN TempCursor
FETCH NEXT FROM TempCursor INTO @TableName
WHILE @@Fetch_Status=0
BEGIN
  IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TableName AND COLUMN_NAME='UpdatedUserId')
  BEGIN
    EXEC('IF OBJECT_ID (''' + @TableName+ '_AuditLog'', ''TR'') IS NOT NULL DROP TRIGGER ' + @TableName+ '_AuditLog')
    SELECT @SQL = '
    CREATE TRIGGER ' + @TableName+ '_AuditLog ON ' + @TableName+ ' WITH EXECUTE AS ''dbo'' FOR INSERT, UPDATE, DELETE NOT FOR REPLICATION
    AS
      SET NOCOUNT ON
      DECLARE @TableName varchar(200),@UpdatedDate varchar(21),@Type varchar(1),@FieldName varchar(200),@SQL nvarchar(4000)
      SELECT @TableName = ''' + @TableName+ '''
      SELECT @UpdatedDate = CONVERT(varchar(8), getutcdate(), 112) + '' '' + CONVERT(varchar(12), getutcdate(), 114)
      IF EXISTS (SELECT * FROM inserted)
        IF EXISTS (SELECT * FROM deleted)
          SELECT @Type = ''U''
        ELSE
          SELECT @Type = ''I''
      ELSE
        SELECT @Type = ''D''

      SELECT * INTO #ins FROM inserted
      SELECT * INTO #del FROM deleted

      DECLARE TempCursor CURSOR LOCAL FOR SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TableName AND COLUMN_NAME NOT IN (''UpdatedDate'',''UpdatedUserId'') ORDER BY ORDINAL_POSITION
      OPEN TempCursor
      FETCH NEXT FROM TempCursor INTO @FieldName
      WHILE @@Fetch_Status=0
      BEGIN
        SELECT @SQL = ''INSERT dbo.tbl_AuditLog (Type, TableName, PrimaryKeyField, PrimaryKeyValue, FieldName, OldValue, NewValue, UpdatedDate, UpdatedUserId)''
        SELECT @SQL = @SQL + '' SELECT '''''' + @Type + ''''''''
        SELECT @SQL = @SQL + '','''''' + @TableName + ''''''''
        SELECT @SQL = @SQL + '',''''Id''''''
        SELECT @SQL = @SQL + '',COALESCE(i.Id,d.Id)''
        SELECT @SQL = @SQL + '','''''' + @FieldName + ''''''''
        SELECT @SQL = @SQL + '',CONVERT(varchar(max),d.'' + @FieldName + '')''
        SELECT @SQL = @SQL + '',convert(varchar(max),i.'' + @FieldName + '')''
        SELECT @SQL = @SQL + '','''''' + @UpdatedDate + ''''''''
        SELECT @SQL = @SQL + '',COALESCE(i.UpdatedUserId,d.UpdatedUserId)''
        SELECT @SQL = @SQL + '' FROM #ins i FULL OUTER JOIN #del d ON i.id=d.id''
        SELECT @SQL = @SQL + '' WHERE i.'' + @FieldName + '' <> d.'' + @FieldName
        SELECT @SQL = @SQL + '' OR (i.'' + @FieldName + '' IS NULL AND  d.'' + @FieldName + '' IS NOT NULL)'' 
        SELECT @SQL = @SQL + '' OR (i.'' + @FieldName + '' IS NOT NULL AND  d.'' + @FieldName + '' IS NULL)'' 
        EXEC(@SQL)

        FETCH NEXT FROM TempCursor INTO @FieldName
      END
      CLOSE TempCursor
      DEALLOCATE TempCursor

      '
    DECLARE @SourceType bigint
    SELECT  @SourceType = SourceType FROM dbo.tbl_AuditLogTable WHERE TableName=@TableName
    IF @TableName='tbl_Device'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,1,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_upm_User'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,2,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_BankAccount'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,3,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_Iso'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,4,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_InterchangeScheme'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,5,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_Network'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,6,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_Report'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,7,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_upm_Role'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,8,COALESCE(i.Id,d.Id) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_AchSchedule'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,COALESCE(i.SourceType,d.SourceType),COALESCE(i.SourceId,d.SourceId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @TableName='tbl_Address'
    BEGIN
      SET @SQL=@SQL+'
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,1,a.Id    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_Device      a ON COALESCE(i.Id,d.Id)=a.AddressId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,2,a.Id    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_upm_User    a ON COALESCE(i.Id,d.Id)=a.AddressId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,3,a.Id    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_BankAccount a ON COALESCE(i.Id,d.Id)=a.AddressId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,4,a.IsoId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_IsoAddress  a ON COALESCE(i.Id,d.Id)=a.AddressId'
    END
    ELSE IF @TableName='tbl_Contact'
    BEGIN
      SET @SQL=@SQL+'
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,1,a.DeviceId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_DeviceContact a ON COALESCE(i.Id,d.Id)=a.ContactId
      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,4,a.IsoId    FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_IsoContact    a ON COALESCE(i.Id,d.Id)=a.ContactId'
    END
    ELSE IF @TableName='tbl_DeviceFeeOverrideRule'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,1,a.DeviceId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_DeviceFeeOverride a ON COALESCE(i.FeeOverrideId,d.FeeOverrideId)=a.Id'
    ELSE IF @TableName='tbl_DeviceViewColumn'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,2,a.UserId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_DeviceView a ON COALESCE(i.ViewId,d.ViewId)=a.Id'
    ELSE IF @TableName='tbl_DeviceViewFilter'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,2,a.UserId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_DeviceView a ON COALESCE(i.ViewId,d.ViewId)=a.Id'
    ELSE IF @TableName='tbl_InterchangeSchemeSignatureAmount'
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,5,a.InterchangeSchemeId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_InterchangeSchemeSignature a ON COALESCE(i.InterchangeSchemeSignatureId,d.InterchangeSchemeSignatureId)=a.Id'
    ELSE IF @TableName='tbl_NetworkMerchantStation' 
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,6,a.NetworkId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_NetworkMerchant a ON COALESCE(i.NetworkMerchantId,d.NetworkMerchantId)=a.Id'
    ELSE IF @SourceType=1
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,1,COALESCE(i.DeviceId,d.DeviceId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=2
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,2,COALESCE(i.UserId,d.UserId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=3
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,3,COALESCE(i.BankAccountId,d.BankAccountId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=4
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,4,COALESCE(i.IsoId,d.IsoId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=5
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,5,COALESCE(i.InterchangeSchemeId,d.InterchangeSchemeId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=6
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,6,COALESCE(i.NetworkId,d.NetworkId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=7
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,7,COALESCE(i.ReportId,d.ReportId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'
    ELSE IF @SourceType=8
      SET @SQL=@SQL+'INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,''Id'',COALESCE(i.Id,d.Id),@UpdatedDate,8,COALESCE(i.RoleId,d.RoleId) FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id'

    EXEC(@SQL)
  END
    
  FETCH NEXT FROM TempCursor INTO @TableName
END
CLOSE TempCursor
DEALLOCATE TempCursor
END
GO
