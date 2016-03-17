CREATE TABLE [dbo].[tbl_upm_UserSession]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[UserId] [bigint] NULL,
[SessionId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SessionTimeout] [bigint] NULL,
[TerminalId] [bigint] NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_upm_UserSession] ADD CONSTRAINT [pk_UserSession] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_UserSession_SessionId] ON [dbo].[tbl_upm_UserSession] ([SessionId]) ON [PRIMARY]
GO
