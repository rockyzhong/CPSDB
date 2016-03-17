CREATE TABLE [dbo].[tbl_DeviceActivity]
(
[DeviceId] [bigint] NOT NULL,
[LastMgmtTime] [datetime] NOT NULL,
[LastTransTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceActivity] ADD CONSTRAINT [pk_DeviceActivity] PRIMARY KEY CLUSTERED  ([DeviceId]) ON [PRIMARY]
GO
