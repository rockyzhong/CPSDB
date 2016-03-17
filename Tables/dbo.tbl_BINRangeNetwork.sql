CREATE TABLE [dbo].[tbl_BINRangeNetwork]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[BINRange] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BINLen] [int] NOT NULL,
[NetworkID] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NetworkCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetworkName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_BINRangeNetwork] ADD CONSTRAINT [pk_BINRange_Network] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BINRange_Network_BINRange_NetworkCode] ON [dbo].[tbl_BINRangeNetwork] ([BINRange], [NetworkCode]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
