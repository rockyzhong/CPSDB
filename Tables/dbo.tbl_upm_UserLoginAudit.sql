CREATE TABLE [dbo].[tbl_upm_UserLoginAudit]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityTime] [datetime] NOT NULL,
[ActivityType] [bigint] NOT NULL,
[IsSuccessful] [bit] NULL CONSTRAINT [DF_UserLoginAudit_IsSuccessful] DEFAULT ((0)),
[Description] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_upm_UserLoginAudit] ADD CONSTRAINT [pk_UserLoginAudit] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_UserLoginAudit_UserId] ON [dbo].[tbl_upm_UserLoginAudit] ([UserName]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
