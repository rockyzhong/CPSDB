SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_InsertCustomerOTB] (
@CustomerOTBId    bigint       OUTPUT,
@CustomerId       bigint       = NULL,
@MerchantId       nvarchar(50) = NULL,
@TransactionClass nvarchar(50) = NULL,
@FullMICR         nvarchar(25) = NULL,
@OTBLimit         bigint       = NULL,
@CustomerLimit    bigint       = NULL,
@ActiveStatus     nvarchar(1)  = NULL,
@EnrollmentType   nvarchar(1)  = NULL,
@EnrollmentDate   datetime     = NULL,
@UpdatedUserId    bigint
)
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tbl_CustomerOTB(CustomerId,MerchantId,TransactionClass,FullMICR,OTBLimit,CustomerLimit,ActiveStatus,EnrollmentType,EnrollmentDate,UpdatedUserId)
  VALUES(@CustomerId,@MerchantId,@TransactionClass,@FullMICR,@OTBLimit,@CustomerLimit,@ActiveStatus,@EnrollmentType,@EnrollmentDate,@UpdatedUserId)
  SELECT @CustomerOTBId=IDENT_CURRENT('tbl_CustomerOTB')
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_InsertCustomerOTB] TO [WebV4Role]
GO
