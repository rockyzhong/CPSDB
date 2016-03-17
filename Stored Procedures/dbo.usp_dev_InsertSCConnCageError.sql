SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertSCConnCageError]
    @SCip [nvarchar](16) ,    --sc ip
	@Cageserver [nvarchar](20) ,   -- cage server location
    @Isoid [bigint],   --casino info(name and 
    @Deivceid [bigint] ,--terminal id)
    @Message [nvarchar](1000),   --error message
    @TransFail bit,  --triggered front end down or not
    @CreatedDate [datetime]
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tbl_SCConnCageError VALUES(
    @SCip ,    --sc ip
	@Cageserver,   -- cage server location
    @Isoid,   --casino info(name and 
    @Deivceid,--terminal id)
    @Message,   --error message
    @TransFail,  --triggered front end down or not
    @CreatedDate)
RETURN 0
END
GO
