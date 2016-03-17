CREATE TABLE [dbo].[tbl_DeviceExtendedColumn]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceEmulation] [bigint] NULL,
[ExtendedColumnType] [bigint] NULL,
[ExtendedColumnLabel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtendedColumnDescription] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SwitchUserFlag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_DeviceExtendedColumn_SwitchUserFlag] DEFAULT (N'U'),
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceExtendedColumn] ADD CONSTRAINT [pk_DeviceExtendedColumn] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
