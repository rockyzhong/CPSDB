SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_Split] 
@String nvarchar(max),
@Delimiter varchar(10) = ','
AS
BEGIN
  SET NOCOUNT ON 
  DECLARE @xml xml
  SET @xml = cast(('<X>'+replace(@String,@Delimiter ,'</X><X>')+'</X>') as xml) 
  SELECT C.value('.', 'nvarchar(200)') as value FROM @xml.nodes('X') as X(C) 
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_Split] TO [WebV4Role]
GO
