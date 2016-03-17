CREATE TABLE [dbo].[tbl_DeviceFunctionFlags]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[FunctionId] [bigint] NOT NULL,
[FunctionDesc] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefaultState] [bigint] NOT NULL,
[WarningText] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceFunctionFlags] ADD CONSTRAINT [pk_DeviceFunctionFlags] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
