CREATE TABLE [dbo].[tbl_DeviceAlertPlus]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[NotificationReason] [bigint] NOT NULL,
[DeviceErrorRepeatInterval] [bigint] NULL,
[InactivityRepeatInterval] [bigint] NULL,
[CashThresholdRepeatInterval] [bigint] NULL,
[DeviceDownRepeatInterval] [bigint] NULL,
[InactiveTime] [bigint] NOT NULL CONSTRAINT [DF_tbl_DeviceAlertPlus_InactiveTime] DEFAULT ((120)),
[AuditEnabled] [bigint] NOT NULL,
[AuditEMail] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceAlertPlus] ADD CONSTRAINT [pk_DeviceAlertPlus] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_DeviceAlertPlus_DeviceId] ON [dbo].[tbl_DeviceAlertPlus] ([DeviceId]) ON [PRIMARY]
GO
