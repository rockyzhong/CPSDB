SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bak_UpdateBankAccount]
@BankAccountId          bigint,
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
@UpdatedUserId          bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_BankAccount SET 
  BankAccountType=@BankAccountType,BankAccountCategory=@BankAccountCategory,HolderName=@HolderName,Rta=@Rta,Currency=@Currency,
  BankName=@BankName,ConsolidationType=@ConsolidationType,IsoId=@IsoId,BankAccountStatus=@BankAccountStatus,
  CriminalCheckStatus=@CriminalCheckStatus,CriminalCheckIssueDate=@CriminalCheckIssueDate,UpdatedUserId=@UpdatedUserId
  WHERE Id=@BankAccountId
 
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_UpdateBankAccount] TO [WebV4Role]
GO
