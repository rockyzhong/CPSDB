CREATE TABLE [dbo].[tbl_DeviceCokeIDP]
(
[TERMID] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TC] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TTI] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RTLID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RTLGROUP] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RTLRGN] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceCokeIDP] ADD CONSTRAINT [PK_tbl_DeviceCokeIDP] PRIMARY KEY CLUSTERED  ([TERMID]) ON [PRIMARY]
GO
