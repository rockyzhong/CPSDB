CREATE TABLE [dbo].[tbl_DeviceColumn]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ColumnName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnCaption] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnHeader] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SampleData] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Required] [bit] NOT NULL CONSTRAINT [DF_tbl_DeviceColumn_Required] DEFAULT ((0)),
[Sortable] [bit] NOT NULL CONSTRAINT [DF_tbl_DeviceColumn_Sortable] DEFAULT ((1)),
[Rank] [bigint] NOT NULL CONSTRAINT [DF_tbl_DeviceColumn_Rank] DEFAULT ((0)),
[ColumnStatus] [bigint] NOT NULL CONSTRAINT [DF_tbl_DeviceColumn_Status] DEFAULT ((1)),
[PermissionId] [bigint] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceColumn] ADD CONSTRAINT [pk_DeviceColumn] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Enable', 'SCHEMA', N'dbo', 'TABLE', N'tbl_DeviceColumn', 'COLUMN', N'ColumnStatus'
GO
