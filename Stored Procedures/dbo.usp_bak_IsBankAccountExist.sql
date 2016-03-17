SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_IsBankAccountExist] 
@IsoId    bigint,
@Rta      nvarchar(50),
@IsExist  bigint OUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_BankAccount WHERE IsoId=@IsoId AND Rta=@Rta)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_IsBankAccountExist] TO [WebV4Role]
GO
