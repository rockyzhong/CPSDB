CREATE TABLE [dbo].[tbl_BankHoliday]
(
[HolidayID] [int] NOT NULL IDENTITY(1, 1),
[HolidayName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MonthOfYear] [int] NULL,
[DayOfMonth] [int] NULL,
[DayOfWeek] [int] NULL,
[DayOfMonthLBound] [int] NULL,
[DayOfMonthUBound] [int] NULL,
[YearAppliesTo] [int] NULL,
[Currency] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_BankHoliday] ADD CONSTRAINT [PK_tbl_BankHoliday] PRIMARY KEY CLUSTERED  ([HolidayID]) ON [PRIMARY]
GO
