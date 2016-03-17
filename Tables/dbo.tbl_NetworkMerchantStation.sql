CREATE TABLE [dbo].[tbl_NetworkMerchantStation]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[NetworkMerchantId] [bigint] NULL,
[StationNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckType] [bigint] NULL,
[ServiceType] [bigint] NULL,
[AccountChain] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckLimit] [bigint] NULL,
[SDelayDays] [numeric] (3, 0) NULL,
[VarianceLimit] [numeric] (3, 0) NULL,
[OverridePermitted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdjustToCAP] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckNumberRequired] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandInModeAPermitted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandInModeCPermitted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandInLimit] [numeric] (12, 2) NULL,
[ACHEntryClass] [bigint] NULL,
[ExpiryDays] [numeric] (3, 0) NULL,
[DVariancePermitted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultStation] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StationName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayToName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditEligible] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSNNumberReqFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IDType] [bigint] NULL,
[SettlementType] [bigint] NULL,
[StatusId] [numeric] (4, 0) NULL,
[CreditLimit] [bigint] NULL,
[ManualFMEntryAllowed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementOption] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettleSmartOption] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FrankingOption] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTB_Enabled] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTB_Casino_Day_FLG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cust_Trans_Hist_Option] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cust_Trans_Hist_Days] [numeric] (3, 0) NULL,
[TXNORGID] [bigint] NULL,
[Service_Fee_Option] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACH_Manual_Entry_Override] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tribal_ID_Option] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mexican_ID_Option] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Kiosk_Enabled] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tbl_NetworkMerchantStation_AuditLog] ON [dbo].[tbl_NetworkMerchantStation]     WITH EXECUTE AS 'dbo' FOR INSERT, UPDATE, DELETE NOT FOR REPLICATION
    AS
      SET NOCOUNT ON
      DECLARE @TableName varchar(200),@UpdatedDate varchar(21),@Type varchar(1),@FieldName varchar(200),@SQL nvarchar(4000)
      SELECT @TableName = 'tbl_NetworkMerchantStation'
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

      INSERT INTO dbo.tbl_AuditLogSource(TableName,PrimaryKeyField,PrimaryKeyValue,UpdatedDate,SourceType,SourceId) SELECT @TableName,'Id',COALESCE(i.Id,d.Id),@UpdatedDate,6,a.NetworkId FROM inserted i FULL OUTER JOIN deleted d ON i.id=d.id JOIN dbo.tbl_NetworkMerchant a ON COALESCE(i.NetworkMerchantId,d.NetworkMerchantId)=a.Id
GO
ALTER TABLE [dbo].[tbl_NetworkMerchantStation] ADD CONSTRAINT [pk_NetworkMerchantStation] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NetworkMerchantStation_NetworkMerchantId] ON [dbo].[tbl_NetworkMerchantStation] ([NetworkMerchantId]) ON [PRIMARY]
GO
