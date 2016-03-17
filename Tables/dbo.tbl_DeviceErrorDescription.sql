CREATE TABLE [dbo].[tbl_DeviceErrorDescription]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceEmulation] [bigint] NOT NULL,
[ErrorCode] [bigint] NOT NULL,
[ErrorDescription] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PageType] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceErrorDescription] ADD CONSTRAINT [pk_DeviceErrorDescription] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
