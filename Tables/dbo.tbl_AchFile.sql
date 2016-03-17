CREATE TABLE [dbo].[tbl_AchFile]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[AchFileFormat] [bigint] NOT NULL,
[InstitutionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstitutionNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyShortName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SettlementLabel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SurchargeLabel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InterchangeLabel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StandardEntryClassCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_AchFile_StandardEntryClassCode] DEFAULT ('CCD'),
[SeparateBatches] [bit] NOT NULL CONSTRAINT [DF_tbl_AchFile_SeparateBatches] DEFAULT ((0)),
[BlockSizeLines] [bigint] NOT NULL CONSTRAINT [DF_tbl_AchFile_BlockSizeLines] DEFAULT ((10)),
[BlockFillFlag] [bit] NOT NULL CONSTRAINT [DF_tbl_AchFile_BlockFillFlag] DEFAULT ((0)),
[BlockFillChar] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_AchFile_BlockFillChar] DEFAULT (' '),
[BatchHeaderCompanyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TraceNumber] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileCreationNo] [bigint] NOT NULL CONSTRAINT [DF_tbl_AchFile_FileCreationNo] DEFAULT ((0)),
[Cutover] [numeric] (4, 2) NOT NULL,
[AchFileStatus] [bigint] NOT NULL,
[Currency] [smallint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AchFile] ADD CONSTRAINT [pk_AchFile] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
