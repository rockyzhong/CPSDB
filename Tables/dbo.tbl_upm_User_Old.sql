CREATE TABLE [dbo].[tbl_upm_User_Old]
(
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PasswordType] [bigint] NOT NULL,
[PasswordEncrypt] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordMD5] [varbinary] (20) NULL,
[OldUserId] [bigint] NULL,
[OldRoleId] [bigint] NULL,
[Firstname] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mid] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_User_OldUserId] ON [dbo].[tbl_upm_User_Old] ([OldUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_User_UserName] ON [dbo].[tbl_upm_User_Old] ([UserName]) ON [PRIMARY]
GO
