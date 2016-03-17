CREATE TABLE [dbo].[tbl_AchSchedule]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[AchFileId] [tinyint] NOT NULL,
[SettlementDate] [datetime] NULL,
[ScheduleType] [tinyint] NOT NULL,
[ScheduleDay] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[OpenDate] [datetime] NULL,
[SourceType] [tinyint] NOT NULL,
[SourceId] [int] NOT NULL,
[FundsType] [tinyint] NOT NULL,
[SourceBankAccountId] [int] NOT NULL,
[DestinationBankAccountId] [int] NOT NULL,
[Amount] [money] NOT NULL,
[TaxList] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchHeader] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_AchSchedule_BatchHeader] DEFAULT ('SETTLEMENT'),
[StandardEntryClassCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_AchSchedule_StandardEntryCode] DEFAULT ('CCD'),
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AchScheduleStatus] [tinyint] NULL CONSTRAINT [DF_tbl_AchSchedule_AchScheduleStatus] DEFAULT ((1)),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_tbl_AchSchedule_CreatedDate] DEFAULT (getutcdate()),
[CreatedUserId] [int] NULL,
[UpdatedDate] [datetime] NULL CONSTRAINT [DF_tbl_AchSchedule_UpdatedDate] DEFAULT (getutcdate()),
[UpdatedUserId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AchSchedule] ADD CONSTRAINT [pk_tbl_AchSchedule] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tbl_AchSchedule_AchScheduleStatus] ON [dbo].[tbl_AchSchedule] ([AchScheduleStatus], [ScheduleType], [ScheduleDay], [StartDate], [EndDate], [SettlementDate]) ON [PRIMARY]
GO
