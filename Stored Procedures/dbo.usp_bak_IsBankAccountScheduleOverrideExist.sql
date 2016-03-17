SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_bak_IsBankAccountScheduleOverrideExist] 
@BankAccountId bigint,
@DeviceId      bigint,
@IsExist       bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_BankAccountScheduleOverride WHERE BankAccountId=@BankAccountId AND DeviceId=@DeviceId)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_IsBankAccountScheduleOverrideExist] TO [WebV4Role]
GO
