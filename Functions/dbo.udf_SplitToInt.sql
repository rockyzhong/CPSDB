SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_SplitToInt]
(
@SourceSql varchar(max),
@StrSeprate varchar(10)
)
returns @temp table(value int)
as 
begin
    declare @i int
    set @SourceSql=rtrim(ltrim(@SourceSql))
    set @i=charindex(@StrSeprate,@SourceSql)
    while @i>=1
        begin
            insert @temp values(left(@SourceSql,@i-1))
            set @SourceSql=substring(@SourceSql,@i+1,len(@SourceSql)-@i)
            set @i=charindex(@StrSeprate,@SourceSql)
        end
    if @SourceSql<>'\'
    insert @temp values(@SourceSql)
    return 
end
GO
