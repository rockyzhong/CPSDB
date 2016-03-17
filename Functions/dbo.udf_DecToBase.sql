SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_DecToBase](@val as bigint,@base as int)
RETURNS varchar(63)
AS
BEGIN
    /* Check if we get the valid base */
    IF (@val<0) OR (@base < 2) OR (@base> 36) RETURN Null;

    /* variable to hold final answer */
    DECLARE @answer as varchar(63);

    /*  Following variable contains all possible alpha numeric letters for any base */
    DECLARE @alldigits as varchar(36);
    SET @alldigits='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    /*  Set the initial value of final answer as empty string */
    SET @answer='';

    /* Loop until your source value is greater than 0 */
    WHILE @val>0
    BEGIN
      SET @answer=Substring(@alldigits,@val % @base + 1,1) + @answer;
      SET @val = @val / @base;
    END

    /* Return the final answer */
    RETURN @answer;
End
GO
