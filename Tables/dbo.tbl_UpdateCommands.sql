CREATE TABLE [dbo].[tbl_UpdateCommands]
(
[UpdatedUserId] [bigint] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdateCommand] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_UpdateCommands_Date] ON [dbo].[tbl_UpdateCommands] ([UpdatedDate]) INCLUDE ([UpdateCommand], [UpdatedUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_UpdateCommands_UserIdandCommand] ON [dbo].[tbl_UpdateCommands] ([UpdatedUserId], [UpdateCommand]) ON [PRIMARY]
GO
