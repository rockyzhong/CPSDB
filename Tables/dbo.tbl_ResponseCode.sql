CREATE TABLE [dbo].[tbl_ResponseCode]
(
[Id] [bigint] NOT NULL,
[ResponseTypeId] [bigint] NOT NULL,
[ResponseCodeExternal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResponseSubCodeExternal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDisplayText] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BrowseNextScreen] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_ResponseCode] ADD CONSTRAINT [pk_ResponseCode] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ResponseTypeId_ResponseCodeExternal_ResponseSubCodeExternal] ON [dbo].[tbl_ResponseCode] ([ResponseTypeId], [ResponseCodeExternal], [ResponseSubCodeExternal]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
