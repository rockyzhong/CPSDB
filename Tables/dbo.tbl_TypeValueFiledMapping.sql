CREATE TABLE [dbo].[tbl_TypeValueFiledMapping]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Field] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConditionType] [bigint] NOT NULL,
[IsActive] [int] NOT NULL,
[UpdateUserId] [bigint] NULL,
[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_TypeValueFiledMapping] ADD CONSTRAINT [pk_TypeValueFiledMapping] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
