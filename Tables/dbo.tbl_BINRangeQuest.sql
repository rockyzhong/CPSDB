CREATE TABLE [dbo].[tbl_BINRangeQuest]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[BINVal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PANLen] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_BINRangeQuest] ADD CONSTRAINT [pk_BINRangeQuest] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BINRangeQuest_BINVal_PANLen] ON [dbo].[tbl_BINRangeQuest] ([BINVal], [PANLen]) ON [PRIMARY]
GO
