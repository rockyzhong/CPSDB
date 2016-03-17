CREATE TABLE [dbo].[tbl_DeviceManagementActivity]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[ManagementDate] [datetime] NOT NULL,
[ManagementData] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceManagementActivity] ADD CONSTRAINT [pk_DeviceManagementActivity] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_DeviceManagementActivity_DeviceId] ON [dbo].[tbl_DeviceManagementActivity] ([DeviceId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
