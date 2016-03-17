CREATE TABLE [dbo].[tbl_RoutingCondition]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[CountryCode] [bigint] NOT NULL,
[Priority] [bigint] NOT NULL,
[MapIndex] [bigint] NOT NULL,
[Surchargeable] [bigint] NOT NULL,
[ConditionType1] [bigint] NULL,
[ConditionValue1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType2] [bigint] NULL,
[ConditionValue2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType3] [bigint] NULL,
[ConditionValue3] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType4] [bigint] NULL,
[ConditionValue4] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType5] [bigint] NULL,
[ConditionValue5] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType6] [bigint] NULL,
[ConditionValue6] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType7] [bigint] NULL,
[ConditionValue7] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType8] [bigint] NULL,
[ConditionValue8] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionType9] [bigint] NULL,
[ConditionValue9] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_RoutingCondition] ADD CONSTRAINT [pk_RoutingCondition] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_RoutingCondition_CountryCode] ON [dbo].[tbl_RoutingCondition] ([CountryCode]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Network ID for Routing', 'SCHEMA', N'dbo', 'TABLE', N'tbl_RoutingCondition', 'COLUMN', N'MapIndex'
GO
