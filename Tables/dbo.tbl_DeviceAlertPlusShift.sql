CREATE TABLE [dbo].[tbl_DeviceAlertPlusShift]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[ShiftId] [bigint] NOT NULL,
[WeekdayType] [bigint] NOT NULL,
[StartHour] [bigint] NOT NULL,
[EndHour] [bigint] NOT NULL,
[DeviceErrorEMail] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InactivityEMail] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CashThresholdEMail] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceAlertPlusShift] ADD CONSTRAINT [pk_DeviceAlertPlusShift] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_DeviceAlertPlusShift_DeviceId_ShiftId] ON [dbo].[tbl_DeviceAlertPlusShift] ([DeviceId], [ShiftId]) ON [PRIMARY]
GO
