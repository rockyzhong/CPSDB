CREATE TABLE [dbo].[tbl_upm_User_OldSlightline]
(
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldUserId] [bigint] NULL,
[OldRoleId] [bigint] NULL,
[Firstname] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mid] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleInitial] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
