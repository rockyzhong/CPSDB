CREATE TABLE [dbo].[tbl_DeviceExtendedValue]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NULL,
[DeviceEmulation] [bigint] NULL,
[ExtendedColumnType] [bigint] NULL,
[ExtendedColumnValue] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SwitchUserFlag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__tbl_Devic__Switc__05113BBC] DEFAULT (N'U'),
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceExtendedValue] ADD CONSTRAINT [pk_DeviceExtendedValue] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_DeviceExtendedValue_DeviceId_DeviceEmulation_ExtendedColumnType] ON [dbo].[tbl_DeviceExtendedValue] ([DeviceId], [DeviceEmulation], [ExtendedColumnType]) ON [PRIMARY]
GO
