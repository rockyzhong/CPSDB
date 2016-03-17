CREATE TABLE [dbo].[tbl_NetworkRouteRule]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[IsoId] [bigint] NOT NULL,
[ConditionType] [bigint] NOT NULL,
[ConditionValue] [bigint] NOT NULL,
[ConditionExtendValue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetworkCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RuleStatus] [bigint] NULL,
[UpdateUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_NetworkRouteRule] ADD CONSTRAINT [pk_NetworkRouteRule] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
