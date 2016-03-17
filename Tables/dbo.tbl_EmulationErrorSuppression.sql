CREATE TABLE [dbo].[tbl_EmulationErrorSuppression]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ErrorText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suppression] [bigint] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_EmulationErrorSuppression] ADD CONSTRAINT [pk_DeviceEmulationErrorSuppression] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_EmulationErrorSuppression_ErrorText] ON [dbo].[tbl_EmulationErrorSuppression] ([ErrorText]) ON [PRIMARY]
GO
