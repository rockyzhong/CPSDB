CREATE TYPE [dbo].[ValueTypeTable] AS TABLE
(
[Id] [bigint] NOT NULL IDENTITY(1, 2),
[Value] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
