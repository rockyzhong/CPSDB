CREATE TABLE [dbo].[tbl_DeviceAlertPlusActivePage]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[AccessoryCode] [bigint] NOT NULL,
[ErrorCode] [bigint] NOT NULL,
[PageType] [bigint] NOT NULL,
[PageDetail] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastCallDate] [datetime] NOT NULL,
[ClearedDate] [datetime] NOT NULL,
[Repeats] [bigint] NOT NULL,
[CallCount] [bigint] NOT NULL,
[ClearedStatus] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceAlertPlusActivePage] ADD CONSTRAINT [pk_DeviceAlertPlusActivePage] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_DeviceAlertPlusActivePage_DeviceId_AccessoryCode_ErrorCode] ON [dbo].[tbl_DeviceAlertPlusActivePage] ([DeviceId], [AccessoryCode], [ErrorCode]) ON [PRIMARY]
GO
