CREATE TABLE [dbo].[tbl_DeviceKeyDukpt]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SerialNum] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MasterKeyId] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssignedDate] [datetime] NULL CONSTRAINT [DF__tbl_Devic__Assig__3E14AEEE] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceKeyDukpt] ADD CONSTRAINT [pk_DeviceKeyDukpt] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_DeviceKeyDukpt_SerialNum] ON [dbo].[tbl_DeviceKeyDukpt] ([SerialNum]) ON [PRIMARY]
GO
