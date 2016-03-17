CREATE TABLE [dbo].[tbl_AuditLog]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKeyField] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKeyValue] [bigint] NULL,
[FieldName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_AuditLog_UpdatedDate] DEFAULT (getutcdate()),
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AuditLog] ADD CONSTRAINT [pk_AuditLog] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AuditLog_TableName_PrimaryKeyValue_UpdatedDate] ON [dbo].[tbl_AuditLog] ([TableName], [PrimaryKeyValue], [UpdatedDate]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
