SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_IsGamblersAddictionCardExist] 
@CustomerMediaData nvarchar(50),
@IsExist           bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @CustomerMediaDataHash varbinary(512)
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT
  IF EXISTS(SELECT Id FROM dbo.tbl_GamblersAddictionCard WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND Active=1)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
