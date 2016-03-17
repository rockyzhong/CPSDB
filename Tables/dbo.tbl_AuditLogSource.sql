CREATE TABLE [dbo].[tbl_AuditLogSource]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[TableName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKeyField] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKeyValue] [bigint] NULL,
[SourceType] [bigint] NULL,
[SourceId] [bigint] NULL,
[SourceName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsoName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tbl_AuditLogSource_AfterInsertUpdateDelete] ON [dbo].[tbl_AuditLogSource]
   WITH EXECUTE AS 'dbo'
   AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_AuditLogSource SET 
  SourceName=dbo.udf_GetSourceName(SourceType,SourceId),IsoName=dbo.udf_GetIsoName(SourceType,SourceId)
  WHERE Id IN (SELECT Id FROM inserted)
END
GO
ALTER TABLE [dbo].[tbl_AuditLogSource] ADD CONSTRAINT [pk_AuditLogSource] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AuditLogSource_UpdatedDate_SourceType_SourceId] ON [dbo].[tbl_AuditLogSource] ([UpdatedDate], [SourceType], [SourceId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
