SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bak_InsertBankAccount]
@BankAccountId          bigint OUTPUT,
@BankAccountType        bigint,
@BankAccountCategory    bigint,
@HolderName             nvarchar(200),
@Rta                    nvarchar(200),
@Currency               bigint,
@BankName               nvarchar(200),
@ConsolidationType      bigint,
@IsoId                  bigint,
@BankAccountStatus      bigint,
@CriminalCheckStatus    bigint,
@CriminalCheckIssueDate datetime,
@UpdatedUserId          bigint,
@AddressId              bigint OUTPUT,
@BankAddressId          bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)  SELECT @AddressId    =IDENT_CURRENT('tbl_Address')
  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)  SELECT @BankAddressId=IDENT_CURRENT('tbl_Address')
  
  INSERT INTO dbo.tbl_BankAccount(BankAccountType,BankAccountCategory,HolderName,Rta,Currency,BankName,ConsolidationType,AddressId,BankAddressId,IsoId,BankAccountStatus,CriminalCheckStatus,CriminalCheckIssueDate,UpdatedUserId)
  VALUES(@BankAccountType,@BankAccountCategory,@HolderName,@Rta,@Currency,@BankName,@ConsolidationType,@AddressId,@BankAddressId,@IsoId,@BankAccountStatus,@CriminalCheckStatus,@CriminalCheckIssueDate,@UpdatedUserId)
  SELECT @BankAccountId=IDENT_CURRENT('tbl_BankAccount')
  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@BankAccountId,3,@UpdatedUserId)
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_InsertBankAccount] TO [WebV4Role]
GO
