CREATE TABLE [dbo].[tbl_DeviceSequenceNumber]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[SequenceNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceSequenceNumber] ADD CONSTRAINT [pk_DeviceSequenceNumber] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_DeviceSequenceNumber_DeviceId] ON [dbo].[tbl_DeviceSequenceNumber] ([DeviceId]) ON [PRIMARY]
GO
